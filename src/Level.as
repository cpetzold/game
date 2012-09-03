package {

  import flash.events.Event;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.ByteArray;

  import net.pixelpracht.tmx.*;

  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*

  import com.furusystems.dconsole2.DConsole;

  import Tile;

  public class Level extends Scene2D {

    protected var tmx:TmxMap;

    protected var tileSize:uint;

    public var tiles:Sprite2DBatch;

    [Embed(source='../data/tiles.png')]
    protected var tilesetBMP:Class;

    public function Level(name:String, tileSize:uint = 32) {
      this.tileSize = 32;
      this.load(name);
    }

    private function load(name:String):void {
      var loader:URLLoader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, this.onLoad);
      loader.load(new URLRequest('../data/' + name + '.tmx'));
    }

    private function onLoad(e:Event):void {
      var xml:XML = new XML(e.target.data);

      this.tmx = new TmxMap(xml);
      this.init();
    }

    private function init():void {
      this.createMap();
    }

    private function createMap():void {
      var map:TmxLayer = this.tmx.getLayer('map');
      //var tileset:TmxTileSet = this.tmx.getTileSet('tiles');

      var tilesetTex:Texture2D = Texture2D.textureFromBitmapData(new tilesetBMP().bitmapData);
      var tilesetSheet:SpriteSheet = new SpriteSheet(tilesetTex.bitmapWidth, tilesetTex.bitmapHeight, this.tileSize, this.tileSize, 60);
      
      this.tiles = new Sprite2DBatch(tilesetTex);
      this.tiles.setSpriteSheet(tilesetSheet);

      // Create map tiles
      var tileIndex:int;
      var tile:Tile;

      for (var y:int = 0; y < map.tileGIDs.length; y++) {
        for (var x:int = 0; x < map.tileGIDs[y].length; x++) {
          tileIndex = map.tileGIDs[y][x];

          tile = new Tile();
          tile.x = x * this.tileSize;
          tile.y = y * this.tileSize;
          this.tiles.addChild(tile);
          tile.frame = tileIndex - 1;
        }
      }

      this.tiles.x = 100;
      this.tiles.y = 100;
      this.addChild(this.tiles);

    }


  }

}