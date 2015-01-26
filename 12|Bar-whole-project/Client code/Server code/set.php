<?php

require_once 'inc/User.php';

$response = '{}';
if (isset($_REQUEST['secret_key'])){
    $method = $_SERVER['REQUEST_METHOD'];   
    $user = new User($_REQUEST['secret_key'], $_REQUEST['user_id']);
    if ($user->isValid == TRUE){
        switch ($method) {
            case "POST":
                if ($_REQUEST['method'] == "add"){ 
                    $res = $user->addNewset($_REQUEST['data'], $_REQUEST['user_id'], $_REQUEST['setId']);                    
                    $response = array("status"=>"ok", "response_code"=>15,"setId"=>$res['setId'],"server_id"=>$res['serverId'],"last_updated_set"=>$res['last_updated_time'], "latest_created_set"=>$res['last_create_time']);                
                } 
                if ($_REQUEST['method'] == "update"){ 
                    $res = $user->updateSetWithId($_REQUEST['setId'], $_REQUEST['data']);
                    if ($res != FALSE) {
                        $response = array("status"=>"ok","response_code"=>17, "last_updated_set"=>$res['last_updated_set']);
                    } else {
                        $response = array("status"=>"failed");
                    }
                }
                if ($_REQUEST['method'] == "remove"){ 
                    $user->removeSet($_REQUEST['setId']);
                    $response = array("status"=>"ok");
                }
                 if ($_REQUEST['method'] == "share"){ 
                    $user->shareSetWithUsers($_REQUEST['setId'], explode(",",$_REQUEST['friend_id']));
                    $response = array("status"=>"ok");
                }
                if ($_REQUEST['method'] == "removeSet"){ 
                    $user->removeSetForUser($_REQUEST['setId'], $_REQUEST['user_id']);
                    $response = array("status"=>"ok");
                }
                
                if ($_REQUEST['method'] == "acceptSet") {
                    $user->acceptSet($_REQUEST['user_id'], $_REQUEST['setId']);
                     $response = array("status"=>"ok","reason"=>"Set accepted");
                }
                
                if ($_REQUEST['method'] == "declineSet"){
                    $user->declineSet($_REQUEST['user_id'], $_REQUEST['setId']);
                }
                break;
            case "PUT":
                break;
            case "GET":
                $data = $user->getSetWithId($_REQUEST['setId']);
                if ($data != FALSE){
                    $response = array("status"=>"ok", "data"=>$data,"last_updated_time" => $user->query_last_updated_time);
                } else {
                    $response = array("status"=>"failed", "reason"=>"set not found");
                }
                break;
            
            default:
                break;
        }
    }
} else {
    $response = array("status"=>"failed",
        "reason"=>"badly formed request");
}
echo json_encode($response);

