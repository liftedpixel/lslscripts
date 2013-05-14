vector color; // the region color
string scolor; // the database response, always returns a string

//// For SLDB ////
string url = "http://www.liftedpixel.net/sldb/pp_data.php";
string secret = "";
string separator = "|";     

key put_id;
key get_id;
key del_id;

GetData(key id, list fields, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=get&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator))+"&verbose="+(string)verbose;
    args += "&secret="+llEscapeURL(secret);
    get_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}
//// End For SLDB ////

default
{
    state_entry()
    {
        // Get the color right away
        GetData( llGetOwner(), [ "color" ], FALSE );
        
        // And then every 10 seconds after that
        llSetTimerEvent(10.0);
    }

    timer()
    {
        // Get the color from the database
        GetData( llGetOwner(), [ "color" ], FALSE );
    }
    
    http_response(key id, integer status, list metadata, string body)
    {
        if((id != put_id) && (id != get_id) && (id != del_id))
        {
            // If the key IDs don't match, ignore it
            return;
        }
        
        if(status != 200)
        {
            // On an error, set the body to the error
            body = "ERROR: CANNOT CONNECT TO SERVER";
        }
        
        // And spit out the information we got.
        //llOwnerSay(body);
        
        // Turn the string returned into a list
        list listData = llParseStringKeepNulls(body, ["|"], []);
        
        // Save the individual items
        scolor = llList2String(listData, 0);
        
        // Cast the string back to a vector
        color = (vector)scolor;
        
        // Set the color of the object
        llSetColor( color, ALL_SIDES );
    }
}