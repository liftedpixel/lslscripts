<?php

// require codebird
require_once('codebird.php');
 
\Codebird\Codebird::setConsumerKey("xxxxx", "xxxxx");
$cb = \Codebird\Codebird::getInstance();
$cb->setToken("xxxxx", "xxxxx");
 
$message = $_GET['message'];
$password = $_GET['password'];

$thePassword = 'xxxxx';

if ( $password != $thePassword )
{
	die('Wrong password');
}

$params = array(
  'status' => $message
);
$reply = $cb->statuses_update($params);

echo "Posted to Twitter: " . $message;
?>
