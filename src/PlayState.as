package
{
	import flash.utils.*;
	import org.flixel.*;

	
	public class PlayState extends FlxState
	{
	    [Embed(source = "fahne.png")] private var yellowFlag:Class;
		[Embed(source = "fahne2.png")] private var redFlag:Class;
		[Embed(source = "fahneValidation.png")] private var validationFlag:Class;
		[Embed(source = "validation1.png")] private var validationImg:Class;
		[Embed(source = "validation2.png")] private var validationImg2:Class;
		[Embed(source = "validation3.png")] private var validationImg3:Class;
		[Embed(source = "validationtext.png")] private var validationTextImg:Class;
		
		[Embed(source = "end.jpg")] private var gameWon:Class;
		[Embed(source = "StartScreen.jpg")] private var startImg:Class;
		
		[Embed(source = "fisch.png")] private var fischImg:Class;
		[Embed(source = "krake.png")] private var krakeImg:Class;
		[Embed(source = "arrow.png")] private var selectedCatImg:Class;
		[Embed(source = "boat_toLeft.png")] private var playerImgLeft:Class;
		[Embed(source = "boat_big.png")] private var playerImgRight:Class;
		
		//Sounds
		[Embed(source = "tada.mp3")] private var validationFound:Class;
		[Embed(source = "validationSound.mp3")] private var validationSound:Class;
		[Embed(source = "Freestyler.mp3")] private var backgroundMusic:Class;
		[Embed(source = "collectFish.mp3")] private var collectFish:Class;
		[Embed(source = "collideOcto.mp3")] private var collideOcto:Class;

		private var player:Player;
		private var playerObject: FlxObject;
		
		private var textState: FlxText;
		private var scoreText: FlxText;
		private var minutes:int, seconds: int; 
		private var secondsstr: String;
		private var cnt: int = 0;
		private var score: int = 0;
		private var button:FlxButton;
		
		private var flagLayer:FlxGroup;
		private var fishLayer: FlxGroup;
		private var krakeLayer: FlxGroup;
		private var valitationlist: FlxGroup;
		private var startLayer: FlxGroup;
		
		private var flag: Flag;
		//container für die jew aktuelle boje/flagge
		private var activeFlag: FlxSprite = null;
		private var validation: FlxSprite = new FlxSprite(0, 0, validationImg);
		private var validationText: FlxSprite = new FlxSprite(0, 0, validationTextImg);
		private var startScreen: FlxSprite = new FlxSprite(0, 0, startImg);
		
		private var bOver: Boolean = false; //GameOver
		private var isStart: Boolean = true; //StartScreen
		
		public const MAX_PLAYGROUND_HEIGHT: int =  FlxG.height;
		public static const MAX_PLAYGROUND_WIDTH: int = 2000;
		public const VALITATIONCOUNT: int = 15;
		public static const BOJEN_DISTANCE: int = 100;
		public const BOJENCOUNT: int = 50;
		public const KRAKENCOUNT: int = 5;
		public const FISCHCOUNT: int = 3;

		private var waves:water = new water(70, 1);

		override public function create():void
		{
			add(startScreen);
			
			//globale lautstärkenänderung
			FlxG.volume = 0.7;
			//hintergrundmusik
			FlxG.playMusic(backgroundMusic, 0.5);
			
			add(waves);
			validation.visible = false;
			validationText.visible = false;
			//Hintergrundfarbe
			FlxState.bgColor = 0xFF0000CC;
			
			player = new Player(20, 50);
			
			FlxG.follow(player);
			FlxG.followBounds(0, 0, MAX_PLAYGROUND_WIDTH, MAX_PLAYGROUND_HEIGHT);

			//Startzeit
			minutes = 1;
			seconds = 0;
			
			//fische
			fishLayer = new FlxGroup();
			var fish: FlxSprite;
			for (var i: Number = 0; i < FISCHCOUNT; i++) {
				fish= generateFishAtRandomPos();
				fishLayer.add(fish);
			}
			
			add(fishLayer);
			
			
			//Krake
			krakeLayer = new FlxGroup();
			var krake: FlxSprite;
			for (var k: Number = 0; k < KRAKENCOUNT; k++) {
				krake= generateKrakeAtRandomPos();
				krakeLayer.add(krake);
			}
			
			add(krakeLayer);
			
			//Bojen
			flagLayer = new FlxGroup();
			valitationlist = new FlxGroup();
			var flag: Flag;
			
			//generiert flaggen
			for (var j: Number = 0; j < BOJENCOUNT; j++) {
				flag = generateFlagAtRandomPos();
				flagLayer.add(flag);
				if (j <= VALITATIONCOUNT) { 
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
	
			//validationImg goes with camera, 0 indicates background/HUD element
			validation.scrollFactor = new FlxPoint(0, 0);
			validationText.scrollFactor = new FlxPoint(0, 0);
			playerObject = this.add(player);
		}
		
		private function getScore():String
		{
			return new String(score);
		}
		
		private function generateFlagAtRandomPos():Flag
		{
			var heightRand : Number = Math.round(MAX_PLAYGROUND_HEIGHT * FlxU.random());
			var widthRand : Number = Math.round(MAX_PLAYGROUND_WIDTH * FlxU.random());
			if (isBojeAlreadyThere(widthRand, heightRand)) {
				return generateFlagAtRandomPos();
			}
			return new Flag(widthRand, heightRand);
		}
		
		private function generateKrakeAtRandomPos():FlxSprite
		{
			var heightRand : Number = Math.round((MAX_PLAYGROUND_HEIGHT-40) * FlxU.random());
			var widthRand : Number = Math.round((MAX_PLAYGROUND_WIDTH - 40) * FlxU.random());
			if ((heightRand < 150) && (widthRand < 150)) { 
				return generateKrakeAtRandomPos() 
			} else {
				return new FlxSprite(widthRand, heightRand, krakeImg);
				
			}
		}		

		private function generateFishAtRandomPos():FlxSprite
		{
			var heightRand : Number = Math.round(MAX_PLAYGROUND_HEIGHT * FlxU.random());
			var widthRand : Number = Math.round(MAX_PLAYGROUND_WIDTH * FlxU.random());
			return new FlxSprite(widthRand, heightRand, fischImg);
		}
		
		
		private function collisionFlag(colFlag:FlxSprite, colPlayer:FlxSprite):void
		{
			if (activeFlag==null) {
			  activeFlag = colFlag;
			  activeFlag.loadGraphic(redFlag);
			}
		}
		
		private function collisionKrake(colKrake:FlxSprite, colPlayer:FlxSprite):void
		{
			DrawGameOver();
			FlxG.play(collideOcto, 0.6, false);
			bOver = true;
		}
		
		private function collisionFish(colFish:FlxSprite, colPlayer:FlxSprite):void
		{
			colFish.visible = false;
			
			if (colFish.active) {
				FlxG.play(collectFish, 0.6, false);
				score+=10;
			}
			colFish.active = false;
		}
		
		
		private function DrawGameOver(): void
		{
			//text schwarz (schatten)
			//adds a 100px wide text field at position 0,0 (upper left)
			var gameoverBlack: FlxText = new FlxText(200, 200, 400, "GAME OVER"); 
		    gameoverBlack.setFormat(null, 37);
			gameoverBlack.color = 0x00000000;
			gameoverBlack.scrollFactor = new FlxPoint(0, 0);
			add(gameoverBlack);
			//text weiss
			var gameoverWhite: FlxText = new FlxText(203, 202, 400, "GAME OVER"); //adds a 100px wide text field at position 0,0 (upper left)
			gameoverWhite.setFormat(null, 36);
			gameoverWhite.scrollFactor = new FlxPoint(0, 0);
			gameoverWhite.shadow = 0x00000000;
			add(gameoverWhite);
		}
		
		private function getValidationCnt(flag: FlxSprite): int
		{
			var cnt: int =0;
			var o:FlxSprite;
			
			for ( var i:int = 0; i < valitationlist.members.length; i++ ) {
				o = valitationlist.members[i] as FlxSprite;
				if (flag!=o) {
				  if (((o.x == (flag.x - BOJEN_DISTANCE)) || (o.x == (flag.x + BOJEN_DISTANCE)) || (o.x == flag.x)) && 
				   ((o.y == (flag.y - BOJEN_DISTANCE)) || (o.y == (flag.y + BOJEN_DISTANCE)) || (o.y == flag.y))) {
					cnt++;
				   }
				}
				
			}
			return cnt;
		}
		
		private function hasClickedOnRadioButton(X:int,Y: int): Boolean
		{
			if ((X<320) || (X>330)) return false;
			if ((Y<110) || (Y>285)) return false;
			
			if (Y < 125) { //artificial areas
				FlxG.play(validationSound,0.8, false);
			}
			else if (Y < 152) { //croplands
				FlxG.play(validationSound, 0.8, false);
			}
			else if (Y < 180) { //Tree cover
				FlxG.play(validationSound, 0.8, false);
			} 
			else if (Y < 207) { //natural vegetation
				FlxG.play(validationSound, 0.8, false);
			} 
			else if (Y < 232) { //urban and built-up areas
				FlxG.play(validationSound, 0.8, false);
			} 
			else if (Y < 259) { //shrub cover
				FlxG.play(validationSound, 0.8, false);
			} 
			else if (Y < 284) { //not in list
				FlxG.play(validationSound, 0.8, false);
			} else return false
			

			return true;
		}
		
		private function isBojeAlreadyThere(X:int,Y: int): Boolean
		{
			//Nach Raster orientiert
			X = Math.floor(X / PlayState.BOJEN_DISTANCE) * PlayState.BOJEN_DISTANCE;
			Y = Math.floor(Y / PlayState.BOJEN_DISTANCE) * PlayState.BOJEN_DISTANCE
			//damit oberer Rand frei bleibt
			Y = Y + 32;
			
			var o:FlxSprite;
			
			for ( var i:int = 0; i < flagLayer.members.length; i++ ) {
				o = flagLayer.members[i] as FlxSprite;
				if ((o.x == X) && (o.y == Y)) {
					return true;
				}
			}
			
			return false;
		}
		
		public function winScreen():void
		{
			player.loadGraphic(gameWon);
			
			var youwon: FlxText = new FlxText(80, 200, 200, "GOOD JOB!"); 
		    youwon.setFormat(null, 25);
			youwon.scrollFactor = new FlxPoint(0, 0);
			
			var endScore: FlxText = new FlxText(80, 250, 200, "Score: " + getScore());
			endScore.setFormat(null, 25);
			endScore.scrollFactor = new FlxPoint(0, 0);
			
			add(youwon);
			add(endScore);
		}
	
		override public function update():void
		{
			if (bOver) { return };
			if (isStart)
			{
				if (FlxG.keys.ENTER) {
					isStart = false;
					startScreen.visible = false;
				}
				return;
			}
			
			if (validation.visible) {	
				var screenX:Number = FlxG.mouse.screenX;	
				var screenY:Number = FlxG.mouse.screenY;	
				var pressed:Boolean = FlxG.mouse.pressed();	
				
				if ((pressed) && (hasClickedOnRadioButton( screenX, screenY))) {
					validation.visible = false;
					validationText.visible = false;
					FlxG.mouse.hide();
				}
				return;
			}
			var sl: int;
			if (activeFlag != null) {
				if ((!activeFlag.active) && (valitationlist.members.indexOf(activeFlag) > 0 )) {
					activeFlag.loadGraphic(validationFlag);
				} else {activeFlag.loadGraphic(yellowFlag);}
			}
			activeFlag = null;
			
			FlxU.overlap(flagLayer, player, collisionFlag);
			
			FlxU.overlap(krakeLayer, player, collisionKrake);
			
			FlxU.overlap(fishLayer, player, collisionFish);

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
						winScreen();
						
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
				player.right;
				player.loadGraphic(playerImgRight, false, true);
				player.x += 3;
			} else if(FlxG.keys.LEFT)
			{
				player.left;
				player.loadGraphic(playerImgLeft, false, true);
				player.x -= 3;
			} else if(FlxG.keys.UP)
			{
				player.y -= 3
			} else if(FlxG.keys.DOWN)
			{
				player.y += 3;
			} else if ((FlxG.keys.ENTER) && (activeFlag!=null) && (activeFlag.active))
			{	 
				var validationcnt: int = 0;
				validationcnt = getValidationCnt(activeFlag);
				var valitionText: FlxText = new FlxText(activeFlag.x+15, activeFlag.y+15, 200, ""+validationcnt); //adds a 100px wide text field at position 0,0 (upper left)
			    valitionText.setFormat(null, 16);
				valitionText.color = 0x00000000;
				//Text muss hinter dem Boot gezeichnet werden, deshalb muss es in der 
				//Render-Pipeline (defaultgroup) weiter vorne stehen --> da es kein
				//insert gibt, wird es mit dem player vertauscht und der player
				//nachher noch einmal hinzugefügt
			    var newObject: FlxObject=add(valitionText);
				defaultGroup.replace(playerObject, newObject);
				add(playerObject);
				
				activeFlag.active = false;
				
				if (valitationlist.members.indexOf(activeFlag) > 0 ) {
				  FlxG.play(validationFound, 0.5, false);
				  FlxG.mouse.show();
				  FlxG.mouse.load(selectedCatImg);
				  var i: int = (3*FlxU.random()) % 3;
				  if (i == 0) {
					  validation.loadGraphic(validationImg);
				  } else if (i == 1) {
					   validation.loadGraphic(validationImg2);
				  } else if (i == 2) {
					   validation.loadGraphic(validationImg3);
				  }
				  
				  validation.x = 100;
				  validation.y = 100;
				  validation.visible = true;
				  add(validation);
				  validationText.x = validation.x + validation.width;
				  validationText.y = 100;
				  validationText.visible = true;
				  add(validationText);
				  
				  activeFlag.loadGraphic(validationFlag);
				  score+=5;
				}
			}
			super.update();
		}
		
	}
	
	
}