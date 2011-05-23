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

		private var player:Player;
		
		private var textState: FlxText;
		private var scoreText: FlxText;
		private var minutes:int, seconds: int; 
		private var secondsstr: String;
		private var cnt: int = 0;
		private var score: int = 0;
		
		private var flagLayer:FlxGroup;
		private var valitationlist: FlxGroup;
		private var flag: Flag;
		private var activeFlag: FlxSprite = null;
		private var validation: FlxSprite = new FlxSprite(0, 0, validationImg);
		private var bOver: Boolean = false; //GameOver
		
		//TODO: bei FlxG.height - 5 zählt er die 5 vom oberen rand weg; wir wollen keine halben img sehen
		public const MAX_PLAYGROUND_HEIGHT: int =  FlxG.height;
		public static const MAX_PLAYGROUND_WIDTH: int = 1500;
		public const VALITATIONCOUNT: int = 20;

		private var waves:water = new water(70,1);

		override public function create():void
		{
			add(waves);
			validation.visible = false;
			//Hintergrundfarbe
			FlxState.bgColor = 0xFF0000CC;
			
            player = new Player(20, 50);
			
			FlxG.follow(player);
			FlxG.followBounds(0, 0, MAX_PLAYGROUND_WIDTH, MAX_PLAYGROUND_HEIGHT);

			//Startzeit
			minutes = 1;
			seconds = 0;
			
			//Bojen
			flagLayer = new FlxGroup();
			valitationlist = new FlxGroup();
			//health: ob Bombe (0) , nix (2) oder Validation (1)
		    var flag: Flag;
			
			//generiert flaggen
			for (var i: Number = 0; i < 70; i++) {
				flag = generateFlagAtRandomPos();
				flagLayer.add(flag);
				if (i <= VALITATIONCOUNT) { 
				  valitationlist.add(flag);
				}
			}
			
			add(flagLayer);
			
			//adds a 100px wide text field at position 0,0 (upper left)
			textState = new FlxText(0, 0, 80, "Time left: 01:00");
			textState.size = 12;
			//text goes with camera, 0 indicates background/HUD element
			textState.scrollFactor = new FlxPoint(0, 0);
			add(textState);
			
			//Score Textfeld
			scoreText = new FlxText(FlxG.width-55, 0, 50, "");
			scoreText.size = 12;
			scoreText.alignment = "right";
			//text goes with camera
			scoreText.scrollFactor = new FlxPoint(0, 0);
			add(scoreText);
			
			//score
	
			//validationImg goes with camera, 0 indicates background/HUD element
			validation.scrollFactor = new FlxPoint(0, 0);
			
			this.add(player);
		}
		
		private function getScore():String
		{
			return new String(score);
		}
		
		private function generateFlagAtRandomPos():Flag
		{
			var heightRand : Number = Math.round(MAX_PLAYGROUND_HEIGHT * FlxU.random());
			var widthRand : Number = Math.round(MAX_PLAYGROUND_WIDTH * FlxU.random());
			return new Flag(widthRand, heightRand);
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
			gameoverBlack.scrollFactor = new FlxPoint(0, 0);
			add(gameoverBlack);
			//text weiss
			var gameoverWhite: FlxText = new FlxText(83, 102, 200, "GAME OVER"); //adds a 100px wide text field at position 0,0 (upper left)
			gameoverWhite.setFormat(null, 24);
			gameoverWhite.scrollFactor = new FlxPoint(0, 0);
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
			
			//aktuellen score anzeigen
			scoreText.text = "Score:\n" + getScore();
			
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
			} else if ((FlxG.keys.ENTER) && (activeFlag!=null) && (activeFlag.active))
			{
				if (valitationlist.members.indexOf(activeFlag)>0 ) {
				  validation.x = 100;
				  validation.y = 40;
				  validation.visible = true;
				  add(validation);
				}
				  
				//activeFlag.kill();  //doch nicht killen
				//TODO: nicht eins rein schreiben, sondern die Anzahl der Valitations rundherum
				var valitionText: FlxText = new FlxText(activeFlag.x+15, activeFlag.y+15, 200, "1"); //adds a 100px wide text field at position 0,0 (upper left)
			    valitionText.setFormat(null, 16);
				valitionText.color = 0x00000000;
			    add(valitionText);
				//todo: valitationText hinter dem Player zeichnen
				
				activeFlag.active = false;
			}
			super.update();
		}
	}
}