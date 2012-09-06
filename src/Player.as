package {

  import flash.geom.Rectangle;

  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;
  import de.nulldesign.nd2d.materials.texture.SpriteSheet;

  import com.furusystems.dconsole2.DConsole;

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
      this.dampx = 0.93;
      this.dampy = 0.93;
      this.speed = 15;
    }

    public function collideMap(map:Map):void {
      var bounds:Rectangle = this.bounds;
      var leftTile:int = Math.floor(bounds.left / map.tileSize);
      var rightTile:int = Math.ceil(bounds.right / map.tileSize) - 1;
      var topTile:int = Math.floor(bounds.top / map.tileSize);
      var bottomTile:int = Math.ceil(bounds.bottom / map.tileSize) - 1;

      //DConsole.print(lefTile + ':' + rightTile + ':' + topTile + ':' + bottomTile);

      for (var y:int = topTile; y <= bottomTile; ++y) {
        for (var x:int = leftTile; x <= rightTile; ++x) {
          if (map.tiles[y][x]) {
            this.collideTile(map.tiles[y][x]);
          }
        }
      }

    }

    private function collideTile(tile:Tile):void {
      var intersection:Rectangle = this.bounds.intersection(tile.bounds);
      DConsole.print(intersection.toString());
    }

    override protected function step(dt:Number):void {
      var speed:int = this.speed;

      if (Input.kd('SHIFT')) {
        speed *= 2;
      }

      if (Input.kd('LEFT')) {
        this.ax = -speed;
      }

      if (Input.kd('RIGHT')) {
        this.ax = speed;
      }

      if (Input.kd('UP')) {
        this.ay = -speed;
      }

      if (Input.kd('DOWN')) {
        this.ay = speed;
      }

      super.step(dt);
    }

  }

}