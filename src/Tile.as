package {
  import DynamicSprite;

  public class Tile extends DynamicSprite {

    protected var _frame:uint;

    public function Tile() {
      super();
    }

    public function set frame(value:uint):void {
      this._frame = value;
      this.spriteSheet.frame = value;
    }

    public function get frame():uint {
      return this._frame;
    }

    public function equals(t:Tile):Boolean {
      return (this.x == t.x && this.y == t.y);
    }

    override protected function step(dt:Number):void {
    }

  }

}