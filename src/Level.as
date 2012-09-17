package {
  import flash.events.*;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.ByteArray;
  import net.pixelpracht.tmx.*;
  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*
  import com.furusystems.dconsole2.DConsole;

  public class Level extends Scene2D {

    public var tmx:TmxMap;
    public var map:Map;
    
    public var player:Player;

    public var events:EventDispatcher;

    [Embed(source='../data/maps/dots.tmx', mimeType='application/octet-stream')]
    protected var mapFile:Class;

    public function Level(name:String) {
      this.events = new EventDispatcher();
      //this.loadMap(name);

      var mapFile:ByteArray = new mapFile();
      var mapStr:String = mapFile.readUTFBytes(mapFile.length);
      var mapXML:XML = new XML(mapStr);

      this.tmx = new TmxMap(mapXML);
      this.map = new Map(this);
    }

    protected function onMouseWheelMove(e:Event):void {
      
    }

    override protected function step(dt:Number):void {
      super.step(dt);

      if (Input.kp('r')) {
        this.player.reset();
      }

      if (Input.kd('[')) {
        this.camera.zoom = Math.max(0.1, this.camera.zoom - 0.01);
      } else if (Input.kd(']')) {
        this.camera.zoom = Math.min(3, this.camera.zoom + 0.01);
      }

      this.camera.x = this.player.x - (this.camera.sceneWidth / 2);
      /*if (this.player.movingLeft) {
        this.camera.x -= (this.camera.sceneWidth / 4);
      } else if (this.player.movingRight) {
        this.camera.x += (this.camera.sceneWidth / 4);
      }*/
      this.camera.y = this.player.y - (this.camera.sceneHeight / 2);

      //this.camera.x += ((this.player.x - (this.camera.sceneWidth / 2)) - this.camera.x) * 0.1;
      //this.camera.y += ((this.player.y - (this.camera.sceneHeight / 2)) - this.camera.y) * 0.1;
    }

  }

}