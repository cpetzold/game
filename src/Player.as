package {
  import flash.geom.Rectangle;
  import flash.events.Event;
  import flash.utils.Timer;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;
  import com.furusystems.dconsole2.DConsole;

  import utils.*;

  public class Player extends DynamicSprite {

    [Embed(source='../data/spritesheet.png')]
    protected var PlayerBMP:Class;

    public var ss:DynamicSpriteSheet;

    public var walkSpeed:Number;
    public var runSpeed:Number;
    public var turnDamp:Number;

    public var jumpForce:Number;
    public var jumpSpeed:Number;
    public var jumpDamp:Number;
    public var jumpDampRate:Number;

    public var secondJumpForce:Number;
    public var secondJumpTimer:Timer;
    public var canSecondJump:Boolean;

    public var moving:Boolean;
    public var turning:Boolean;
    public var running:Boolean;
    public var jumping:Boolean;
    public var secondJumping:Boolean;

    public function Player(map:Map) {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);
      this.map = map;

      this.addAnimations();
      this.spriteSheet.playAnimation('idle');

      this.grav = new Vec2(0, 1500);
      this.damp = new Vec2(1, 1);
      this.hit = new Rectangle(24, 32, 16, 28);

      this.walkSpeed = 500;
      this.runSpeed = 1000;
      this.turnDamp = 0.9;

      this.jumpForce = 200;
      this.jumpSpeed = 100;
      this.jumpDamp = 1;
      this.jumpDampRate = 0.8;

      this.secondJumpForce = 400;
      this.secondJumpTimer = new Timer(100);
      this.secondJumpTimer.addEventListener('timer', this.secondJumpMiss);
      this.canSecondJump = false;

      this.moving = false;
      this.turning = false;
      this.running = false;
      this.jumping = false;
      this.secondJumping = false;

      this.debug = true;
    }

    protected function playAnimation(name:String, fps:uint):void {
      if (fps) this.ss.setFps(fps);
      this.ss.playAnimation(name);
    }

    private function addAnimations():void {
      this.ss = new DynamicSpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 64, 64, 13, true); // 64 = width / 64 = height / 13 = fps
      this.ss.addAnimation('idle', [0,1,2,3], true); 
      this.ss.addAnimation('walk', [9,10,11,12,13,14,15], true);
      this.ss.addAnimation('quickwalk', [8,9,10,12,15], true);


      this.ss.addAnimation('run', [16,17,18,19,20,21,22], true);
      this.ss.addAnimation('jump', [24,25,26], false); //Frozen on keyframe 1, missing transition
      this.ss.addAnimation('fall', [32,33,34], false); // Frozen on keyframe 2, missing transition
      this.ss.addAnimation('slide', [40,41,42,43,44], false);
      this.spriteSheet = this.ss;
    }

    override protected function step(dt:Number):void {
      var avx:Number = Math.abs(this.vel.x);

      this.moving = false;
      this.running = Input.kd('SHIFT');

      if (Input.kd('LEFT')) {
        this.acc.x = -(this.running ? this.runSpeed : this.walkSpeed);
        this.moving = true;
        this.turning = this.movingRight;
      } else if (Input.kd('RIGHT')) {
        this.acc.x = (this.running ? this.runSpeed : this.walkSpeed);
        this.moving = true;
        this.turning = this.movingLeft;
      }

      if (this.movingLeft) {
        this._scaleX = -1;
      } else if (this.movingRight) {
        this._scaleX = 1;
      }

      if (!this.moving || this.turning) {
        this.vel.x *= (avx > 30) ? this.turnDamp : 0;
      }

      if (this.grounded) {
        if (avx > 5) {
          if (!this.moving || this.turning) {
            if (avx > 120) {
              this.playAnimation('slide', 20);
            } else if (avx < 30) {
              this.playAnimation('idle', 13);
            } else if (avx < 70) {
              this.playAnimation('walk', 3);
            }
          } else if (avx > 300) {
            this.playAnimation('run', 30);
          } else {
            if (avx < 70) {
              this.playAnimation('walk', 40);
            } else {
              this.playAnimation('walk', 20);
            }
          }
        } else {
          this.playAnimation('idle', 13);
        }
      } else if (this.movingDown) {
        this.playAnimation('fall', 7);
      }

      // Jumping
      if (Input.kp('SPACE') && this.grounded) {
        this.jumping = true;
        if (this.canSecondJump) {
          this.secondJumping = true;
          this.vel.y -= this.secondJumpForce;
        } else {
          this.vel.y -= this.jumpForce;
        }
        
        this.playAnimation('jump', 7);
      }

      // More height while the key is held down
      if (Input.kd('SPACE') && this.jumping) {
        this.vel.y -= (this.jumpSpeed * this.jumpDamp);
        this.jumpDamp *= this.jumpDampRate;
      }

      super.step(dt);
    }

    protected function secondJumpMiss(e:Event):void {
      this.canSecondJump = false;
    }

    override protected function landed():void {
      super.landed();
      if (this.jumping) {
        this.jumping = false;
        this.jumpDamp = 1;

        if (!this.secondJumping) {
          this.canSecondJump = true;
          this.secondJumpTimer.reset();
          this.secondJumpTimer.start();
        }

        this.secondJumping = false;
      }
    }

    override protected function falling():void {
      this.grounded = false;
      this.spriteSheet.playAnimation('fall');
    }

    override protected function roof():void {
      this.jumpDamp = 0;
    }

  }

}