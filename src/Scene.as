package {

  import de.nulldesign.nd2d.display.Scene2D;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;

  import de.nulldesign.nd2d.materials.texture.SpriteSheet; // Sprite

  public class Scene extends Scene2D {

    [Embed(source='../data/mario.png')]
    protected var MarioBitmap:Class;

    protected var mario:Sprite2D;

    public function Scene() {

      var texture:Texture2D = Texture2D.textureFromBitmapData(new MarioBitmap().bitmapData);
      this.mario = new Sprite2D(texture);



      this.addChild(this.mario);

//Animation Code
      this.mario.spriteSheet = new SpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 29, 16, 10); //29 = width / 16 = height / 10 = fps
      this.mario.spriteSheet.addAnimation("RUN", [0,1,2,3,2,1], true); //"RUN" is the name of the animation. / 0,1,2, etc calls the frame
      this.mario.spriteSheet.playAnimation("RUN"); //play duh.

//Animation Code - ENDS
      this.mario.x = 200;
      this.mario.y = 200;

    }

  }

}