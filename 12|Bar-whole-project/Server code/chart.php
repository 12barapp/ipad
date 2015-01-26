<?php

require_once 'inc/User.php';

$response = '{}';
if (isset($_REQUEST['secret_key'])){
    
    $method = $_SERVER['REQUEST_METHOD'];
    
    $user = new User($_REQUEST['secret_key'], $_REQUEST['user_id']);
    
    if ($user->isValid == TRUE){
        $response = array("status"=>"failed",
            'message'=>'Unrecognized method');        
        switch ($method) {
            case "GET":  
                   $data = $user->getChartWithId($_REQUEST['chord_id']);                   
                   if ($data != FALSE) {
                    $response = array("status" => "ok",
                        "data" => array("result" => json_decode($data)),
                        "last_updated_time" => $user->query_last_updated_time);
                    } else {
                        $response = array("status" => "failed",
                            "reason" => "badly formed request: no data found");
                    }
                break;
            case "PUT":
                break;
            case "POST":
                if ($_REQUEST['method'] == "update"){
                    $updateRes = $user->updateChart($_REQUEST['chord_id'], $_REQUEST['data'], $_REQUEST['user_id']);
                    if ($updateRes != FALSE)
                        $response = array("status"=>"ok", "reason"=>"Chart was updated", "response_code"=>16, "last_updated_chart"=>$updateRes['last_updated_time'],"last_updated_set"=>$updateRes['last_updated_set']);
                        
                    else
                        $response = array("status"=>"failed", "reason"=>"failed to updated chart");
                } 
                if ($_REQUEST['method'] == "add") {
                     $res = $user->addNewChart($_REQUEST['data'], $_REQUEST['user_id'], $_REQUEST['chart_id']);
                     $response = array("status"=>"ok", "data"=>$res['old_data'],"chord_id"=> $res['chartId'], "response_code"=>14,"serverId"=>$res['serverId'],"last_updated_chart"=>$res['last_updated_time'], "latest_created_chart"=>$res['last_created']);               
                } 
                if ($_REQUEST['method'] == "into") {
                     $res = $user->addChartToSet($_REQUEST['chord_id'], $_REQUEST['setId'], $_REQUEST['data'] ,$_REQUEST['user_id']);
                     $response = array("status"=>"ok", "response_code"=>17,"last_updated_set"=>$res['last_updated_time']);               
                } 
                if ($_REQUEST['method'] == "insideSet") {
                    $res = $user->addChartToSetWithData($_REQUEST['chord_id'], $_REQUEST['setId'], $_REQUEST['data']);
                    $response = array("status"=>"ok", "response_code"=>17,"last_updated_set"=>$res['last_updated_time'], "data"=>$res['old_data'],"chord_id"=> $res['chartId'], "response_code"=>14,"serverId"=>$res['serverId'],"last_updated_chart"=>$res['last_updated_time'], "latest_created_chart"=>$res['last_created']);
                }
                if ($_REQUEST['method'] == "removeFromSet"){
                    $res = $user->removeChartFromSet($_REQUEST['chord_id'], $_REQUEST['setId']);
                    if ($res == TRUE){
                    $response = array("status"=>"ok");
                    } else {
                        $response = array("status"=>"failed");
                    }
                } 
                if ($_REQUEST['method'] == "removeForUser"){
                    $res = $user->removeChartForUser($_REQUEST['chord_id'], $_REQUEST['user_id']);
                    if ($res == TRUE){
                         $response = array("status"=>"ok");
                    } else {
                        $response = array("status"=>"failed");
                    }
                }
                if ($_REQUEST['method'] == "remove"){
                    $res = $user->removeChart($_REQUEST['chord_id']);
                    if ($res == TRUE){
                        $response = array("status"=>"ok");
                    } else {
                        $response = array("status"=>"failed");
                    }
                }
                if ($_REQUEST['method'] == "share"){
                    $user->shareChartWithUsers($_REQUEST['chord_id'], explode(",",$_REQUEST['friend_id']));
                    $response = array("status"=>"ok");
                }
                
                if ($_REQUEST['method']== "acceptChart") {
                    $user->acceptChart($_REQUEST['user_id'], $_REQUEST['chartId']);
                    $response = array("status"=>"ok");
                }
                
                if ($_REQUEST['method'] == "declineChart") { 
                    $user->declineChart($_REQUEST['user_id'], $_REQUEST['chartId']);
                    $response = array("status"=>"ok","reason"=>"Chart declined");
                }
               
                break;
            case "DELETE":
               
                break;
            case "PATCH":
          
                break;
            case "OPTIONS":
                break;
            default:
                break;
        }
    } else {
        $response = array("status"=>"failed",
        "reason"=>"badly formed request: secret is wrong");
    }
} else {
    $response = array("status"=>"failed",
        "reason"=>"badly formed request");
}
echo json_encode($response);
    