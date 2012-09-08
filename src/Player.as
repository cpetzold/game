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

    public var speed:int;

    public function Player(map:Map) {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);

      this.spriteSheet = new SpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 64, 64, 13); // 64 = width / 64 = height / 13 = fps
      this.spriteSheet.addAnimation('idle_r', [0,1,2,3], true); 
      this.spriteSheet.addAnimation('idle_l', [8,9,10,11], true); 

      this.spriteSheet.addAnimation('walk_r', [16,17,18,19,20,21,22,23], true);
      this.spriteSheet.addAnimation('walk_l', [31,30,29,28,27,26,25,24], true); //Frames are counted backwards because image was flipped

      this.spriteSheet.addAnimation('run_r', [32,33,34,35,36,37,38], true);
      this.spriteSheet.addAnimation('run_l', [46,45,44,43,42,41,40], true); //Frames are counted backwards because image was flipped
      
      this.spriteSheet.addAnimation('jump_r', [58], false); // Frozen on keyframe 3, missing transition
      this.spriteSheet.addAnimation('jump_l', [64], false); //Frozen on keyframe 1, missing transition

      this.spriteSheet.addAnimation('fall_r', [73], false); // Frozen on keyframe 2, missing transition
      this.spriteSheet.addAnimation('fall_l', [81], false); //Frozen on keyframe 2, missing transition

      this.spriteSheet.playAnimation('idle_r');

      this.map = map;
      this.grav = new Vec2(0, 1500);
      this.damp = new Vec2(0.9, 0.98);
      this.speed = 1000;
      this.debug = true;

      // Player hitbox
      // 8 = x offset from center / 32 = y offset from center
      // 16 = width / 28 = height
      this.hit = new Rectangle(24, 32, 16, 28);
    }

    override protected function step(dt:Number):void {
      var speed:int = this.speed;

      if (Input.kd('SHIFT')) {
        speed *= 2;
      }

      if (Input.kd('LEFT')) {
        this.acc.x = -speed;
      }

      if (Input.kd('RIGHT')) {
        this.acc.x = speed;
      }

      if (Input.kd('UP')) {
        this.acc.y = -speed;
      }

      if (Input.kd('DOWN')) {
        this.acc.y = speed;
      }

      super.step(dt);
    }

  }

}