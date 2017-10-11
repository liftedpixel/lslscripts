key ownerKey;
integer ownerLightBus;
integer listenOLB;

list unitList;
list keyList;

key unitKey;
string unitName = "none";
vector unitColor;
float unitRate;
float unitFan;
float unitTemp;
string unitPersona = "n/a";
integer unitLightBus;
integer listenULB;

integer getChannel(key UUID) {
    return -1-(integer)("0x" + llGetSubString(UUID, -7, -1))+106;
}

init() {
    updateText("INIT");
    llParticleSystem([]);
    ownerKey = llGetOwner();
    ownerLightBus = getChannel(ownerKey);
    listenOLB = llListen(ownerLightBus+1, "", NULL_KEY, "");
    llListenControl(listenOLB, FALSE);
    updateText("Ready!");
}

updateText(string message) {
    //llMessageLinked(LINK_ALL_OTHERS, 122, message, (string)unitColor);
    llMessageLinked(LINK_ALL_OTHERS, 122, (string)unitColor, message);
}

scan(float range) {
    llSensor("", NULL_KEY, AGENT, range, PI);
}

key getUUID(string name) {
    unitName = name;
    integer x = llListFindList(unitList, [name]);
    return llList2String(keyList, x);
}

permission(key UUID) {
    llOwnerSay("Asking " + unitName + " for permission.");
    unitLightBus = -1-(integer)("0x" + llGetSubString((string)UUID, -7, -1))+106;
    llListen(unitLightBus, "", NULL_KEY, "");
    llSay(unitLightBus, "auth scanner " + (string)ownerKey);
}

getPort(key UUID) {
    llSay(unitLightBus, "color-q");
    llSay(unitLightBus, "persona-q");
    if (UUID == NULL_KEY) {
        //llOwnerSay("sending [port-connect data-1]");
        llSay(unitLightBus, "port-connect data-1"); }
    else {
        //llOwnerSay("sending [port-connect " + (string)UUID + "]");
        llSay(unitLightBus, "port-connect " + (string)UUID); }
}

connect(key UUID) {
    updateText("Unit: " + unitName);
    particles(UUID);
    mainMenu(ownerKey);
}

disconnect() {
    busSpam = FALSE;
    llParticleSystem([]);
    unitName = "none";
    unitColor = <0,0,0>;
    unitPersona = "n/a";
    unitLightBus = -25432122;
    llListenControl(listenULB, FALSE);
    llOwnerSay("Disconnecting scanner.");
    llSay(unitLightBus, "remove scanner");
    updateText("Disconnected");
    mainMenu(ownerKey);
}

particles(key UUID) {
    llParticleSystem([
        PSYS_PART_FLAGS, 0
            | PSYS_PART_FOLLOW_VELOCITY_MASK
            | PSYS_PART_INTERP_COLOR_MASK
            | PSYS_PART_TARGET_POS_MASK
            | PSYS_PART_RIBBON_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
        PSYS_PART_START_COLOR, unitColor,
        PSYS_PART_END_COLOR, unitColor,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 1.0,
        PSYS_PART_START_SCALE, <0.04, 0.04, 0>,
        PSYS_SRC_TEXTURE, TEXTURE_BLANK,
        PSYS_SRC_TARGET_KEY, UUID,
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_PART_MAX_AGE, 10.0,
        PSYS_SRC_BURST_RATE, 0.0,
        PSYS_SRC_BURST_PART_COUNT, 1
    ]);
}

beep() { updateText("beep"); llWhisper(PUBLIC_CHANNEL, "beep"); }

mainMenu(key UUID) {
    llListenControl(listenOLB, TRUE);
    llSetTimerEvent(60);
    string x = "Spam: off";
    if (busSpam) { x = "Spam: on"; }
    llDialog(UUID, "Select an option.\nCurrent unit: " + unitName + "\n" + x, ["SCAN","SPAM","DISPLAY","DISCONNECT","TEST","CLEAR","RESET"], ownerLightBus+1);
}

selectMenu(key UUID) {
    llListenControl(listenOLB, TRUE);
    llSetTimerEvent(60);
    string text = "[" + (string)llGetListLength(unitList) + "] units detected.";
    updateText(text);
    llDialog(UUID, text, unitList, ownerLightBus+1);
}

disableListen() {
    llListenControl(listenOLB, FALSE);
    llSetTimerEvent(0);
}

integer busSpam = FALSE;
toggleSpam() {
    if (!busSpam) { busSpam = TRUE; updateText("Spam enabled..."); }
    else { busSpam = FALSE; updateText("Spam disabled."); }
}

processCommand(string input) {
    string command = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    string params = llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    //hoverText("Heard command: " + command);
    //hoverText("Heard params: " + params);
    if (command == "color") { messageColor(params); }
    if (command == "power") { messagePower(params); }
    if (command == "persona") { messagePersona(params); }
    //if (command == "persona-eject") { messagePersona(""); }
    //if (command == "poke") { messagePoke(params); }
    //if (command == "peek") { messagePeek(params); }
    //if (command == "bolts") { messageBolts(params); }
    //if (command == "charge") { messageCharge(params); }
    //if (command == "weather") { messageWeather(params); }
}

messageColor(string input) {
    list rgb = llParseString2List(input, [" "], []);
    unitColor = <llList2Float(rgb, 0), llList2Float(rgb, 1), llList2Float(rgb, 2)>;
}

messagePersona(string input) {
    if (input == "") {
        updateText("Updating persona...");
    } else {
        unitPersona = input;
        updateText("Persona: " + input);
    }
}

string power;
messagePower(string input) {
    float powerFloat = (float)input * 100;
    integer powerInt = (integer)powerFloat;
    power = (string)powerInt;
    //hoverText("Current power: " + (string)powerInt + "%");
}

messagePoke(string input) {
    updateText("Poke: " + input);
}

messagePeek(string input) {
    updateText("Peek: " + input);
}

messageBolts(string input) {
    if (input == "off") {
        updateText("Unit unlocked");
    } else {
        updateText("Unit locked");
    }
}

messageCharge(string input) {
    if (input == "start") {
        updateText("Charge: started");
    } else {
        updateText("Charge: ended");
    }
}

messageWeather(string input) {
    string weather = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    integer temp = (integer)llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    updateText("Weather: " + weather + "\nTemp: " + (string)temp + "C");
}

clearScreen() {
    updateText("INIT");
    mainMenu(ownerKey);
}

displayVitals() {
    updateText(unitName + " : " + unitPersona);
    updateText("unit make and model");
    updateText("unlocked permissions?");
    updateText("power voltage status");
    updateText("power settings");
    updateText("integrity etc temp");
    updateText("vox filters");
    updateText("network, motors, ftl, audio, mind, video");
    mainMenu(ownerKey);
}

default
{
    state_entry() { init(); }

    listen(integer c, string n, key k, string m) {
        if (c == ownerLightBus+1) {
            disableListen();
            if (m == "SCAN") { updateText("Scanning for units..."); scan(20);  }
            else if (m == "DISCONNECT") { updateText("Disconnecting..."); disconnect(); mainMenu(ownerKey); }
            else if (m == "TEST") { beep(); }
            else if (m == "CLEAR") { clearScreen(); }
            else if (m == "RESET") { llResetScript(); }
            else if (m == "OK") { mainMenu(ownerKey); }
            else if (m == "SPAM") { toggleSpam(); mainMenu(ownerKey); }
            else if (m == "DISPLAY") { displayVitals(); mainMenu(ownerKey); }
            else {
                key UUID = getUUID(m);
                permission(UUID);
            }
        }
        if (c == unitLightBus) {
            if (busSpam == TRUE) { llOwnerSay(unitName + " LB: " + m); updateText(m); }
            if (m == "accept " + (string)ownerKey) { llOwnerSay("Connection approved."); llSay(unitLightBus, "add scanner"); getPort(NULL_KEY); }
            else if (m == "add-confirm") { llOwnerSay("Device added.");  }
            else if (m == "add-fail") { llOwnerSay("Connection failed."); }
            else if (m == "remove-confirm") { llOwnerSay("Disconnect successful."); }
            else if (m == "remove-fail") { llOwnerSay("Unable to remove."); }
            else if (llGetSubString(m, 0, 8) == "port-real") {
                key portUUID = (key)llGetSubString(m, 17, -1);
                connect(portUUID);
            }
            else if (llGetSubString(m, 0, 3) == "port") {
                key UUID = (key)llGetSubString(m, -36, -1);
                llOwnerSay("Port forward to: " + (string)UUID);
                getPort(UUID);
            }
             else { processCommand(m); }
        }
    }

    sensor(integer d)
    {
        unitList = [];
        keyList = [];
        integer x = 0;
        while (x < d) {
            unitList += llDetectedName(x);
            keyList += llDetectedKey(x);
            x++;
        }
        selectMenu(ownerKey);
    }

    no_sensor()
    {
        selectMenu(ownerKey);
    }

    touch_end(integer d) {
        mainMenu(ownerKey);
    }

    timer() {
        disableListen();
    }
}
