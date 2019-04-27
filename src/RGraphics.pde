/**
 * 角度を指定して図形を描画する関数群
 */
public class RGraphics {
  
  public RGraphics() {}
  
  /**
   * 回転させた長方形を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   */
  public void rRect(float xc, float yc, float w, float h, float r) {
    rzRect(xc, yc, w, h, r, 1.0);
  }

  /**
   * 回転+拡大縮小させた長方形を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   * @param z 拡大率
   */
  public void rzRect(float xc, float yc, float w, float h, float r, float z) {
    rzRect(xc, yc, w, h, r, z, z);
  }

  /**
   * 回転+拡大縮小させた長方形を描画します（縦横ともに倍率指定）
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   */
  public void rzRect(float xc, float yc, float w, float h, float r, float zx, float zy) {
    pushMatrix();
    translate(xc, yc);
    rotate(r);
    scale(zx, zy);
    rect(-w/2, -h/2, w, h);
    popMatrix();
  }


  /**
   * 回転させた円弧を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param start 開始角度（時計回り）
   * @param end 終了角度（時計回り）
   * @param r 回転角（時計回り）
   * @param mode 円弧描画モード
   */
  public void rArc(float xc, float yc, float w, float h, float start, float end, float r, int mode) {
    rzArc(xc, yc, w, h, start, end, r, 1.0, mode);
  }

  /**
   * 回転+拡大縮小させた円弧を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param start 開始角度（時計回り）
   * @param end 終了角度（時計回り）
   * @param r 回転角（時計回り）
   */
  public void rArc(float xc, float yc, float w, float h, float start, float end, float r) {
    rzArc(xc, yc, w, h, start, end, r, 1.0, OPEN+PIE);
  }

  /**
   * 回転+拡大縮小させた円弧を描画します（モード指定）
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param start 開始角度（時計回り）
   * @param end 終了角度（時計回り）
   * @param r 回転角（時計回り）
   * @param z 拡大率
   * @param mode 円弧描画モード
   */
  public void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float z, int mode) {
    rzArc(xc, yc, w, h, start, end, r, z, z, mode);
  }

  /**
   * 回転+拡大縮小させた円弧を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param start 開始角度（時計回り）
   * @param end 終了角度（時計回り）
   * @param r 回転角（時計回り）
   * @param z 拡大率
   */
  public void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float z) {
    rzArc(xc, yc, w, h, start, end, r, z, z, OPEN+PIE);
  }

  /**
   * 回転+拡大縮小させた円弧を描画します（モード指定、縦横ともに倍率指定）
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param start 開始角度（時計回り）
   * @param end 終了角度（時計回り）
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   * @param mode 円弧描画モード
   */
  public void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float zx, float zy, int mode) {
    pushMatrix();
    translate(xc, yc);
    rotate(r);
    scale(zx, zy);
    arc(xc, yc, w, h, start, end, mode);
    popMatrix();
  }

  /**
   * 回転+拡大縮小させた円弧を描画します（縦横ともに倍率指定）
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param start 開始角度（時計回り）
   * @param end 終了角度（時計回り）
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   */
  public void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float zx, float zy) {
    rzArc(xc, yc, w, h, start, end, r, zx, zy, OPEN+PIE);
  }


  /**
   * 回転させた楕円を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   */
  public void rEllipse(float xc, float yc, float w, float h, float r) {
    rzEllipse(xc, yc, w, h, r, 1.0);
  }

  /**
   * 回転+拡大縮小させた楕円を描画します
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   * @param z 拡大率
   */
  public void rzEllipse(float xc, float yc, float w, float h, float r, float z) {
    rzEllipse(xc, yc, w, h, r, z, z);
  }

  /**
   * 回転+拡大縮小させた楕円を描画します（縦横ともに倍率指定）
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   */
  public void rzEllipse(float xc, float yc, float w, float h, float r, float zx, float zy) {
    pushMatrix();
    translate(xc, yc);
    rotate(r);
    scale(zx, zy);
    ellipse(xc, yc, w, h);
    popMatrix();
  }


  /**
   * 文字列グラフィックの高さを返します
   * @return 文字列グラフィックの高さの概算値（ピクセル単位）
   */
  public float textHeight() {
    return textAscent() + textDescent();
  }


  /**
   * 回転させた文字列を描画します
   * @param s 描画する文字列
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param r 回転角（時計回り）
   */
  public void rText(String s, float xc, float yc, float r) {
    rzText(s, xc, yc, r, 1.0);
  }

  /**
   * 回転+拡大縮小させた文字列を描画します
   * @param s 描画する文字列
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param r 回転角（時計回り）
   * @param z 拡大率
   */
  public void rzText(String s, float xc, float yc, float r, float z) {
    rzText(s, xc, yc, r, z, z);
  }

  /**
   * 回転+拡大縮小させた文字列を描画します（縦横ともに倍率指定）
   * @param s 描画する文字列
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   */
  public void rzText(String s, float xc, float yc, float r, float zx, float zy) {
    pushMatrix();
    translate(xc, yc);
    rotate(r);
    scale(zx, zy);
    text(s, -textWidth(s)/2, -(textHeight())/2);
    popMatrix();
  }


  /**
   * 回転させた画像を描画します（幅高さ指定）
   * @param img 描画するPImage
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   */
  public void rImage(PImage img, float xc, float yc, float w, float h, float r) {
    rzImage(img, xc, yc, w, h, r, 1.0);
  }

  /**
   * 回転させた画像を描画します
   * @param img 描画するPImage
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param r 回転角（時計回り）
   */
  public void rImage(PImage img, float xc, float yc, float r) {
    rzImage(img, xc, yc, r, 1.0);
  }

  /**
   * 回転+拡大縮小させた画像を描画します（幅高さ指定）
   * @param img 描画するPImage
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   * @param z 拡大率
   */
  public void rzImage(PImage img, float xc, float yc, float w, float h, float r, float z) {
    rzImage(img, xc, yc, w, h, r, z, z);
  }

  /**
   * 回転+拡大縮小させた画像を描画します
   * @param img 描画するPImage
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param r 回転角（時計回り）
   * @param z 拡大率
   */
  public void rzImage(PImage img, float xc, float yc, float r, float z) {
    rzImage(img, xc, yc, r, z, z);
  }

  /**
   * 回転+拡大縮小させた画像を描画します（幅高さ指定、縦横ともに倍率指定）
   * @param img 描画するPImage
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param w 幅
   * @param h 高さ
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   */
  public void rzImage(PImage img, float xc, float yc, float w, float h, float r, float zx, float zy) {
    pushMatrix();
    translate(xc, yc);
    rotate(r);
    scale(zx, zy);
    image(img, -w/2, -h/2, w, h);
    popMatrix();
  }

  /**
   * 回転+拡大縮小させた画像を描画します（縦横ともに倍率指定）
   * @param img 描画するPImage
   * @param xc 中心X座標
   * @param yc 中心X座標
   * @param r 回転角（時計回り）
   * @param zx 拡大率（X軸）
   * @param zy 拡大率（Y軸）
   */
  public void rzImage(PImage img, float xc, float yc, float r, float zx, float zy) {
    rzImage(img, xc, yc, img.width, img.height, r, zx, zy);
  }
}

// 以下、エイリアスを張るために全く同じ関数をグローバル域（？）に置いている
void rRect(float xc, float yc, float w, float h, float r) {
  rzRect(xc, yc, w, h, r, 1.0);
}

void rzRect(float xc, float yc, float w, float h, float r, float z) {
  rzRect(xc, yc, w, h, r, z, z);
}

void rzRect(float xc, float yc, float w, float h, float r, float zx, float zy) {
  pushMatrix();
  translate(xc, yc);
  rotate(r);
  scale(zx, zy);
  rect(-w/2, -h/2, w, h);
  popMatrix();
}

void rArc(float xc, float yc, float w, float h, float start, float end, float r, int mode) {
  rzArc(xc, yc, w, h, start, end, r, 1.0, mode);
}

void rArc(float xc, float yc, float w, float h, float start, float end, float r) {
  rzArc(xc, yc, w, h, start, end, r, 1.0, OPEN+PIE);
}

void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float z, int mode) {
  rzArc(xc, yc, w, h, start, end, r, z, z, mode);
}

void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float z) {
  rzArc(xc, yc, w, h, start, end, r, z, z, OPEN+PIE);
}

void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float zx, float zy, int mode) {
  pushMatrix();
  translate(xc, yc);
  rotate(r);
  scale(zx, zy);
  arc(xc, yc, w, h, start, end, mode);
  popMatrix();
}

void rzArc(float xc, float yc, float w, float h, float start, float end, float r, float zx, float zy) {
  rzArc(xc, yc, w, h, start, end, r, zx, zy, OPEN+PIE);
}

void rEllipse(float xc, float yc, float w, float h, float r) {
  rzEllipse(xc, yc, w, h, r, 1.0);
}

void rzEllipse(float xc, float yc, float w, float h, float r, float z) {
  rzEllipse(xc, yc, w, h, r, z, z);
}

void rzEllipse(float xc, float yc, float w, float h, float r, float zx, float zy) {
  pushMatrix();
  translate(xc, yc);
  rotate(r);
  scale(zx, zy);
  ellipse(xc, yc, w, h);
  popMatrix();
}

float textHeight() {
  return textAscent() + textDescent();
}

void rText(String s, float xc, float yc, float r) {
  rzText(s, xc, yc, r, 1.0);
}

void rzText(String s, float xc, float yc, float r, float z) {
  rzText(s, xc, yc, r, z, z);
}

void rzText(String s, float xc, float yc, float r, float zx, float zy) {
  pushMatrix();
  translate(xc, yc);
  rotate(r);
  scale(zx, zy);
  text(s, -textWidth(s)/2, -(textHeight())/2);
  popMatrix();
}

void rImage(PImage img, float xc, float yc, float w, float h, float r) {
  rzImage(img, xc, yc, w, h, r, 1.0);
}

void rImage(PImage img, float xc, float yc, float r) {
  rzImage(img, xc, yc, r, 1.0);
}


void rzImage(PImage img, float xc, float yc, float w, float h, float r, float z) {
  rzImage(img, xc, yc, w, h, r, z, z);
}

void rzImage(PImage img, float xc, float yc, float r, float z) {
  rzImage(img, xc, yc, r, z, z);
}

void rzImage(PImage img, float xc, float yc, float w, float h, float r, float zx, float zy) {
  pushMatrix();
  translate(xc, yc);
  rotate(r);
  scale(zx, zy);
  image(img, -w/2, -h/2, w, h);
  popMatrix();
}

void rzImage(PImage img, float xc, float yc, float r, float zx, float zy) {
  rzImage(img, xc, yc, img.width, img.height, r, zx, zy);
}
