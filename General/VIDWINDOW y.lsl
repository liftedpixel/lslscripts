string Sound = "Beep";
string YouTube = "http://www.y";
string YouTubeS = "https://www.y";

doAlign(integer w, integer h, integer face)
{
    // compute scale factors based on next bigger power of 2
    integer div;
    div = 2;
    while (div < w) div*=2;    
    float scale_s = (float)w / div;
    div = 2;
    while (div < h) div*=2;
    float scale_t = (float)h / div;
 
    // compute offset from scale
    float offset_u = -(1.0 - scale_s) / 2.0;
    float offset_v = -(1.0 - scale_t) / 2.0;
 
    // do the "Align":   
    llOffsetTexture(offset_u, offset_v, face);
    llScaleTexture(scale_s, scale_t, face);
}

vector WHITE = < 1.0, 1.0, 1.0 >;
vector BLACK = ZERO_VECTOR;

default
{
    on_rez(integer start_param)
    {
        llSetPrimitiveParams([
        PRIM_COLOR, ALL_SIDES, BLACK, 1,
        PRIM_SIZE, < 0.2, 0.2, 0.2 > ]
        );
        
        llResetScript();
    }
    
    state_entry ()
    {
        llSay ( PUBLIC_CHANNEL, "VIDWINDOW LOADING..." );
        
        
        llSleep ( 1.0 );
        
        llPlaySound( Sound, 1.0 );
        llSetPrimitiveParams([
        PRIM_COLOR, ALL_SIDES, WHITE, 1,
        PRIM_SIZE, < 0.5, 3.0, 3.0 > ]
        );
            
        integer face = 2;
        integer w = 800;
        integer h = 600;
        string url = llGetObjectName();
        
        llSay ( PUBLIC_CHANNEL, "url: " + url );
        
        string YTCheck = llGetSubString ( url, 0, 12 );
        llSay ( PUBLIC_CHANNEL, "YTCheck: " + YTCheck );
        
        if ( llGetSubString ( url, 0, 11 ) == YouTube || llGetSubString ( url, 0, 12 ) == YouTubeS )
        {
            string YT = llDeleteSubString( url, 0, 31 );
            url = "http://www.youtube.com/watch_popup?v=" + YT;
            llSay ( PUBLIC_CHANNEL, "YT: " + url );
        }
        
        llSetPrimMediaParams(face, [
        PRIM_MEDIA_CURRENT_URL, url,
        PRIM_MEDIA_AUTO_SCALE, FALSE,
        PRIM_MEDIA_AUTO_PLAY, TRUE,
        PRIM_MEDIA_WIDTH_PIXELS, w,
        PRIM_MEDIA_HEIGHT_PIXELS, h
        ]);
        
        doAlign ( 800, 600, face );
        
        llSay ( PUBLIC_CHANNEL, "CLICK TO REFRESH" );
    }
}
