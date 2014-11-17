// [LP] BLOCK WALL - DEPTH CONTROL DOWN BUTTON
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

vector WHITE = < 1.0, 1.0, 1.0 >;
float SOLID = 1.0;

integer DChannel = 50;
integer RezChannel = 20;

integer Depth = 1;
default
{
    state_entry()
    {
        llListen ( DChannel, "", NULL_KEY, "" );
        llSetText ( (string)Depth, WHITE, SOLID );
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "DUP" )
        {
            Depth = Depth + 1;
            if ( Depth > 3 )
            {
                Depth = 3;
            }
            llSetText ( (string)Depth, WHITE, SOLID );
            llRegionSay ( RezChannel, "D" + (string)Depth );
        }
        
        if ( message == "DWHAT" )
        {
            llSay ( (DChannel + 1), (string)Depth );
        }
    }
    
    touch_start ( integer num_detected )
    {
        Depth = Depth - 1;
        if ( Depth < 1 )
        {
            Depth = 1;
        }
        
        llSetText ( (string)Depth, WHITE, SOLID );
        llRegionSay ( RezChannel, "D" + (string)Depth );
    }
}
