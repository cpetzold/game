package {
  import flash.geom.Rectangle;
  import flash.events.Event;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.display3D.Context3D;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import net.pixelpracht.tmx.*;
  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*;

  public class Map extends Sprite2DBatch {

    public var game:Game;

    public var collisionsLayer:TmxLayer;
    public var tilesLayer:TmxLayer;

    public var tileSize:uint;
    public var tilesWide:uint;
    public var tilesHigh:uint;

    public var objects:Array;
    public var collisions:Array;
    public var tiles:Array;

    [Embed(source='../data/tiletest.png')]
    protected var tilesetBMP:Class;

    public function Map(game:Game, tileSize:uint = 32) {
      this.game = game;

      this.collisionsLayer = this.game.tmx.getLayer('collisions');
      this.tilesLayer = this.game.tmx.getLayer('tiles');

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

      this.game.addChild(this);
      this.createObjects();
    }

    public function getTile(x:Number, y:Number):Tile {
      if (x < 0 || y < 0 || x >= this.tilesWide || y >= this.tilesHigh) {
        return null;
      } else {
        return this.tiles[y][x];
      }
    }

    public function getTileAt(x:Number, y:Number):Tile {
      if (x < 0 || y < 0 ||
          x > this.tilesWide * this.tileSize ||
          y > this.tilesHigh * this.tileSize) {
        return null;
      } else {
        return this.getTile(Math.floor(x / this.tileSize),
                            Math.floor(y / this.tileSize));
      }
    }

    protected function getVisibleTiles(camera:Camera2D):Vector.<Node2D> {
      var xMin:uint = Math.max(0, Math.floor(camera.x / this.tileSize))
        , yMin:uint = Math.max(0, Math.floor(camera.y / this.tileSize))
        , xMax:uint = xMin + Math.floor(camera.sceneWidth / this.tileSize)
        , yMax:uint = yMin + Math.floor(camera.sceneHeight / this.tileSize)
        , visibleTiles:Vector.<Node2D> = new Vector.<Node2D>()
        , tile:Tile;

      for (var y:uint = yMin; y <= yMax; y++) {
        for (var x:uint = xMin; x <= xMax; x++) {
          tile = this.getTile(x, y)
          if (tile) {
            visibleTiles.push(tile as Node2D);
          }
        }
      }

      return visibleTiles;
    }

    // Overriding original draw method to only draw visible tiles,
    // avoiding iteration over all tilles to determine visibility.
    /* TEMP: Removed while figuring out zooming/size
    override protected function draw(context:Context3D, camera:Camera2D):void {
      this.children = this.getVisibleTiles(camera);
      super.draw(context, camera);
    }
    */

    public function pointCheck(x:Number, y:Number):Boolean {
      return !!this.getCollisionTileAt(x, y);
    }

    public function getCollisionTile(x:Number, y:Number):Rectangle {
      if (x < 0 || y < 0 || x >= this.tilesWide || y >= this.tilesHigh) {
        return null;
      } else {
        return this.collisions[y][x];
      }
    }

    public function getCollisionTileAt(x:Number, y:Number):Rectangle {
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
            this.collisions[y][x] = new Rectangle(xpos, ypos, this.tileSize-1, this.tileSize-1);
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

    private function createObjects():void {
      var objectGroups:Object = this.game.tmx.objectGroups
        , objects:Array
        , node:Node2D;

      for each (var objectGroup:TmxObjectGroup in objectGroups) {
        objects = objectGroup.objects;
        for each (var object:TmxObject in objects) {
          switch (object.type) {
            case 'Player':
              node = new Player(this);
              node.x = object.x;
              node.y = object.y;
              this.game.player = node as Player;
              this.game.player.startPos.x = this.game.player.x;
              this.game.player.startPos.y = this.game.player.y;
              break;
            default:
              node = null;
              break;
          }

          if (node) {
            this.objects.push(node);
            this.game.addChild(node);
          }
        }
      }
    }

  }
}