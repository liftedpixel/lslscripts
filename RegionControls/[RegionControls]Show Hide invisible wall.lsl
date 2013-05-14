integer channel = 2234; // 0 listens in open chat
string name = "Wall changer"; // the name of the object or agent doing the talking
key id = NULL_KEY; // the UUID of the object doing the talking
string message = ""; // a particular message to listen for

default
{
    state_entry()
    {
        llListen( channel , name , id , message ); 
    }

    listen( integer channel, string name, key id, string message )
    {
        if ( message == "show" )
        {
            llSetAlpha(0.4, ALL_SIDES);
        }
        
        else if ( message == "hide" )
        {
            llSetAlpha(0.0, ALL_SIDES); 
        }
    }
}