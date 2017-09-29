//A lightbus sniffer for NS units
//Jessyka Richard - Jessica Pixel
//9/2017

integer channelLightBus;
integer listenLightBus;
vector color;

hoverText(string input) {
    llSetText(input, color, 1.0);
}

messageColor(string input) {
    list rgb = llParseString2List(input, [" "], []);
    color = <llList2Float(rgb, 0), llList2Float(rgb, 1), llList2Float(rgb, 2)>;
    //hoverText("New color: " + (string)color);
}

messagePersona(string input) {
    if (input == "") {
        hoverText("Changing persona...");
    } else {
        hoverText("New persona: " + input);
    }
}

messagePower(string input) {
    float powerFloat = (float)input * 100;
    integer powerInt = (integer)powerFloat;
    hoverText("Current power: " + (string)powerInt + "%");
}

messagePoke(string input) {
    hoverText("Poke: " + input);
    llDialog((key)input, "Charger Menu", ["CABLE ", "CABLEOFF "], channelLightBus);
}

messageBolts(string input) {
    if (input == "off") {
        hoverText("Bolts: unlocked");
    } else {
        hoverText("Bolts: locked");
    }
}

messageCharge(string input) {
    if (input == "start") {
        hoverText("Charge: started");
    } else {
        hoverText("Charge: ended");
    }
}

getPort(string port) {
    llSay(channelLightBus, "port-connect " + port);
}

string cablePort;
string cableId;

connectCable(string input) {
    cablePort = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    //llOwnerSay("Port: " + cablePort);
    cableId = llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    //llOwnerSay("key: " + cableId);
    particles(cableId);
}

particles(string uuid) {
    llParticleSystem([
        PSYS_PART_FLAGS, 0
            | PSYS_PART_FOLLOW_VELOCITY_MASK
            | PSYS_PART_INTERP_COLOR_MASK
            | PSYS_PART_TARGET_POS_MASK
            | PSYS_PART_RIBBON_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
        PSYS_PART_START_COLOR, color,
        PSYS_PART_END_COLOR, color,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 1.0,
        PSYS_PART_START_SCALE, <0.04, 0.04, 0>,
        PSYS_SRC_TEXTURE, TEXTURE_BLANK,
        PSYS_SRC_TARGET_KEY, (key)uuid,
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_PART_MAX_AGE, 10.0,
        PSYS_SRC_BURST_RATE, 0.0,
        PSYS_SRC_BURST_PART_COUNT, 10
    ]);
}

disconnectCable(string input) {
    llParticleSystem([]);
    llSay(channelLightBus, "port-disconnect " + cablePort);
}

messageWeather(string input) {
    string weather = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    integer temp = (integer)llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    hoverText("Weather: " + weather + "\nTemp: " + (string)temp + "C");
}

processCommand(string input) {
    string command = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    string params = llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    //hoverText("Heard: " + command);
    //hoverText("Heard: " + params);
    if (command == "color") { messageColor(params); }
    if (command == "power") { messagePower(params); }
    if (command == "persona") { messagePersona(params); }
    if (command == "persona-eject") { messagePersona(""); }
    if (command == "poke") { messagePoke(params); }
    if (command == "bolts") { messageBolts(params); }
    if (command == "charge") { messageCharge(params); }
    if (command == "CABLE") { getPort("data-1"); }
    if (command == "port-real") { connectCable(params); }
    if (command == "CABLEOFF") {  disconnectCable(params); }
    if (command == "weather") { messageWeather(params); }
}

default {
    state_entry() {
        llParticleSystem([]);
        key ownerKey = llGetOwner();
        channelLightBus = -1 - (integer)("0x" + llGetSubString( (string) ownerKey, -7, -1) ) + 106;
        hoverText("Channel: " + (string)channelLightBus);
        listenLightBus = llListen(channelLightBus, "", NULL_KEY, "");
    }

    listen(integer c, string n, key k, string m) {
        if (c == channelLightBus) {
            //llOwnerSay(m);
            processCommand(m);
        }
    }
}
