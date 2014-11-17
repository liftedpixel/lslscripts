// RANDOM TP v2
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014

integer DialogChannel = -83;
integer ListenHandle;

key HttpRequestID;
string url;

key Toucher;

string Hovertext;
vector RED = < 1.0, 0.0, 0.0 >;
vector BLUE = < 0.0, 0.0, 1.0 >;
vector GREEN = < 0.0, 1.0, 0.0 >;

string RegionName;

key RatingQuery;
string RegionRating;
string MaxRating = "MATURE";

key CoordinateQuery;
vector RegionCoordinates;

vector LocalCoordinates;
vector LookAt;

string MenuHeader = "WELCOME TO RANDOM TP v2 BY JESSYKA RICHARD\n------------------------------------------\n";

mainmenu ( )
{
    llDialog ( Toucher, MenuHeader + "-Click ROLL to teleport to a random sim.\n-Click RATING to change max sim rating\nCURRENT MAX SIM RATING: " + MaxRating, ["ROLL", "RATING"], DialogChannel );
    ListenHandle = llListen ( DialogChannel, "", Toucher, "" );
}

roll ( )
{
    url = "http://api.gridsurvey.com/simquery.php?region=FETCH_RANDOM_ONLINE_REGION_FROM_DATABASE";
    HttpRequestID = llHTTPRequest ( url, [], "" );
}

default
{
    state_entry ( )
    {
        Hovertext = "Random teleport.  Click to start.";
        llSetText ( Hovertext, RED, 1.0 );
    }

    touch_start ( integer num_detected )
    {
        Toucher = llDetectedKey ( 0 );
        
        if ( Toucher == llGetOwner ( ) )
        {
            mainmenu ( );
        }
        
        else
        {
            llSay ( PUBLIC_CHANNEL, "I can only teleport my owner, sorry." );
        }
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "RATING" )
        {
            llDialog ( Toucher, MenuHeader + "Select the max rating of sim:\nPG = General\nMATURE = Moderate\nADULT = Adult", ["PG", "MATURE", "ADULT"], DialogChannel );
        }
        
        else if ( message == "PG" )
        {
            llListenRemove ( ListenHandle );
            MaxRating = "PG";
            mainmenu ( );
        }
        
        else if ( message == "MATURE" )
        {
            llListenRemove ( ListenHandle );
            MaxRating = "MATURE";
            mainmenu ( );
        }
        
        else if ( message == "ADULT" )
        {
            llListenRemove ( ListenHandle );
            MaxRating = "ADULT";
            mainmenu ( );
        }
        
        else if ( message == "ROLL" )
        {
            llListenRemove ( ListenHandle );
            Hovertext = "Looking for random location...";
            llSetText ( Hovertext, RED, 1.0 );
            roll ( );
        }
    }
    
    http_response ( key request_id, integer status, list metadata, string body )
    {
        RegionName = body;
        Hovertext = "Checking region " + RegionName + "...";
        llSetText ( Hovertext, RED, 1.0 );
        RatingQuery = llRequestSimulatorData ( RegionName, DATA_SIM_RATING );
    }

    run_time_permissions ( integer perm )
    {
        if ( PERMISSION_TELEPORT & perm )
        {
            Hovertext = "Teleporting to " + RegionName;
            llSetText ( Hovertext, BLUE, 1.0 );
            llTeleportAgentGlobalCoords ( Toucher, RegionCoordinates, LocalCoordinates, LookAt );
        }
    }

    dataserver(key query_id, string data)
    {
        if ( query_id == RatingQuery )
        {
            RegionRating = data;
            //llSay ( PUBLIC_CHANNEL, "Region rating: " + RegionRating );
            
            if ( MaxRating == "ADULT" )
            {
                CoordinateQuery = llRequestSimulatorData ( RegionName, DATA_SIM_POS );
            }
            
            else if ( RegionRating == MaxRating )
            {
                CoordinateQuery = llRequestSimulatorData ( RegionName, DATA_SIM_POS );
            }
            
            else if ( MaxRating == "MATURE" && RegionRating == "MATURE" || RegionRating == "PG" )
            {
                CoordinateQuery = llRequestSimulatorData ( RegionName, DATA_SIM_POS );
            }
            
            else
            {
                roll ( );
            }
        }
        
        else if ( query_id == CoordinateQuery )
        {
            RegionCoordinates = (vector)data;
            //llSay ( PUBLIC_CHANNEL, "Region coordinates: " + (string)RegionCoordinates );
            LocalCoordinates = < 128, 128, 30 >;
            LookAt = ZERO_VECTOR;
            Hovertext = "Requesting permission to teleport to " + RegionName + "...";
            llSetText ( Hovertext, RED, 1.0 );
            llRequestPermissions ( Toucher, PERMISSION_TELEPORT );
        }
    }
    
    changed ( integer change )
    {
        if ( CHANGED_REGION & change )
        {
            Hovertext = "Welcome (hopefully) to " + RegionName;
            llSetText ( Hovertext, GREEN, 1.0 );
        }
    }
}
