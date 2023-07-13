class Main2 {
    static function main() {
        trace("haxe started!\n" + UseMeFromC.exampleStaticFunction());
    }
}

class UseMeFromC {

    public function new() {}

  public function add(a: Int, b: Int) {
    var result = a + b;
    return result;
  }

  static public function myNum() {
    final u = new UseMeFromC();
    return u.add(11, 1);
  }

  static public function exampleStaticFunction() {
    return "here's a string from haxe! In C this will be represented as a const char*. When passing haxe object to C, the object will be retained so it's not garbage collected while it's being used in C. When finished with haxe objects, you can call releaseHaxeString() or releaseHaxeObject()";
  }

}