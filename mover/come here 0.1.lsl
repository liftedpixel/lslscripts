vector location;

default
{
    touch_start(integer x)
    {
        location = llGetPos();
        
        llRegionSay( 1, "come here" );
        llRegionSay( 2, (string)location );
    }
}
