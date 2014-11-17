vector color; 

RandomColor()
{
    color = (<llFrand(1), llFrand(1), llFrand(1)>);
}

default
{
    on_rez(integer start_param)
    {
        RandomColor();
        llSetColor(color, ALL_SIDES);
    }
    
    state_entry()
    {
        RandomColor();
        llSetColor(color, ALL_SIDES);
    }
}
