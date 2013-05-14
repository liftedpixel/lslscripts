integer CHANNEL = 1234; // channel to say color on
string objectName = "Color changer"; // name of object

default
{
    state_entry()
    {
        // set the object name
        llSetObjectName( objectName ); 
    }
    
    touch_start(integer x)
    {
        // On touch, say the color of the object
        llRegionSay( CHANNEL, (string)llGetColor(0) );
    }
}