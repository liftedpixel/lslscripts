//Note: this code was adapted from someone.
// added option to play the first animation in inventory
// if there isn't one, you'll just 'turn180' like normal

key mkLoungingAgentKey = NULL_KEY;
integer miPermissionsAcquired = FALSE;

string animation; // What animation to play

default
{
    touch_end(integer x)
    {
        llResetScript();
    }
    
    state_entry()
    {
        animation = llGetInventoryName( INVENTORY_ANIMATION, 0 ); // get the first animation in the object
        
        if ( animation == "" )
        {
            llSay( PUBLIC_CHANNEL, "Insert animation." );
        }
        
        else 
        {
            llSay( PUBLIC_CHANNEL, "Animation: " + animation );
        }
        
        //overriden sit target
        //lower them a bit
        vector vLoungeTarget = <0.00, 0.00, 1.50>;
        
        rotation rX;
        rotation rY;
        rotation rZ;
        rotation r;
        
        //build rotations
        //Note: this is broken out like this to simplify the
        //        process of finding the correct sit angle.  I 
        //        use the following form until I have the rotation 
        //        that I want perfect, and then I simply 
        //        hardcode the perfected quaterion and remove   
        //        this mess.
        //
        rX = llAxisAngle2Rot( <1,0,0>, 0 * DEG_TO_RAD);         //cartwheel
        rY = llAxisAngle2Rot( <0,1,0>, 0 * DEG_TO_RAD);       //sumersault
        rZ = llAxisAngle2Rot( <0,0,1>, 0 * DEG_TO_RAD);       //turn in place
        
        //combine rotations
        r = rX * rY * rZ;
        
        //override 'sit' on pie menu
        llSetSitText( "Stand" );

        //override default sit target and rotation on prim
        llSitTarget( vLoungeTarget, r );
    }
    
    changed(integer change) 
    {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if ( mkLoungingAgentKey == NULL_KEY && agent != NULL_KEY ) 
            {

                //changed user
                //cache new user key and request their permissions
                mkLoungingAgentKey = agent;
                 llRequestPermissions(mkLoungingAgentKey,PERMISSION_TRIGGER_ANIMATION);
            }
            else if ( mkLoungingAgentKey != NULL_KEY && agent == NULL_KEY) 
            {
                
                //user is getting up
                if ( miPermissionsAcquired ) 
                {
                    
                    //restore anims
                    llStopAnimation("turn_180");
                               
                }
                
                //reset the script to release permissions
                llResetScript();
            }
        }        
    }
    
    run_time_permissions(integer parm) 
    {
        if(parm == PERMISSION_TRIGGER_ANIMATION) 
        {
            
            //set permission flag
            miPermissionsAcquired = TRUE;
            
            //cancel the sit anim
            llStopAnimation("sit");
            
            if ( animation == "" )
            {
                // if there is no animation, default to turn_180
                llStartAnimation("turn_180");
            }
            
            else
            {
                // otherwise play the first animation in the inventory
                llStartAnimation( animation );
            }
        }
    }    
}