package {
  import flash.geom.Rectangle;
  import flash.events.Event;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import net.pixelpracht.tmx.*;
  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*

  public class Map extends Sprite2DBatch {

    public var tileSize:uint;
    public var tilesWide:uint;
    public var tilesHigh:uint;
    public var tiles:Array;

    [Embed(source='../data/tiles.png')]
    protected var tilesetBMP:Class;

    public function Map(tmx:TmxLayer, tileSize:uint = 32) {
      this.tileSize = tileSize;
      this.tiles = [];

      var tilesetTex:Texture2D = Texture2D.textureFromBitmapData(new tilesetBMP().bitmapData);
      var tilesetSheet:SpriteSheet = new SpriteSheet(tilesetTex.bitmapWidth, tilesetTex.bitmapHeight, this.tileSize, this.tileSize, 60);

      super(tilesetTex);
      this.setSpriteSheet(tilesetSheet);

      this.createTiles(tmx.tileGIDs);
      this.tilesHigh = this.tiles.length;
      this.tilesWide = this.tiles[0].length;
    }

    public function getTile(x:int, y:int):Tile {
      if (x < 0 || y < 0 || x >= this.tilesWide || y >= this.tilesHigh) {
        return null;
      } else {
        return this.tiles[y][x];
      }
    }

    public function getTileAt(x:int, y:int):Tile {
      if (x < 0 || y < 0 ||
          x > this.tilesWide * this.tileSize ||
          y > this.tilesHigh * this.tileSize) {
        return null;
      } else {
        return this.getTile(Math.floor(x / this.tileSize),
                            Math.floor(y / this.tileSize));
      }
    }

    public function getCollisionTiles(bounds:Rectangle):Array {
      return [ this.getTileAt(bounds.left, bounds.top)
             , this.getTileAt(bounds.right, bounds.top)
             , this.getTileAt(bounds.left, bounds.bottom)
             , this.getTileAt(bounds.right, bounds.bottom) ];
    }

    private function createTiles(tileGIDs:Array):void {
      var tileIndex:int;
      var tile:Tile;
      var halfTileSize:int = this.tileSize / 2;

      for (var y:int = 0; y < tileGIDs.length; y++) {
        this.tiles[y] = [];
        for (var x:int = 0; x < tileGIDs[y].length; x++) {
          tileIndex = tileGIDs[y][x];

          if (tileIndex) {
            tile = new Tile();
            tile.x = (x * this.tileSize) + halfTileSize;
            tile.y = (y * this.tileSize) + halfTileSize;
            tile.hit.width = tile.hit.height = this.tileSize;

            this.addChild(tile);
            tile.frame = tileIndex - 1;

            this.tiles[y][x] = tile;
          } else {
            this.tiles[y][x] = null;
          }
        }
      }
    }

  }
}