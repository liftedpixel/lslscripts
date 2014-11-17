default
{
    touch_start ( integer num_detected )
    {
        llSay ( PUBLIC_CHANNEL, llGetKey() );
        llSay ( PUBLIC_CHANNEL, llGetObjectName() );
    }
}
