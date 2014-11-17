// [LP] BLOCK WALL - BLOCK WALL REZZER
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

integer ListenChannel = 20;
integer BlockChannel = 10;

string BlockName = "[LP] BLOCK WALL BLOCK";
integer HowTall = 1;
integer HowWide = 1;
integer HowDeep = 1;

default
{
    state_entry()
    {
        llListen ( ListenChannel, "", NULL_KEY, "" );
    }

    listen ( integer channel, string name, key id, string message )
    {
        if ( llGetSubString ( message, 0, 0 ) == "H" )
        {
            HowTall = (integer)llGetSubString ( message, 1, -1);
            //llSay ( PUBLIC_CHANNEL, "Heard height: " + (string)HowTall );
        }
        
        if ( llGetSubString ( message, 0, 0 ) == "W" )
        {
            HowWide = (integer)llGetSubString ( message, 1, -1);
            //llSay ( PUBLIC_CHANNEL, "Heard width: " + (string)HowWide );
        }
        
        if ( llGetSubString ( message, 0, 0 ) == "D" )
        {
            HowDeep = (integer)llGetSubString ( message, 1, -1);
            //llSay ( PUBLIC_CHANNEL, "Heard depth: " + (string)HowDeep );
        }
        
        if ( message == "REZ WALL" )
        {
            integer Depth;
            for ( Depth = 0; Depth < HowDeep; ++Depth )
            {
                float y = (float)Depth * 0.6;
                
                integer Height;
                for ( Height = 0; Height < HowTall; ++Height )
                {
                    float z = (float)Height * 0.6;
                
                    integer Count;
                    for ( Count = 1; Count < ( HowWide + 1 ); ++Count )
                    {
                        float x = (float)Count * 0.6;
                        //llSay ( PUBLIC_CHANNEL, (string)x );
                        llRezObject ( BlockName, ( llGetPos() + < x, y, z > ), ZERO_VECTOR, ZERO_ROTATION, 0 );
                    }
                }
            }
            
            llOwnerSay ( "Saving block positions..." );
            llRegionSay ( BlockChannel, "BLOCKS SET" );
            llSleep ( 1.0 );
            llOwnerSay ( "Setting blocks to physical..." );
            llRegionSay ( BlockChannel, "BLOCKS RESET" );
        }
    }
}
