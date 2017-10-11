string anim ="hold";
list display = [];
vector color = ZERO_VECTOR;
default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        llStartAnimation(anim);
    }

    attach(key wearer)
    {
    if(wearer == NULL_KEY)
        {
          llStopAnimation(anim);
          llSetTimerEvent(0);
        }
        else
        {
         llRequestPermissions(wearer,PERMISSION_TRIGGER_ANIMATION);
        }
    }

    run_time_permissions(integer permissions)
    {
        if (PERMISSION_TRIGGER_ANIMATION & permissions)
        {
        llStartAnimation(anim);
        llSetTimerEvent(15);
        }
    }
   timer()
   {
        llStartAnimation(anim);
   }

   link_message(integer l, integer n, string m, key k)
   {
       if (l == LINK_ROOT) {
       //llOwnerSay("l :" + (string)l + " n: " + (string)n + " m: " + m + " k: " + (string)k);
       display = display + (string)k;
        if ((string)k == "INIT") { display = []; }
       if (llGetListLength(display) > 8) {
           display = llDeleteSubList(display, 0, 0);
        }
       string text = llDumpList2String(display,"\n");
       text += "\n·\n·\n·\n·\n·\n·\n·\n·\n";
       if (llGetListLength(display) == 0) { text = ""; }
       if (m == "<0.00000, 0.00000, 0.00000>") { m = "<0.00000, 1.00000, 0.00000>"; }
       string temp = llGetSubString(m,1,-2);
       list vectorList = llParseString2List(temp, [", "],[""]);
       color.x = llList2Float(vectorList, 0);
       color.y = llList2Float(vectorList, 1);
       color.z = llList2Float(vectorList, 2);
       llSetColor(color, 0);
       llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, color, 1, 0.1, 0]);
       llSetText(text, color, 0.5);
       }
    }
}
