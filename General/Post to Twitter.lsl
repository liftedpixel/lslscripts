key http_request_id;
string URL = "http://liftedpixel.net/pixelplanet/tweet.php";
string PASS = "itsasecret";

integer timeout = 60;
integer ListenHandle;

vector BLUE = < 0.0, 0.5, 1.0>;
float OPAQUE = 1.0;
        
MakePost ( string tweet )
{
    URL = URL + "?password=" + PASS + "&message=" + llEscapeURL ( tweet );
    http_request_id = llHTTPRequest ( URL, [ HTTP_METHOD, "GET" ], "" );
}

default
{
    state_entry ()
    {
        llSetText ( "Click to tweet.", BLUE, OPAQUE );
    }
    
    touch_start ( integer num_detected )
    {
        llSay ( PUBLIC_CHANNEL, "Say message to tweet in open chat.  Timeout in " + (string)timeout + " seconds." );
        ListenHandle = llListen ( PUBLIC_CHANNEL, "", NULL_KEY, "" );
        llSetTimerEvent ( timeout );
    }
    
    timer ()
    {
        llListenRemove ( ListenHandle );
        llSetTimerEvent ( 0 );
        llSay ( PUBLIC_CHANNEL, "No longer listening.  Click again to tweet." );
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        llListenRemove ( ListenHandle );
        llSetTimerEvent ( 0 );
        llSay ( PUBLIC_CHANNEL, "Tweeting..." );
        MakePost ( message );
    }
    
    changed ( integer change )
    {
        if ( change & CHANGED_REGION_START )
        {
            MakePost ( "Pixel Planet just started up." );
        }
    }
    
    http_response ( key request_id, integer status, list metadata, string body )
    {
        if ( request_id != http_request_id )
        {
            return;
        }
 
        llSetText ( body, BLUE, OPAQUE );
    }
}
