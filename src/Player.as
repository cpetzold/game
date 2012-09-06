package {
  import flash.geom.Rectangle;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;
  import de.nulldesign.nd2d.materials.texture.SpriteSheet;
  import com.furusystems.dconsole2.DConsole;

  import utils.*;

  public class Player extends DynamicSprite {

    [Embed(source='../data/player.png')]
    protected var PlayerBMP:Class;

    public var speed:int;

    public function Player() {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);
      super(texture);

      //this.spriteSheet = new SpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 29, 16, 10); //29 = width / 16 = height / 10 = fps
      //this.spriteSheet.addAnimation('run', [0, 1, 2, 3, 2, 1], true);
      //this.spriteSheet.playAnimation('run');

      this.damp = new Vec2(0.9, 0.9);
      this.speed = 20;
      this.debug = true;
    }

    public function collideMap(map:Map):void {
      var bounds:Rectangle = this.bounds;
      var leftTile:int = Math.floor((bounds.left - map.x) / map.tileSize);
      var rightTile:int = Math.ceil((bounds.right - map.x) / map.tileSize);
      var topTile:int = Math.floor((bounds.top - map.y) / map.tileSize);
      var bottomTile:int = Math.ceil((bounds.bottom - map.y) / map.tileSize);

      DConsole.print(leftTile + ':' + rightTile + ':' + topTile + ':' + bottomTile);

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
      DConsole.print(this.bounds.toString() + ' - ' + tile.bounds.toString() + ' - ' + intersection.toString());
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