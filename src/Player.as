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

    public function Player() {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);

      this.spriteSheet = new SpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 64, 64, 13); //29 = width / 16 = height / 10 = fps
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

      this.grav = new Vec2(0, 20);
      this.damp = new Vec2(0.9, 0.98);
      this.speed = 20;
      this.debug = true;
    }

    public function collideMap(map:Map):void {
      var bounds:Rectangle = this.bounds;
      var leftTile:int = Math.floor((bounds.left - map.x) / map.tileSize);
      var rightTile:int = Math.ceil((bounds.right - map.x) / map.tileSize);
      var topTile:int = Math.floor((bounds.top - map.y) / map.tileSize);
      var bottomTile:int = Math.ceil((bounds.bottom - map.y) / map.tileSize);

      //DConsole.print(leftTile + ':' + rightTile + ':' + topTile + ':' + bottomTile);

      var tile:Tile;
      for (var y:int = topTile; y <= bottomTile; ++y) {
        for (var x:int = leftTile; x <= rightTile; ++x) {
          tile = map.getTile(x, y);

          if (tile) {
            this.collideTile(tile);
          }
        }
      }

    }

    private function collideTile(tile:Tile):void {
      var intersection:Rectangle = this.bounds.intersection(tile.bounds);
      if (intersection.width && intersection.width < intersection.height) {
        this.x += (this.movingLeft ? intersection.width : -intersection.width);
        this.vel.x = 0;
      } else if (intersection.height) {
        this.y += (this.movingUp ? intersection.height : -intersection.height);
        this.vel.y = 0;
      }
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