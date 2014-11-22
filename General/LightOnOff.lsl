vector WHITE = < 1.0, 1.0, 1.0 >;
float Intensity = 1.0;
float Radius = 10.0;
float Falloff = 0.75;

list LightOff;
list LightOn;

integer IsLightOn;

default
{
    state_entry ()
    {
        LightOff = [ PRIM_FULLBRIGHT, ALL_SIDES, FALSE, PRIM_POINT_LIGHT, FALSE, WHITE, 0, 0, 0 ];
        LightOn = [ PRIM_FULLBRIGHT, ALL_SIDES, TRUE, PRIM_POINT_LIGHT, TRUE, WHITE, Intensity, Radius, Falloff ];

        IsLightOn = FALSE;
        llSetPrimitiveParams ( LightOff );
    }
    
    touch_start ( integer x )
    {
        if ( IsLightOn == FALSE )
        {
            llSetPrimitiveParams ( LightOn );
            IsLightOn = TRUE;
        }
        
        else if ( IsLightOn == TRUE )
        {
            llSetPrimitiveParams ( LightOff );
            IsLightOn = FALSE;
        }
    }
}
