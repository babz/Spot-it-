package
{
	import flash.display.InteractiveObject;
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.data.FlxAnim;
 
	public class PlayState extends FlxState
	{
	    [Embed(source = "fahne.png")] private var yellowFlag:Class;
		[Embed(source = "fahne2.png")] private var redFlag:Class;
		[Embed(source = "validation.png")] private var validationImg:Class;

		public var player:Player;
		public var minutes:int, seconds: int; 
		private var secondsstr: String;
		private var textState: FlxText;
		private var cnt: int = 0;
		
		public var flagLayer:FlxGroup;
		public var flag: Flag;
		public var activeFlag: FlxSprite = null;
		public var validation: FlxSprite = new FlxSprite(0, 0, validationImg);
		public var bOver: Boolean = false;

		private var waves:water = new water(70,1);

		override public function create():void
		{
			add(waves);
			validation.visible = false;
			//Hintergrundfarbe
			FlxState.bgColor = 0xFF0000CC;
			
            player = new Player(20, 50);
			FlxG.follow(player);
			FlxG.followBounds(0, 0,2000, FlxG.height);

			//Startzeit
			minutes = 1;
			seconds = 0;
			
			//Bojen
			flagLayer = new FlxGroup();
			//health: ob Bombe (0) , nix (2) oder Validation (1)
		    flag = new Flag(100, 100); flag.health = 0;
			flagLayer.add(flag);
		    flag = new Flag(200, 200); flag.health = 2;
			flagLayer.add(flag);
		    flag = new Flag(300, 260); flag.health = 1;
			flagLayer.add(flag);
		    flag = new Flag(400, 70);  flag.health = 1;
			flagLayer.add(flag);
			flag = new Flag(500, 210); flag.health = 2;
			flagLayer.add(flag);
			flag = new Flag(600, 20);  flag.health = 2;
			flagLayer.add(flag);
			flag = new Flag(700, 10);  flag.health = 2;
			flagLayer.add(flag);
			flag = new Flag(800, 400);  flag.health = 1;
			flagLayer.add(flag);
			flag = new Flag(900, 150);  flag.health = 1;
			flagLayer.add(flag);
			
			add(flagLayer);
			
			//adds a 100px wide text field at position 0,0 (upper left)
			textState=FlxText(add(new FlxText(0, 0, 80, "Time left: 01:00")));
	
			this.add(player);
		}
		
		private function collisionFlag(colFlag:FlxSprite, colPlayer:FlxSprite):void
		{
			activeFlag = colFlag;
			activeFlag.loadGraphic(redFlag);
		}
		
		private function DrawGameOver(): void
		{
			//text schwarz
			//adds a 100px wide text field at position 0,0 (upper left)
			var gameoverBlack: FlxText = new FlxText(80, 100, 200, "GAME OVER"); 
		    gameoverBlack.setFormat(null, 25);
			gameoverBlack.color = 0x00000000;
			add(gameoverBlack);
			//text weiss
			var gameoverWhite: FlxText = new FlxText(83, 102, 200, "GAME OVER"); //adds a 100px wide text field at position 0,0 (upper left)
			gameoverWhite.setFormat(null, 24);
			add(gameoverWhite);
		}
		
		override public function update():void
		{
			if (bOver) { return };
			
			if (validation.visible) {
				if (FlxG.keys.justPressed('ENTER')) {
					validation.visible = false;
				}
				return;
			}
			var sl: int;
			if (activeFlag != null) {
				activeFlag.loadGraphic(yellowFlag);
			}
			activeFlag = null;
			
			FlxU.overlap(flagLayer, player, collisionFlag);

			//Uhrzeit berechnen
			cnt++;
			if (cnt >= 60) {
				cnt = 0;
				seconds --;
				if (seconds <= 0) {
					seconds = 59;
					if (minutes <= 0) {
						seconds = 0;
						minutes = 0;
						bOver = true;
						DrawGameOver();
						
					} else {
					  minutes --;
					}
				}
				secondsstr = "" + seconds;
				if (seconds < 10) { secondsstr = "0"+secondsstr ; }
					
				textState.text = "Time left: 0" + minutes + ":" + secondsstr;	
			}
			
			//Taste gedrückt?
			if(FlxG.keys.RIGHT)
			{
				player.x += 3;
			} else if(FlxG.keys.LEFT)
			{
				player.x -= 3;
			} else if(FlxG.keys.UP)
			{
				player.y -= 3
			} else if(FlxG.keys.DOWN)
			{
				player.y += 3;
			} else if ((FlxG.keys.ENTER) && (activeFlag!=null))
			{
				validation.x = 100;
				validation.y = 40;
				validation.visible = true;
				add(validation);
				  
				activeFlag.kill();
				activeFlag = null;
			}
			super.update();
		}
	}
}