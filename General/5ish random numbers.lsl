integer channel = PUBLIC_CHANNEL;
string message;

integer randomInteger()
{
    float randomFloat = llFrand(1.0);
    return llCeil(randomFloat * 100000);
}

default
{
    touch_start(integer x)
    {
        message = (string)randomInteger();

        llSay( channel , message );
        llSetObjectDesc( message );
    }
}
