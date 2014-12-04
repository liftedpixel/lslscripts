// Speed Up! by Jessica Pixel [bit.ly/pixelplanet] - v0.2.2013
// I release this script into the public domain.
//
// Attach this little guy to yourself (or you can rez it locally, but then other people can control it).
// Click to toggle the speed multiplier of the object owner.
// The objects attempts to detect if osSetSpeed is available before actually using it.
// See http://opensimulator.org/wiki/OsSetSpeed for more info

///// You may edit this /////
float speedMulti = 3.0; // How fast do you want to go? Keep it below 5 or you'll be uncontrolable.
///// End you may edit this /////

//// Adapted from http://opensimulator.org/wiki/Threat_level ////
integer WhichProbeFunction; // to tell us which function we're probing
integer NumberOfFunctionsToCheck; // how many functions are we probing?
list FunctionNames = [ "osSetSpeed" ]; // what functions to check
list FunctionPermitted = [ 0 ]; // 0 = not permitted, 1 = permitted

integer isFunctionAvailable( string whichFunction )
{
    integer index = llListFindList( FunctionNames, whichFunction );
    if (index == -1) return 0; // Return FALSE if the function name wasn't one of the ones we checked.
    return llList2Integer( FunctionPermitted, index ); // return the appropriate availability flag.
}
//// End Adapted from http://opensimulator.org/wiki/Threat_level //// 

float speedDefault = 1.0;

vector green = < 0, 1, 0 >;
vector red = < 1, 0, 0 >;
vector blue = < 0, 0, 1 >;

default
{
    state_entry( )
    {
        llOwnerSay( "Checking for osSetSpeed..." );
        
        NumberOfFunctionsToCheck = llGetListLength( FunctionNames );
        WhichProbeFunction = -1;
        llSetTimerEvent( 0.25 ); // check only four functions a second, just to be nice.
    }
    
    timer()
    {
        string BogusKey = "12345678-1234-1234-1234-123456789abc"; // it doesn't need to be valid
        
        if (++WhichProbeFunction == NumberOfFunctionsToCheck) // Increment WhichProbeFunction; exit if we're done
        {
            llSetTimerEvent( 0.0 ); // stop the timer
            state running; // switch to the Running state
        }
        
        llOwnerSay( "Checking function " + llList2String( FunctionNames, WhichProbeFunction )); // say status
        
        if (WhichProbeFunction == 0)
        osSetSpeed( BogusKey, 1 );

        FunctionPermitted = llListReplaceList( FunctionPermitted, [ 1 ], WhichProbeFunction, WhichProbeFunction );
    }
    
    changed( integer change )
    {
        if(change & CHANGED_REGION)
        {
            llOwnerSay( "Changed regions, resetting..." );
            llResetScript();
        }
    }
}

state running
{
    state_entry()
    {
        if ( isFunctionAvailable( "osSetSpeed" ))
        {
            llOwnerSay( "osSetSpeed available" );
            state off;
        }
        
        else
        {
            llOwnerSay( "no osSetSpeed" );
            state unavailable;
        }
    }
    
    changed( integer change )
    {
        if(change & CHANGED_REGION)
        {
            llOwnerSay( "Changed regions, resetting..." );
            llResetScript();
        }
    }
}

state off
{
    state_entry( )
    {
        llOwnerSay( "Setting speed multiplier to " + (string) speedDefault );
        osSetSpeed( llGetOwner(), speedDefault );
        llSetColor( red, ALL_SIDES );
    }
    
    touch_start( integer num_detected )
    {
        state on;
    }
    
    changed( integer change )
    {
        if(change & CHANGED_REGION)
        {
            llOwnerSay( "Changed regions, resetting..." );
            llResetScript();
        }
    }
}
    
state on
{
    state_entry( )
    {
        llOwnerSay( "Setting speed multiplier to " + (string) speedMulti );
        osSetSpeed( llGetOwner(), speedMulti );
        llSetColor ( green, ALL_SIDES );
    }
    
    touch_start( integer num_detected )
    {
        state off;
    }
    
    changed( integer change )
    {
        if(change & CHANGED_REGION)
        {
            llOwnerSay( "Changed regions, resetting..." );
            llResetScript();
        }
    }
}

state unavailable
{
    state_entry()
    {
        llOwnerSay( "Disabling..." );
        llSetColor ( blue, ALL_SIDES );
    }
    
    changed( integer change )
    {
        if(change & CHANGED_REGION)
        {
            llOwnerSay( "Changed regions, resetting..." );
            llResetScript();
        }
    }
}
