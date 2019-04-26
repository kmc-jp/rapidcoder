// ライブラリを読み込み（よくわからなかったらとりあえずそのままにしておいてください）
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// ゲームシステム用変数（よくわからなかったらとりあえずそのままにしておいてください）
// キーボード入力管理用のKeyboardManager
KeyboardManager keyman;
// 当たり判定取得用のCollisionManager
CollisionManager colman;
// フォント（環境によって違ったらヤバそうなので一応スケッチに付属させたVLゴシックを使うことにしている）
PFont font;

// Minimライブラリ用の変数
Minim minim;
// ゲームシステム用変数ここまで

// 以下にグローバル変数を宣言します
ArrayList<PShape> s;
PShape t;
// グローバル変数ここまで

// スケッチ実行時に最初に１度だけ実行されます
void setup() {
  // ゲームの初期化
  // ゲームシステムの初期化（よくわからなかったらとりあえずそのままにしておいてください）
  print("文字列描画を初期化中......");
  // KeyboardManagerのインスタンスを作成
  keyman = new KeyboardManager();
  // CollisionManagerのインスタンスを作成
  colman = new CollisionManager();
  // フォントを読み込む
  font = createFont("fonts/VL-PGothic-Regular.ttf", 24);
  if(font == null) {
    // ここで読み込めていない場合はWindowsと同じで'\'で区切るのかもしれない
    font = createFont("fonts\\VL-PGothic-Regular.ttf", 24);
  }
  textFont(font);
  // 文字描画位置を設定する（座標が左上）
  textAlign(LEFT, TOP);
  println("\t[ OK ]");

  print("ビデオを初期化中......");
  // 画面サイズを設定（左から順に幅と高さ）
  size(800, 600);
  // フレームレート（単位はフレーム毎秒）
  // １秒間にここに指定した回数だけdraw()が呼ばれる
  frameRate(30);
  println("\t[ OK ]");

  print("サウンドシステムを初期化中......");
  // 音声ライブラリ初期化
  minim = new Minim(this);
  println("\t[ OK ]");

  println("完了.");
  // ゲームシステムの初期化ここまで

  // 以下に追加の初期化処理を書きます
  s = new ArrayList<PShape>();
  for(int i = 0;i<100;++i){
    ellipseMode(CENTER);
    PShape a = createShape(ELLIPSE,0,0,80,80);
    a.translate(random(0,800),random(0,600));
    a.rotate(random(0,HALF_PI));
    s.add(a);
  }
  // 初期化処理ここまで
}

// ゲームメインループ
void draw(){
  // キー入力情報の更新
  keyman.updateKeys();
  // 画面の消去（背景色をここで指定する）
  background(255, 255, 255);

  // 以下にゲームの処理を書きます
  ellipseMode(CENTER);
  rectMode(CENTER);


  t = createShape(TRIANGLE,30, 75, 58, 20, 86, 75);
  t.translate(mouseX,mouseY);
  t.rotate(1f);
  t.setFill(false);

  for(PShape a : s){
    if(colman.isHit(a,t)){
      a.setFill(color(255,0,0));
    }else{
      a.setFill(color(0,0,255));
    }
    shape(a);
  }

  shape(t);

  fill(0);
  text(frameRate,0,0);
  // ゲームの処理ここまで
}

// 何かキーが押されたときに行う処理を書きます（よくわからなかったらとりあえずそのままにしておいてください）
void keyPressed() {
  // 押されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyPressedHook();
}
// 何かキーが離されたときに行う処理を書きます（よくわからなかったらとりあえずそのままにしておいてください）
void keyReleased() {
  // 離されたキーを確認する（KeyboardManager keymanを動作させるために必要）
  keyman.keyReleasedHook();
}
