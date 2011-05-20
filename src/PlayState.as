package
{
	import flash.display.InteractiveObject;
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.data.FlxAnim;
 
	public class PlayState extends FlxState
	{
	    [Embed(source = "fahne.png")] private var EnemyImage:Class;
		[Embed(source = "fahne2.png")] private var EnemyImage2:Class;
		[Embed(source = "Kaboom.png")] private var Kaboom:Class;
		[Embed(source = "validation.png")] private var ValidationImg:Class;

		public var player:Player;
		public var minutes, seconds: int; 
		private var secondsstr: String;
		private var TextState: FlxText;
		private var cnt: int = 0;
		
		public var enemies:FlxGroup;
		public var enemy: Enemy;
		public var activeEnemy: FlxSprite = null;
		public var kaboomImagae: FlxSprite = new FlxSprite(0, 0, Kaboom);
		public var ValidationImage: FlxSprite = new FlxSprite(0, 0, ValidationImg);
		public var kaboomTime: int = 0;
		public var bOver: Boolean = false;

		private var sf:water = new water(70,1);

		override public function create():void
		{
			add(sf);
			ValidationImage.visible = false;
			//Hintergrundfarbe
			FlxState.bgColor = 0xFF0000CC;
			
            player = new Player(20, 50);
			FlxG.follow(player);
			FlxG.followBounds(0, 0,2000,2000);

			//Startzeit
			minutes = 1;
			seconds = 0;
			
			//Bojen
			enemies = new FlxGroup(); //enemies will be spawned into this later
			//health: ob Bombe (0) , nix (2) oder Validation (1)
		    enemy = new Enemy(100, 100); enemy.health = 0;
			enemies.add(enemy);
		    enemy = new Enemy(200, 100); enemy.health = 2;
			enemies.add(enemy);
		    enemy = new Enemy(120, 200); enemy.health = 1;
			enemies.add(enemy);
		    enemy = new Enemy(270, 70);  enemy.health = 1;
			enemies.add(enemy);
			enemy = new Enemy(250, 210); enemy.health = 2;
			enemies.add(enemy);
			enemy = new Enemy(100, 20);  enemy.health = 2;
			enemies.add(enemy);
			enemy = new Enemy(200, 10);  enemy.health = 2;
			enemies.add(enemy);
			enemy = new Enemy(10, 200);  enemy.health = 1;
			enemies.add(enemy);
			enemy = new Enemy(270, 150);  enemy.health = 1;
			enemies.add(enemy);
			
			add(enemies);
			
			TextState=FlxText(add(new FlxText(0, 0, 80, "Time to death: 01:00"))); //adds a 100px wide text field at position 0,0 (upper left)
	
			this.add(player);
		}
		
		private function CollisionEnemy(colEnemy:FlxSprite, colPlayer:FlxSprite):void
		{
			activeEnemy = colEnemy;
			activeEnemy.loadGraphic(EnemyImage2);
		}
		
		private function DrawGameOver(): void
		{
			var gameoverText:  FlxText = new FlxText(80, 100, 200, "GAME OVER"); //adds a 100px wide text field at position 0,0 (upper left)		
		    gameoverText.setFormat(null, 25);
			gameoverText.color = 0x00000000;
			add(gameoverText);
			var gameoverText2:   FlxText = new FlxText(83, 102, 200, "GAME OVER"); //adds a 100px wide text field at position 0,0 (upper left)
			gameoverText2.setFormat(null, 24);
			add(gameoverText2);
		}
		
		override public function update():void
		{
			if (bOver) { return };
			
			if (ValidationImage.visible) {
				if (FlxG.keys.justPressed('ENTER')) {
					ValidationImage.visible = false;
				}
				return;
			}
			var sl: int;
			if (activeEnemy != null) {
				activeEnemy.loadGraphic(EnemyImage);
			}
			activeEnemy = null;
			
			FlxU.overlap(enemies, player, CollisionEnemy);

			//Kaboom-Bild länger einblenden
			if ((kaboomTime <= 100) && (kaboomTime > 0)) {
				kaboomTime --;
				if (kaboomTime == 0) {
					kaboomImagae.visible = false;
					bOver = true;
					DrawGameOver();
				}
			}
			
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
					
				TextState.text = "Time to death: 0" + minutes + ":" + secondsstr;	
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
			} else if ((FlxG.keys.ENTER) && (activeEnemy!=null))
			{
				
				if (activeEnemy.health == 0) {
				  kaboomTime = 100;
			      kaboomImagae.x = activeEnemy.x - 20;
				  kaboomImagae.y = activeEnemy.y - 20;
				  kaboomImagae.visible = true;
				  add(kaboomImagae);
				}else if (activeEnemy.health==1){
				  ValidationImage.x = 100;
				  ValidationImage.y = 40;
				  ValidationImage.visible = true;
				  add(ValidationImage);
				}
				activeEnemy.kill();
				activeEnemy = null;
			}
			
			super.update();
			
		}
		

	}
}