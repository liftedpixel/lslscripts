// [LP] BLOCK WALL - BLOCKS DELETE BUTTON
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

integer BlockChannel = 10;

default
{
    touch_start(integer total_number)
    {
        llOwnerSay ( "Deleting blocks..." );
        llRegionSay ( BlockChannel, "BLOCKS DELETE" );
    }
}
