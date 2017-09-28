//A lightbus sniffer for NS units
//Jessyka Richard - Jessica Pixel
//9/2017

integer channelLightBus;
integer listenLightBus;
vector color;
integer running = FALSE;

hoverText(string input) {
    llSetText(input, color, 1.0);
}

messageColor(string input) {
    //from SitAnywhere Flicker
    list rgb = llParseString2List(input, [" "], []);
    color = <llList2Float(rgb, 0), llList2Float(rgb, 1), llList2Float(rgb, 2)>;
    //hoverText("New color: " + (string)color);
}

messagePersona(string input) {
    if (input == "") {
        hoverText("Changing persona...");
    } else {
        hoverText("Current persona: " + input);
    }
}

messagePower(string input) {
    float powerFloat = (float)input * 100;
    integer powerInt = (integer)powerFloat;
    hoverText("Current power: " + (string)powerInt + "%");
}

messagePoke(string input) {
    hoverText("Poked object: " + input);
}

messageBolts(string input) {
    if (input == "off") {
        hoverText("Bolts: unlocked");
    } else {
        hoverText("Bolts: locked");
    }
}

processCommand(string input) {
    string command = llGetSubString(input, 0, llSubStringIndex(input, " ") - 1);
    string params = llGetSubString(input, llSubStringIndex(input, " ") + 1, -1);
    //hoverText("Heard: " + command);
    //hoverText("Heard: " + params);
    if (command == "color") { messageColor(params); }
    if (command == "power") { messagePower(params); }
    if (command == "persona") { messagePersona(params); }
    if (command == "persona-eject") { messagePersona(""); }
    //if (command == "poke") { messagePoke(params); }
    if (command == "bolts") { messageBolts(params); }
}

default {
    state_entry() {
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
