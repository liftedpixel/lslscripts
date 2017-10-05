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
    //hoverText("Current power: " + (string)powerInt + "%");
}

messagePoke(string input) {
    hoverText("Poke: " + input);
}

messagePeek(string input) {
    hoverText("Peek: " + input);
}

messageBolts(string input) {
    if (input == "off") {
        hoverText("Unit unlocked");
    } else {
        hoverText("Unit locked");
    }
}

messageCharge(string input) {
    if (input == "start") {
        hoverText("Charge: started");
    } else {
        hoverText("Charge: ended");
    }
}

messageWeather(string input) {
    string weather = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    integer temp = (integer)llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    hoverText("Weather: " + weather + "\nTemp: " + (string)temp + "C");
}

processCommand(string input) {
    string command = llGetSubString(input, 0, llSubStringIndex(input, " ")-1);
    string params = llGetSubString(input, llSubStringIndex(input, " ")+1, -1);
    //hoverText("Heard command: " + command);
    //hoverText("Heard params: " + params);
    if (command == "color") { messageColor(params); }
    if (command == "power") { messagePower(params); }
    if (command == "persona") { messagePersona(params); }
    if (command == "persona-eject") { messagePersona(""); }
    if (command == "poke") { messagePoke(params); }
    if (command == "peek") { messagePeek(params); }
    if (command == "bolts") { messageBolts(params); }
    if (command == "charge") { messageCharge(params); }
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
