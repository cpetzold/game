package {

  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;
  import de.nulldesign.nd2d.materials.texture.SpriteSheet;

  import DynamicSprite;

  public class Player extends DynamicSprite {

    [Embed(source='../data/mario.png')]
    protected var PlayerBMP:Class;

    public function Player() {
      var texture:Texture2D = Texture2D.textureFromBitmapData(new PlayerBMP().bitmapData);

      this.spriteSheet = new SpriteSheet(texture.bitmapWidth, texture.bitmapHeight, 29, 16, 10); //29 = width / 16 = height / 10 = fps
      this.spriteSheet.addAnimation("RUN", [0,1,2,3,2,1], true); //"RUN" is the name of the animation. / 0,1,2, etc calls the frame
      this.spriteSheet.playAnimation("RUN"); //play duh.

      super(texture);
    }

  }

}