<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of user
 *
 * @author Alex
 */

require_once( $_SERVER['DOCUMENT_ROOT'] . '/app12Bar/bar_acp/wp-config.php' );
require_once( $_SERVER['DOCUMENT_ROOT'] . '/app12Bar/bar_acp/wp-includes/wp-db.php' );

 class User extends wpdb{    
     private $db;
     private $secret_key = "";
     var  $isValid = FALSE;
     var $myId = 0;
     var $query_last_updated_time = "";
     
     
             
     function User($secretKey, $userId, $authorization = FALSE, $userName = ""){
         $this->db = new wpdb( DB_USER, DB_PASSWORD, DB_NAME, DB_HOST);
         if ($authorization == FALSE){           
           $user_key = $this->db->get_results($this->db->prepare("select secret_key from vf_users where secret_key=%s and ID = %s",$secretKey,$userId));
           $this->isValid = count($user_key) > 0;
            if ($user_key[0]->secret_key == ""){
              $this->secret_key = md5(date('m/d/Y h:i:s a', time()).$userId);
              $this->db->query($this->db->prepare("update vf_users set secret_key=%s where facebook_ID=%s",  $this->secret_key, $userId));
            }
         } else {
           $user_key = $this->db->get_results($this->db->prepare("select secret_key, facebook_ID, ID from vf_users where  facebook_ID = %s",$userId));
          if ($user_key[0]->secret_key == ""){
              $this->secret_key = md5(date('m/d/Y h:i:s a', time()).$userId);
              $this->db->query($this->db->prepare("update vf_users set secret_key=%s where facebook_ID=%s",  $this->secret_key, $userId));
          }
           $this->isValid = count($user_key) > 0;                          
           if ($this->isValid == FALSE){
               $this->secret_key = md5(date('m/d/Y h:i:s a', time()).$userId);
               $this->db->query($this->db->prepare("insert into vf_users (`facebook_ID`, `secret_key`, `user_nicename`, `display_name`) values (%s, %s, %s, %s)",$userId, $this->secret_key, $userName, $userName));
               $this->myId = $this->db->insert_id;               
           } else {
               $this->secret_key = $user_key[0]->secret_key;
               $this->myId = $user_key[0]->ID;
           }
           
         }
         
     }
     
     function getGeneratedSecretKey(){
         return $this->secret_key;
     }
             
    function getChartWithId($chartId){
         $userChart = $this->db->get_results($this->db->prepare("select * from chords where id=%s OR chord_id=%s",$chartId,$chartId));
         if (count($userChart) > 0){
             $this->query_last_updated_time = $userChart[0]->query_last_updated_time;
             return stripslashes($userChart[0]->data);
         } else {
             return FALSE;
         }
     }
     
     function addNewChart($data, $userId, $chartId){
         $this->db->query($this->db->prepare("insert into chords set data=%s, chord_id=%s ,`last_updated_time`=NOW()",stripslashes($data), $chartId));         
         $last_updated_time = $this->db->get_var($this->db->prepare("select last_updated_time from chords where id=%s",$this->db->insert_id));
         $last_created_time = $this->db->get_var($this->db->prepare("select created from chords where id=%s",$this->db->insert_id));
         $result = array("old_data"=>$data, "serverId"=>  $this->db->insert_id,"chartId"=>$chartId, "last_updated_time"=>$last_updated_time, "last_created"=>$last_created_time);
         $this->db->query("insert into chord_owner  set `chord_id`='".$this->db->insert_id."' , `user_id`='".$userId."'");	
         return $result;
     }
     
     
     
     
     function removeChart($chartId){
         $chartWithId = $this->db->get_var($this->db->prepare("select id from chords where chord_id=%s",$chartId));
         $this->db->query($this->db->prepare("delete from chord_owner where `chord_id`=%s",$chartWithId));
         $setId = $this->db->get_var($this->db->prepare("select set_id from chords_inside_sets where chord_id=%@",$chartWithId));
         $this->db->query($this->db->prepare("update sets set `last_updated_time`=NOW() where `set_id`=%s",$setId));
	 $this->db->query($this->db->prepare("delete from chords_inside_sets where `chord_id`=%s",$chartWithId));
         return TRUE;
     }
     
     function removeChartForUser($chartId, $userId){
         $this->db->query($this->db->prepare("delete from chord_owner where `chord_id`=%s",$chartId));
	 $this->db->query($this->db->prepare("delete from chords_inside_sets where `chord_id`=%s",$chartId));
         return TRUE;
     }
     

     function addChartToSet($chartId, $setId){
         $chartWithId = $this->db->get_var($this->db->prepare("select id from chords where chord_id=%s",$chartId));
         $setWithId = $this->db->get_var($this->db->prepare("select id from sets where set_id=%s",$setId));         
         $this->db->query($this->db->prepare("update sets set `last_updated_time`=NOW() where `set_id`=%s",$setId));
         $this->db->query($this->db->prepare("insert into `chords_inside_sets` set `chord_id`=%s , `set_id`=%s",$chartWithId,$setWithId));
         return array("last_updated_time"=>  $this->getMaxUpdatedTimeForSet($setId), "query"=>  $this->db->last_query);
     }
     
     
     function addChartToSetWithData($chartId, $setId, $data){
         $this->db->query($this->db->prepare("insert into chords set data=%s, chord_id=%s ,`last_updated_time`=NOW()",stripslashes($data), json_decode(stripslashes($data))->chordId));         
         $chartWithId = $this->db->insert_id;
         $last_updated_time = $this->db->get_var($this->db->prepare("select last_updated_time from chords where id=%s",$this->db->insert_id));
         $last_created_time = $this->db->get_var($this->db->prepare("select created from chords where id=%s",$this->db->insert_id));
                         
         $this->db->query("insert into chord_owner  set `chord_id`='".$this->db->insert_id."' , `user_id`='".$userId."'");	
         
          $setWithId = $this->db->get_var($this->db->prepare("select id from sets where set_id=%s",$setId));
         
         $this->db->query($this->db->prepare("update sets set `last_updated_time`=NOW() where `set_id`=%s",$setId));
         $this->db->query($this->db->prepare("insert into `chords_inside_sets` set `chord_id`=%s , `set_id`=%s",$chartWithId,$setWithId));
         $result = array("last_updated_time"=>  $this->getMaxUpdatedTimeForSet($setId), "query"=>  $this->db->last_query ,"old_data"=>$data, "serverId"=>  $chartWithId,"chartId"=>json_decode(stripslashes($data))->chordId, "last_updated_time"=>$last_updated_time, "last_created"=>$last_created_time);
         return $result;
     }
    
     
     function removeChartFromSet($chartId, $setId){
         $chartWithId = $this->db->get_var($this->db->prepare("select id from chords where chord_id=%s",$chartId));
         $setWithId = $this->db->get_var($this->db->prepare("select id from sets where set_id=%s",$setId));
         $this->db->query($this->db->prepare("update sets set `last_updated_time`=NOW() where `set_id`=%s",$setId));
         return $this->db->query($this->db->prepare("delete from `chords_inside_sets` where `chord_id`=%s and `set_id`=%s",$chartWithId,$setWithId));
     }
     
     function shareChartWithUsers($chartId, $users){
         
         $chartWithId = $this->db->get_var($this->db->prepare("select id from chords where chord_id=%s", $chartId));
         for ( $i = 0; $i < count($users); $i++){            
             
 	    $userForCheck = $this->db->get_var($this->db->prepare("SELECT ID from vf_users where `facebook_ID`=%s",$users[$i]));  	           
 	    if (count($userForCheck) > 0){						
			$this->db->query($this->db->prepare("insert into chord_owner  set `chord_id`=%s , `user_id`=%s, `share_status`=1", $chartWithId, $userForCheck));
			        	 	 		 
 	    }        
 	}  
     }
             
     function updateChart($chartId, $data, $userId) {
         
         if  ($this->db->query($this->db->prepare("update chords set `data`=%s, `last_updated_time`=NOW() where `chord_id`=%s",$data,$chartId))){
             $chart_id = $this->db->get_var($this->db->prepare("select id from chords  where `chord_id`=%s", $chartId));
             
             $setsIdsToUpdate = $this->db->get_results($this->db->prepare("select cis.`set_id` from `chords_inside_sets` cis where cis.`chord_id`=%s",$chart_id));
             
             for ($i = 0; $i < count ($setsIdsToUpdate); $i++){
                 
                 $this->db->query($this->db->prepare("update sets set `last_updated_time`=NOW() where `id`=%s",$setsIdsToUpdate[$i]->set_id));
                 echo $this->db->last_error;
             }
             $latesUpdatedSet = $this->db->get_results($this->db->prepare("select MAX(s.`last_updated_time`) as updated from `set_owner` so, sets s where so.`user_id`=%s and s.id=so.`set_id`",$userId));
             return array("last_updated_time"=>  $this->getMaxUpdatedTimeForChart($chartId), "last_updated_set"=> $latesUpdatedSet[0]-> updated);
         } else 
             
         return FALSE;
     }
     
     function getMaxUpdatedTimeForChart($chartId){
         $latestUpdatedChart = $this->db->get_var($this->db->prepare("select MAX(ch.`last_updated_time`) as updated from `chord_owner` co, chords ch where  ch.chord_id=%s",$chartId));         
         return $latestUpdatedChart;
     }
     
     function getMaxUpdatedTimeForSet($setId){
         $latesUpdatedSet = $this->db->get_var($this->db->prepare("select MAX(s.`last_updated_time`) as updated from `set_owner` so, sets s where  s.`set_id`=%s",$setId));
         return $latesUpdatedSet;
     }
     
     function addNewset($data, $userId, $setId){
         
         $sets = $this->db->get_results($this->db->prepare("select * from sets where set_id=%s",$setId));
         $result = array();
        if (count($sets) == 0){
            $this->db->query($this->db->prepare("insert into sets set `data`=%s,`last_updated_time`=NOW(), `set_id`=%s",$data,$setId));         
            $last_updated_time = $this->db->get_var($this->db->prepare("select last_updated_time from sets where id=%s",$this->db->insert_id));
            $last_create_time = $this->db->get_var($this->db->prepare("select created from sets where id=%s",$this->db->insert_id));
            $result = array("serverId"=>  $this->db->insert_id,"setId"=>$setId, "last_updated_time"=>$last_updated_time, "last_create_time"=>$last_create_time); 
            $this->db->query($this->db->prepare("insert into `set_owner` set `set_id`=%s , `user_id`=%s",  $this->db->insert_id,$userId));
        } else {
            $result = array("serverId"=>$sets[0]->id, "last_updated_time"=>$sets[0]->last_updated_time, "last_create_time"=>$sets[0]->created);
        }
         return $result;
     }

     function getSetWithId($setId){
         $result = $this->db->get_results($this->db->prepare("select * from sets where id=%s",$setId));
         if (count($result) > 0){
             $this->query_last_updated_time = $result[0]->query_last_updated_time;
             return json_decode($result[0]->data);
         } else {
             return FALSE;
         }
     }
     
     function updateSetWithId($setId, $data){
         
        if ($this->db->query($this->db->prepare("update sets set `data`=%s, `last_updated_time`=NOW() where `set_id`=%s",$data,$setId))){
            return array("last_updated_set"=>  $this->getMaxUpdatedTimeForSet($setId));
        } else {
            return FALSE;
        }
         
     }
     
     function removeSet($setId){
         $setWithId = $this->db->get_var($this->db->prepare("select id from sets where set_id=%s",$setId));
         $this->db->query($this->db->prepare("delete from set_owner where `set_id`=%s",$setId));
         $this->db->query($this->db->prepare("delete from chords_inside_sets where `set_id`=%s",$setWithId));
     }
     
     function removeSetForUser($setId, $userId){
         $setWithId = $this->db->get_var($this->db->prepare("select id from sets where set_id=%s",$setId));
         $this->db->query($this->db->prepare("delete from set_owner where `set_id`=%s and user_id=%s",$setId,$userId));
     }
     
     function shareSetWithUsers($setId, $users){
         $setWithId = $this->db->get_var($this->db->prepare("select id from sets where set_id=%s",$setId));
        for ( $i = 0; $i < count($users); $i++){ 	                   
 	    $userForCheck = $this->db->get_results($this->db->prepare("SELECT * from vf_users where facebook_ID=%s",$users[$i]));  	           
 	    if (count($userForCheck) > 0){
		$this->db->query($this->db->prepare("insert into set_owner  set `set_id`=%s , `user_id`=%s, `share_status`=1",$setWithId,$userForCheck[0]->ID));
            }
 	}
     }
     
    function acceptSet($userId, $setServerId){
        $this->db->query($this->db->prepare("update set_owner set share_status = 0 where set_id=%s and user_id=%s",$setServerId, $userId));
    }
    
    function acceptChart($userId, $chartServerId){
        $this->db->query($this->db->prepare("update chord_owner set share_status = 0 where chord_id=%s and user_id=%s",$chartServerId, $userId));
    }
    
    function declineSet($userId, $setServerId){
        $this->db->query($this->db->prepare("delete from set_owner where set_id=%s and user_id=%s",$setServerId, $userId));
    }
    
    function declineChart($userId, $chartServerId){
        $this->db->query($this->db->prepare("delete from chord_owner  where chord_id=%s and user_id=%s",$chartServerId, $userId));
    }
     
     function getUserData($userId, $last_created_date_chart, $last_updated_date_chart,$last_created_date_set, $last_updated_date_set){
        $userChords = $this->db->get_results($this->db->prepare("select DISTINCT co.`chord_id`,ch.data,ch.id,ch.`last_updated_time`,ch.`created`, co.`share_status` from `chord_owner` co, chords ch where co.`user_id`=%s and ch.id=co.chord_id and (ch.`created` > %s OR ch.`last_updated_time`> %s)",$userId, $last_created_date_chart, $last_updated_date_chart));	
       
        $userSets = $this->db->get_results($this->db->prepare("select s.data,s.id as id, s.data, s.`created`, s.`last_updated_time`, so.`share_status` from `set_owner` so, sets s where so.`user_id`=%s and s.id=so.set_id and (s.`last_updated_time` > %s OR so.`created` > %s )",$userId, $last_updated_date_set,$last_created_date_set));
        
	if (count($userChords) == 0 && count($userSets) == 0){
		return FALSE;
	} else {
		$freeChords = array();
		
		
			for ($i = 0; $i < count($userChords); $i++){
				$tmp = json_decode(stripslashes($userChords[$i]->data), true);
                                
                               if ($tmp != NULL){
                                    $tmp["serverId"] = $userChords[$i]->id;
                                    $tmp["share_status"]=$userChords[$i]->share_status;
                                    $tmp["created"]=$userChords[$i]->created;
                                    $tmp["last_updated_time"]=$userChords[$i]->last_updated_time;
                                    $freeChords[] = $tmp;
                                }
				
                           
			}
		
		$sets = array();
		if (count($userSets) > 0){
			for ($i = 0; $i < count($userSets); $i++){
                            
                        
				$tmp = json_decode(stripslashes ($userSets[$i]->data));
                                if ($tmp != NULL){
                                    $tmp->{"created"}=$userSets[$i]->created;
                                    $tmp->{"share_status"}=$userSets[$i]->share_status;
                                    $tmp->{"last_updated_time"}=$userSets[$i]->last_updated_time;
                                    $tmp->{"serverId"} = $userSets[$i]->id;
                                    $chordsIdForCurrSet = array();
                                    $chords = $this->db->get_results($this->db->prepare("select cis.chord_id, ch.chord_id as chartId, ch.data, ch.id as sid,ch.`last_updated_time`,ch.`created` from chords_inside_sets cis, chords ch where cis.chord_id=ch.id and cis.set_id=%s",$userSets[$i]->id));                                    
                                     $lQuery = $this->db->last_query;
                                    if (count($chords) > 0){
                                            for ($j = 0; $j < count($chords); $j++){

                                                    $chordsIdForCurrSet[] = array("chordId"=>$chords[$j]->chartId,"serverId"=>$chords[$j]->chord_id);
                                                    $tmp2 = json_decode(stripslashes ($chords[$j]->data),true);                                                    
                                                    if ($tmp2 != NULL){
                                                        //echo ($chords[$j]->chord_id);
                                                        
                                                        $setWithId = $this->db->get_var($this->db->prepare("select share_status from chord_owner where chord_id=%s",$chords[$j]->chord_id));
                                                        $tmp2["serverId"] = $chords[$j]->chord_id;
                                                      
                                                        $tmp2["share_status"]=$setWithId;
                                                        $tmp2["created"]=$chords[$j]->created;
                                                        $tmp2["last_updated_time"]=$chords[$j]->last_updated_time;
                                                        $freeChords[] = $tmp2;
                                                    } 
                                            }
                                    }
                                    $tmp->chords = json_decode(json_encode($chordsIdForCurrSet));
                                    $sets[] = $tmp;
                                }
                           
			}
		}
		$latestCreatedChart = $this->db->get_results($this->db->prepare("SELECT MAX(a.created) as created FROM (select ch.`created` as created from  chords_inside_sets cis, chords ch, `set_owner` so where so.`user_id`=%s and ch.id=cis.chord_id UNION ALL select ch.`created` as created from `chord_owner` co, chords ch where co.`user_id`=%s and ch.id=co.chord_id) as a ",$userId,$userId));
		
                $latestUpdatedChart = $this->db->get_results($this->db->prepare("SELECT MAX(a.updated) as updated FROM (select ch.`last_updated_time` as updated from  chords_inside_sets cis, chords ch, `set_owner` so where so.`user_id`=%s and ch.id=cis.chord_id UNION ALL select ch.`last_updated_time` as updated from `chord_owner` co, chords ch where co.`user_id`=%s and ch.id=co.chord_id) as a",$userId,$userId));
		
                $latestCreatedSet = $this->db->get_results($this->db->prepare("select MAX(so.`created`) as created from `set_owner` so, sets s where so.`user_id`=%s and s.id=so.`set_id`",$userId));
		
                $latesUpdatedSet = $this->db->get_results($this->db->prepare("select MAX(s.`last_updated_time`) as updated from `set_owner` so, sets s where so.`user_id`=%s and s.id=so.`set_id`",$userId));
		return array("latest_created_chart"=>$latestCreatedChart[0]->created,
		"last_updated_chart"=>$latestUpdatedChart[0]->updated,
		"latest_created_set"=>$latestCreatedSet[0]->created,
		"last_updated_set"=>$latesUpdatedSet[0]->updated,
                "query"=>$lQuery,
		"data"=>array("freeChords"=>$freeChords,"sets"=>$sets)); 
	}
     }

     
}
