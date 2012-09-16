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

    public var wallJumpForce:Number;
    public var wallJumpSpeed:Number;
    public var wallJumpDamp:Number;
    public var wallJumpDampRate:Number;

    public var moving:Boolean;
    public var turning:Boolean;
    public var running:Boolean;
    public var jumping:Boolean;
    public var wallJumping:Boolean;

    public var grabLeft:Boolean;
    public var grabRight:Boolean;
    public var grabLocked:Boolean;
    public var grabTimer:Timer;

    public function Player(map:Map) {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);
      this.map = map;

      this.addAnimations();
      this.spriteSheet.playAnimation('idle');

      this.grav = new Vec2(0, 2000);
      this.damp = new Vec2(1, 1);
      this.hit = new Rectangle(24, 32, 16, 28);

      this.walkSpeed = 600;
      this.runSpeed = 1000;
      this.turnDamp = 0.9;

      this.jumpForce = 380;
      this.jumpSpeed = 100;
      this.jumpDamp = 1;
      this.jumpDampRate = 0.8;

      this.wallJumpForce = 380;
      this.wallJumpSpeed = 100;
      this.wallJumpDamp = 1;
      this.wallJumpDampRate = 0.8;

      this.moving = false;
      this.turning = false;
      this.running = false;
      this.jumping = false;
      this.wallJumping = false;

      this.grabLeft = false;
      this.grabRight = false;
      this.grabLocked = false;
      this.grabTimer = new Timer(100, 1);
      this.grabTimer.addEventListener('timer', this.grabRelease);

      this.debug = true;
    }

    protected function grabRelease(e:Event):void {
      this.grabLocked = false;
      if (this.grabLeft) {
        this.x += 1;
      }
    }

    protected function playAnimation(name:String, fps:uint, frame:int = -1):void {
      if (fps) this.ss.setFps(fps);
      if (frame > -1) this.ss.frame = frame;
      this.ss.playAnimation(name);
    }

    private function addAnimations():void {
      this.ss = new DynamicSpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 64, 64, 13, true); // 64 = width / 64 = height / 13 = fps
      this.ss.addAnimation('idle', [0,1,2,3], true); 
      this.ss.addAnimation('walk', [9,10,11,12,13,14,15], true);
      this.ss.addAnimation('quickwalk', [8,9,10,12,15], true);

      this.ss.addAnimation('wallgrab', [48,49], true);

      this.ss.addAnimation('run', [16,17,18,19,20,21,22], true);
      this.ss.addAnimation('jump', [25,26,27], false); //Frozen on keyframe 1, missing transition
      this.ss.addAnimation('fall', [32,33,34,35,36], false); // Frozen on keyframe 2, missing transition
      this.ss.addAnimation('slide', [40,41,42,43,44], false);
      this.spriteSheet = this.ss;
    }

    override protected function step(dt:Number):void {
      var avx:Number = Math.abs(this.vel.x)
        , bounds:Rectangle = this.bounds
        , midY:Number = bounds.top + (bounds.height / 2)
        , leftPressed:Boolean = Input.kd('LEFT')
        , rightPressed:Boolean = Input.kd('RIGHT');

      this.moving = false;
      this.running = Input.kd('SHIFT');
      this.grabLeft = !this.grounded && (this.map.pointCheck(bounds.left - 1, bounds.top)
                                      || this.map.pointCheck(bounds.left - 1, bounds.bottom));
      this.grabRight = !this.grounded && (this.map.pointCheck(bounds.right, bounds.top)
                                      || this.map.pointCheck(bounds.right, bounds.bottom));

      if (leftPressed && !(this.grabRight && this.grabLocked)) {
        this.acc.x = -(this.running ? this.runSpeed : this.walkSpeed);
        this.moving = true;
        this.turning = this.movingRight;
      } else if (rightPressed && !(this.grabLeft && this.grabLocked)) {
        this.acc.x = (this.running ? this.runSpeed : this.walkSpeed) + 100;
        this.moving = true;
        this.turning = this.movingLeft;
      }

      // TEST: Wall slide
      if (this.grabbingWall &&
          this.movingDown &&
          !this.running) {
        this.vel.y *= 0.8;
      }

      // Flip sprite based on x velocity
      if (this.movingLeft) {
        this.scaleX = -1;
      } else if (this.movingRight) {
        this.scaleX = 1;
      }

      if (!this.moving || this.turning) {
        this.vel.x *= (avx > 30) ? this.turnDamp : 0;
      }

      if (this.grabbingWall &&
          !this.grabLocked &&
          !((leftPressed && this.grabRight) ||
           (rightPressed && this.grabLeft))) {
        this.grabWall();
      }

      if (this.grabLocked &&
          !this.grabTimer.running &&
          ((leftPressed && this.grabRight) ||
           (rightPressed && this.grabLeft))) {
        this.grabTimer.start();
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
      } else {
        if (this.grabbingWall) {
          this.playAnimation('wallgrab', 20);
        } else if (this.movingDown) {
          this.playAnimation('fall', 7);
        } else {
          this.playAnimation('jump', 7, 2);
        }
      }

      // Jumping
      if (Input.kp('SPACE')) {
        if (this.grounded) {
          this.jumping = true;
          this.jumpDamp = 1;
          this.vel.y = -this.jumpForce;
          this.playAnimation('jump', 7);
        } else if (this.grabbingWall) {
          this.resetJump();
          this.wallJumping = true;
          this.grabLocked = false;
          this.vel.y = -this.wallJumpForce;
          this.vel.x = this.wallJumpForce;
          if (this.grabRight) {
            this.vel.x *= -1;
          }
          this.playAnimation('jump', 7);
        }   
      }

      // More height while the key is held down
      if (Input.kd('SPACE') && this.movingUp) {
        if (this.jumping) {
          this.vel.y -= (this.jumpSpeed * this.jumpDamp);
          this.jumpDamp *= this.jumpDampRate;
        } else if (this.wallJumping) {
          this.vel.y -= (this.wallJumpSpeed * this.wallJumpDamp);
          this.wallJumpDamp *= this.wallJumpDampRate;
        }
      }

      super.step(dt);
    }

    public function get grabbingWall():Boolean {
      return this.grabRight || this.grabLeft;
    }

    protected function grabWall():void {
      this.grabLocked = true;
      this.grabTimer.reset();
      if (this.wallJumping) {
        this.resetWallJump();
      }
    }

    protected function resetJump():void {
      this.jumping = false;
      this.jumpDamp = 1;
    }

    protected function resetWallJump():void {
      this.wallJumping = false;
      this.wallJumpDamp = 1;
    }

    override protected function landed():void {
      super.landed();
      if (this.jumping) {
        this.resetJump();
      }
      if (this.wallJumping) {
        this.resetWallJump();
      }
      this.grabLocked = false;
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