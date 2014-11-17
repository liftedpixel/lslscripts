// [LP] BLOCK WALL - WIDTH CONTROL DOWN BUTTON
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

vector WHITE = < 1.0, 1.0, 1.0 >;
float SOLID = 1.0;

integer WChannel = 40;
integer RezChannel = 20;

integer Width = 1;
default
{
    state_entry()
    {
        llListen ( WChannel, "", NULL_KEY, "" );
        llSetText ( (string)Width, WHITE, SOLID );
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "WUP" )
        {
            Width = Width + 1;
            if ( Width > 12 )
            {
                Width = 12;
            }
            llSetText ( (string)Width, WHITE, SOLID );
            llRegionSay ( RezChannel, "W" + (string)Width );
        }
        
        if ( message == "WWHAT" )
        {
            llSay ( (WChannel + 1), (string)Width );
        }
    }
    
    touch_start ( integer num_detected )
    {
        Width = Width - 1;
        if ( Width < 1 )
        {
            Width = 1;
        }
        
        llSetText ( (string)Width, WHITE, SOLID );
        llRegionSay ( RezChannel, "W" + (string)Width );
    }
}
