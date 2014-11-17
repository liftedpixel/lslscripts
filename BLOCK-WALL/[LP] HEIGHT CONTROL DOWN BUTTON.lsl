// [LP] BLOCK WALL - HEIGHT CONTROL DOWN BUTTON
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

vector WHITE = < 1.0, 1.0, 1.0 >;
float SOLID = 1.0;

integer HChannel = 30;
integer RezChannel = 20;

integer Height = 1;
default
{
    state_entry()
    {
        llListen ( HChannel, "", NULL_KEY, "" );
        llSetText ( (string)Height, WHITE, SOLID );
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "HUP" )
        {
            Height = Height + 1;
            if ( Height > 10 )
            {
                Height = 10;
            }
            llSetText ( (string)Height, WHITE, SOLID );
            llRegionSay ( RezChannel, "H" + (string)Height);
        }
        
        if ( message == "HWHAT" )
        {
            llSay ( (HChannel + 1), (string)Height );
        }
    }
    
    touch_start ( integer num_detected )
    {
        Height = Height - 1;
        if ( Height < 1 )
        {
            Height = 1;
        }
        
        llSetText ( (string)Height, WHITE, SOLID );
        llRegionSay ( RezChannel, "H" + (string)Height);
    }
}
