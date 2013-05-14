integer channel = 2234;
string objectName = "Wall changer";

default
{
    state_entry()
    {
        llSetObjectName( objectName );
    }
    
    touch_start(integer x)
    {
        llRegionSay( channel , "hide" );
    }
}