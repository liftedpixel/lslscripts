string emailAddress = "0000000000@vtext.com";

vector shelfLocation = <83.20608, 24.39412, 58.39062>;
vector shelfSize = <0.15, 0.15, 0.15>;
vector deskLocation = <82.62545, 21.64140, 58.84116>;
vector deskSize = <0.34, 0.34, 0.34>;
vector offlineLocation = <83.00000, 18.62920, 58.84116>;
vector offlineSize = <0.65, 0.65, 0.65>;

key assistKey;

integer chatChannel;
integer chatHandle;

integer getChannel() {
    return 0x80000000 | (integer)llFrand(65536) | ((integer)llFrand(65536) << 16);
}

vector getColor() {
    float a = llFrand(1.0);
    float b = llFrand(1.0);
    float c = llFrand(1.0);
    return <a, b, c>;
}

hoverText(string text) { llSetText(text, getColor(), 1.0); }

init() {
    hoverText("Starting up...");
    llTargetOmega(<0,0,1>, 1.0, 1.0);
    status = offline;
    assistKey = llGetOwner();
    counter = 0;
    llSetTextureAnim(ANIM_ON | SMOOTH | PING_PONG | LOOP, ALL_SIDES,1,1,0, TWO_PI, 0.1);
    llAllowInventoryDrop(TRUE);
    check(online);
    llSetTimerEvent(1.0);
}

float area = 10.0;
integer online = 1;
integer radar = 2;
integer mail = 3;
check(integer what) {
    if (what == online) { hoverText("Checking online status..."); llRequestAgentData(assistKey, DATA_ONLINE); }
    else if (what == radar) { hoverText("Looking for Jessica..."); llSensor("", assistKey, AGENT, area, PI); }
    else if (what == mail) { hoverText("Checking for reply..."); llGetNextEmail("", ""); }
}

integer shelf = 1;
integer desk = 2;
integer offline = 3;
move(integer where) {
    if (where == shelf) {
        llSetPos(shelfLocation);
        llSetScale(shelfSize);
        hoverText("Jessica is currently in office.");
    } else if (where == desk) {
        llSetPos(deskLocation);
        llSetScale(deskSize);
        hoverText("Jessica is online, but out of office.\n\nPlease click for options.");
    } else if (where == offline) {
        llSetPos(offlineLocation);
        llSetScale(offlineSize);
        hoverText("Jessica is offline.\n\nPlease click for options.");
    }
}

//      online = 1
integer away = 2;
//      offline = 3
integer status;

integer counter;

mainMenu(key toucher) {
    string dialog = "\n\nI'm currently out of the office, on another region, or offline. My normal office hours are\n2pm - 4pm SLT\nMonday through Friday.\n\nYOUR OPTIONS:\nINFO for additional information";
    list options = ["INFO"];
    if (status == away) { options += "PAGE"; dialog += "\nPAGE to ping me."; }
    if (status == offline) { options += "MESSAGE"; dialog += "\nMESSAGE to text me a short message."; }
    if (status == online) { llInstantMessage(toucher, "I'm currently in my office. Come speak with me directly."); }
    llDialog(toucher, dialog, options, chatChannel);
}

string cardName = "- Jessica Pixel -";
process(integer channel, string name, key uuid, string message) {
    if (uuid == assistKey && llToLower(message) == "clear page") {
        llListenRemove(assistListen);
        activePage = FALSE;
        hoverText("Page cleared.");
    }
    else if (message == "INFO") { llListenRemove(chatHandle); hoverText("Please accept the following notecard with my details:\n\n- Jessica Pixel -"); llGiveInventory(uuid, cardName); }
    else if (message == "PAGE") { page(name); }
    else if (message == "MESSAGE") { sendMessage(name, uuid); }
    else { emailMessage(name, message); }
}

integer activePage = FALSE;
integer assistListen;
page(string name) {
    if (!activePage) {
        llListenRemove(chatHandle);
        llInstantMessage(assistKey, "\nPAGE ALERT PAGE ALERT\n" + name + " is requesting you.\nPAGE ALERT PAGE ALERT");
        hoverText("Jessica has been paged...");
        activePage = TRUE;
        assistListen = llListen(PUBLIC_CHANNEL, "", assistKey, "");
    } else { llListenRemove(chatHandle); hoverText("Jessica has already been paged."); }
}

integer activeEmail = FALSE;
sendMessage(string name, key uuid) {
    if (activeEmail) { hoverText("A message has already been sent.\nPlease wait for a reply."); }
    else { llTextBox(uuid, "\n\nPlease enter a short message. The OoOsistant checks every few seconds for a reply, so stick around - I may answer.", chatChannel); }
}


emailMessage(string name, string message) {
    llListenRemove(chatHandle);
    hoverText("Sending message...");
    activeEmail = TRUE;
    string subject = message;
    string objectName = llGetObjectName();
    llSetObjectName(name);
    string body = "PING";
    llEmail(emailAddress, subject, body);
    llSetObjectName(objectName);
    hoverText("Message has been sent.");
}

default {
    state_entry() {
        init();
    }

    timer() {
        counter++;
        if (counter%300 == 0) { check(online); }
        if (activeEmail == TRUE && counter%10 == 0) { check(mail); }
    }
    
    email(string time, string address, string subj, string message, integer num_left)
    {
        activeEmail = FALSE;
        llWhisper(PUBLIC_CHANNEL, "Jessica says: " + message);
    }
    
    dataserver(key q, string d) {
        if ((integer)d == TRUE) { check(radar); }
        else if ((integer)d == FALSE) {
            status = offline;
            move(offline);
        }
    }
    
    sensor(integer d) {
        status = online;
        move(shelf);
    }
    
    no_sensor() {
        status = away;
        move(desk);
    }
    
    touch_end(integer d) {
        chatChannel = getChannel();
        chatHandle = llListen(chatChannel, "", NULL_KEY, "");
        mainMenu(llDetectedKey(0));
    }
    
    listen(integer c, string n, key k, string m) { process(c,n,k,m); }
}
