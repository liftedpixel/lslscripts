//A wireless charger for NS units
//Jessyka Richard - Jessica Pixel
//9/2017

//Particles via http://particles-lsl-generator.bashora.com/index.php
string Texture;
integer Interpolate_Scale;
vector Start_Scale;
vector End_Scale;
integer Interpolate_Colour;
vector Start_Colour;
vector End_Colour;
float Start_Alpha;
float End_Alpha;
integer Emissive;
float Age;
float Rate;
integer Count;
float Life;
integer Pattern;
float Radius;
float Begin_Angle;
float End_Angle;
vector Omega;
integer Follow_Source;
integer Follow_Velocity;
integer Wind;
integer Bounce;
float Minimum_Speed;
float Maximum_Speed;
vector Acceleration;
integer Target;
key Target_Key;
// BASIC FUNCTION ==============================
Particle_System ()
{
list Parameters =
[
PSYS_PART_FLAGS,
(
(Emissive * PSYS_PART_EMISSIVE_MASK) |
(Bounce * PSYS_PART_BOUNCE_MASK) |
(Interpolate_Colour * PSYS_PART_INTERP_COLOR_MASK) |
(Interpolate_Scale * PSYS_PART_INTERP_SCALE_MASK) |
(Wind * PSYS_PART_WIND_MASK) |
(Follow_Source * PSYS_PART_FOLLOW_SRC_MASK) |
(Follow_Velocity * PSYS_PART_FOLLOW_VELOCITY_MASK) |
(Target * PSYS_PART_TARGET_POS_MASK)
),
PSYS_PART_START_COLOR, Start_Colour,
PSYS_PART_END_COLOR, End_Colour,
PSYS_PART_START_ALPHA, Start_Alpha,
PSYS_PART_END_ALPHA, End_Alpha,
PSYS_PART_START_SCALE, Start_Scale,
PSYS_PART_END_SCALE, End_Scale,
PSYS_SRC_PATTERN, Pattern,
PSYS_SRC_BURST_PART_COUNT, Count,
PSYS_SRC_BURST_RATE, Rate,
PSYS_PART_MAX_AGE, Age,
PSYS_SRC_ACCEL, Acceleration,
PSYS_SRC_BURST_RADIUS, Radius,
PSYS_SRC_BURST_SPEED_MIN, Minimum_Speed,
PSYS_SRC_BURST_SPEED_MAX, Maximum_Speed,
PSYS_SRC_TARGET_KEY, Target_Key,
PSYS_SRC_ANGLE_BEGIN, Begin_Angle,
PSYS_SRC_ANGLE_END, End_Angle,
PSYS_SRC_OMEGA, Omega,
PSYS_SRC_MAX_AGE, Life,
PSYS_SRC_TEXTURE, Texture
];
llParticleSystem (Parameters);
}
// YOUR PARTICLES FUNCTION ==============================
MyParticle (){
Interpolate_Scale = TRUE;
Start_Scale = <0.1,0.1, 0>;
End_Scale = <0.01,0.01, 0>;
Interpolate_Colour = TRUE;
Start_Colour = < 0, 1, 1 >;
End_Colour = < 1, 0, 0 >;
Start_Alpha = 0.5;
End_Alpha =0.1;
Emissive = TRUE;
Age = 1;
Rate = 0.5;
Count = 3;
Life = 0;
Pattern = PSYS_SRC_PATTERN_EXPLODE;
Radius = 0;
Begin_Angle = 0;
End_Angle = 3.14159;
Omega = < 0, 0, 0 >;
Follow_Source = TRUE;
Follow_Velocity = FALSE;
Wind = FALSE;
Bounce = FALSE;
Minimum_Speed = 1;
Maximum_Speed = 1;
Acceleration = < 0, 0, 0 >;
Target = TRUE;
Target_Key =  llGetKey();

Particle_System ();
}
//==========================

turnOn(string message) {
    running = TRUE;
    llTargetOmega(<1,1,1>,2,1);
    MyParticle();
    llOwnerSay(message);
    llSetTimerEvent(FREQ);
}

turnOff(string message) {
    running = FALSE;
    llSetColor(<0.3,0.3,0.3>, ALL_SIDES);
    llSetText("disabled", <0.3,0.3,0.3>, 0.5);
    llTargetOmega(<0,0,0>,0,0);
    llParticleSystem([]);
    llOwnerSay(message);
    llSetTimerEvent(0);
}

float RATE = 20.0; // units to charge per hit
float FREQ = 1.0; // how often to charge!

key ownerKey;

integer x; //for flipping the charging flair
integer handleLightBus;
integer channelLightBus;

integer running = TRUE;
vector color;

default
{
    state_entry() {
        turnOff("Initializing...");
        ownerKey = llGetOwner();
        channelLightBus = -1 - (integer)("0x" + llGetSubString( (string) ownerKey, -7, -1) ) + 106;
        handleLightBus = llListen(channelLightBus, "", NULL_KEY, "");
        llSay(channelLightBus, "add charger");
    }

    listen(integer c, string n, key k, string m)
    {
        if (c == channelLightBus)
        {
            string toggleMessage = "command " + (string)ownerKey + " toggle";
            if (m == "probe") { llSay(channelLightBus, "add charger"); }
            else if (m == "add-confirm") { llSay(channelLightBus, "add-command toggle"); }
            else if (m == "charge start" || m == "off" ) { turnOff("Charge disabled."); }
            else if (m == "poke " + (string)llGetOwner()) { llDialog(llGetOwner(), "Charger Menu", ["CABLE"], channelLightBus); }
            else if (llGetSubString(m,0,9) == "power 0.99") { turnOff("Charge complete!"); }
            else if (llGetSubString(m,0,8) == "power 0.2") { turnOn("Low power. Charge enabled..."); }
            else if (m == toggleMessage) {
                if (running) { turnOff("Charge disabled.");}
                else { turnOn("Charge enabled..."); }
            }
            //from SitAnywhere Flicker
            else if (llGetSubString(m, 0, 5) == "color ") {
                list rgb = llParseString2List(llGetSubString(m, 6, -1), [" "], []);
                color = <llList2Float(rgb, 0), llList2Float(rgb, 1), llList2Float(rgb, 2)>;
                if (running) { llSetColor(color, ALL_SIDES); }
            }
        }
    }

    timer()
    {
        llRegionSayTo(ownerKey, -9999999, "charge " + (string)RATE);

        if (x == TRUE)
        {
            llSetText("⇉ charging ⇇", color, 1);
            x = FALSE;
        }
        else
        {
            llSetText("charging", color, 1);
            x = TRUE;
        }
    }

    changed(integer change) { if (change & CHANGED_OWNER) { llResetScript(); } }
}
