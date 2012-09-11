package {
  import flash.geom.Rectangle;
  import flash.events.Event;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import net.pixelpracht.tmx.*;
  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*;
  import com.furusystems.dconsole2.DConsole;

  public class Map extends Sprite2DBatch {

    public var level:Level;

    public var collisionsLayer:TmxLayer;
    public var tilesLayer:TmxLayer;

    public var objectGroup:TmxObjectGroup;

    public var tileSize:uint;
    public var tilesWide:uint;
    public var tilesHigh:uint;

    public var objects:Array;
    public var collisions:Array;
    public var tiles:Array;

    [Embed(source='../data/tiles.png')]
    protected var tilesetBMP:Class;

    public function Map(level:Level, tileSize:uint = 32) {
      this.level = level;

      this.collisionsLayer = this.level.tmx.getLayer('collisions');
      this.tilesLayer = this.level.tmx.getLayer('tiles');

      this.objectGroup = this.level.tmx.getObjectGroup('objects');

      this.tileSize = tileSize;

      this.objects = [];
      this.collisions = [];
      this.tiles = [];

      var tilesetTex:Texture2D = Texture2D.textureFromBitmapData(new tilesetBMP().bitmapData);
      var tilesetSheet:SpriteSheet = new SpriteSheet(tilesetTex.bitmapWidth, tilesetTex.bitmapHeight, this.tileSize, this.tileSize, 60, true);

      super(tilesetTex);
      this.setSpriteSheet(tilesetSheet);

      this.createTiles(this.tilesLayer.tileGIDs, this.collisionsLayer.tileGIDs);
      this.tilesHigh = this.tiles.length;
      this.tilesWide = this.tiles[0].length;

      this.level.addChild(this);
      this.createObjects(this.objectGroup.objects);
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

    public function getCollisionTile(x:int, y:int):Rectangle {
      if (x < 0 || y < 0 || x >= this.tilesWide || y >= this.tilesHigh) {
        return null;
      } else {
        return this.collisions[y][x];
      }
    }

    public function getCollisionTileAt(x:int, y:int):Rectangle {
      if (x < 0 || y < 0 ||
          x > this.tilesWide * this.tileSize ||
          y > this.tilesHigh * this.tileSize) {
        return null;
      } else {
        return this.getCollisionTile(Math.floor(x / this.tileSize),
                                     Math.floor(y / this.tileSize));
      }
    }

    public function getCollisionTiles(bounds:Rectangle):Array {
      return [ this.getCollisionTileAt(bounds.left, bounds.top)
             , this.getCollisionTileAt(bounds.right, bounds.top)
             , this.getCollisionTileAt(bounds.left, bounds.bottom)
             , this.getCollisionTileAt(bounds.right, bounds.bottom) ];
    }

    private function createTiles(tileIDs:Array, collisionIDS:Array):void {
      var halfTileSize:int = this.tileSize / 2
        , tileIndex:uint
        , collisionIndex:uint
        , tile:Tile
        , xpos:int
        , ypos:int;

      for (var y:int = 0; y < tileIDs.length; y++) {
        this.tiles[y] = [];
        this.collisions[y] = [];
        for (var x:int = 0; x < tileIDs[y].length; x++) {
          tileIndex = tileIDs[y][x];
          collisionIndex = collisionIDS[y][x];

          if (tileIndex || collisionIndex) {
            xpos = (x * this.tileSize);
            ypos = (y * this.tileSize);
          }

          if (collisionIndex) {
            this.collisions[y][x] = new Rectangle(xpos, ypos, this.tileSize, this.tileSize);
          } else {
            this.collisions[y][x] = null;
          }

          if (tileIndex) {
            tile = new Tile();
            tile.x = xpos + halfTileSize;
            tile.y = ypos + halfTileSize;

            this.addChild(tile);
            tile.frame = tileIndex - 1;

            this.tiles[y][x] = tile;
          } else {
            this.tiles[y][x] = null;
          }
        }
      }
    }

    private function createObjects(objects:Array):void {
      var node:Node2D;

      for each (var object:TmxObject in objects) {
        switch (object.type) {
          case 'Player':
            node = new Player(this);
            node.x = object.x;
            node.y = object.y;
            this.level.player = node as Player;
            break;
          default:
            node = null;
            break;
        }

        if (node) {
          this.objects.push(node);
          this.level.addChild(node);
        }
      }
    }

  }
}