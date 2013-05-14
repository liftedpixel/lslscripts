key requestid; // just to check if we're getting the result we've asked for; all scripts in the same object get the same replies

default
{
    touch_start(integer number)
    {
        requestid = llHTTPRequest("http://liftedpixel.net/sldb/test_remote.php", 
            [HTTP_METHOD, "POST",
             HTTP_MIMETYPE, "application/x-www-form-urlencoded"],
            "parameter1=something&parameter2=anotherthing");
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == requestid)
            llWhisper(0, "Web server said: " + body);
    }
}