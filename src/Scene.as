package {

  import de.nulldesign.nd2d.display.Scene2D;
  
  import Player;
  import Tile;

  public class Scene extends Scene2D {

    protected var player:Player;
    protected var tile:Tile;
    


    public function Scene() {


    //PLAYER
      this.player = new Player();
      this.player.x = 400;
      this.player.y = 300;

      this.player.vx = 20;
      this.player.vy = -100;

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