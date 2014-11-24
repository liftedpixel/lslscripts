<?php

$url = $_GET["url"];
$objectuuid = $_GET["objectuuid"];
$PASS = $_GET["PASS"];

$thePASS = "xxxxx";

include "connectwrite.php";

if ( $PASS == $thePASS )
{
	$query = "INSERT INTO ppurls ( url, objectuuid ) VALUES ( '$url', '$objectuuid' )";
	
	if ( !mysqli_query( $connect, $query ) )
    {
        die( 'Error: ' . mysqli_error( $connect ) );
    }
	
	echo "URL added...";
}

else 
{
    echo "Password incorrect...";
}
?>
