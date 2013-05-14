float time = 60.0; // How often to check status

// Some colors for later
vector GREEN = <0,1,0>;
vector RED = <1,0,0>;

// The UUID and name of the object owner
key UUID;
string name;

//// For SLDB ////
string url = "http://www.liftedpixel.net/sldb/pp_data.php";
string secret = "";
string separator = "|";     

key put_id;
key get_id;
key del_id;

PutData(key id, list fields, list values, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=put&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator));
    args += "&values="+llEscapeURL(llDumpList2String(values,separator));
    args += "&secret="+llEscapeURL(secret);
    put_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}
//// End For SLDB ////

default 
{
    state_entry()
    {
        llWhisper ( PUBLIC_CHANNEL, "Starting up..." );
        
        // Start the update timer
        llSetTimerEvent( time );
        
        // Get the UUID and name of the object owner
        UUID = llGetOwner();
        name = llKey2Name( UUID );
        
        // Change the object name
        llSetObjectName( name + "'s Online Status" );
        
        // Check online status now
        llRequestAgentData( UUID , DATA_ONLINE );
    }
    
    timer()
    {
        // Check online status
        llRequestAgentData( UUID , DATA_ONLINE );
    }
    
    dataserver(key queryid, string data) 
    {
        if ( data == "1" ) // If they're online
        {
            llSetColor( GREEN , ALL_SIDES ); // Set the object color to green
            llSetText( name + "\nis Online", GREEN, 1 ); // Set the hover text
            PutData( UUID, ["status"], ["online"], TRUE ); // Write status to database
        }
        
        if ( data == "0" ) // If they're offline
        {
            llSetColor( RED , ALL_SIDES ); // Set the object color to red
            llSetText( name + "\nis Offline", RED, 1 ); // Set the hover text
            PutData( UUID, ["status"], ["offline"], TRUE ); // Write status to database
        }
    }
    
    http_response(key id, integer status, list metadata, string body)
    {
        // If the keys don't match, ignore
        if((id != put_id) && (id != get_id) && (id != del_id)) return;
        
        if( status != 200 ) // If there is an error
        {
            llWhisper( PUBLIC_CHANNEL , "Error writing status." );
        }
        
        if ( status == 200 ) // If everything is fine
        {
            //llWhisper( PUBLIC_CHANNEL , "Status written." );
        }
        
        // llOwnerSay(body);
    }
}