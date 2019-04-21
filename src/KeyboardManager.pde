// キーボードの入力を管理するクラス
class KeyboardManager {
  // IntDictでキーの状態を保持する
  // キー: str(key)(KeyState)およびstr(keyCode)(specialKeyState)
  // ASCII文字キーの現在の状態を保持するIntDict 
  IntDict c_keyState;
  // ASCII文字キーの状態を保持するIntDict
  IntDict keyState;
  // 前フレームのASCII文字キーの状態を保持するIntDict
  IntDict prevKeyState;
  // 特殊キー(方向キー、Alt、Ctrl、Shift)の現在の状態を保持するIntDict
  IntDict c_specialKeyState;
  // 特殊キー(方向キー、Alt、Ctrl、Shift)の状態を保持するIntDict
  IntDict specialKeyState;
  // 前フレームの特殊キー(方向キー、Alt、Ctrl、Shift)の状態を保持するIntDict
  IntDict prevSpecialKeyState;
  
  // コンストラクタ
  KeyboardManager() {
    keyState = new IntDict();
    specialKeyState = new IntDict();
    c_keyState = new IntDict();
    c_specialKeyState = new IntDict();
    prevKeyState = new IntDict();
    prevSpecialKeyState= new IntDict();
  }
  
  // これのインスタンスメソッドをkeyPressed()で呼び出すようにしてください
  void keyPressedHook() {
    if(key == CODED) {
      this.c_specialKeyState.set(str(keyCode), 1);
    } else {
      this.c_keyState.set(str(key), 1);
    }
  }
  // これのインスタンスメソッドをkeyReleased()で呼び出すようにしてください
  void keyReleasedHook() {
    if(key == CODED) {
      this.c_specialKeyState.set(str(keyCode), 0);
    } else {
      this.c_keyState.set(str(key), 0);
    }
  }
  
  // キー入力の情報を更新します
  void updateKeys() {
    this.prevKeyState=keyState;
    this.prevSpecialKeyState=specialKeyState;
    this.keyState = new IntDict(c_keyState.keyArray(), c_keyState.valueArray());
    this.specialKeyState = new IntDict(c_specialKeyState.keyArray(), c_specialKeyState.valueArray());
  }
  
  // s_keyに対応するASCII文字キーが押されているかどうかを確かめます
  // 返り値: キーが押されている=true, それ以外=false
  boolean getKey(String s_key) {
    if(this.keyState.hasKey(s_key) == true) {
      if(this.keyState.get(s_key) == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  // key_codeに対応する特殊キーが押されているかどうかを確かめます
  // 返り値: キーが押されている=true, それ以外=false
  boolean getKey(int key_code){
    return getSpecialKey(key_code);
  }
  private boolean getSpecialKey(int key_code) {
    if(this.specialKeyState.hasKey(str(key_code)) == true) {
      if(this.specialKeyState.get(str(key_code)) == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  // キーが押された瞬間かどうかを確かめます
  // 返り値: キーが押された瞬間=true, それ以外=false
  boolean getKeyPush(String s_key){
    return getKey(s_key)&&!getPrevKey(s_key);
  }
  boolean getKeyPush(int key_code){
    return getSpecialKeyPush(key_code);
  }
  private boolean getSpecialKeyPush(int key_code){
    return getSpecialKey(key_code)&&!getPrevSpecialKey(key_code);
  }
  // キーが離された瞬間かどうかを確かめます
  // 返り値: キーが離された瞬間=true, それ以外=false
  boolean getKeyRelease(String s_key){
    return !getKey(s_key)&&getPrevKey(s_key);
  }
  boolean getKeyRelease(int key_code){
    return getSpecialKeyRelease(key_code);
  } 
  private boolean getSpecialKeyRelease(int key_code){
    return !getSpecialKey(key_code)&&getPrevSpecialKey(key_code);
  }
  
  //内部用
  boolean getPrevKey(String s_key) {
    if(this.prevKeyState.hasKey(s_key) == true) {
      if(this.prevKeyState.get(s_key) == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
  //内部用
    boolean getPrevSpecialKey(int key_code) {
    if(this.prevSpecialKeyState.hasKey(str(key_code)) == true) {
      if(this.prevSpecialKeyState.get(str(key_code)) == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
