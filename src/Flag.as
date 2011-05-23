package  
{
	import org.flixel.*;
	public class Flag extends FlxSprite
    {
        [Embed(source = "fahne.png")] private var yellowFlag:Class;

        public function Flag(X:Number = 0, Y:Number = 0):void
        {
			//Nach Raster orientiert
			X = Math.floor(X / PlayState.BOJEN_DISTANCE) * PlayState.BOJEN_DISTANCE;
			Y = Math.floor(Y / PlayState.BOJEN_DISTANCE) * PlayState.BOJEN_DISTANCE
			//damit oberer Rand frei bleibt
			Y = Y + 32;
            super(X, Y, yellowFlag);
        }

        public override function update():void
        {
            super.update();
			

        }
    }
}