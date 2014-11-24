<?php
include "connect.php";

$sqlCommand = "SELECT * FROM ppurls";
$query = mysqli_query($connect, $sqlCommand) or die (mysqli_error());

while ($row = mysqli_fetch_assoc($query))
{
    // Get the info
    $id = $row['id'];
	$url = $row['url'];
	$objectuuid = $row['objectuuid'];
	$timestamp = $row['created'];
	
    // Spit out the results
	echo "<div class='well well-sm'>";
	echo "<h3>Object Name: x</h3><p>Entry ID: $id</p><p>ObjectUUID: $objectuuid</p><p>URL: <a href='http://os.liftedpixel.net:9000/lslhttp/$url/'>$url</a></p><p>Created: $timestamp</p>";
	echo "<form action='deleteppurl.php' method='post' class='form-inline' role='form'><input name='id' type='hidden' value='$id'><input name='password' type='text' class='form-control input-sm' placeholder='Password'> <input type='submit' value='Delete' class='btn btn-sm btn-danger'></form>";
	echo "</div>";

} // close while statement
?>
