vector moveTo;

//// Good ole warpPos ////
// http://lslwiki.net/lslwiki/wakka.php?wakka=LibraryWarpPos

warp(vector pos)
{
    list rules;
    integer num = llCeil(llVecDist(llGetPos(),pos)/10);
    // while(num--)rules=(rules=[])+rules+[PRIM_POSITION,pos]; // this helps with memory in Second Life?
    while(num--)rules=rules+[PRIM_POSITION,pos]; // but gives a warning in Open Sim, so I changed it
    llSetPrimitiveParams(rules);
}
//// End Good ole warpPos ////

default
{
    state_entry()
    {
        llListen( 1, "", NULL_KEY, "come here" );
        llListen( 2, "", NULL_KEY, "" );
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if ( channel == 1 )
        {
            llOwnerSay ( "heard you" );
        }
        
        if ( channel == 2 )
        {
            moveTo = (vector)message;
            llOwnerSay ( "moving to " + (string)moveTo );
            //warp( moveTo ); // incase we want to move further than 10m :[
            
            llMoveToTarget( moveTo, 0.05 ); //Movement
            llSleep(0.25); //Prevents you from flying.
            llStopMoveToTarget(); //Stops the movement
        }
    }
}
