package {

  import DynamicSprite;

  public class Tile extends DynamicSprite {

    protected var _frame:uint;

    public function Tile() {
    }

    public function set frame(value:uint):void {
      this._frame = value;
      this.spriteSheet.frame = value;
    }

    public function get frame():uint {
      return this._frame;
    }

    override protected function step(dt:Number):void {
    }

  }

}