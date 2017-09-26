integer channel = 9387;
default
{
    on_rez(integer p)
    {
        llSay(channel, "HERE");
        llListen(channel, "", NULL_KEY, "");
    }

    listen(integer c, string n, key k, string m)
    {
        if (m == "BYE")
        {
            key thekey = llGetOwner();
            llRequestPermissions(thekey,PERMISSION_ATTACH);
        }
    }

    run_time_permissions(integer perm) {
        if (perm & PERMISSION_ATTACH) {
            llDetachFromAvatar();
        }
    }
}
