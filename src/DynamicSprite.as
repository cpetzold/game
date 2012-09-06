package {
  import flash.geom.Rectangle;
  import flash.display.Sprite;
  import de.nulldesign.nd2d.display.Sprite2D;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import com.furusystems.dconsole2.DConsole;
  import utils.Vec2;

  import Sprite;

  /**
   * DynamicSprite is a Sprite with some extra properties
   * It adds x/y acceleration and damping, and overrides the step function
   * with something that automatically updates all physical properties.
   */
  public class DynamicSprite extends Sprite {

    public var boundsSprite:flash.display.Sprite;

    public var acc:Vec2 = new Vec2(); // Acceleration vector
    public var grav:Vec2 = new Vec2(); // Gravity/wind vector
    public var vel:Vec2 = new Vec2(); // Velocity vector
    public var damp:Vec2 = new Vec2(0.97, 0.97); // Damping vector

    public function DynamicSprite(texture:Texture2D = null) {
      super(texture);

      this.boundsSprite = new flash.display.Sprite();
    }

    public function get bounds():Rectangle {
      var sprite:Sprite2D = this;
      if (this.mask) {
        sprite = this.mask;
      }

      return new Rectangle(sprite.x - (sprite.width / 2), sprite.y - (sprite.height / 2), sprite.width, sprite.height);
    }

    public function get movingLeft():Boolean {
      return this.vel.x < 0;
    }

    public function get movingRight():Boolean {
      return this.vel.x > 0;
    }

    public function get movingUp():Boolean {
      return this.vel.y < 0;
    }

    public function get movingDown():Boolean {
      return this.vel.y > 0;
    }

    override protected function step(dt:Number):void {
      this.vel.addSelf(this.acc).mulSelf(this.damp);

      this.pos = this.vel.scale(dt).add(this.pos);

      this.acc = this.grav.clone();

      if (this.debug) this.debugStep(dt);
      super.step(dt);
    }

    private function debugStep(dt:Number):void {
      var bounds:Rectangle = this.bounds;
      if (bounds.width) {
        this.boundsSprite.x = bounds.x;
        this.boundsSprite.y = bounds.y;
        this.boundsSprite.graphics.clear();
        this.boundsSprite.graphics.lineStyle(1, 0xff0000);
        this.boundsSprite.graphics.drawRect(0, 0, bounds.width, bounds.height);
      }
    }

  }

}