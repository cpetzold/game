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
    public var jumpWallSpeed:Number;
    public var jumpDamp:Number;
    public var jumpDampRate:Number;

    public var wallJumpForce:Vec2;
    public var wallJumpSpeed:Number;
    public var wallJumpDamp:Number;
    public var wallJumpDampRate:Number;

    public var diveForce:Vec2;
    public var canDive:Boolean;
    //public var diveForceMax:Vec2;

    public var moving:Boolean;
    public var turning:Boolean;
    public var running:Boolean;
    public var jumping:Boolean;
    public var wallJumping:Boolean;
    public var landing:Boolean;
    public var diving:Boolean;
    public var sliding:Boolean;

    public var landTimer:Timer;

    public var grabLeft:Boolean;
    public var grabRight:Boolean;
    public var grabLocked:Boolean;
    public var grabTimer:Timer;

    public function Player(map:Map) {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);
      this.map = map;

      this.addAnimations();

      this.grav = new Vec2(0, 2000);
      this.damp = new Vec2(1, 1);
      this.hit = new Rectangle(24, 32, 16, 28);

      this.walkSpeed = 620;
      this.runSpeed = 820;
      this.turnDamp = 0.8;

      this.jumpForce = 380;
      this.jumpSpeed = 100;
      this.jumpWallSpeed = 150;
      this.jumpDamp = 1;
      this.jumpDampRate = 0.8;

      this.wallJumpForce = new Vec2(450, -380);
      this.wallJumpSpeed = 100;
      this.wallJumpDamp = 1;
      this.wallJumpDampRate = 0.8;

      this.diveForce = new Vec2(400, -400);
      this.canDive = true;
      //this.diveForceMax = new Vec2();

      this.moving = false;
      this.turning = false;
      this.running = false;
      this.jumping = false;
      this.wallJumping = false;
      this.landing = false;
      this.diving = false;
      this.sliding = false;

      this.grabLeft = false;
      this.grabRight = false;
      this.grabLocked = false;
      this.grabTimer = new Timer(100, 1);
      this.grabTimer.addEventListener('timer', this.grabRelease);

      this.landTimer = new Timer(100, 1);
      this.landTimer.addEventListener('timer', this.doneLanding);

      this.debug = true;
    }

    protected function grabRelease(e:Event):void {
      this.grabLocked = false;
      if (this.grabLeft) {
        this.x += 1;
      }
    }

    protected function doneLanding(e:Event):void {
      this.landing = false;
    }

    public function playAnimationAtFPS(name:String, fps:uint, frame:int = 0, restart:Boolean = false):void {
      if (fps) this.ss.setFps(fps);
      super.playAnimation(name, frame, restart);
    }

    private function addAnimations():void {
      this.ss = new DynamicSpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 64, 64, 13, true); // 64 = width / 64 = height / 13 = fps
      this.ss.addAnimation('idle', [0,1,2,3], true); 
      this.ss.addAnimation('walk', [9,10,11,12,13,14,15], true);
      this.ss.addAnimation('quickwalk', [8,9,10,12,15], true);
      this.ss.addAnimation('run', [16,17,18,19,20,21,22], true);
      // 
      this.ss.addAnimation('jump', [25,26,27], false); 
      this.ss.addAnimation('land', [96,97,98,99], false); 
      // 
      this.ss.addAnimation('fall', [32,33,34,35,36], false);
      this.ss.addAnimation('turn', [40,41,42,43,44], false);
      this.ss.addAnimation('wallgrab', [48,49], true);
      this.ss.addAnimation('wallrelease', [56,57], false);
      this.ss.addAnimation('wallrun', [64,65,66,67], true);
      this.ss.addAnimation('slidedive', [72,73,74,75,76], false);
      this.ss.addAnimation('slide', [80,81], true);
      this.ss.addAnimation('slideup', [89,90], false);
      this.spriteSheet = this.ss;
    }

    override protected function step(dt:Number):void {
      var avx:Number = Math.abs(this.vel.x)
        , bounds:Rectangle = this.bounds
        , midY:Number = bounds.top + (bounds.height / 2)
        , leftPressed:Boolean = Input.kd('LEFT')
        , rightPressed:Boolean = Input.kd('RIGHT')
        , downPressed:Boolean = Input.kd('DOWN');

      this.moving = false;
      this.running = Input.kd('SHIFT');
      this.grabLeft = !this.grounded && (this.map.pointCheck(bounds.left - 1, bounds.top + 5)
                                      || this.map.pointCheck(bounds.left - 1, bounds.bottom - 5));
      this.grabRight = !this.grounded && (this.map.pointCheck(bounds.right, bounds.top + 5)
                                      || this.map.pointCheck(bounds.right, bounds.bottom - 5));

      if (!this.sliding) {
        if (leftPressed && !(this.grabRight && this.grabLocked)) {
          this.acc.x = -(this.running ? this.runSpeed : this.walkSpeed);
          this.moving = true;
          this.turning = this.movingRight;
        } else if (rightPressed && !(this.grabLeft && this.grabLocked)) {
          this.acc.x = (this.running ? this.runSpeed : this.walkSpeed) + 100;
          this.moving = true;
          this.turning = this.movingLeft;
        }
      }

      if (this.grabbingWall &&
          this.movingDown &&
          !this.running &&
          !downPressed) {
        this.vel.y *= 0.6;
      }

      // Flip sprite based on x velocity
      if (this.movingLeft || this.grabLeft) {
        this.scaleX = -1;
      } else if (this.movingRight || this.grabRight) {
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

      if (this.sliding && avx < 50) {
        this.sliding = false;
      }

      // Animations
      if (this.grounded) {
        if (this.sliding && avx > 50) {
          this.turnDamp = 0.93;
          this.playAnimationAtFPS('slide', 13);
        } else if (this.landing) {
          this.playAnimationAtFPS('land', 15);
        } else if (avx > 5) {
          if (!this.moving || this.turning) {
            if (avx > 120) {
              this.playAnimationAtFPS('turn', 20);
              this.turnDamp = 0.8;
            } else if (avx < 30) {
              this.playAnimationAtFPS('idle', 13);
              this.turnDamp = 0.8;
            } else if (avx < 70) {
              this.playAnimationAtFPS('walk', 3);
              this.turnDamp = 0.8;
            }
          } else if (avx > 300) {
            this.playAnimationAtFPS('run', 30);
            this.turnDamp = 0.8;
          } else {
            if (avx < 70) {
              if (avx < 40) {
                this.playAnimationAtFPS('walk', 40);
                this.turnDamp = 0.8;
              }
            } else {
              this.playAnimationAtFPS('walk', 20);
              this.turnDamp = 0.8;
            }
          }
        } else {
          this.playAnimationAtFPS('idle', 13);
          this.turnDamp = 0.8;
        }
      } else {
        if (this.grabbingWall) {
          if (this.vel.y >= -250) {
            if (this.grabLocked && this.grabTimer.running) {
              this.playAnimationAtFPS('wallrelease', 7);
            } else {
              this.playAnimationAtFPS('wallgrab', 20);
            }
          } else {
            this.playAnimationAtFPS('wallrun', 13);
          }
        } else if (this.diving) {
          this.playAnimationAtFPS('slidedive', 13);
        } else if (this.movingDown) {
          this.playAnimationAtFPS('fall', 7);
        } else {
          this.playAnimationAtFPS('jump', 7, 2);
        }
      }

      // Jumping
      if (Input.kp('SPACE')) {
        if (this.grounded) {
          this.grabTimer.reset();
          this.landing = false;
          this.jumping = true;
          this.sliding = false;
          this.jumpDamp = 1;
          this.vel.y = -this.jumpForce;
          this.playAnimationAtFPS('jump', 7);
        } else if (this.grabbingWall) {
          this.resetJump();
          this.wallJumping = true;
          this.grabLocked = false;
          this.sliding = false;
          this.vel = this.wallJumpForce.clone();
          if (this.grabRight) {
            this.vel.x *= -1;
          }
          this.playAnimationAtFPS('jump', 7);
        }   
      }

      // More height while the key is held down
      var jumpSpeed:Number;
      if (Input.kd('SPACE') && this.movingUp) {
        if (this.jumping) {
          jumpSpeed = this.grabbingWall ? this.jumpWallSpeed : this.jumpSpeed;
          this.vel.y -= (jumpSpeed * this.jumpDamp);
          this.jumpDamp *= this.jumpDampRate;
        } else if (this.wallJumping) {
          this.vel.y -= (this.wallJumpSpeed * this.wallJumpDamp);
          this.wallJumpDamp *= this.wallJumpDampRate;
        }
      }

      // Dive
      if (this.canDive && Input.kp('x') && !this.sliding) {
        if (!this.diving && avx > 35) {
          this.diving = true;
          this.vel.y = this.diveForce.y;
          this.vel.x += (this.movingLeft ? -this.diveForce.x : this.diveForce.x);
          this.playAnimationAtFPS('slidedive', 13);
          this.canDive = false;
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

    override protected function collided():void {
      if (this.diving) {
        this.diving = false;
        if (this.grounded) {
          this.sliding = true;
        }
      }
    }

    override protected function landed(offset:Number):void {
      if (!this.landTimer.running && this.vel.y > 200) {
        this.landing = true;
        this.landTimer.start();
        this.canDive = true;
      }

      if (this.jumping) {
        this.resetJump();
      }

      if (this.wallJumping) {
        this.resetWallJump();
      }

      this.grabLocked = false;

      super.landed(offset);
    }

    override protected function roof(offset:Number):void {
      this.jumpDamp = 0;
      super.roof(offset);
    }

    override protected function falling():void {
      this.grounded = false;

      super.falling();
    }

  }

}