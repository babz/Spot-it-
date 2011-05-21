package  
{
	import org.flixel.*;
	public class Flag extends FlxSprite
    {
        [Embed(source = "fahne.png")] private var yellowFlag:Class;


        public function Flag(X:Number = 0, Y:Number = 0):void
        {
            super(X, Y, yellowFlag);
        }

        public override function update():void
        {
            super.update();
			

        }
    }
}