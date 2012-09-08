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
      this.spriteSheet.addAnimation('walk', [8,9,10,11,12,13,14,15], true);
      this.spriteSheet.addAnimation('run', [16,17,18,19,20,21,22], true);
      this.spriteSheet.addAnimation('jump', [24,25,26], false); //Frozen on keyframe 1, missing transition
      this.spriteSheet.addAnimation('fall', [32,33,34], false); // Frozen on keyframe 2, missing transition
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