// ELEVATOR STOP
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014

integer Channel = 122;
integer Handle;

string LocationName;

default
{
    on_rez ( integer start_param )
    {
          llResetScript();
    }

    state_entry ()
    {
        Handle = llListen ( Channel, "", NULL_KEY, "" );
    }

    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "LOCATIONS" )
        {
                LocationName = llGetObjectDesc();
            llRegionSay ( Channel, LocationName );
        }
        
        else if ( message == LocationName )
        {
            llRegionSay ( Channel, "COME HERE" );
        }
    }
    
    touch_start ( integer num_detected )
    {
          LocationName = llGetObjectDesc();
        llSay ( PUBLIC_CHANNEL, LocationName + " clicked..." );
        llRegionSay ( Channel, "COME HERE" );
    } 
}
