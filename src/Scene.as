package {

  import de.nulldesign.nd2d.display.Scene2D;
  import de.nulldesign.nd2d.materials.texture.Texture2D;
  import de.nulldesign.nd2d.display.Sprite2D;

  public class Scene extends Scene2D {

    [Embed(source='../data/mario.png')]
    protected var MarioBitmap:Class;

    protected var mario:Sprite2D;

    public function Scene() {

      var texture:Texture2D = Texture2D.textureFromBitmapData(new MarioBitmap().bitmapData);
      this.mario = new Sprite2D(texture);

      this.addChild(this.mario);

      this.mario.x = 200;
      this.mario.y = 200;

    }

  }

}