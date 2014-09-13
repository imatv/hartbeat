class HBHudWrapper extends UTHUDBase;

var HBGFxHUD HUDMovie; //The name of our GFX UI movie.

simulated function PostBeginPlay()
{
    // Grab all the normal initialization for the HUD class.
    super.PostBeginPlay();
    
    //Create a new instance of our custom GFX HUD class.
    HudMovie = new class'HBGFxHUD'; 
    
    //Set it to realtime updating.
    HudMovie.SetTimingMode(TM_Real); 
    
    //Calls an initialization function inside the custom GFX HUD class
    HudMovie.Init();
}

event PostRender()
{
    //local int i;
    //Call all the other PostRender stuff from GFxMovie
    super.PostRender();
    
    //if (HudMovie != none)
    //{
        // As long as we have a HUD, we call the TickHUD function on every tick.
        HudMovie.TickHUD();
    //}    
    
    //As long as the HUD is enabled, we want to draw it.
    if ( bShowHud && bEnableActorOverlays )
    {
        DrawHud();
    }
}