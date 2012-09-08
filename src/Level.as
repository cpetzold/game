package {
  import flash.events.*;
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import net.pixelpracht.tmx.*;
  import de.nulldesign.nd2d.display.*;
  import de.nulldesign.nd2d.materials.texture.*
  import com.furusystems.dconsole2.DConsole;

  public class Level extends Scene2D {

    protected var tmx:TmxMap;
    public var map:Map;
    public var player:Player;

    public var events:EventDispatcher;

    public function Level(name:String) {
      this.events = new EventDispatcher();
      this.loadMap(name);
    }

    private function loadMap(name:String):void {
      var loader:URLLoader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, this.onLoadMap);
      loader.load(new URLRequest('../data/' + name + '.tmx'));
    }

    private function onLoadMap(e:Event):void {
      var xml:XML = new XML(e.target.data);

      this.tmx = new TmxMap(xml);
      this.init();
    }

    private function init():void {
      this.map = new Map(this.tmx.getLayer('map'));

      this.player = new Player(this.map);
      this.player.x = 400;
      this.player.y = 200;

      this.addChild(this.map);
      this.addChild(this.player);

      this.events.dispatchEvent(new Event('init'));
      //this.camera.zoom = 2;
    }

    override protected function step(dt:Number):void {
      super.step(dt);

      //this.camera.x = this.player.x - (this.camera.sceneWidth / 2);
      //this.camera.y = this.player.y - (this.camera.sceneHeight / 2);
    }

  }

}