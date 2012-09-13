package {
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;
  import utils.Vec2;

  public class Sprite extends Sprite2D {

    public var startPos:Vec2;
    public var debug:Boolean = false;

    public function Sprite(texture:Texture2D = null) {
      this.startPos = new Vec2();
      super(texture);
    }

    public function set pos(p:Vec2):void {
      this.x = p.x;
      this.y = p.y;
    }

    public function get pos():Vec2 {
      return new Vec2(this.x, this.y);
    }

    public function reset():void {
      this.pos = this.startPos.clone();
    }

  }

}