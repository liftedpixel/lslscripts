// ELEVATOR SEAT REZZER
// JESSYKA RICHARD / JESSICA PIXEL
// LIFTEDPIXEL.NET 2014

string SeatName = "ELEVATOR SEAT";

default
{
    touch_end ( integer total_number )
    {
        llSay ( PUBLIC_CHANNEL, "REZZING " + SeatName + "..." );
        llRezObject ( SeatName, llGetPos() + < 0.0, 0.0, 1.0 >, < 0.0, 0.0, 0.0 >, < 0.0, 0.0, 0.0, 1.0 >, 0 );
    }
}
