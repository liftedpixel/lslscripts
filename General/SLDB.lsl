//// For SLDB ////
string url = "http://www.liftedpixel.net/sldb/pp_data.php"; // Location of PHP script
string secret = ""; // Minimal security

string separator = "|"; // for between values

// for the http_request
key put_id;
key get_id;
key del_id;

// Write to the database
PutData(key id, list fields, list values, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=put&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator));
    args += "&values="+llEscapeURL(llDumpList2String(values,separator));
    args += "&secret="+llEscapeURL(secret);
    put_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}

// Read from the database
GetData(key id, list fields, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=get&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator))+"&verbose="+(string)verbose;
    args += "&secret="+llEscapeURL(secret);
    get_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}

// Delete from the database
DelData(key id, list fields, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=del&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator))+"&verbose="+(string)verbose;
    args += "&secret="+llEscapeURL(secret);
    del_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}
//// End For SLDB ////

default
{
    touch_start(integer total_number)
    {
        //Everything must be formatted to a string
        //PutData(llGetOwner(),["name","size","location"],[name,sSize,sLocation],TRUE); 
        //GetData(llGetOwner(),["name","size","location"],FALSE);
        //DelData(llGetOwner(),["ALL_DATA"],TRUE);
        
    }
    
    http_response(key id, integer status, list metadata, string body)
    {
        if((id != put_id) && (id != get_id) && (id != del_id))
        {
            // If the keys didn't match, ignore
            return;
        }

        if(status != 200)
        {
            // If an error, say so
            body = "ERROR: CANNOT CONNECT TO SERVER";
        }
        
        // Say the returned message
        llOwnerSay(body);
        
        // Write the returned info to a list
        list listData = llParseStringKeepNulls(body, ["|"], []);
        
        // Save the values to variables
        string name = llList2String(listData, 0);
        string size = (string)llList2String(listData, 1);
        string location = (string)llList2String(listData, 2);
        
        // Return the info
        llOwnerSay("-----");
        llOwnerSay("Name:" + name);
        llOwnerSay("Size:" + size);
        llOwnerSay("Location:" + location);
    }
}
