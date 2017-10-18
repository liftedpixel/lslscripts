//eventually a session timer

integer seconds;
vector color = <1,1,1>;
integer running;
integer channel = -122;
integer listenHandle;

listenOpen(integer theHandle) {
    theHandle = llListen(channel,"",llGetOwner(),"");
}

listenClose(integer theHandle) {
    llListenRemove(theHandle);
}

mainMenu() {
    list options = ["GO","STOP","SAY","ADJUST","RESET"];
    string message = "Current seconds: " + (string)seconds + "\nRunning: " + (string)running;
    llDialog(llGetOwner(),message,options,channel);
}

adjustMenu() {
    list options = ["+1","+5","+10","+30","-1","-5","-10","-30","CLEAR","MAIN"];
    string message = "Current seconds: " + (string)seconds + "\nRunning: " + (string)running + "\nSelect how many minutes to add/remove.";
    llDialog(llGetOwner(),message,options,channel);
}

default {
    state_entry() {
        llSetText("Seconds: " + (string)seconds, color, 0.5);
    }

    touch_start(integer t) {
        if (llDetectedKey(0) == llGetOwner()) { listenOpen(listenHandle); mainMenu(); }
        else { llInstantMessage(llDetectedKey(0), "Owner only."); }
    }

    listen(integer c, string n, key k, string m) {
        if (m == "MAIN") { mainMenu(); }
        if (m == "GO") { llOwnerSay("Hello there!"); }
        if (m == "STOP") { llOwnerSay("Hello there!"); }
        if (m == "SAY") { llOwnerSay("Hello there!"); }
        if (m == "ADJUST") { adjustMenu(); }
        if (m == "RESET") { llResetScript(); }

        if (m == "+1") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "+5") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "+10") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "+30") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "-1") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "-5") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "-10") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "-30") { llOwnerSay("Hello there!"); adjustMenu(); }
        if (m == "CLEAR") { seconds = 0; adjustMenu(); }
    }
}
