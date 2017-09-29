//this will eventually get worked into something larger

integer masterLightBus;
integer slaveLightBus;
key ownerKey;

integer getChannel(key UUID) {
    masterLightBus = -1 - (integer)("0x" + llGetSubString(UUID, -7, -1))+106;
    return masterLightBus;
}

init() {
    ownerKey = llGetOwner();
    getChannel(ownerKey);
    //llOwnerSay("Channel: " + (string)channelLightBus);
    llListen(masterLightBus+1, "", NULL_KEY, "");
}

integer scanRange = 1000;
scan() {
    llSensor("", NULL_KEY, AGENT, scanRange, PI);
}

list avatarList = [];
list keyList = [];
selectMenu(list avatars) {
    string text = "[" + (string)llGetListLength(avatars) + "] avatars detected.";
    text += "\nScan range: " + (string)scanRange + "m";
    llDialog(ownerKey, text, avatars, masterLightBus+1);
}

string unitName = "";
key getUUID(string name) {
    unitName = name;
    integer x = llListFindList(avatarList, [name]);
    return llList2String(keyList, x);
}

permission(key UUID) {
    llOwnerSay("Asking " + unitName + " for permission.");
    slaveLightBus = -1 - (integer)("0x" + llGetSubString((string)UUID, -7, -1))+106;
    llListen(slaveLightBus, "", NULL_KEY, "");
    llSay(slaveLightBus, "auth scanner " + (string)ownerKey);
}

getPort(string UUID) {
    if (UUID = "") { llSay(slaveLightBus, "port-connect data-1"); }
    else { llSay(slaveLightBus, "port-connect " + UUID); }
}

connect(string UUID) {
    llOwnerSay("Port UUID: " + UUID);
    particles(UUID);
}

disconnect() {
    llSay(slaveLightBus, "remove scanner");
    particles((string)ownerKey);
}

list options = ["CONNECT","DISCONNECT"];
optionsMenu() {
    llDialog(ownerKey, "Options Menu", options, masterLightBus+1);
}

particles(string UUID) {
    llParticleSystem([
        PSYS_PART_FLAGS, 0
            | PSYS_PART_FOLLOW_VELOCITY_MASK
            | PSYS_PART_INTERP_COLOR_MASK
            | PSYS_PART_TARGET_POS_MASK
            | PSYS_PART_RIBBON_MASK,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
        PSYS_PART_START_COLOR, <1,1,1>,
        PSYS_PART_END_COLOR, <1,1,1>,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 1.0,
        PSYS_PART_START_SCALE, <0.04, 0.04, 0>,
        PSYS_SRC_TEXTURE, TEXTURE_BLANK,
        PSYS_SRC_TARGET_KEY, (key)UUID,
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_PART_MAX_AGE, 10.0,
        PSYS_SRC_BURST_RATE, 0.0,
        PSYS_SRC_BURST_PART_COUNT, 10
    ]);
}

default
{
    state_entry()
    {
        init();
        scan();
    }

    listen(integer c, string n, key k, string m) {
        if (c == masterLightBus+1) {
            if (m == "DISCONNECT") { disconnect(); }
            else {
                key UUID = getUUID(m);
                llOwnerSay("UUID: " + (string)UUID);
                permission(UUID);
            }
        }
        //04d7d605-a379-408a-ad81-1933a54af844
        if (c == slaveLightBus) {
            llOwnerSay(m);
            if (m == "accept " + (string)ownerKey) { llOwnerSay("Connection approved."); getPort(""); }
            if (llGetSubString(m, 0, 8) == "port-real") {
                string portUUID = llGetSubString(m, 10, -1);
                llOwnerSay(portUUID);
                connect(portUUID);
            }
            else if (llGetSubString(m, 0, 3) == "port") {
                string UUID = llGetSubString(m, -36, -1);
                llOwnerSay(UUID);
                getPort(UUID);
            }
        }
    }

    sensor(integer d)
    {
        integer x = 0;
        while (x < d) {
            avatarList += llDetectedName(x);
            keyList += llDetectedKey(x);
            x++;
        }
        selectMenu(avatarList);
    }

    no_sensor()
    {
        list x = [];
        selectMenu(x);
    }
}
