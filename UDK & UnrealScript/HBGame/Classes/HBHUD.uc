/*
    Our beautfiul custom HUD... if we do it right.
    This is stupid.
*/

/*
class HBHUD extends UTHUD;

var CanvasIcon clockIcon;
var int clock; 

simulated event PostBeginPlay()
{
   SetTimer( 1, true );
   clock = 30;
}

simulated function Timer()
{
  clock--;

  if(clock <= 0)
  {     
     clock = 30;
  }
}

function DrawHUD()
{
   super.DrawHUD();    

   Canvas.DrawIcon(clockIcon, 0, 0);     

   Canvas.Font = class'Engine'.static.GetLargeFont();      
   Canvas.SetDrawColor(255, 255, 255); // White
   Canvas.SetPos(70, 15);
   
   Canvas.DrawText(clock);

   if(clock < 10)
   {
     Canvas.SetDrawColor(255, 0, 0); // Red
   }
   else if (clock < 20)
   {
     Canvas.SetDrawColor(255, 255, 0); // Yellow
   } 
   else 
   {
     Canvas.SetDrawColor(0, 255, 0); // Green
   }
 
   Canvas.SetPos(200, 15);   
   Canvas.DrawRect(20 * clock, 30);

}
defaultproperties
{
 clockIcon=(Texture=Texture2D'UDKHUD.Time')  
}
*/

class HBHUD extends UTHUD;

var CanvasIcon clockIcon;

function DrawHealthBar(float Value, float MaxValue,int X, int Y, int R, int G, int B)
{
    local int PosX,NbCases,i;
    local int CanvasThird;
    local int RectWidth;
    
    CanvasThird = Canvas.ClipX/3;
    RectWidth = CanvasThird/100;

    PosX = X; // Where we should draw the next rectangle
    NbCases = 100 * Value / MaxValue;	// Number of active rectangles to draw
    i=0; // Number of rectangles already drawn

    //Displays active rectangles
    while(i < NbCases && i < 100)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(R,G,B,200); // This controls the color of the bar.
        Canvas.DrawRect(RectWidth,12);  // The number 12 is the default height of the bar. This might need scaling later on.

        PosX += RectWidth;
        i++;
    }

     //Displays deactivated rectangles
    while(i < 100)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(255,255,255,80);
        Canvas.DrawRect(RectWidth,12);  // The number 12 is the default height of the bar. This might need scaling later on.

        PosX += RectWidth;
        i++;
    }
}

function DrawAmmoBar(float Value, float MaxValue,int X, int Y, int R, int G, int B)
{
    local int PosX,NbCases,i;

    PosX = X; // Where we should draw the next rectangle
    NbCases = Value;	// Number of active rectangles to draw
    i=0; // Number of rectangles already drawn
    
    //Displays active rectangles
    while(i < NbCases)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(R,G,B,200); // This controls the color of the bar.
        Canvas.DrawRect(2,12);  // The number 12 is the default height of the bar. This might need scaling later on.

        PosX += 3;
        i++;
    }
}

function DrawAmmoText(String curValue, String maxValue)
{
    local int PosX;
    
    PosX = 20;
    
    Canvas.SetPos(PosX,Canvas.ClipY*18/20);
    Canvas.SetDrawColor(255,255,255,255);
    Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.DrawText(curValue, false, 2, 2);
    
    PosX += 80;
    
    Canvas.SetPos(PosX,Canvas.ClipY*18/20 + 10);
    Canvas.SetDrawColor(255,255,255,255);
    Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.DrawText("/", false, 1.5, 1.5);
    
    PosX += 15;  
    
    Canvas.SetPos(PosX,Canvas.ClipY*18/20 + 10);
    Canvas.SetDrawColor(255,255,255,255);
    Canvas.Font = class'Engine'.static.GetLargeFont();
    Canvas.DrawText(maxValue, false, 1, 1);
    
}

function DrawGameHud()
{
    //Super.DrawGameHud();
    
    if ( !PlayerOwner.IsDead() && !UTPlayerOwner.IsInState('Spectating'))
    {
        DrawHealthBar(PlayerOwner.Pawn.Health, PlayerOwner.Pawn.HealthMax, Canvas.ClipX/3, Canvas.ClipY/10, 200, 80, 80);
        DrawAmmoText(String(UTWeapon(PawnOwner.Weapon).AmmoCount), String(UTWeapon(PawnOwner.Weapon).MaxAmmoCount));
        DrawAmmoBar(UTWeapon(PawnOwner.Weapon).AmmoCount, UTWeapon(PawnOwner.Weapon).MaxAmmoCount, 175, Canvas.ClipY*18/20 + 15, 245, 245, 100);
    }
    
    Super.DisplayDamage();  //For damage indicator (TODO: Need to make this directional)
    
    Canvas.DrawIcon(clockIcon, 0, 0);   
}

defaultproperties
{
    clockIcon=(Texture=Texture2D'UDKHUD.Time')  
}