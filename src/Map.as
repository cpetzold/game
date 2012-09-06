package {

  import flash.events.Event;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  import net.pixelpracht.tmx.*;

  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*

  import Tile;

  public class Map extends Sprite2DBatch {

    public var tileSize:uint;

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
    }

    private function createTiles(tileGIDs:Array):void {
      var tileIndex:int;
      var tile:Tile;

      for (var y:int = 0; y < tileGIDs.length; y++) {
        this.tiles[y] = [];
        for (var x:int = 0; x < tileGIDs[y].length; x++) {
          tileIndex = tileGIDs[y][x];

          if (tileIndex) {
            tile = new Tile();
            tile.x = x * this.tileSize;
            tile.y = y * this.tileSize;

            this.addChild(tile);
            tile.frame = tileIndex - 1;

            this.tiles[y][x] = tile;
          }
        }
      }
    }


  }
}