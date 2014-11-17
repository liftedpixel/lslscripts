// [LP] BLOCK WALL - SET UP AND RESET BLOCKS
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014 8 8

integer BlockChannel = 10;

default
{
    touch_start(integer total_number)
    {
        llOwnerSay ( "Resetting wall..." );
        llRegionSay ( BlockChannel, "BLOCKS RESET" );
    }
}
