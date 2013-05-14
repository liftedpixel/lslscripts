// Listen 2234
// Repeats what's heard on the specified channel on the public channel
// Touch to toggle on and off

// What channel to listen on
integer channel = 0;

// Name to listen to
string name = "";

// Key to listen to
key id = NULL_KEY;

// Message to listen for
string message = "";

// Color of hovertext
vector green = <0,1,0>;
vector red = <1,0,0>;
 
// Alpha of hovertext
float alpha = 1.0;

default
{  
    state_entry()
    {
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
        // Repeast the heard message on the public channel
        llWhisper( PUBLIC_CHANNEL, name + " said " + message );
    }
    
    touch_start(integer x)
    {
        // When touched, switch to off state
        state off;
    }
}

state off
{
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