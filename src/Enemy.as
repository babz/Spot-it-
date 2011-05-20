package  
{
	import org.flixel.*;
	public class Enemy extends FlxSprite
    {
        [Embed(source = "fahne.png")] private var EnemyImage:Class;


        public function Enemy(X:Number = 0, Y:Number = 0):void
        {
            super(X, Y, EnemyImage);
        }

        public override function update():void
        {
            super.update();
			

        }
    }
}