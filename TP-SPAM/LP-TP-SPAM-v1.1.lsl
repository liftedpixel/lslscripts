// [LP] TP SPAM v1.1
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 7 22

key AvatarKey;
string LandmarkName;
integer Running;
float Timer = 10.0;
vector BLUE = < 0.0, 0.749, 1.0 >;
vector GRAY = < 0.5, 0.5, 0.5 >;

default
{
    state_entry ( )
    {
        AvatarKey = NULL_KEY;
        llSetColor ( GRAY, ALL_SIDES );
        Running = FALSE;
        llOwnerSay ( "Welcome to TP SPAM.  Please click to teleport." );
    }
 
    touch_start ( integer num_detected )
    {
        if ( Running == FALSE )
        {
            AvatarKey = llDetectedKey ( 0 );
            LandmarkName = llGetInventoryName ( INVENTORY_LANDMARK, 0 );
            llRequestPermissions ( AvatarKey, PERMISSION_TELEPORT );
        }
        
        else if ( Running == TRUE )
        {
            llSetColor ( GRAY, ALL_SIDES );
            Running = FALSE;
            llSetTimerEvent ( 0.0 );
            llOwnerSay ( "No longer teleporting." );
        }
    }
 
    run_time_permissions ( integer perm )
    {
        if ( PERMISSION_TELEPORT & perm )
        {
            if ( LandmarkName == "" )
            {
                llOwnerSay ( "Please insert landmark." );
            }
            
            else
            {
                llSetColor ( BLUE, ALL_SIDES );
                Running = TRUE;
                llSetTimerEvent ( Timer );
                llOwnerSay ( "Teleporting to " + LandmarkName + " in " + (string)Timer + " seconds." );
            }
        }
    }
    
    timer ( )
    {
        llTeleportAgent ( AvatarKey, LandmarkName, ZERO_VECTOR, ZERO_VECTOR );
    }
    
    changed ( integer change )
    {
        if ( CHANGED_OWNER & change )
        {
            llResetScript ();
        }
        
        if ( CHANGED_REGION & change && Running == TRUE )
        {
            llSetColor ( GRAY, ALL_SIDES );
            Running = FALSE;
            llSetTimerEvent ( 0.0 );
            llOwnerSay ( "You have (hopefully) arrived at " + LandmarkName + "." );
        }
    }
}
