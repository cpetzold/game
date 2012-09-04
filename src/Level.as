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

  import Map;
  import Player;

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
      this.map.x = 16;
      this.map.y = 300;

      this.player = new Player();
      this.player.x = 400;
      this.player.y = 200;
      this.player.vx = 50;

      this.addChild(this.map);
      this.addChild(this.player);

      this.events.dispatchEvent(new Event('init'));
    }

    override protected function step(dt:Number):void {
      //this.player.ay = 20;

      //DConsole.print(this.player.bounds.toString());

      super.step(dt);
    }

  }

}