// ELEVATOR SEAT
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014

integer ChatChannel = 122;
integer ChatHandle;

list Locations;
key Touched;

vector WarpLocation;

WarpPos( vector destpos ) 
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
 
default
{
    state_entry ( )
    {
        llSitTarget ( < 0.0, 0.0, 0.1 >, ZERO_ROTATION );
        ChatHandle = llListen ( ChatChannel, "", NULL_KEY, "" );
    }

    touch_start ( integer num_detected )
    {
          Touched = llDetectedKey ( 0 );
          llRegionSay ( ChatChannel, "LOCATIONS" );
          llSay ( PUBLIC_CHANNEL, "GETTING AVAILABLE LOCATIONS..." );
          llSetTimerEvent ( 1.0 );
    }

    changed ( integer change )
    {
                if ( ( change & CHANGED_LINK ) && ( llAvatarOnSitTarget ( ) != NULL_KEY ) )
                {
                        Touched = llAvatarOnSitTarget ( );
                        llRegionSay ( ChatChannel, "LOCATIONS" );
                        llSay ( PUBLIC_CHANNEL, "GETTING AVAILABLE LOCATIONS..." );
                        llSetTimerEvent ( 1.0 );
                }

                else if ( ( change & CHANGED_LINK ) && ( llAvatarOnSitTarget () == NULL_KEY ) )
                {
                        llSay ( PUBLIC_CHANNEL, "DYING..." );
                        llSay ( PUBLIC_CHANNEL, "GOODBYE." );
                        llDie ( );
                } 
    }

    listen ( integer channel, string name, key id, string message )
    {
        if ( message == "COME HERE" )
        {
            list ElevatorInfo = llGetObjectDetails ( id, [ OBJECT_POS, OBJECT_DESC ] );

            string HeardPOS = (string)llList2String ( ElevatorInfo, 0 );
            string HeardDesc = llList2String ( ElevatorInfo, 1 );

            WarpLocation = (vector)HeardPOS;

            llSay ( PUBLIC_CHANNEL, "MOVING TO " + HeardDesc + "..." );
            WarpPos ( WarpLocation );
                return;
        }
          
          if ( id == Touched )
          {
                llRegionSay ( ChatChannel, message );
                return;
          }

        if ( message != "COME HERE" && message != "LOCATIONS" )
        {
            if ( llListFindList ( Locations, [ message ] ) == -1 )
            {
                Locations = Locations + [ message ] ;
            }
                return;
        }

          return;
    }

    timer ( )
    {
        llSetTimerEvent ( 0.0 );
        llDialog ( Touched, "TRAVEL TO WHICH LOCATION?", Locations, ChatChannel );
    }
}
