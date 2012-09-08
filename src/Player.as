package {
  import flash.geom.Rectangle;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;
  import de.nulldesign.nd2d.materials.texture.SpriteSheet;
  import com.furusystems.dconsole2.DConsole;

  import utils.*;

  public class Player extends DynamicSprite {

    [Embed(source='../data/spritesheet.png')]
    protected var PlayerBMP:Class;

    public var jumping:Boolean = false;

    public var speed:int;
    public var jumpDamp:int;

    public var facingLeft:Boolean = false;

    public function Player(map:Map) {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);
      this.map = map;

      this.addAnimations();
      this.spriteSheet.playAnimation('idle');

      this.grav = new Vec2(0, 1500);
      this.damp = new Vec2(0.9, 1);
      this.hit = new Rectangle(24, 32, 16, 28);

      this.speed = 150;
      this.jumpDamp = 1;
      this.debug = true;
    }

    private function addAnimations():void {
      this.spriteSheet = new SpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 64, 64, 13); // 64 = width / 64 = height / 13 = fps
      this.spriteSheet.addAnimation('idle', [0,1,2,3], true); 
      //this.spriteSheet.addAnimation('idle_l', [8,9,10,11], true); 

      this.spriteSheet.addAnimation('walk', [16,17,18,19,20,21,22,23], true);
      //this.spriteSheet.addAnimation('walk_l', [31,30,29,28,27,26,25,24], true); //Frames are counted backwards because image was flipped

      this.spriteSheet.addAnimation('run', [32,33,34,35,36,37,38], true);
      //this.spriteSheet.addAnimation('run_l', [46,45,44,43,42,41,40], true); //Frames are counted backwards because image was flipped
      
      //this.spriteSheet.addAnimation('jump', [58], false); // Frozen on keyframe 3, missing transition
      this.spriteSheet.addAnimation('jump', [64], false); //Frozen on keyframe 1, missing transition

      this.spriteSheet.addAnimation('fall', [73], false); // Frozen on keyframe 2, missing transition
      //this.spriteSheet.addAnimation('fall_l', [81], false); //Frozen on keyframe 2, missing transition
    }

    override protected function step(dt:Number):void {
      var speed:int = this.speed
        , jumpSpeed:int = 1000
        , moving:Boolean = false
        , running:Boolean = false;

      if (Input.kd('Z')) {
        speed *= 2;
        running = true;
      }

      if (Input.kd('LEFT')) {
        this.vel.x = -speed;
        moving = true;
        this._scaleX = -1;
      }

      if (Input.kd('RIGHT')) {
        this.vel.x = speed;
        moving = true;
        this._scaleX = 1;
      }

      if (!this.jumping) {
        if (moving) {
          if (running) {
            this.spriteSheet.playAnimation('run');
          } else {
            this.spriteSheet.playAnimation('walk');
          }
        } else {
          this.spriteSheet.playAnimation('idle');
        }
      }

      // Jumping
      if (Input.kd('X')) {
        if (!this.jumping) {
          this.spriteSheet.playAnimation('jump');
        }
        this.jumping = true;
        this.vel.y -= (jumpSpeed * this.jumpDamp);
        this.jumpDamp *= 0.98;
      }

      super.step(dt);
    }

    override protected function landed():void {
      this.jumping = false;
      this.jumpDamp = 1;
    }

    override protected function falling():void {
      this.spriteSheet.playAnimation('fall');
    }

  }

}