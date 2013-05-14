integer CHANNEL = 8654;
string COMMAND = "please die";

default
{
    state_entry()
    {
        llListen( 8654, "", NULL_KEY, "" );
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ( llToLower(message) == llToLower(COMMAND) )
        {
            llSay( PUBLIC_CHANNEL, "Cleaning up " + llGetObjectName() + " [" + llGetKey() + "]." );
            llDie();
        }
    }
}