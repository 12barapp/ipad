<?php

require_once 'inc/User.php';
$response = '{}';


if (isset($_REQUEST['secret_key'])){
    $user = new User($_REQUEST['secret_key'], $_REQUEST['user_id']);
    
    if ($user->isValid == TRUE){
         $response = array("status"=>"failed",
            'message'=>'Unrecognized method'); 
         $res = $user->getUserData($_REQUEST["user_id"], $_REQUEST['last_created_date_chart'], $_REQUEST['last_updated_date_chart'], $_REQUEST['last_created_date_set'], $_REQUEST['last_updated_date_set']);
         
         if ($res != FALSE){
         $response = array("status"=>"ok",
             "response_code"=>"8",
             "query"=>($res['query']),
             "data"=>($res['data']),
             "latest_created_chart"=>$res['latest_created_chart'],
             "last_updated_chart"=>$res['last_updated_chart'],
             "latest_created_set"=>$res['latest_created_set'],
             "last_updated_set"=>$res['last_updated_set']);
         } else {
             $response = array("status"=>"ok","response_code"=>6,"reason"=>"no data");
         }
         
    } else {
        $response = array("status"=>"failed",
        "reason"=>"badly formed request: secret is wrong");
    }
} else {
    
}
echo json_encode($response);

