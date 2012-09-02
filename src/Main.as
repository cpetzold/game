package {

  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display3D.Context3DRenderMode;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;

  import net.hires.debug.Stats;
  import com.furusystems.dconsole2.DConsole;

  import de.nulldesign.nd2d.display.World2D;
  import de.nulldesign.nd2d.display.Scene2D;

  import Scene;

  [SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
  public class Main extends World2D {

    public static var stats:Stats = new Stats();
    
    public function Main() {
      this.stage.scaleMode = StageScaleMode.NO_SCALE;
      this.stage.align = StageAlign.TOP_LEFT;
      
      super(Context3DRenderMode.AUTO, 60);
    }
    
    override protected function addedToStage(event:Event):void {
      super.addedToStage(event);
      
      this.addChild(stats);
      this.addChild(DConsole.view);
      //DConsole.show();

      var currentScene:Scene2D = new Scene();
      this.setActiveScene(currentScene);

      this.start();
    }

    override protected function mainLoop(e:Event):void {
      super.mainLoop(e);
      stats.update(statsObject.totalDrawCalls, statsObject.totalTris);
    }
    
  }

}