integer channel = 1234;

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
        llSetTimerEvent(60.0);
        UUID = llGetOwner(); // my UUID
    }
    
    timer()
    {
        vector color = < llFrand(1.0), llFrand(1.0), llFrand(1.0) >;
        string scolor = (string)color;
        llSetColor( color , ALL_SIDES );
        llRegionSay( channel, scolor );
        //llWhisper( PUBLIC_CHANNEL, "The color is now " + scolor );
        llSetText( " Color: " + scolor, color, 1.0 );
        PutData( UUID, ["color"], [ scolor ], TRUE ); // Write color to database
    }
    
    touch_start(integer x)
    {
        state off;
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
        
         //llOwnerSay(body);
    }
}

state off
{

    state_entry() 
    {
        llSetTimerEvent(0.0);
        llSetColor( <0,0,0> , ALL_SIDES );
        llSetText( "OFF", <0,0,0>, 1.0 );
    }
    
    touch_start(integer x)
    {
        state default;
    }
}
    
