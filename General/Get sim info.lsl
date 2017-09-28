//OpenSim only script

string RegionName;
string GridName;
string GridURL;

string Hovertext;

vector BLUE = < 0.0, 0.5, 1.0 >;

refresh ()
{
    GridName = osGetGridName();
    GridURL = osGetGridGatekeeperURI();
    RegionName = llGetRegionName();

    Hovertext = "Location: " + GridName + "\n" + GridURL + ":" + RegionName;

    llSetText ( Hovertext, BLUE, 1.0 );
}

default
{
    touch_start ( integer num_detected )
    {
        refresh();
    }
}
