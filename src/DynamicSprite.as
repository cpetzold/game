package {

  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;

  import com.furusystems.dconsole2.DConsole;

  /**
   * DynamicSprite is a Sprite2D with some extra properties
   * It adds x/y acceleration and damping, and overrides the step function
   * with something that automatically updates all physical properties.
   */
  public class DynamicSprite extends Sprite2D {

    public var ax:Number = 0.0; // X Acceleration
    public var ay:Number = 0.0; // Y Acceleration
    public var dampx:Number = 1; // X Damping
    public var dampy:Number = 1; // Y Damping

    public function DynamicSprite(texture:Texture2D = null) {
      super(texture);

      this.vx = 0.0;
      this.vy = 0.0;
    }

    override protected function step(dt:Number):void {

      //DConsole.print('Acc: ' + this.ax + ' x ' + this.ay);
      DConsole.print('Vel: ' + this.vx + ' x ' + this.vy);
      //DConsole.print('Pos: ' + this.x + ' x ' + this.y);

      this.vx += this.ax;
      this.vy += this.ay;

      this.vx *= this.dampx;
      this.vy *= this.dampy;

      this.x += (this.vx * dt);
      this.y += (this.vy * dt);

      this.ax = this.ay = 0.0;

      super.step(dt);
    }

  }

}