package {

  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display.StageDisplayState;
  import flash.display3D.Context3DRenderMode;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;

  import flash.utils.setTimeout;

  import net.hires.debug.Stats;
  import com.furusystems.dconsole2.DConsole;

  import de.nulldesign.nd2d.display.World2D;
  import de.nulldesign.nd2d.display.Scene2D;

  [SWF(width="1024", height="640", frameRate="60", backgroundColor="#333333")]
  public class Main extends World2D {

    protected var current:Game;

    public static var stats:Stats = new Stats();
    
    public function Main() {
      super(Context3DRenderMode.AUTO, 60);

      this.stage.scaleMode = StageScaleMode.NO_SCALE;
      this.stage.align = StageAlign.TOP_LEFT;

      this.addEventListener(Event.DEACTIVATE, this.onLostFocus);
      this.addEventListener(Event.ACTIVATE, this.onFocus);

      Input.initialize(this.stage, false);
    }
    
    override protected function addedToStage(e:Event):void {
      var self:Main = this;

      super.addedToStage(e);
      
      this.addChild(stats);
      //this.addChild(DConsole.view);
      //DConsole.show();

      this.current = new Game('new');
      this.setActiveScene(this.current);
      setTimeout(function():void {
        self.start();
      }, 0);
    }

    protected function onLostFocus(e:Event):void {
      this.pause();
    }

    protected function onFocus(e:Event):void {
      this.resume();
    }

    public function togglePause():void {
      if (!this.isPaused) {
        this.pause();
      } else {
        this.resume();
      }
    }

    public function toggleFullscreen():void {
      if (this.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
        this.stage.displayState = StageDisplayState.NORMAL;
      } else {
        this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
      }
    }

    override protected function mainLoop(e:Event):void {
      super.mainLoop(e);
      stats.update(statsObject.totalDrawCalls, statsObject.totalTris);
    }

    override protected function step(dt:Number, t:Number):void {
      super.step(dt, t);

      if (Input.kp('ESC')) this.togglePause();
      // if (Input.kp('F')) this.toggleFullscreen();

      Input.clear();
    }


    
  }

}