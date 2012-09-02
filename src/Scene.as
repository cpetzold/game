package {

  import de.nulldesign.nd2d.display.Scene2D;
  
  import Player;

  public class Scene extends Scene2D {

    protected var player:Player;

    public function Scene() {

      this.player = new Player();
      this.player.x = 400;
      this.player.y = 100;

      this.addChild(this.player);
    }

    //STEP - Movement
    override protected function step(dt:Number):void {
      this.player.ay = 20;
      super.step(dt);
    }
    //STEP - Movement END

  }

}