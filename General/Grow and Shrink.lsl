//a shape that slowly grows
//click it to make it shrink down a bit

vector MaxSize = < 5.0, 5.0, 5.0 >;
vector MinSize = < 0.1, 0.1, 0.1 >;
vector Gap = < 0.1, 0.1, 0.1 >;
vector Factor = < 3.0, 3.0, 3.0 >;
integer Timer = 5;

float MinGlow = 0.0;
float MaxGlow = 1.0;
float GlowGap = 0.02;
float GlowFactor = 4;

Grow ()
{
    vector CurrentSize = llGetScale ();
    vector NewSize = CurrentSize + Gap;

    if ( NewSize.x > MaxSize.x )
    {
        //llWhisper ( PUBLIC_CHANNEL, "MaxSize reached..." );
        NewSize = MaxSize;
    }

    list GetParams = llGetPrimitiveParams ( [ PRIM_GLOW, 0 ] );
    float CurrentGlow = llList2Float ( GetParams, 0 );
    float NewGlow = CurrentGlow + GlowGap;

    if ( NewGlow > MaxGlow )
    {
        //llWhisper ( PUBLIC_CHANNEL, "MaxGlow reached..." );
        NewGlow = MaxGlow;
    }

    llSetPrimitiveParams ( [ PRIM_GLOW, ALL_SIDES, NewGlow, PRIM_SIZE, NewSize ] );
}

Shrink ()
{
    vector CurrentSize = llGetScale ();
    vector NewSize;
    NewSize.x = CurrentSize.x - ( Gap.x * Factor.x );
    NewSize.y = CurrentSize.y - ( Gap.y * Factor.y );
    NewSize.z = CurrentSize.z - ( Gap.z * Factor.z );

    if ( NewSize.x < MinSize.x )
    {
        //llWhisper ( PUBLIC_CHANNEL, "MinSize reached..." );
        NewSize = MinSize;
    }

    list GetParams = llGetPrimitiveParams ( [ PRIM_GLOW, 0 ] );
    float CurrentGlow = llList2Float ( GetParams, 0 );
    float NewGlow = CurrentGlow - ( GlowGap * GlowFactor );

    if ( NewGlow < MinGlow )
    {
        //llWhisper ( PUBLIC_CHANNEL, "MinGlow reached..." );
        NewGlow = MinGlow;
    }

    llSetPrimitiveParams ( [ PRIM_GLOW, ALL_SIDES, NewGlow, PRIM_SIZE, NewSize ] );
}

default
{
    state_entry()
    {
        llSetPrimitiveParams ( [ PRIM_GLOW, ALL_SIDES, MinGlow, PRIM_SIZE, MinSize ] );
        llSetTimerEvent ( Timer );
    }

    touch_start ( integer num_detected )
    {
        //llWhisper ( PUBLIC_CHANNEL, "Shrinking..." );
        Shrink ();
    }

    timer ()
    {
        //llWhisper ( PUBLIC_CHANNEL, "Growing..." );
        Grow ();
    }
}
