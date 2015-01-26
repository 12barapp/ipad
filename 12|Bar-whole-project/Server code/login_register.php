<?php
require_once 'inc/User.php';
$response = '{}';


if (isset($_REQUEST['key'])){    
       $user =  new User($_REQUEST['secret_key'], $_REQUEST['key'], TRUE, $_REQUEST['name']);
       if ($user->isValid == TRUE){
           $response = array("status"=>"ok","response_code"=>1,"secret_key"=>$user->getGeneratedSecretKey(), "user_id"=>$user->myId);
       } else {
           // can't restore user with secret key
           $response = array("status"=>"ok",
               "response_code"=>2, 
               "secret_key"=>  $user->getGeneratedSecretKey(),
               "user_id"=>$user->myId);                         
        }
    
} else {
    $response = array("status"=>"failed","reason"=>"badly formated request");
}
echo json_encode($response);
