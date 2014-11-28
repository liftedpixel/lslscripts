string emailAddress = "email@email.email";
string emailHeader = "";
 
 
default
{
    state_entry()
    {
        llOwnerSay("My email address is: " + (string)llGetKey() + "@lsl.secondlife.com");
        //llSetTimerEvent(10.0);
    }
    
    timer()
    {
        //Check for emails
        llWhisper(PUBLIC_CHANNEL, "Checking for email...");
        llGetNextEmail("", "");
    }
 
    email(string time, string address, string subj, string message, integer num_left)
    {
          llOwnerSay("I got an email: " + subj + "\n" + message);
    }
     
    touch_start(integer num_detected)
    {
        llSay(PUBLIC_CHANNEL, "PINGing Jessyka...");
 
        key id = llDetectedKey(0);
        string name = llDetectedName(0);
        
        emailHeader = "PING:" + name;
        
        llEmail(emailAddress, emailHeader,
            "I was touched by: '" + name + "' (" + (string)id + ").");
 
        llSay(PUBLIC_CHANNEL, "PING sent");
    }
}
