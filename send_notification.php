<?php 
error_reporting(0);
date_default_timezone_set("Asia/Kuala_Lumpur");
	
//MySQL connection
$con = mysqli_connect("localhost", "root", "", "promas"); 
	
require 'vendor/autoload.php';

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use Kreait\Firebase\Messaging\AndroidConfig;

$factory = (new Factory)->withServiceAccount('firebase.json');

$messaging = $factory->createMessaging();

$title = $_POST['title'];
$body = $_POST['body'];
$sender = $_POST['sender'];
$time = date('Y-m-d H:i:s');
$token = 'c0ABQJ1VQTe0whSApymSdp:APA91bHorZP09jM-ir2xbSMaVTkDdDt7RfslGnygTlUczYvTUFY0tsnEhaPrLWIUSChcQygBk9YmSTy3U2yyRGl-Ff8PLF3u8Ou5yCQzSGFtaxjdaPNaAaJHE8i8aFMVNBwXj-LuPrnF';
$customSoundUrl = 'http://192.168.2.110/linxpetMobile/cat.mp3';

$sql = "INSERT INTO mobile_notification (title, body, sender, time) VALUES ('$title', '$body', '$sender', '$time')";
//$result = mysqli_query($con, $sql);

$notification = Notification::fromArray([
    'title' => $title,
    'body' => $body,
    //'image' => $imageUrl,
    
]);

$message = CloudMessage::withTarget('token', $token)
    ->withNotification($notification)
    ->withAndroidConfig(
        AndroidConfig::new()
            ->withSound("cat.mp3")
    );


$response = $messaging->send($message);
var_dump($response);
if (isset($response['results'][0]['error'])) {
    $error = $response['results'][0]['error'];
    echo "Failed to send notification to token: $error";
} else {
    echo "Notification sent successfully.";
}

?>
