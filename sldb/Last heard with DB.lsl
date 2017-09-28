// Listen 2234 [withDB(w-d)]
// Repeats what's heard on the specified channel on the public channel
// Touch to toggle on and off

// The objects key
key objectKey;

// What channel to listen on
integer channel = 122;

// Name to listen to
string name = "";

// Key to listen to
key id = NULL_KEY;

// Message to listen for
string message = "";

// Making everything strings up in here
string schannel;
string sname;
string sid;
string smessage;

// Color of hovertext
vector green = <0,1,0>;
vector red = <1,0,0>;
 
// Alpha of hovertext
float alpha = 1.0;

//// For SLDB ////
string url = "http://location.of/your/script.php"; // Location of PHP script
string secret = "xxxxx"; // Minimal security

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
    on_rez( integer x)
    {
        // Reset on rez
        llResetScript();
    }
    
    state_entry()
    {
        // Get the UUID of the object.  This is used to identify the rows (tuples lol).
        objectKey = llGetKey();
        
        // Create the hovertext
        string hovertext = "Listening to channel\n+[" + (string)channel + "]+";
        
        // Set the hovertext
        llSetText( hovertext, green, alpha );
        
        // Start listening
        llListen( channel , name , id , message );
        
        // Whisper the hovertext message for good measure
        llWhisper( PUBLIC_CHANNEL, hovertext );
    }

    listen( integer channel, string name, key id, string message )
    {
        schannel = (string)channel;
        sname = name;
        sid = (string)id;
        smessage = message;
        
        // Repeat the heard message on the public channel
        llWhisper( PUBLIC_CHANNEL, name + " said " + message );
        
        // Write to the DB
        PutData( objectKey ,[ "id", "name", "message", "channel" ],[ sid, sname, smessage, schannel ],TRUE );
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
        
        /* Repeat all the info
        llWhisper( PUBLIC_CHANNEL, "Writing heard message from " + sname );
        llWhisper( PUBLIC_CHANNEL, "id:" + sid );
        llWhisper( PUBLIC_CHANNEL, "message:" + smessage );
        llWhisper( PUBLIC_CHANNEL, "channel:" + schannel );
        */
        
        // Say the returned message
        llWhisper( PUBLIC_CHANNEL, body );
    }
    
    touch_start(integer x)
    {
        // When touched, switch to off state
        state off;
    }
}

state off
{
    /* Is this one nessicary? I don't know... 5/10/13
    on_rez( integer x)
    {
        // Reset on rez
        llResetScript();
    }
    */
    
    state_entry()
    {
        // Create the hovertext
        string hovertext = "Not listening to channel\n+[" + (string)channel + "]+";
        
        // Set the hovertext
        llSetText( hovertext, red, alpha );
        
        // Whisper the hovertext message for good measure
        llWhisper( PUBLIC_CHANNEL, hovertext );
    }
    
    touch_start(integer x)
    {
        // When touched, switched to default state
        state default;
    }
}
