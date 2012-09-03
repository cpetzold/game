package {

  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;

  public class Tile extends Sprite2D {

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

  }

}