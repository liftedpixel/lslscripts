// GO PHYSICAL
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014

vector MyPosition;
rotation MyRotation;

integer ListenHandle;

Init ( )
{
    llSetStatus ( STATUS_RETURN_AT_EDGE | STATUS_PHYSICS, FALSE );

    llWhisper ( PUBLIC_CHANNEL, "GETTING POSITION" );
    MyPosition = llGetPos();
    llWhisper ( PUBLIC_CHANNEL, (string)MyPosition );
        
    llWhisper ( PUBLIC_CHANNEL, "GETTING ROTATION" );
    MyRotation = llGetRot();
    llWhisper ( PUBLIC_CHANNEL, (string)MyRotation );
}


default
{
    on_rez ( integer start_param )
    {
        Init ( );
    }
        
    state_entry ( )
    {
        Init ( );
        
        ListenHandle = llListen ( PUBLIC_CHANNEL, "", NULL_KEY, "" );
    }

    touch_end ( integer total_number )
    { 
        llSetPos ( llGetPos ( ) + < 0.0, 0.0, 0.5 > );
        
        llSetStatus ( STATUS_RETURN_AT_EDGE | STATUS_PHYSICS, TRUE );
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( llToUpper ( message ) == "RESET" )
        {
            llWhisper ( PUBLIC_CHANNEL, "RESETTING..." );
            llSetStatus ( STATUS_RETURN_AT_EDGE | STATUS_PHYSICS, FALSE );
            
            llSetPos ( MyPosition );
            llSetRot ( MyRotation );
        }

          else if ( llToUpper ( message ) == "INIT" )
          {
                Init ( );
          }
    }
}
