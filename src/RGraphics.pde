// 角度を指定して図形を描画する関数群

// 手順
// pushMatrix()で現在の変形行列を保存
// 原点を座標（ここでは図形の中心の座標を指定する）に合わせる
// rだけ回転する
// 原点を中心として図形を描画する
// popMatrix()で変形行列を復元する

// 基本的にはProcessingにある図形描画関数名の先頭に"r"をつけて各々を命名している
// もともとある関数とは
// - 座標は左上ではなく中心
// - rに回転角度を指定する
// ところが違うの注意
// また、rectModeを初期値以外にするとライブラリが壊れるので変更しないでください

// v2.0で追加
// ズーム系関数（rzで始まる関数）
// - z（あるいはzx, zy）に倍率を指定します
// r = 1.0を指定するとズームだけ行うことができます


// API説明　//////////

// 長方形

// rRect - 回転させた長方形を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）

// rzRect(1) - 回転+拡大縮小させた長方形を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）
// z : 倍率

// rzRect(2) - 回転+拡大縮小させた長方形を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）
// zx : X軸倍率
// zy : Y軸倍率


// 円弧

// rArc - 回転させた円弧を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// start : 開始角度
// end : 終了角度
// r : 回転角（時計回り）
// （省略可）mode : 描画モード

// rzArc(1) - 回転+拡大縮小させた円弧を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）
// z : 倍率
// （省略可）mode : 描画モード

// rzArc(2) - 回転+拡大縮小させた円弧を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）
// zx : X軸倍率
// zy : Y軸倍率
// （省略可）mode : 描画モード


// 楕円

// rEllipse - 回転させた楕円を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）

// rzEllipse(1) - 回転+拡大縮小させた楕円を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）
// z : 倍率

// rzEllipse(2) - 回転+拡大縮小させた楕円を描画します
// xc : 中心X座標
// yc : 中心Y座標
// w : 幅
// h : 高さ
// r : 回転角（時計回り）
// zx : X軸倍率
// zy : Y軸倍率


// 文字列

// rText - 回転させた文字列を描画します
// s : 描画する文字列（FIXME：数値変数にも対応させろ！！）
// xc : 中心X座標
// yc : 中心Y座標
// r : 回転角（時計回り）

// rzText(1) - 回転+拡大縮小させた文字列を描画します
// s : 描画する文字列（FIXME：数値変数にも対応させろ！！）
// xc : 中心X座標
// yc : 中心Y座標
// r : 回転角（時計回り）
// z : 倍率

// rzText(2) - 回転+拡大縮小させた文字列を描画します
// s : 描画する文字列（FIXME：数値変数にも対応させろ！！）
// xc : 中心X座標
// yc : 中心Y座標
// r : 回転角（時計回り）
// zx : X軸倍率
// zy : Y軸倍率

// textHeight - 文字列グラフィックの高さを返します
// （引数なし）


// 画像

// rImage - 回転させた画像を描画します
// img : 描画するPImage
// xc : 中心X座標
// yc : 中心Y座標
// （省略可）w : 幅
// （省略可）h : 高さ
// r : 回転角（時計回り）

// rzImage(1) - 回転+拡大縮小させた画像を描画します
// img : 描画するPImage
// xc : 中心X座標
// yc : 中心Y座標
// （省略可）w : 幅
// （省略可）h : 高さ
// r : 回転角（時計回り）
// z : 倍率

// rzImage(2) - 回転+拡大縮小させた画像を描画します
// img : 描画するPImage
// xc : 中心X座標
// yc : 中心Y座標
// （省略可）w : 幅
// （省略可）h : 高さ
// r : 回転角（時計回り）
// zx : X軸倍率
// zy : Y軸倍率

// API説明ここまで //////////

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
}void rzImage(PImage img, float xc, float yc, float r, float zx, float zy) {
  rzImage(img, xc, yc, img.width, img.height, r, zx, zy);
}
