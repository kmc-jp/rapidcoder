import java.io.*;
import processing.core.*;
import java.lang.reflect.*;

class CollisionManager{
  /**
   * ellipseをPathに変換するときの点の数。大きいほど精度が良くなるが処理が重くなる。
   */
  final int ELLIPSE_POINTS = 8;

  /**
   * 当たり判定を取得するメソッド 2次元で使うこと
   * @param s 1つめの図形
   * @param t 2つめの図形
   * @return 図形が重なっている=true, それ以外=false
   */
  public boolean isHit(PShape s,PShape t){
    try{
      PMatrix2D sm = PShape2PMatrix2D(s);
      PMatrix2D tm = PShape2PMatrix2D(t);

      //Matrixが一致するなら楽をする
      if(equalm(sm,tm)){
        if(isCircle(s)&&isCircle(t)){
          return isHitCircleCircle(s,t);
        }
        if(isRect(s)&&isRect(t)){
          return isHitRectRect(s,t);
        }
      }

      //Matrixの性質がいいなら楽をする
      if(isCircle(s)&&isCircle(t)){
        if(isGoodCircle(s)&&isGoodCircle(t)){
          return isHitCircleCircleMat(s,t);
        }
      }
      if(isRect(s)&&isRect(t)){
        if(isGoodRect(s)&&isGoodRect(t)){
          return isHitRectRectMat(s,t);
        }
      }

      //多角形に変換して当たり判定を取る（重い）
      return isHitPathPath(s,t);
    }catch(Exception e){
      println(e + ": (" + s + ") , (" + t + ")");
      return false;
    }
  }

  /**
   * 当たり判定を大雑把に取得するメソッド isHitより高速 2次元で使うこと 細長いやつに弱い
   * @param s 1つめの図形
   * @param t 2つめの図形
   * @return 図形が重なっている=true, それ以外=false
   */
  public boolean isHitAbout(PShape s,PShape t){
    try{
      Ellipse sc = Path2Circle(new Path(s));
      Ellipse tc = Path2Circle(new Path(t));

      return isHitCircleCircle(sc,tc);
    }catch(Exception e){
      println(e + ": (" + s + ") , (" + t + ")");
      return false;
    }
  }

  final float FLT_EPSILON = 1.E-03F;

  boolean isHitRectRect(PShape s,PShape t) throws Exception {
    Rect sr = new Rect(s);
    Rect tr = new Rect(t);

    return (abs(sr.cx-tr.cx)<sr.halfw+tr.halfw) && (abs(sr.cy-tr.cy)<sr.halfh+tr.halfh);
  }

  //isGoodRect
  boolean isHitRectRectMat(PShape s,PShape t) throws Exception {
    Rect sr = new Rect(s,true);
    Rect tr = new Rect(t,true);

    return (abs(sr.cx-tr.cx)<sr.halfw+tr.halfw) && (abs(sr.cy-tr.cy)<sr.halfh+tr.halfh);
  }

  boolean isHitPathPath(PShape s,PShape t) throws Exception{
    Path sp = new Path(s);
    Path tp = new Path(t);

    ArrayList<PVector> sl = sp.getPath();
    ArrayList<PVector> tl = tp.getPath();

    for(int i = 0; i < sl.size()-1; ++i){
      for(int j = 0; j < tl.size()-1; ++j){
        PVector a = sl.get(i);
        PVector b = sl.get(i+1);
        PVector c = tl.get(j);
        PVector d = tl.get(j+1);

        if(isHitLineLine(a,b,c,d))
          return true;
      }
    }

    if(sp.isClose){
      for(int i = 0; i < tl.size(); ++i){
        float res = 0;
        for(int j = 0; j < sl.size()-1; ++j){
          PVector v1 = PVector.sub(sl.get(j),tl.get(i));
          PVector v2 = PVector.sub(sl.get(j+1),tl.get(i));

          float cos = (v1.x * v2.x + v1.y * v2.y) / (sqrt(v1.x * v1.x + v1.y * v1.y) * sqrt(v2.x * v2.x + v2.y * v2.y));
          res += acos(cos);
        }
        if(abs(res-TWO_PI)<FLT_EPSILON)
          return true;
      }
    }

    if(tp.isClose){
      for(int i = 0; i < sl.size(); ++i){
        float res = 0;
        for(int j = 0; j < tl.size()-1; ++j){
          PVector v1 = PVector.sub(tl.get(j),sl.get(i));
          PVector v2 = PVector.sub(tl.get(j+1),sl.get(i));

          float cos = (v1.x * v2.x + v1.y * v2.y) / (sqrt(v1.x * v1.x + v1.y * v1.y) * sqrt(v2.x * v2.x + v2.y * v2.y));
          res += acos(cos);
        }
        if(abs(res-TWO_PI)<FLT_EPSILON)
          return true;
      }
    }

    return false;
  }

  //ab、cdがの交差判定
  boolean isHitLineLine(PVector a,PVector b,PVector c,PVector d){
    float ta = (c.x - d.x) * (a.y - c.y) + (c.y - d.y) * (c.x - a.x);
    float tb = (c.x - d.x) * (b.y - c.y) + (c.y - d.y) * (c.x - b.x);
    float tc = (a.x - b.x) * (c.y - a.y) + (a.y - b.y) * (a.x - c.x);
    float td = (a.x - b.x) * (d.y - a.y) + (a.y - b.y) * (a.x - d.x);

    return tc * td <= 0 && ta * tb <= 0;
  }

  //isCircle==trueである必要あり
  boolean isHitCircleCircle(PShape s,PShape t) throws Exception {
    Ellipse sc = new Ellipse(s);
    Ellipse tc = new Ellipse(t);

    return isHitCircleCircle(sc,tc);
  }

  //isGoodCircle
  boolean isHitCircleCircleMat(PShape s,PShape t) throws Exception {
    Ellipse sc = new Ellipse(s,true);
    Ellipse tc = new Ellipse(t,true);

    return isHitCircleCircle(sc,tc);
  }

  boolean isHitCircleCircle(Ellipse sc,Ellipse tc) throws Exception {
    float d = dist(sc.x,sc.y,tc.x,tc.y);
    return d < sc.rx + tc.rx;
  }

  //Pshapeが円かどうか
  boolean isCircle(PShape s) throws Exception {
    if(s.getKind()!=ELLIPSE){
      return false;
    }else{
      Ellipse sc = new Ellipse(s);
      return equalf(sc.rx,sc.ry);
    }
  }

  boolean isRect(PShape s){
    return s.getKind()==RECT;
  }

  //平行移動+拡大のみであるか
  boolean isGoodRect(PShape s) throws Exception{
    PMatrix2D sm = PShape2PMatrix2D(s);
    PVector v00 = sm.mult(new PVector(0,0),null);
    PVector v10 = sm.mult(new PVector(1,0),null).sub(v00);
    PVector v01 = sm.mult(new PVector(0,1),null).sub(v00);
    return equalf(v10.y,0) && equalf(v01.x,0);
  }

  //平行移動+回転+いい拡大のみであるか
  boolean isGoodCircle(PShape s) throws Exception{
    PMatrix2D sm = PShape2PMatrix2D(s);
    PVector v00 = sm.mult(new PVector(0,0),null);
    PVector v10 = sm.mult(new PVector(1,0),null).sub(v00);
    PVector v01 = sm.mult(new PVector(0,1),null).sub(v00);
    return
      equalf(PVector.angleBetween(v10,v01),HALF_PI) &&
      equalf(v10.mag(),v01.mag());
  }

  //多角形を雑な円に変換
  Ellipse Path2Circle(Path p){
    if(!p.isClose){
      for(int i = p.points.size()-2;i>=1;--i){
        p.points.add(p.points.get(i));
      }
    }

    PVector g = Path2G(p);
    float r = Path2average(p,g);
    return new Ellipse(g.x,g.y,r,r);
  }

  //重心からの辺との距離の平均
  float Path2average(Path p,PVector g){
    //辺の長さのsum
    float sum = 0;
    //距離の和
    float d = 0;
    PVector m = p.points.get(p.points.size()-1);
    for(int i = 0; i<p.points.size();++i){
      PVector q = p.points.get(i);

      sum += q.dist(m);
      d += (g.dist(q) + g.dist(m))/2.0f * q.dist(m);

      m = q;
    }
    return d/sum;
  }

  //重心
  PVector Path2G(Path p){
    float sum = 0;
    float sumX = 0;
    float sumY = 0;
    PVector m = p.points.get(p.points.size()-1);
    for(int i = 0; i<p.points.size();++i){
      PVector q = p.points.get(i);

      float s = q.x * m.y - q.y * m.x;
      sum += s;//面積x2
      sumX += (q.x + m.x) * s;//x重心x6
      sumY += (q.y + m.y) * s;//y重心x6
      m = q;
    }
    return new PVector(sumX/(3.0f*sum),sumY/(3.0f*sum));
  }

  private class Path{
    ArrayList<PVector> points;
    boolean isClose;

    public Path(PShape s) throws Exception{
      PMatrix2D sm = PShape2PMatrix2D(s);
      points = new ArrayList<PVector>();
      if(s.getKind()==RECT){
        Rect r = new Rect(s);
        points.add(new PVector(r.cx+r.halfw,r.cy+r.halfh));
        points.add(new PVector(r.cx+r.halfw,r.cy-r.halfh));
        points.add(new PVector(r.cx-r.halfw,r.cy-r.halfh));
        points.add(new PVector(r.cx-r.halfw,r.cy+r.halfh));
        isClose = true;
        applyMat(sm);
        return;
      }
      if(s.getKind()==ELLIPSE){
        Ellipse e = new Ellipse(s);
        for(int i = 0; i < ELLIPSE_POINTS; ++i){
          float ang = float(i) / float(ELLIPSE_POINTS) * TWO_PI;
          points.add(new PVector(e.x+e.rx*cos(ang),e.y+e.ry*sin(ang)));
        }
        isClose = true;
        applyMat(sm);
        return;
      }
      if(s.getKind()==POLYGON){
        for(int i = 0; i < s.getVertexCount(); ++i){
          points.add(s.getVertex(i));
        }
        isClose = s.isClosed();
        applyMat(sm);
        return;
      }
      if(s.getKind()==LINE){
        float[] p = s.getParams();
        points.add(new PVector(p[0],p[1]));
        points.add(new PVector(p[2],p[3]));
        isClose = false;
        applyMat(sm);
        return;
      }
      if(s.getKind()==TRIANGLE){
        float[] p = s.getParams();
        points.add(new PVector(p[0],p[1]));
        points.add(new PVector(p[2],p[3]));
        points.add(new PVector(p[4],p[5]));
        isClose = true;
        applyMat(sm);
        return;
      }
      if(s.getKind()==QUAD){
        float[] p = s.getParams();
        points.add(new PVector(p[0],p[1]));
        points.add(new PVector(p[2],p[3]));
        points.add(new PVector(p[4],p[5]));
        points.add(new PVector(p[6],p[7]));
        isClose = true;
        applyMat(sm);
        return;
      }
      if(s.getKind()==ARC){
        Ellipse e = new Ellipse(s);
        for(int i = 0; i < ELLIPSE_POINTS; ++i){
          float ang = lerp(e.start,e.last,float(i) / float(ELLIPSE_POINTS));
          points.add(new PVector(e.x+e.rx*cos(ang),e.y+e.ry*sin(ang)));
        }
        if(e.mode==OPEN){
          isClose = false;
        }else
        if(e.mode==CHORD){
          isClose = true;
        }else
        if(e.mode==PIE){
          isClose = true;
          points.add(new PVector(e.x,e.y));
        }else{
          isClose = false;
        }
        applyMat(sm);
        return;
      }
      throw new Exception("その図形はサポートされていません。" + s );
    }

    public ArrayList<PVector> getPath(){
      ArrayList<PVector> res = (ArrayList<PVector>)points.clone();
      if(isClose){
        res.add(res.get(0));
      }
      return res;
    }

    public void applyMat(PMatrix2D m){
      for(int i = 0; i < points.size(); ++i){
        points.set(i,m.mult(points.get(i),null));
      }
    }
  }

  private class Rect{
    float cx,cy,halfw,halfh;
    public Rect(float cx,float cy,float w,float h){
      set(cx,cy,w,h);
    }
    public Rect(PShape s) throws Exception {
      if(s.getKind()==RECT){
        float[] p = s.getParams();
        switch(PShape2RectMode(s)){
          case RADIUS:
            set(p[0],p[1],p[2],p[3]);
            break;
          case CENTER:
            set(p[0],p[1],p[2]/2,p[3]/2);
            break;
          case CORNER:
            set(p[0]+p[2]/2,p[1]+p[3]/2,p[2]/2,p[3]/2);
            break;
          case CORNERS:
            set((p[0]+p[2])/2,(p[1]+p[3])/2,abs(p[0]-p[2])/2,abs(p[1]-p[3])/2);
            break;
          default:
            throw new Exception("不正なrectModeです。:" + s);
        }
      }else{
        throw new Exception("RECTでないPShapeを変換しようとしました。:" + s);
      }
    }
    public Rect(PShape s,boolean b) throws Exception{
      this(s);
      if(b){
        PMatrix2D sm = PShape2PMatrix2D(s);
        PVector v00 = sm.mult(new PVector(0,0),null);
        PVector v10 = sm.mult(new PVector(1,0),null).sub(v00);
        PVector v01 = sm.mult(new PVector(0,1),null).sub(v00);
        float theta = atan2(cy,cx);
        float length = mag(cx,cy);
        cx += v00.x + cos(theta) * length * v10.mag() - cos(theta) * length;
        cy += v00.y + sin(theta) * length * v01.mag() - sin(theta) * length;
        halfw *= v10.mag();
        halfh *= v01.mag();
      }
    }
    void set(float cx,float cy,float w,float h){
      this.cx = cx;
      this.cy = cy;
      this.halfw = w;
      this.halfh = h;
    }
  }

  //ellipseMode(RADIUS)に対応する,座標+半径
  private class Ellipse{
    float x,y,rx,ry;
    public Ellipse(float x,float y,float rx,float ry){
      set(x,y,rx,ry);
    }
    public Ellipse(PShape s) throws Exception {
      if(s.getKind()==ELLIPSE){
        float[] p = s.getParams();
        switch(PShape2EllipseMode(s)){
          case RADIUS:
            set(p[0],p[1],p[2],p[3]);
            break;
          case CENTER:
            set(p[0],p[1],p[2]/2,p[3]/2);
            break;
          case CORNER:
            set(p[0]+p[2]/2,p[1]+p[3]/2,p[2]/2,p[3]/2);
            break;
          case CORNERS:
            set((p[0]+p[2])/2,(p[1]+p[3])/2,abs(p[0]-p[2])/2,abs(p[1]-p[3])/2);
            break;
          default:
            throw new Exception("不正なellipseModeです。:" + s);
        }
      }else{
        throw new Exception("ELLIPSEでないPShapeを変換しようとしました。:" + s);
      }
    }
    //いい感じの変換をするか
    public Ellipse(PShape s,boolean b) throws Exception {
      this(s);
      if(b){
        PMatrix2D sm = PShape2PMatrix2D(s);
        PVector v00 = sm.mult(new PVector(0,0),null);
        PVector v10 = sm.mult(new PVector(1,0),null).sub(v00);
        PVector v01 = sm.mult(new PVector(0,1),null).sub(v00);
        float theta1 = atan2(y,x);
        float theta2 = atan2(y,x) + v10.heading();
        float length = mag(x,y);
        x += v00.x + cos(theta2) * length * v10.mag() - cos(theta1)*length;
        y += v00.y + sin(theta2) * length * v01.mag() - sin(theta1)*length;
        rx *= v10.mag();
        ry *= v01.mag();
      }
    }
    void set(float x,float y,float rx,float ry){
      this.x = x;
      this.y = y;
      this.rx = rx;
      this.ry = ry;
    }
  }

  //デバッグ用
  void printMatrix(PMatrix2D sm){
    println(sm.m00+" "+sm.m01+" "+sm.m02);
    println(sm.m10+" "+sm.m11+" "+sm.m12);
  }

  //floatの一致判定
  boolean equalf(float a,float b){
    return abs(a - b) <= FLT_EPSILON * max(1.f, max(abs(a), abs(b)));
  }

  //PVectorの一致判定
  boolean equalv(PVector v,PVector w){
    return equalf(v.x,w.x) && equalf(v.y,w.y);
  }

  //PMatrix2Dの一致判定
  boolean equalm(PMatrix2D s,PMatrix2D t){
    return
      equalf(s.m00,t.m00)&&equalf(s.m01,t.m01)&&equalf(s.m02,t.m02)&&
      equalf(s.m10,t.m10)&&equalf(s.m11,t.m11)&&equalf(s.m12,t.m12);
  }

  //PShapeからPMatrix2Dを取得
  PMatrix2D PShape2PMatrix2D(PShape s) throws Exception {
    PMatrix2D m = (PMatrix2D)PShapeField(s,"matrix");
    if(m == null) m = new PMatrix2D();
    return m;
  }

  //PShapeからRectModeを取得
  int PShape2RectMode(PShape s) throws Exception {
    return (int)PShapeField(s,"rectMode");
  }

  //PShapeからEllipseModeを取得
  int PShape2EllipseMode(PShape s) throws Exception {
    return (int)PShapeField(s,"ellipseMode");
  }

  //privateなFieldを無理やり取得するクソ野郎
  Object PShapeField(PShape s,String field) throws Exception {
    Field f = PShape.class.getDeclaredField(field);
    f.setAccessible(true);
    return f.get(s);
  }
}
