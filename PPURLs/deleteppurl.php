<?php

$id = $_POST["id"];
$pass = $_POST["password"];

$thePASS = "xxxxxx";

include "connectwrite.php";

if ( $pass == $thePASS )
{
	$query = "DELETE FROM ppurls WHERE id = $id";
	
	if ( !mysqli_query( $connect, $query ) )
    {
        die( 'Error: ' . mysqli_error( $connect ) );
    }
	
	echo "URL deleted.";
}

else 
{
    echo "Password incorrect.";
}

echo "<br>Returning in a few seconds...";
sleep (5);
?>
<script>
window.location = "http://liftedpixel.net/pixelplanet/displayppurl.php";
</script>
