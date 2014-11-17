string URL;
float time = 1.0;
integer counter;

default
{
    state_entry()
    {
        llRequestURL();
        llSetTimerEvent ( time );
    }
    
    timer ()
    {
        counter = counter + 1;
        llSetText ( "Counter: " + (string)counter, <1,1,1>, 1 );
    }
    
    touch_start ( integer num_detected )
    {
        llSay ( PUBLIC_CHANNEL, "URL: " + URL );
        counter = 0;
    }
    
    http_request(key id, string method, string body)
    {
        if ( method == URL_REQUEST_GRANTED )
        {
            URL = body;
            
            llSay ( PUBLIC_CHANNEL, "URL: " + URL );
        }
        
        else if ( method == "GET" || method == "POST" )
        {
            llSetContentType ( id, CONTENT_TYPE_HTML );
            llHTTPResponse ( id, 200, (string)counter );
            llOwnerSay ( "PING" );
        }
    }
}
