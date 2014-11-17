// Listen to open chat and repeat what was heard in open chat
// Not normally something you want to do, but this is a good script for setting up a simple listen

integer channel = 0; // 0 listens in open chat
string name = ""; // the name of the object or agent doing the talking
key id = NULL_KEY; // the UUID of the object doing the talking
string message = ""; // a particular message to listen for

default
{
    state_entry()
    {
        llListen( channel , name , id , message ); // start listening
    }

    listen( integer channel, string name, key id, string message )
    {
        llWhisper( 0, message ); // repeat what you heard on channel 0.
        // This does not cause a loop.  Objects are smarter than that, I suppose.
    }
}
