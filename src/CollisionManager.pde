import java.io.*;
import processing.core.*;
import java.lang.reflect.*;

class CollisionManager{
  /**
   * 当たり判定を取得するメソッド
   * @param s 1つめの図形
   * @param t 2つめの図形
   * @return 図形が重なっている=true, それ以外=false
   */
  public boolean isHit(PShape s,PShape t){
    try{
      if(isCircle(s)&&isCircle(t)){
        return isHitCircleCircle(s,t);
      }
      if(isRect(s)&&isRect(t)){
        return isHitRectRect(s,t);
      }
      
      println("その図形はサポートされていません。: (" + s + ") , (" + t + ")");
      return false;
    }catch(Exception e){
      println(e + ": (" + s + ") , (" + t + ")");
      return false;
    }
  }
  
  PApplet sketch;
  
  public CollisionManager(PApplet sketch){
    this.sketch = sketch;
  }
  
  final float FLT_EPSILON = 1.19209290E-07F;
  
  boolean isHitRectRect(PShape s,PShape t) throws Exception {
    Rect sr = new Rect(s);
    Rect tr = new Rect(t);
    
    return (abs(sr.cx-tr.cx)<sr.harfw+tr.harfw) && (abs(sr.cy-tr.cy)<sr.harfh+tr.harfh);
  }
  
  //isCircle==trueである必要あり
  boolean isHitCircleCircle(PShape s,PShape t) throws Exception {
    Ellipse sc = new Ellipse(s);
    Ellipse tc = new Ellipse(t);
    
    float d = dist(sc.x,sc.y,tc.x,tc.y);
    return d < sc.rx + tc.rx;
  }
  
  //Pshapeが円かどうか
  public boolean isCircle(PShape s) throws Exception {
    if(s.getKind()!=ELLIPSE){
      return false;
    }else{
      Ellipse sc = new Ellipse(s);
      return equalf(sc.rx,sc.ry);
    }
  }
  
  public boolean isRect(PShape s){
    return s.getKind()==RECT;
  }
  
  //floatの一致判定
  boolean equalf(float a,float b){
    return abs(a - b) <= FLT_EPSILON * max(1.f, max(abs(a), abs(b)));
  }
  
  class Rect{
    float cx,cy,harfw,harfh;
    public Rect(float cx,float cy,float w,float h){
      Set(cx,cy,w,h);
    }
    public Rect(PShape s) throws Exception {
      if(s.getKind()==RECT){
        float[] p = s.getParams();        
        switch(PShape2RectMode(s)){
          case RADIUS:
            Set(p[0],p[1],p[2],p[3]);
            break;
          case CENTER:
            Set(p[0],p[1],p[2]/2,p[3]/2);
            break;
          case CORNER:
            Set(p[0]+p[2]/2,p[1]+p[3]/2,p[2]/2,p[3]/2);
            break;
          case CORNERS:
            Set((p[0]+p[2])/2,(p[1]+p[3])/2,abs(p[0]-p[2])/2,abs(p[1]-p[3])/2);
            break;
          default:
            throw new Exception("不正なellipseModeです。:" + s);
        }
      }else{
        throw new Exception("RECTでないPShapeを変換しようとしました。:" + s);
      }
    }
    void Set(float cx,float cy,float w,float h){
      this.cx = cx;
      this.cy = cy;
      this.harfw = w;
      this.harfh = h;
    }
  }
  
  //ellipseMode(RADIUS)に対応する,座標+半径
  class Ellipse{
    float x,y,rx,ry;
    public Ellipse(float x,float y,float rx,float ry){
      Set(x,y,rx,ry);
    }
    public Ellipse(PShape s) throws Exception {
      if(s.getKind()==ELLIPSE){
        float[] p = s.getParams();
        switch(PShape2EllipseMode(s)){
          case RADIUS:
            Set(p[0],p[1],p[2],p[3]);
            break;
          case CENTER:
            Set(p[0],p[1],p[2]/2,p[3]/2);
            break;
          case CORNER:
            Set(p[0]+p[2]/2,p[1]+p[3]/2,p[2]/2,p[3]/2);
            break;
          case CORNERS:
            Set((p[0]+p[2])/2,(p[1]+p[3])/2,abs(p[0]-p[2])/2,abs(p[1]-p[3])/2);
            break;
          default:
            throw new Exception("不正なellipseModeです。:" + s);
        }
      }else{
        throw new Exception("ELLIPSEでないPShapeを変換しようとしました。:" + s);
      }
    }
    void Set(float x,float y,float rx,float ry){
      this.x = x;
      this.y = y;
      this.rx = rx;
      this.ry = ry;
    }
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
