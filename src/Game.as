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

  import Level;

  [SWF(width="800", height="600", frameRate="60", backgroundColor="#222222")]
  public class Game extends World2D {

    protected var currentLevel:Level;

    public static var stats:Stats = new Stats();
    
    public function Game() {
      this.stage.scaleMode = StageScaleMode.NO_SCALE;
      this.stage.align = StageAlign.TOP_LEFT;
      
      super(Context3DRenderMode.AUTO, 60);
    }
    
    override protected function addedToStage(e:Event):void {
      super.addedToStage(e);
      
      this.addChild(stats);
      this.addChild(DConsole.view);
      //DConsole.show();

      this.currentLevel = new Level('map2');
      this.setActiveScene(this.currentLevel);
      currentLevel.events.addEventListener('init', this.onLevelInit);
    }

    protected function onLevelInit(e:Event):void {
      this.addChild(this.currentLevel.player.boundsSprite);
      this.start();
    }

    override protected function mainLoop(e:Event):void {
      super.mainLoop(e);
      stats.update(statsObject.totalDrawCalls, statsObject.totalTris);
    }
    
  }

}