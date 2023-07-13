import HaxeCBridge;

class Main {
    static function main() {
        trace("haxe thread started!");
    }
}

@:build(HaxeCBridge.expose())
class UseMeFromC {

  final callback: cpp.Callable<(num: Int) -> Void>;

  public function new(nativeCallback: cpp.Callable<(num: Int) -> Void>) {
    this.callback = nativeCallback;
  }

  public function add(a: Int, b: Int) {
    var result = a + b;
    if (callback != null) {
        callback(result);
    }
    return result;
  }

  @externalThread
  static public function myNum() {
    final u = new UseMeFromC(null);
    return u.add(11, 1);
  }

  static public function exampleStaticFunction() {
    return "here's a string from haxe! In C this will be represented as a const char*. When passing haxe object to C, the object will be retained so it's not garbage collected while it's being used in C. When finished with haxe objects, you can call releaseHaxeString() or releaseHaxeObject()";
  }

}