integer channel = 1234; // The channel to listen on
string objectName = "Color changer"; // The name of the object doing the talking

default
{
    state_entry()
    {
        // Start listening on the channel for the object
        llListen( channel , objectName , NULL_KEY, "" ); 
    }

    listen( integer channel, string name, key id, string message )
    {
        // Set color to the heard vector
        llSetColor( (vector)message, ALL_SIDES );
    }
}