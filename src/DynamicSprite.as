package {

  import flash.geom.Rectangle;
  import flash.display.Sprite;

  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;

  import com.furusystems.dconsole2.DConsole;

  /**
   * DynamicSprite is a Sprite2D with some extra properties
   * It adds x/y acceleration and damping, and overrides the step function
   * with something that automatically updates all physical properties.
   */
  public class DynamicSprite extends Sprite2D {

    public var boundsSprite:Sprite;

    public var ax:Number = 0.0; // X Acceleration
    public var ay:Number = 0.0; // Y Acceleration
    public var dampx:Number = 0.99; // X Damping
    public var dampy:Number = 0.99; // Y Damping

    public var debug:Boolean = false;

    public function DynamicSprite(texture:Texture2D = null) {
      super(texture);

      this.boundsSprite = new Sprite();

      this.vx = 0.0;
      this.vy = 0.0;
    }

    public function get bounds():Rectangle {
      var sprite:Sprite2D = this;
      if (this.mask) {
        sprite = this.mask;
      }

      return new Rectangle(sprite.x - (sprite.width / 2), sprite.y - (sprite.height / 2), sprite.width, sprite.height);
    }

    public function get movingLeft():Boolean {
      return this.vx < 0;
    }

    public function get movingRight():Boolean {
      return this.vx > 0;
    }

    public function get movingUp():Boolean {
      return this.vy < 0;
    }

    public function get movingDown():Boolean {
      return this.vy > 0;
    }

    override protected function step(dt:Number):void {
      this.vx += this.ax;
      this.vy += this.ay;

      this.vx *= this.dampx;
      this.vy *= this.dampy;

      this.x += (this.vx * dt);
      this.y += (this.vy * dt);

      this.ax = this.ay = 0.0;

      if (this.debug) {
        this.debugStep(dt);
      }

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