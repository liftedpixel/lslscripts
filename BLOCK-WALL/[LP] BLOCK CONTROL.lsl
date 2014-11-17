// [LP] BLOCK WALL - BLOCK CONTROL
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

warpPos( vector destpos ) 
 {   //R&D by Keknehv Psaltery, 05/25/2006
     //with a little poking by Strife, and a bit more
     //some more munging by Talarus Luan
     //Final cleanup by Keknehv Psaltery
     //Changed jump value to 411 (4096 ceiling) by Jesse Barnett
     // Compute the number of jumps necessary
     integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 10.0) + 1;
     // Try and avoid stack/heap collisions
     if (jumps > 411)
         jumps = 411;
     list rules = [ PRIM_POSITION, destpos ];  //The start for the rules list
     integer count = 1;
     while ( ( count = count << 1 ) < jumps)
         rules = (rules=[]) + rules + rules;   //should tighten memory use.
     llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
     if ( llVecDist( llGetPos(), destpos ) > .001 ) //Failsafe
         while ( --jumps ) 
             llSetPos( destpos );
 }

integer ListenChannel = 10;
vector POS;
rotation ROT;

default
{
    on_rez ( integer start_param )
    {
        vector COLOR = < llFrand ( 1.0 ), llFrand ( 1.0 ), llFrand ( 1.0 ) >;
        
        llSetColor ( COLOR, ALL_SIDES );
        llSetPrimitiveParams ( [ PRIM_PHYSICS, FALSE ] );
        llListen ( ListenChannel, "", NULL_KEY, "" );
        POS = llGetPos();
        ROT = llGetRot();
    }
    
    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "BLOCKS SET" )
        {
            POS = llGetPos();
            ROT = llGetRot();
        }
        
        else if ( message == "BLOCKS RESET" )
        {
            llSetPrimitiveParams ( [ PRIM_PHYSICS, FALSE ] );
            llSleep ( 1.0 );
            warpPos ( POS );
            llSetRot ( ROT );
            llSleep ( 5.0 );
            llSetPrimitiveParams ( [ PRIM_PHYSICS, TRUE ] );
        }
        
        else if ( message == "BLOCKS DELETE" )
        {
            //llSay ( PUBLIC_CHANNEL, "I'd be dying now..." );
            llDie();
        }
    }
}
