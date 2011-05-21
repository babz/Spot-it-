package  
{
	import org.flixel.*;
	public class Player extends FlxSprite
    {
        [Embed(source = "boat_big.png")] private var playerImg:Class;

        public function Player(X:Number = 0, Y:Number = 0):void
        {
            super(X, Y, playerImg);
        }
        public override function update():void
        {
            //dont let the boat go outside the screen
			if (this.x <= 0) {
				this.x = 0;
			} 
			//TODO: dont let the boat go outside x
			/*else if (x > PlayState.MAX_PLAYGROUND_WIDTH - width) {
				this.x = PlayState.MAX_PLAYGROUND_WIDTH;
			}*/
			if (this.y <= 0) {
				this.y = 0;
			} else if (y > FlxG.height - height) {
				y = FlxG.height - height;
			}
        }
    }
}