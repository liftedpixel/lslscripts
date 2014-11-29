string emailAddress = "xxxxxxxxxx@vtext.com";
string emailHeader;
 
 
default
{
    state_entry ( )
    {
        llSetText ( "PING Jessica\nPlease click only once\nThis sends me a short SMS", <0,0,1>, 1 );
    }
     
    touch_start ( integer num_detected )
    {
        llSay ( PUBLIC_CHANNEL, "PINGing Jessica..." );
 
        key id = llDetectedKey ( 0 );
        string name = llDetectedName ( 0 );
        
        emailHeader = "PINGd by:" + name;
        
        llEmail ( emailAddress, emailHeader, "PING" );
 
        llSay ( PUBLIC_CHANNEL, "PING sent" );
    }
}
