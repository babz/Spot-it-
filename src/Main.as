package
{

	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width = "640", height = "480", backgroundColor = "#000000")] //Set the size and color of the Flash file

 
	public class Main extends FlxGame
	{
		
		public function Main()
		{
			super(640, 480, PlayState, 1); //Create a new FlxGame object at 640x480 with 1x pixels, then load PlayState		
		}
	}
}