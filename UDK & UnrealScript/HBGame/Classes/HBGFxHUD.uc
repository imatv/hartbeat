class HBGFxHUD extends GFxMoviePlayer;

function Init( optional LocalPlayer LocPlay )
{
    //Gets all the other intialization stuff we need.
    super.Init (LocPlay);
    
    //Starts the GFx Movie that's attached to this script (IE: our HUD).
    Start();
    
    //Advances the frame to the first one.
    Advance(0.f);
}

DefaultProperties
{
    //The path to the swf asset
    MovieInfo=SwfMovie'hb_hud.hb_hud'
    bDisplayWithHudOff=false
    bIgnoreMouseInput=true
    bAutoPlay=true
}