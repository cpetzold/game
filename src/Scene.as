package {

  import de.nulldesign.nd2d.display.Scene2D;
  
  import Player;
  import Tile;

  public class Scene extends Scene2D {

    protected var player:Player;
    protected var tile:Tile;
    


    public function Scene() {

    //MAP ARRAY
    var mapArray:Array = new Array();
    mapArray[0] = [1,1,1,1];
    mapArray[1] = [1,0,0,1];
    mapArray[2] = [1,0,0,1];
    mapArray[3] = [1,1,1,1];


    //BUILD MAP
    for ( var row:int = 0; row <= 3; row++ )
      {
      for ( var column:int = 0; column <= 4; column++ )
        {
        if (mapArray[row][column] == 1){

           tile = new Tile();
           tile.x = (row * 32 + 164);
           tile.y = (column * 32 + 164);
           addChild(tile);
         }
        } 
    }


    //PLAYER
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