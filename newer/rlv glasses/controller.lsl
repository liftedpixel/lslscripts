// RLV glasses

goDark() {
    //llOwnerSay("Muted vision.");
    //llOwnerSay("@camtextures:6c1a7986-22ef-4bc9-799d-cf1d6feef58d=n");
    llOwnerSay("@setenv_ambienti:.1=force");
    llOwnerSay("@setenv_bluedensityi:.1=force");
    llOwnerSay("@setenv_bluehorizoni:.1=force");
    llOwnerSay("@setenv_cloudcolori:.1=force");
    llOwnerSay("@setenv_cloudcoverage:.1=force");
    llOwnerSay("@setenv_sunmooncolori:.1=force");
    llOwnerSay("@setenv_scenegamma:.3=force");
    llOwnerSay("@showhovertextall=n");
    llOwnerSay("@showminimap=n");
    llOwnerSay("@showhovertexthud=n");
    llOwnerSay("@setenv=n");
    llOwnerSay("@setdebug_renderresolutiondivisor:4=force");
}

removeGlasses() {
    llSay(channel, "BYE");
    llSleep(1);
    llOwnerSay("@detach:nose=n");
}

string ambienti;
string bluedensityi;
string bluehorizoni;
string cloudcolori;
string cloudcoverage;
string sunmooncolori;
string scenegamma;

goLight() {
    //llOwnerSay("Normal vision.");
    llOwnerSay("@camtextures:6c1a7986-22ef-4bc9-799d-cf1d6feef58d=y");
    llOwnerSay("@setenv_ambienti:" + ambienti + "=force");
    llOwnerSay("@setenv_bluedensityi:" + bluedensityi + "=force");
    llOwnerSay("@setenv_bluehorizoni:" + bluehorizoni + "=force");
    llOwnerSay("@setenv_cloudcolori:" + cloudcolori + "=force");
    llOwnerSay("@setenv_cloudcoverage:" + cloudcoverage + "=force");
    llOwnerSay("@setenv_sunmooncolori:" + sunmooncolori + "=force");
    llOwnerSay("@setenv_scenegamma:" + scenegamma + "=force");
    llOwnerSay("@showhovertextall=y");
    llOwnerSay("@showminimap=y");
    llOwnerSay("@showhovertexthud=y");
    llOwnerSay("@setenv=y");
    llOwnerSay("@setdebug_renderresolutiondivisor:1=force");
}

integer count = 0;
getEnvSettings() {
    llOwnerSay("Getting current environment settings.");
    llOwnerSay("@getenv_ambienti=1");
    llOwnerSay("@getenv_bluedensity1=1");
    llOwnerSay("@getenv_bluehorizoni=1");
    llOwnerSay("@getenv_cloudcolori=1");
    llOwnerSay("@getenv_cloudcoverage=1");
    llOwnerSay("@getenv_sunmooncolori=1");
    llOwnerSay("@getenv_scenegamma=1");
}

key toucher;
integer channel = 9387;
integer counter = 0;
integer lockSeconds = 120;
default
{
    state_entry()
    {
        removeGlasses();
        llListen(channel,llGetObjectName(), llGetKey(), "");
        getEnvSettings();
        state notwearing;
    }

    listen(integer c, string n, key k, string m)
    {
        if (count = 0) {
            ambienti = m;
            count++;}
        else if (count = 1) {
            bluedensityi = m;
            count++;}
        else if (count = 2) {
            bluehorizoni = m;
            count++;}
        else if (count = 3) {
            cloudcolori = m;
            count++;}
        else if (count = 4) {
            cloudcoverage = m;
            count++;}
        else if (count = 5) {
            sunmooncolori = m;
            count++;}
        else if (count = 6) {
            scenegamma = m;
            count = 0;}
    }
}

state wearing
{
    state_entry()
    {
        llListen(channel,"",NULL_KEY,"");
        goLight();
    }

    touch_start(integer n)
    {
        toucher = llDetectedKey(0);
        llDialog(toucher,"Knock off my glasses?",["NO", "KNOCK OFF"],channel);
    }

    listen(integer c, string n, key k, string m)
    {
        if (m == "NO")
        {
            llInstantMessage(toucher, "Thank you for not knocking off my glasses.");
            llOwnerSay(llKey2Name(toucher) + " didn't knock them off.");
        }

        else if (m == "KNOCK OFF")
        {
            llInstantMessage(toucher, "You knocked them off and now I can't see well.");
            llOwnerSay(llKey2Name(toucher) + " knocked them off.");
            removeGlasses();
            state notwearing;
        }
    }
}

state notwearing
{
    state_entry()
    {
        goDark();
        llListen(channel,"",NULL_KEY,"");
        llSetTimerEvent(1);
    }

    listen(integer c, string n, key k, string m)
    {
        if (m == "HERE")
        {
            llOwnerSay("Glasses on.");
            state wearing;
        }
    }

    timer()
    {
        counter++;
        if (counter == lockSeconds)
        {
            llOwnerSay("@detach:nose=y");
            llOwnerSay("Glasses can now be replaced.");
            llListen(channel,"",NULL_KEY,"");
            counter = 0;
        }
        else if (counter % 5 == 0) { llOwnerSay("@setdebug_renderresolutiondivisor:4=force"); }
    }

    touch_start(integer n)
    {
        llInstantMessage(llDetectedKey(0),"My glasses are currently off.");
    }
}
