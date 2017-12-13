string objectName = "Jessica's OoOsistant";
string emailAddress = "0000000000@vtext.com";
string emailHeader = "";
integer listenHandle;
integer activePing = FALSE;
vector white = <1,1,1>;
vector black = <0,0,0>;
vector green = <0.2,1,0.2>;
vector blue = <0,0.7,1>;
vector red = <1,0,0>;
integer Notecards;

integer dialogChannel;

integer getChannel() {
    integer rand = 0x80000000 | (integer)llFrand(65536) | ((integer)llFrand(65536) << 16);
    return rand;
}

vector getColor() {
    float a = llFrand(1.0);
    float b = llFrand(1.0);
    float c = llFrand(1.0);
    return <a, b, c>;
}

defaultText(){ llSetText( llGetObjectDesc() + "\nDrag notecards or click to ping Jessica.\n Notecards: " + (string)Notecards, getColor(), 1.0 ); }

init(float emailCheckTime) {
    llSetObjectName(objectName);
    llSetTimerEvent(emailCheckTime);
    llOwnerSay("My email address is: " + (string)llGetKey() + "@lsl.secondlife.com");
    llAllowInventoryDrop(TRUE);
    defaultText();
}

ping() {
    if (!activePing) {
        activePing = TRUE;
        llSetText("Pinging Jessica...", getColor(), 1.0);
        listenHandle = llListen(PUBLIC_CHANNEL, "", llGetOwner(), "");
        key id = llDetectedKey(0);
        string name = llDetectedName(0);
        
        emailHeader = "PING:" + name;
        
        llEmail(emailAddress, emailHeader, name);
            
        llSetText("Jessica has been pinged.", getColor(), 1.0);
    }
    else {
        llSetText("Jessica has already been pinged.", getColor(), 1.0);
    }
}

message(string m) {
    llSetObjectName(m);
    ping();
    llSetObjectName(objectName);
}
checkEmail() {
    llSetText("Checking email...", getColor(), 1.0);
    llGetNextEmail("", "");
}

Up() { llSetPos ( llGetPos() + < 0, 0, 0.2 > ); }
Down() { llSetPos ( llGetPos() - < 0, 0, 0.2 > ); }
UpAndDown() {
 float x = 0.1;
 Up(); llSleep(x); Up(); llSleep(x); Up(); llSleep(x);
 Down(); llSleep(x); Down(); llSleep(x); Down();
}

default
{
    state_entry()
    {
        llOwnerSay("dialogchannel: " + (string)dialogChannel);
        init(7.0);
         llSetTextureAnim(ANIM_ON | SMOOTH | ROTATE | LOOP, ALL_SIDES,1,1,0, TWO_PI, 1);
    }
    
    timer()
    {
       //checkEmail();
       //UpAndDown();
    }
 
    email(string time, string address, string subj, string message, integer num_left)
    {
          llWhisper(PUBLIC_CHANNEL, "Jessica says: " + message);
    }
     
    touch_start(integer num_detected)
    {
        state offline;
    }
    
    listen(integer c, string n, key k, string m)
    {
        if (m == "clear ping") {
            activePing = FALSE;
            llSay(PUBLIC_CHANNEL, "Ping cleared.");
            defaultText();
        }
    }
    
    changed( integer mask )
    {
        if( mask & CHANGED_INVENTORY )
        {
            if (Notecards != llGetInventoryNumber(INVENTORY_NOTECARD)) {
            Notecards = llGetInventoryNumber(INVENTORY_NOTECARD);
            defaultText();
            llInstantMessage( llGetOwner(), "Someone left a notecard for you.  You currently have " + (string)Notecards );
        }
        }
    }
}

state offline {
    state_entry() {
        llSetText("Jessica Pixel is offline.\nClick for options.", getColor(), 1.0);
        dialogChannel = getChannel();
        llListen(dialogChannel, "", NULL_KEY, "");
        llListen(dialogChannel + 1, "", NULL_KEY, "");
    }
    
    touch_end(integer d) {
        llDialog(llDetectedKey(0), "Out of Office menu:\nPress INFO for a notecard with information on me, and using the Osistant.\nPress MESSAGE to send a message.\nPress PING to page me.\n\nYou may also drag a notecard inside.", ["INFO", "MESSAGE", "PING"], dialogChannel);
    }
    
    listen(integer c, string n, key k, string m) {
        if (m == "INFO") { llInstantMessage(k, "INFO pressed"); }
        else if (m == "PING") { ping(); }
        else if (m == "MESSAGE") { llTextBox(k, "Please enter a short message, maximum 62 characters.", dialogChannel + 1); }
        else { message(m); }
    }
}