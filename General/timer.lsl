// a timer, next to add is color fading

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

add(integer thisMuch) {
    seconds = seconds + thisMuch;
    llSetText("Seconds: " + (string)seconds, color, 0.5);
}

remove(integer thisMuch) {
    seconds = seconds - thisMuch;
    if (seconds < 0) { seconds = 0; }
    llSetText("Seconds: " + (string)seconds, color, 0.5);
}

mainMenu() {
    list options = ["GO","STOP","SAY","ADJUST","CLOSE","RESET"];
    string message = "Current mins: " + (string)(seconds/60) + "\nRunning: " + (string)running;
    llDialog(llGetOwner(),message,options,channel);
}

adjustMenu() {
    list options = ["+1","+5","+10","+30","-1","-5","-10","-30","CLEAR","MAIN"];
    string message = "Current mins: " + (string)(seconds/60) + "\nRunning: " + (string)running + "\nSelect how many minutes to add/remove.";
    llDialog(llGetOwner(),message,options,channel);
}

default {
    state_entry() {
        llSetText("Ready!", color, 0.5);
    }

    touch_start(integer t) {
        if (llDetectedKey(0) == llGetOwner()) { listenOpen(listenHandle); mainMenu(); }
        else { llInstantMessage(llDetectedKey(0), "Owner only."); }
    }

    listen(integer c, string n, key k, string m) {
        if (m == "MAIN") { mainMenu(); }
        if (m == "GO") { running = TRUE; llSetTimerEvent(1); llOwnerSay("running"); mainMenu(); }
        if (m == "STOP") { running = FALSE; llSetTimerEvent(0); llOwnerSay("pausing"); mainMenu(); }
        if (m == "SAY") { llWhisper(PUBLIC_CHANNEL, "Minutes remaining: " + (string)((float)(seconds)/60)); mainMenu(); }
        if (m == "ADJUST") { adjustMenu(); }
        if (m == "CLOSE") { listenClose(listenHandle); }
        if (m == "RESET") { llResetScript(); }

        if (m == "+1") { add(60); adjustMenu(); }
        if (m == "+5") { add(300); adjustMenu(); }
        if (m == "+10") { add(600); adjustMenu(); }
        if (m == "+30") { add(1800); adjustMenu(); }
        if (m == "-1") { remove(60); adjustMenu(); }
        if (m == "-5") { remove(300); adjustMenu(); }
        if (m == "-10") { remove(600); adjustMenu(); }
        if (m == "-30") { remove(1800); adjustMenu(); }
        if (m == "CLEAR") { seconds = 0; llSetText("Seconds: " + (string)seconds, color, 0.5); adjustMenu(); }
    }

    timer() {
        llSetText("Seconds: " + (string)seconds, color, 0.5);
        seconds--;
        if (seconds <= 0) { seconds = 0; llSetTimerEvent(0); llOwnerSay("time up"); }
    }
}
