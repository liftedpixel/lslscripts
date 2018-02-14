//idk jessica pixel / jessyka richard put these functions together in the right order to make this online status checker
//it reads UUIDs and whatever name you want to use from a notecard like this:
// UUID1
// name1
// UUID2
// *name2
//if the name starts with * it will show up in the alt color
//create two objects of the same size and link them on top of each other overlapping
//put script and notecard in objects

vector altColor = <0,0.7,1>;

list keys;
list names;
list status;

integer name;

key oQ;
integer x;

key ncQ;
string ncN = "units";
integer ncL;
list ncC;

integer time;
start() {
    llSetTimerEvent(1.0);
    keys = [];
    names = [];
    status = [];
    name = FALSE;
    ncC = [];
    ncL = 0;
    ncQ = llGetNotecardLine(ncN, ncL);
}

next() {
    name = !name;
    ++ncL;
    ncQ = llGetNotecardLine(ncN, ncL);
}

checkOnline() {
        if (x > llGetListLength(keys)) { displayStatus(); }
        else {
                oQ = llRequestAgentData(llList2Key(keys,x),DATA_ONLINE);
        }
}

displayStatus() {
        string text = "Units Online\n----------\n";
        string red = "\n\n";
        integer n;
        for (n = 0; n < llGetListLength(status)-1; n++) {
                if (llList2Integer(status,n) == TRUE) {
                    if (llGetSubString(llList2String(names,n),0,0) == "*") {
                        text += " \n";
                        red += llGetSubString(llList2String(names,n),1,-1) + "\n";
                    } else {
                        text += llList2String(names,n) + "\n";
                        red += " \n";
                    }
                }
        }
        llSetText(text, <1,1,1>, 1.0);
        llSetLinkPrimitiveParamsFast(LINK_ALL_OTHERS, [PRIM_TEXT, red, altColor, 1.0]);
}

default {
        state_entry() {
                start();
        }

        touch_end(integer n) {
                start();
        }

        dataserver(key q, string d) {
                if (q == ncQ) {
                        if (d == EOF) {
                                x = 0;
                                checkOnline();
                        }
                        else if (!name) { keys += (key)d; next(); }
                        else { names += d; next(); }
                }
                if (q == oQ) {
                        status = llListInsertList(status, [d], x);
                        ++x;
                        checkOnline();
                }
        }
        
        changed(integer c) {
            if (c && CHANGED_INVENTORY) { start(); }
        }
        
        timer() {
            ++time;
            if (time%300 == 0) { start(); }
        }
}
