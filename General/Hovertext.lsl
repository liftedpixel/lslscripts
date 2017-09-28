string message = "xxxxx"; // What text to set
vector color = < 0, 0, 1 >; // The text color
float alpha = 0.7; // How transparent the text is

default
{
    state_entry()
    {
        // Set the text
        llSetText( message , color , alpha );
    }
}
