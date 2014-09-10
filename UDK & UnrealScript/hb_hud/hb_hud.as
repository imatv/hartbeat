package  {
	import flash.display.MovieClip;		// Needed for the stage
	import scaleform.gfx.Extensions;	// Allows us to use Scaleform
	import flash.events.Event;			//Allows us to use the Event.ENTER_FRAME event listener
	
	// Declaring the Document class
	public class hb_hud extends MovieClip {
		
		// Variables that we will be using to show the player's current and max health
		//public static var currentHealth:int = 100;
		//public static var maxHealth:int = 100;
		
		//Constructor will be called the first frame of the game
		public function hb_hud() {
			
			// Enables Scaleform
			Extensions.enabled = true;
			// Adds an event so that the Update function will be called every single frame.
			//addEventListener(Event.ENTER_FRAME,this.Update);
		}
		
		// Code that we want to run every frame of the game
		//function Update(event:Event) {
			// Update our life's scale to reflect the current ratio of currentHealth to maxHealth
			//lifebar.scaleX = currentHealth/maxHealth;
		//}
	}
}