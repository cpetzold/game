package {
  import flash.geom.Rectangle;
  import de.nulldesign.nd2d.display.Sprite2D;
  import de.nulldesign.nd2d.display.Node2D;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import com.furusystems.dconsole2.DConsole;
  import utils.Vec2;

  /**
   * DynamicSprite is a Sprite with some extra properties
   * It adds x/y acceleration and damping, and overrides the step function
   * with something that automatically updates all physical properties.
   */
  public class DynamicSprite extends Sprite {

    public var hit:Rectangle; // X / Y offset from self

    public var acc:Vec2 = new Vec2(); // Acceleration vector
    public var grav:Vec2 = new Vec2(); // Gravity/wind vector
    public var vel:Vec2 = new Vec2(); // Velocity vector
    public var damp:Vec2 = new Vec2(0.97, 0.97); // Damping vector

    public function DynamicSprite(texture:Texture2D = null) {
      super(texture);
      this.hit = new Rectangle(0, 0, this.width, this.height);
    }

    public function get bounds():Rectangle {
      var bounds:Rectangle = this.hit.clone();
      bounds.offset(this.x - (this.width / 2), this.y - (this.height / 2));
      return bounds; 
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

      super.step(dt);
    }

  }

}