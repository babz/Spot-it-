package {
	import org.flixel.*;
 
	public class water extends FlxObject {
		public static const NUM_STARS:Number = 30;
		private var _stars:FlxGroup;
		private var screenhight:int = 500;
		private var screenwidth:int = 500;
		[Embed(source = "welle.png")] private var welle:Class;
		[Embed(source = "welle2.png")] private var welle2:Class;
		/**
		 * @param	ang This is the angle that the starField will be rotating (in degrees)
		 * @param	speedMultiplier
		 */
		override public function water(ang:Number = 90, speedMultiplier:Number = 4):void {			
			angle = ang;
			_stars = new FlxGroup();

 
			var radang:Number = angle * Math.PI / 180;
			var cosang:Number = Math.cos(radang);
			var sinang:Number = Math.sin(radang);
 
			for ( var i:int = 0; i < water.NUM_STARS; i++ ) {
				var tempheight: Number = Math.random() * screenhight;
				var tempwidth: Number = Math.random() * screenwidth;
				var str:FlxSprite = new FlxSprite(tempwidth, tempheight);
				var vel:Number = Math.random() * -16 * speedMultiplier;
 
				// change the transparency of the star based on it's velocity
				var transp:uint = (Math.round(16 * (-vel / speedMultiplier) - 1) << 24);
 
				//str.createGraphic(2, 2, 0x00ffffff | transp);
				str.loadGraphic(welle);
				str.velocity.y = cosang * vel;
				str.velocity.x = sinang * vel;
				_stars.add(str);
				
				var str2:FlxSprite = new FlxSprite(Math.random() * screenwidth,  Math.random() * screenhight);
				vel = Math.random() * -16 * speedMultiplier;
				transp = (Math.round(16 * ( -vel / speedMultiplier) - 1) << 24);
				
				str2.loadGraphic(welle2);
				str2.velocity.y = cosang * vel;
				str2.velocity.x = sinang * vel;
				_stars.add(str2);
			}
		}
 
		/**
		 * Rotate the starField
		 * @param	howMuch Input the amount of rotation in degrees
		 */
		public function rotate(howMuch:Number = 1):void {
			angle += howMuch;
 
			var radang:Number = angle * Math.PI / 180;
			var cosang:Number = Math.cos(radang);
			var sinang:Number = Math.sin(radang);
 
			for ( var i:int = 0; i < water.NUM_STARS*2; i++ ) {
				var str:FlxSprite = _stars.members[i] as FlxSprite;
 
				FlxU.rotatePoint(str.velocity.x, str.velocity.y, 0, 0, howMuch, str.velocity);
			}
		}
 
		override public function update():void {
			_stars.update();
 
			for (var i:int = 0; i < _stars.members.length; i++) {
				var star:FlxSprite = _stars.members[i] as FlxSprite;
				if (star.x > screenwidth) {
					star.x = 0;
				} else if (star.x < 0) {
					star.x = screenwidth;
				}
				if (star.y > screenhight) {
					star.y = 0;
				} else if (star.y < 0) {
					star.y = screenhight;
				}
 
			}
		}
 
		override public function render():void {
			_stars.render();
		}
	}
 
}