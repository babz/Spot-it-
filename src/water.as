package {
	import org.flixel.*;
 
	public class water extends FlxObject {
		public static const NUM_WAVES:Number = 100;
		private var _waves:FlxGroup;
		private var screenhight:int = 500;
		private var screenwidth:int = PlayState.MAX_PLAYGROUND_WIDTH;
		[Embed(source = "welle.png")] private var welle:Class;
		[Embed(source = "welle2.png")] private var welle2:Class;

		override public function water(ang:Number = 90, speedMultiplier:Number = 4):void {			
			angle = ang;
			_waves = new FlxGroup();

 
			var radang:Number = angle * Math.PI / 180;
			var cosang:Number = Math.cos(radang);
			var sinang:Number = Math.sin(radang);
 
			for ( var i:int = 0; i < water.NUM_WAVES; i++ ) {
				var tempheight: Number = Math.random() * screenhight;
				var tempwidth: Number = Math.random() * screenwidth;
				var str:FlxSprite = new FlxSprite(tempwidth, tempheight);
				var vel:Number = Math.random() * -16 * speedMultiplier;
 
				// change the transparency of the wave based on it's velocity
				var transp:uint = (Math.round(16 * (-vel / speedMultiplier) - 1) << 24);
 
				//str.createGraphic(2, 2, 0x00ffffff | transp);
				str.loadGraphic(welle);
				str.velocity.y = cosang * vel;
				str.velocity.x = sinang * vel;
				_waves.add(str);
				
				var str2:FlxSprite = new FlxSprite(Math.random() * screenwidth,  Math.random() * screenhight);
				vel = Math.random() * -16 * speedMultiplier;
				transp = (Math.round(16 * ( -vel / speedMultiplier) - 1) << 24);
				
				str2.loadGraphic(welle2);
				str2.velocity.y = cosang * vel;
				str2.velocity.x = sinang * vel;
				_waves.add(str2);
			}
		}
 
		/**
		 * Rotate the waves
		 * @param	howMuch Input the amount of rotation in degrees
		 */
		public function rotate(howMuch:Number = 1):void {
			angle += howMuch;
 
			var radang:Number = angle * Math.PI / 180;
			var cosang:Number = Math.cos(radang);
			var sinang:Number = Math.sin(radang);
 
			for ( var i:int = 0; i < water.NUM_WAVES*2; i++ ) {
				var str:FlxSprite = _waves.members[i] as FlxSprite;
 
				FlxU.rotatePoint(str.velocity.x, str.velocity.y, 0, 0, howMuch, str.velocity);
			}
		}
 
		override public function update():void {
			_waves.update();
 
			for (var i:int = 0; i < _waves.members.length; i++) {
				var wave:FlxSprite = _waves.members[i] as FlxSprite;
				if (wave.x > screenwidth) {
					wave.x = 0;
				} else if (wave.x < 0) {
					wave.x = screenwidth;
				}
				if (wave.y > screenhight) {
					wave.y = 0;
				} else if (wave.y < 0) {
					wave.y = screenhight;
				}
 
			}
		}
 
		override public function render():void {
			_waves.render();
		}
	}
 
}