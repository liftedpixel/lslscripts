string url = "http://location.of/your/script.php";
string secret = "xxxxx";
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

default
{
    touch_start(integer x)
    {
        // Get the parcel name, description, and owner
        list details = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME, PARCEL_DETAILS_DESC, PARCEL_DETAILS_OWNER, PARCEL_DETAILS_ID]);
        
        // Get the parcel UUID
        string parcelUUID = llList2String(details, 3);
        llSay(0, "Parcel UUID: " + parcelUUID);
        
        // Get the gatekeeper URI
        string gatekeeperURI = osGetGridGatekeeperURI();
        gatekeeperURI = llDeleteSubString(gatekeeperURI, 0, 6);
        llSay(0, "Gatekeeper URI: " + gatekeeperURI);
        
        // Get the region name
        string regionName = llGetRegionName();
        llSay(0, "Region Name:" + regionName);
        
        // Get the region location
        vector locationMeters = llGetRegionCorner();
        string regionLocation = (string)llRound(locationMeters.x / 256) + ", " + (string)llRound(locationMeters.y / 256);
        llSay(0, "Region Location: " + regionLocation);
        
        // Get the parcel name
        string parcelName = llList2String(details, 0);
        llSay(0, "Parcel Name:" + parcelName);
        
        // Get the parcel description
        string parcelDescription = llList2String(details, 1);
        llSay(0, "Parcel Desc:" + parcelDescription);
        
        // Get the parcel owner
        string parcelOwner = llKey2Name(llList2String(details, 2));
        llSay(0, "Parcel Owner:" + parcelOwner);
        
        // Write the data
        PutData(parcelUUID,["gatekeeperURI","regionName","regionLocation","parcelName","parcelDescription","parcelOwner"],[gatekeeperURI,regionName,regionLocation,parcelName,parcelDescription,parcelOwner],TRUE);  
    }
    
    http_response(key id, integer status, list metadata, string body)
    {
        if((id != put_id) && (id != get_id) && (id != del_id)) return;
        
        if(status != 200) body = "ERROR: CANNOT CONNECT TO SERVER";
        
        llOwnerSay(body);
    }
}
