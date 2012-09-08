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

    public var map:Map;
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

    private function landed():void {}
    private function roof():void {}
    private function falling():void {}

    override protected function step(dt:Number):void {
      this.vel.addSelf(this.acc.scale(dt));
      this.vel.subSelf(this.vel.mulSelf(this.damp).scale(dt));

      this.y += this.vel.y * dt;
      if (this.map) this.collideMapY();

      this.x += this.vel.x * dt;
      if (this.map) this.collideMapX();

      this.acc = this.grav.clone();
      super.step(dt);
    }

    public function collideMapOffsets():Array {
      var bounds:Rectangle = this.bounds
        , tiles:Array = this.map.getCollisionTiles(bounds)
        , offsets:Array = [];

      for (var i:int = 0; i < tiles.length; i++) {
        offsets[i] = tiles[i] ? bounds.intersection(tiles[i].bounds) : null;
      }

      return offsets;
    }

    public function collideMapX():void {
      var offsets:Array = this.collideMapOffsets()
        , offset:Number;

      if (this.movingRight) {
        if (offsets[3] && offsets[3].width) {
          offset = -offsets[3].width;
        } else if (offsets[1] && offsets[1].width) {
          offset = -offsets[1].width;
        }
      } else if (this.movingLeft) {
        if (offsets[2] && offsets[2].width) {
          offset = offsets[2].width;
        } else if (offsets[0] && offsets[0].width) {
          offset = offsets[0].width;
        }
      }

      if (offset) {
        this.vel.x = 0;
        this.x += offset;
      }
    }

    public function collideMapY():void {
      var offsets:Array = this.collideMapOffsets()
        , offset:Number;

      if (this.movingDown) {
        if (offsets[2] && offsets[2].height) {
          offset = offsets[2].height;
        } else if (offsets[3] && offsets[3].height) {
          offset = offsets[3].height;
        }

        if (offset) {
          this.vel.y = 0;
          this.y -= offset;
          this.landed();
        }
      } else if (this.movingUp) {
        if (offsets[0] && offsets[0].height) {
          offset = offsets[0].height;
        } else if (offsets[1] && offsets[1].height) {
          offset = offsets[1].height;
        }

        if (offset) {
          this.vel.y = 0;
          this.y += offset;
          this.roof();  
        }
      } else {
        if (!offsets[2] && !offsets[3]) {
          this.falling();
        }
      }
    }

  }

}