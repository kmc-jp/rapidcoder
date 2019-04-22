import java.lang.*;

/**
 * キーボードの入力を管理するクラス
 */
public class KeyboardManager {
  // IntDictでキーの状態を保持する
  // キー: str(key)(KeyState)およびstr(keyCode)(specialKeyState)

  /**
   * 大文字と小文字を区別するか
   */
  public boolean ignoreUpperCase = true;

  /**
   * ASCII文字キーの現在の状態を保持するIntDict
   */
  private IntDict c_keyState;

  /**
   * ASCII文字キーの状態を保持するIntDict
   */
  private IntDict keyState;

  /**
   * 前フレームのASCII文字キーの状態を保持するIntDict
   */
  private IntDict prevKeyState;

  /**
   * 特殊キー(方向キー、Alt、Ctrl、Shift)の現在の状態を保持するIntDict
   */
  private IntDict c_specialKeyState;

  /**
   * 特殊キー(方向キー、Alt、Ctrl、Shift)の状態を保持するIntDict
   */
  private IntDict specialKeyState;

  /**
   * 前フレームの特殊キー(方向キー、Alt、Ctrl、Shift)の状態を保持するIntDict
   */
  private IntDict prevSpecialKeyState;

  /**
   * コンストラクタ
   */
  KeyboardManager() {
    keyState = new IntDict();
    specialKeyState = new IntDict();
    c_keyState = new IntDict();
    c_specialKeyState = new IntDict();
    prevKeyState = new IntDict();
    prevSpecialKeyState= new IntDict();
  }
  
  /**
   * 押したキーのStringが返ってくる
   */
  public ArrayList<String> getKeyString(){
    ArrayList<String> res = new ArrayList<String>();
    for(int i = 0; i< keyState.size();++i){
      String s_key = keyState.key(i);
      if(keyState.value(i) == 1){
        if(prevKeyState.hasKey(s_key)){
          if(prevKeyState.get(s_key)==0){
            res.add(s_key);
          }
        }else{
          res.add(s_key);
        }
      }
    }
    return res;
  }

  /**
   * keyPressedで行う入力状態の更新をするメソッド
   * これをkeyPressed()で呼び出すようにしてください
   */
  public void keyPressedHook() {
    if(key == CODED) {
      this.c_specialKeyState.set(str(keyCode), 1);
    } else {
      if(Character.isUpperCase(key)){
        this.c_keyState.set(str(key), 1);
        this.c_keyState.set(str(Character.toLowerCase(key)), 0);
      }else
      if(Character.isLowerCase(key)){
        this.c_keyState.set(str(key), 1);
        this.c_keyState.set(str(Character.toUpperCase(key)), 0);
      }else{
        this.c_keyState.set(str(key), 1);
      }
    }
  }

  /**
   * keyReleasedで行う入力状態の更新をするメソッド
   * これをkeyReleased()で呼び出すようにしてください
   */
  public void keyReleasedHook() {
    if(key == CODED) {
      this.c_specialKeyState.set(str(keyCode), 0);
    } else {
      this.c_keyState.set(str(key), 0);
    }
  }

  /**
   * 実際に返す入力状態を更新するメソッド
   */
  public void updateKeys() {
    this.prevKeyState=keyState;
    this.prevSpecialKeyState=specialKeyState;
    this.keyState = new IntDict(c_keyState.keyArray(), c_keyState.valueArray());
    this.specialKeyState = new IntDict(c_specialKeyState.keyArray(), c_specialKeyState.valueArray());
  }

  /**
   * s_keyに対応するASCII文字キーが押されているかどうかを確かめるメソッド
   * @param s_key 確かめるキーの文字（大文字小文字は区別される）
   * @return キーが押されている=true, それ以外=false
   */
  public boolean getKey(String s_key) {
    if(ignoreUpperCase){
      char c = s_key.charAt(0);
      if(Character.isUpperCase(c)||
         Character.isLowerCase(c)){
        return 
          getKeyImpl(str(Character.toUpperCase(c)))||
          getKeyImpl(str(Character.toLowerCase(c)));
      }else{
        return getKeyImpl(s_key);
      }
    }else{
      return getKeyImpl(s_key);
    }
  }
  
  boolean getKeyImpl(String s_key){
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

  /**
   * key_codeに対応するキーが押されているかどうかを確かめるメソッド
   * @param key_code 確かめるキーのキーコード
   * @return キーが押されている=true, それ以外=false
   */
  public boolean getKey(int key_code){
    return getSpecialKey(key_code);
  }


  // 内部用 && 広報互換性を保つために残す
  public boolean getSpecialKey(int key_code) {
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

  /**
   * キーが押された瞬間かどうかを確かめるメソッド
   * @param s_key 確かめるキーの文字（大文字小文字が区別される）
   * @return キーが押された瞬間=true, それ以外=false
   */
  public boolean getKeyPush(String s_key){
    return getKey(s_key)&&!getPrevKey(s_key);
  }

  /**
   * キーが押された瞬間かどうかを確かめるメソッド
   * @param key_code 確かめるキーのキーコード
   * @return キーが押された瞬間=true, それ以外=false
   */
  public boolean getKeyPush(int key_code){
    return getSpecialKeyPush(key_code);
  }

  // 内部用
  private boolean getSpecialKeyPush(int key_code){
    return getSpecialKey(key_code)&&!getPrevSpecialKey(key_code);
  }

  /**
   * キーが離された瞬間かどうかを確かめるメソッド
   * @param s_key 確かめるキーの文字（大文字小文字が区別される）
   * @return キーが押された瞬間=true, それ以外=false
   */
  public boolean getKeyRelease(String s_key){
    return !getKey(s_key)&&getPrevKey(s_key);
  }

  /**
   * キーが離された瞬間かどうかを確かめるメソッド
   * @param key_code 確かめるキーのキーコード
   * @return キーが押された瞬間=true, それ以外=false
   */
  public boolean getKeyRelease(int key_code){
    return getSpecialKeyRelease(key_code);
  }


  // 内部用
  private boolean getSpecialKeyRelease(int key_code){
    return !getSpecialKey(key_code)&&getPrevSpecialKey(key_code);
  }

  //内部用
  private boolean getPrevKey(String s_key) {
    if(ignoreUpperCase){
      char c = s_key.charAt(0);
      if(Character.isUpperCase(c)||
         Character.isLowerCase(c)){
        return 
          getPrevKeyImpl(str(Character.toUpperCase(c)))||
          getPrevKeyImpl(str(Character.toLowerCase(c)));
      }else{
        return getPrevKeyImpl(s_key);
      }
    }else{
      return getPrevKeyImpl(s_key);
    }
  }
  private boolean getPrevKeyImpl(String s_key){
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
  private boolean getPrevSpecialKey(int key_code) {
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
