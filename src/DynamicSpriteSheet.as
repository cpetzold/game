package {
  import de.nulldesign.nd2d.materials.texture.SpriteSheet;

  public class DynamicSpriteSheet extends SpriteSheet {

    public function DynamicSpriteSheet(sheetWidth:Number, sheetHeight:Number, spriteWidth:Number, spriteHeight:Number, fps:uint, spritesPackedWithoutSpace:Boolean = false) {
      super(sheetWidth, sheetHeight, spriteWidth, spriteHeight, fps, spritesPackedWithoutSpace);
    }

    public function setFps(fps:uint):void {
      this.fps = fps;
    }

  }

}