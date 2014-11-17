// [LP] BLOCK WALL - CREATE WALL BUTTON
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

integer RezChannel = 20;
integer BlockChannel = 10;

default
{
    touch_start(integer total_number)
    {
        llOwnerSay ( "Deleting any existing blocks..." );
        llRegionSay ( BlockChannel, "BLOCKS DELETE" );
        llSleep ( 2.0 );
        llOwnerSay ( "Rezzing blocks..." );
        llRegionSay ( RezChannel, "REZ WALL" );
    }
}
