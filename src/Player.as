package  
{
	import org.flixel.*;
	public class Player extends FlxSprite
    {
        [Embed(source = "boat.png")] private var PlayerImage:Class;

        public var decisionCounter:Number;
        public var decisionGoal:Number;
        public var decision:Number;

        public function Player(X:Number = 0, Y:Number = 0):void
        {
            super(X, Y, PlayerImage);
        }
        public override function update():void
        {
            super.update();
			if (this.x <= 0) {
				this.x = 0;
			}
			if (this.y <= 0) {
				this.y = 0;
			}
			/**if (this.x > (FlxG.width - this.width)){
				this.x = FlxG.width - this.width;
			} else if (this.x <= 0) {
				this.x = 0;
			}
			if (this.y > (FlxG.height - this.height)){
				this.y = (FlxG.height - this.height);
			} else if (this.y <= 0) {
				this.y = 0;
			}
			**/
        }
    }
}