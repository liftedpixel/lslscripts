string URL;
key HttpRequest;

WriteURL ( string TheURL )
{
    // Location of PHP script
    string ScriptAddress = "http://location.of/your/script.php";
    // Minimal security
    string PASS = "xxxxx";
    
    // We're gunna use get
    list Params = [ HTTP_METHOD, "GET" ];
    // Get just the UUID part of the URL
    string xURL = llGetSubString ( TheURL, -37, -2 );
    // Get the UUID of the object containing the script
    string objectuuid = llGetKey ();
    // Put the address together
    string Address = ScriptAddress + "?url=" + xURL + "&objectuuid=" + objectuuid + "&PASS=" + PASS;
    
    // Make the request
    HttpRequest = llHTTPRequest ( Address, Params, "" );
}

default
{
    touch_start ( integer num_detected )
    {
        llRequestURL ();
    }
    
    http_request ( key id, string method, string body )
    {
        if ( method == URL_REQUEST_GRANTED )
        {
            URL = body;
            llSay ( PUBLIC_CHANNEL, "My URL: " + URL );
            
            WriteURL ( URL );
        }
        
        else if ( method == "GET" )
        {
            llHTTPResponse ( id, 200, "Testing 123" );
        }
    }
    
    http_response ( key request_id, integer status, list metadata, string body )
    {
        if ( request_id == HttpRequest )
        {
            llSay ( PUBLIC_CHANNEL, body );
        }
    }
}
