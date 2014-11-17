// [LP] TP SPAM VERSION 2.1
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 7 22

key AvatarKey;
string LandmarkName;
integer Running;
float Timer = 10.0;
vector BLUE = < 0.0, 0.749, 1.0 >;
vector GRAY = < 0.5, 0.5, 0.5 >;

string Message;
list Buttons;
integer DialogChannel = 389;
integer ListenHandle;

integer SLURLchannel = 10;
integer SLURLlistenHandle;

integer LMchannel = 11;
integer LMlistenHandle;

string SimName;
vector GlobalCoordinates;
vector LocalCoordinates = < 128, 128, 20 >;

integer UsingSLURL = FALSE;
string Place;

integer LandmarkCount;

key SimStatusRequest;
key SimPOSRequest;

default
{
    state_entry ( )
    {
        ListenHandle = llListen ( DialogChannel, "", AvatarKey, "" );
        SLURLlistenHandle = llListen ( SLURLchannel, "", AvatarKey, "" );
        LMlistenHandle = llListen ( LMchannel, "", AvatarKey, "" );
        
        llSetColor ( GRAY, ALL_SIDES );
        Running = FALSE;
        llSetTimerEvent ( 0.0 );
        llOwnerSay ( "Welcome to [LP] TP SPAM.  Please click for menu." );
    }
 
    touch_start ( integer num_detected )
    {
        if ( Running == TRUE )
        {
            Running = FALSE;
            llSetColor ( GRAY, ALL_SIDES );
            llSetTimerEvent ( 0.0 );
            LocalCoordinates = < 128, 128, 20 >;
            llOwnerSay ( "No longer teleporting." );
        }
        
        else
        {
            AvatarKey = llDetectedKey ( 0 );
            LandmarkCount = llGetInventoryNumber ( INVENTORY_LANDMARK );
            LocalCoordinates = < 128, 128, 20 >;
            
            
            if ( LandmarkCount == 0 )
            {
                llDialog ( AvatarKey, "Please edit object and insert up to 12 landmarks.\nClick SLURL to type in the location.", [ "SLURL", " " ], DialogChannel );
            }
            
            else {
                
                llDialog ( AvatarKey, "Would you like to input a SLURL,\n or use a landmark?\n(You have " + (string)LandmarkCount + " landmarks)", [ "SLURL", "LANDMARK" ], DialogChannel );
            }
        }
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( channel == DialogChannel && message == "LANDMARK" && id == AvatarKey )
        {
            if ( LandmarkCount > 12 && Running == FALSE )
            {
                llOwnerSay ( "More than 12 landmarks detected.  Please remove " + (string)( LandmarkCount - 12 ) + " landmarks." );
            }
            
            else {
                integer x = 0;
                Message = "Please select the landmark you'd like to TP SPAM to: \n\n";
                Buttons = [ ];
                while ( x < LandmarkCount )
                {
                    Message = Message + (string)( x + 1 ) + ") " + llGetSubString ( llGetInventoryName ( INVENTORY_LANDMARK, x ), 0, 24 ) + "\n";
                    Buttons = Buttons + [ (string)( x + 1 ) ];
                    x = x + 1;
                }
            
                llDialog ( AvatarKey, Message, Buttons, LMchannel );
            }
        }
        
        else if ( channel == DialogChannel && message == "SLURL" && id == AvatarKey )
        {
            string URL = "http://maps.secondlife%2Ecom/secondlife/SimName/X/Y/Z";
            string message = "Paste the location into the box below like:\n" + URL + "\nSimName/X/Y/Z\nOr just the name of the sim.";
            llTextBox( AvatarKey, message, SLURLchannel );
        }
        
        else if ( channel == SLURLchannel && id == AvatarKey )
        {
            //llOwnerSay ( message );
            
            if ( llGetSubString ( message, 0, 4 ) == "http:" )
            {
                string n = llGetSubString ( message, 38, llStringLength ( message ) );
                
                //llOwnerSay ( "n: " + n );
                
                integer ToCut = llSubStringIndex ( n, "/" );
                //llOwnerSay ( "ToCut: " + (string)ToCut );
                
                if ( ToCut == -1 )
                {
                    SimName = n;
                }
                
                else {
                    SimName = llGetSubString ( n, 0, ( ToCut - 1 ) );
                
                    SimName = llUnescapeURL ( SimName );
                    //llOwnerSay ( "SimName: " + SimName );
                
                    n = llGetSubString ( n, ( llStringLength ( SimName ) + 1 ), -1 );
                
                    float x = (float)llGetSubString ( n, 0, ( llSubStringIndex ( n, "/" ) - 1 ) );
                    LocalCoordinates.x = x;
                
                    n = llGetSubString ( n, ( llSubStringIndex ( n, "/" ) + 1 ), -1 );
                
                    float y = (float)llGetSubString ( n, 0, ( llSubStringIndex ( n, "/" ) - 1 ) );
                    LocalCoordinates.y = y;
                
                    n = llGetSubString ( n, ( llSubStringIndex ( n, "/" ) + 1 ), -1 );
                
                    float z = (float)n;
                    LocalCoordinates.z = z;
                }
            }
            
            else if ( llSubStringIndex ( message, "/" ) == -1 )
            {
                SimName = message;
                
                SimName = llUnescapeURL ( SimName );
            }
            
            else {
                SimName = llGetSubString ( message, 0, ( llSubStringIndex ( message, "/" ) - 1 ) );
                
                string n = message;
                SimName = llGetSubString ( n, 0, ( llSubStringIndex ( n, "/" ) - 1 ) );
                
                SimName = llUnescapeURL ( SimName );
                
                n = llGetSubString ( n, ( llStringLength ( SimName ) + 1 ), -1 );
                
                float x = (float)llGetSubString ( n, 0, ( llSubStringIndex ( n, "/" ) - 1 ) );
                LocalCoordinates.x = x;
                
                n = llGetSubString ( n, ( llSubStringIndex ( n, "/" ) + 1 ), -1 );
                
                float y = (float)llGetSubString ( n, 0, ( llSubStringIndex ( n, "/" ) - 1 ) );
                LocalCoordinates.y = y;
                
                n = llGetSubString ( n, ( llSubStringIndex ( n, "/" ) + 1 ), -1 );
                
                float z = (float)n;
                LocalCoordinates.z = z;
            }
            
            //llOwnerSay ( "SimName: " + SimName );
            //llOwnerSay ( "LocalCoordinates: " + (string)LocalCoordinates );
            UsingSLURL = TRUE;
            SimStatusRequest = llRequestSimulatorData ( SimName, DATA_SIM_STATUS );
        }
        
        else if ( channel == LMchannel && id == AvatarKey )
        {
            LandmarkName = llGetInventoryName ( INVENTORY_LANDMARK, ( (integer)message - 1 ) );
            UsingSLURL = FALSE;
            llRequestPermissions ( AvatarKey, PERMISSION_TELEPORT );
        }
    }
    
    run_time_permissions ( integer perm )
    {
        if ( PERMISSION_TELEPORT & perm )
        {
            Running = TRUE;
            llSetColor ( BLUE, ALL_SIDES );
            llSetTimerEvent ( Timer );
            
            if ( UsingSLURL == TRUE )
            {
                Place = SimName;
            }
            
            else {
                Place = LandmarkName;
            }
            
            llOwnerSay ( "Attempting teleport to " + Place + " every " + (string)Timer + " seconds." );
        }
    }
    
    timer ( )
    {
        if ( UsingSLURL == TRUE )
        {
            llTeleportAgentGlobalCoords ( AvatarKey, GlobalCoordinates, LocalCoordinates, ZERO_VECTOR);
        }
        
        else if ( UsingSLURL == FALSE )
        {
            llTeleportAgent ( AvatarKey, LandmarkName, ZERO_VECTOR, ZERO_VECTOR );
        }
    }
    
    dataserver ( key query_id, string data )
    {
        if ( query_id == SimStatusRequest )
        {
            if ( data != "up" )
            {
                llOwnerSay ( SimName + " not available.  Please click to start again." );
            }
            
            else
            {
                SimPOSRequest = llRequestSimulatorData ( SimName, DATA_SIM_POS );
            }
        }
        
        if ( query_id == SimPOSRequest )
        {
            GlobalCoordinates = (vector)data;
            //llOwnerSay ( "GlobalCoordinates: " + (string)GlobalCoordinates );
            UsingSLURL = TRUE;
            llRequestPermissions ( AvatarKey, PERMISSION_TELEPORT );
        }
    }
    
    changed ( integer change )
    {
        if ( CHANGED_OWNER & change )
        {
            llResetScript ();
        }
        
        if ( CHANGED_REGION & change && Running == TRUE )
        {
            Running = FALSE;
            llSetColor ( GRAY, ALL_SIDES );
            llSetTimerEvent ( 0.0 );
            llOwnerSay ( "You have (hopefully) arrived at " + Place + "." );
        }
    }
}
