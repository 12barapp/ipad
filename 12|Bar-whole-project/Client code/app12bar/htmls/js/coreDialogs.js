function showSettingsDialog(){
   
    $("#dialogs").html("");
    $("#dialogs").append(getMainSettings());
    displayHover();
     showBlurEffect();
}

function showNotesDlg(notes){
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='chart_order_dlg' style='box-shadow: 0 0 31px rgba(0,0,0,0.8); width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+"; background: white; position: absolute; z-index: 55'><table cellspacing='0' cellpadding='0'>"+
                         "<tr id='order_row0'>"+
                         "<td style='vertical-align: bottom; color: #4db4d3; height: 25%;' colspan='4'><img  src='icons/notes_btn.png' style='height: 10%; background: #9d9d9d; float: left;' alt=''></td>"+
                         "</tr>"+
                         "<tr id='order_row1'>"+
                         "<td style='height: 75%;'><textarea id='notes' style='color: #a2a2a2;line-height: 1.5em;'>"+notes+"</textarea></td>"+
                         "</tr></table><div style='width: 100%; text-align: center;'><img onclick='notesDone()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div></div>");
    displayHover();
    showBlurEditor();
}

function displaySetsOrderDialog(){
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='chart_order_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+"; background: white; position: absolute; z-index: 55'><table cellspacing='0' cellpadding='0'>"+
                         "<tr id='order_row0'>"+
                         "<td style='vertical-align: bottom; color: #4db4d3;' colspan='4'>Order by</td>"+
                         "</tr>"+
                         "<tr id='order_row1'>"+
                         "<td style='height: 25%; background: #81cded; border: 0.5px solid #47b6e5;'>Title</td>"+
                         "<td style='height: 25%; background: #72c7eb; border: 0.5px solid #47b6e5;'>Author</td>"+
                         "<td style='height: 25%; background: #a8ddf2; border: 0.5px solid #47b6e5;'>Date</td>"+
                         "<td style='height: 25%; background: #86cfee; border: 0.5px solid #47b6e5;'>Location</td>"+
                         "</tr></table><div style='width: 100%; text-align: center;'><img onclick='dialogDone()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div></div>");
    displayHover();
    showBlurEffect();
}

function displaySetsSearchDialog(){
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='chart_order_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+"; background: white; position: absolute; z-index: 55'><table cellspacing='0' cellpadding='0'>"+
                         "<tr id='order_row0'>"+
                         "<td style='vertical-align: bottom; color: #4db4d3;' colspan='4'>Search</td>"+
                         "</tr>"+
                         "<tr id='order_row1'>"+
                         "<td style='height: 25%; background: #81cded; border: 0.5px solid #47b6e5;'>Title</td>"+
                         "<td style='height: 25%; background: #72c7eb; border: 0.5px solid #47b6e5;'>Author</td>"+
                         "<td style='height: 25%; background: #a8ddf2; border: 0.5px solid #47b6e5;'>Date</td>"+
                         "<td style='height: 25%; background: #86cfee; border: 0.5px solid #47b6e5;'>Location</td>"+
                         "</tr></table><div style='width: 100%; text-align: center;'><img onclick='dialogDone()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div></div>");
    displayHover();
    showBlurEffect();
}


function displayChartOrderDialog(){
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='chart_order_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+"; background: white; position: absolute; z-index: 55'><table cellspacing='0' cellpadding='0'>"+
                         "<tr id='order_row0'>"+
                         "<td style='vertical-align: bottom;' colspan='4'>Order by</td>"+
                         "</tr>"+
                         "<tr id='order_row1'>"+
                         "<td style='height: 25%; background: #f2706b'>Title</td>"+
                         "<td style='height: 25%; background: #f7a6a2'>Author</td style='height: 25%; background: #f7afac'>"+
                         "<td style='height: 25%; background: #f7afac'>Key</td>"+
                         "<td style='height: 25%; background: #f06964'>Time</br>Signature</td>"+
                         "</tr>"+
                         "<tr id='order_row2'>"+
                         "<td style='height: 25%; background: #f48c88'>BPM</td>"+
                         "<td style='height: 25%; background: #f3807b'>genre</td>"+
                         "<td style='height: 25%; background: #cbcbcb'></td>"+
                         "<td style='height: 25%; background: #b7b7b7'></td>"+
                         "</tr></table><div style='width: 100%; text-align: center;'><img onclick='dialogDone()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>");
      displayHover();
    showBlurEffect();
}



function displayChartSearchDialog(){
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='chart_order_dlg' style='width: 100px; height: 100px; background: white; position: absolute; z-index: 55'><div style='width: 100%; text-align: center;'><img onclick='dialogDone()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>");
    displayHover();
    showBlurEffect();
}

//var vagueEditor;

function showBlurEditor(){
     $("#dialogs").append("<div class='blur'></div>");
  //  vagueEditor = $("#chart_editor").Vague({intensity:3});
  //  vagueEditor.blur();
    // $("#chart_editor").addClass("blur");
    
}

function addNewChart(){
    
  //  alert("New chord");
  //  $("#dialogs").html("");
    $("#dialogs").append("<form enctype='multipart/form-data' action='http://newurl.url' class='dialog' id='newchart_dlg' style='width: "+(($( window ).width()/8)*4)+"; left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";height: "+(($( window ).width()/8)*4)+"; '><table cellspacing='0' cellpadding='0'><tr>"+
                         "<td style='background: #ED1C24;'>Title</td>"+
                         "<td colspan='3'><input id='chord_title' type='text' style='border-bottom: 1px solid black;margin-left: 5px; margin-right: 5px; width: 95%;' /></td>"+
                         "<td></td><td></td></tr><tr>"+
                         "<td style='background: #f57889;'>Author</td>"+
                         "<td colspan='3'><input id='chord_author' type='text'/></td><td></td><td></td></tr><tr>"+
                         "<td style='background: #f791a0;'>Key</td>"+
                         "<td><div class='styled-select'>"+getListForKeys()+"</div></td><td style='background: #f791a0;'>Genre</td><td><div class='styled-select'>"+getListForGenre()+"</div></td></tr>"+
                         "<tr>"+
                         "<td style='background: #f36478;'>Time</br>signature</td>"+
                         "<td><div class='styled-select'>"+getListForSignature()+"</div></td>"+
                         "<td style='background: #f35f74;width: 192px;height: 204px;'>BPM</td>"+
                         "<td id='user_txt'>125</td></tr></table><div style='width: 100%; text-align: center;'><img onclick='newChordDone($(\"#newchart_dlg\"))' style='width: 80px; position: absolute;top: 150px;right: -120px' src='icons/btn_done.png'  alt=''></div>"+
                         "<div style='width: 100%; text-align: center;'><img onclick='newChordDone($(\"#newchart_dlg\"))' style='width: 80px; position: absolute;top: 150px;left: -120px' src='icons/btn_done.png'  alt=''></div></form>");
   showBlurEffect();
    displayHover();
}

function addNewSet(){
    
    $("#dialogs").html("");
    $("#dialogs").append("<form class='newSetDlg' id='newset_dlg' style='width: "+(($( window ).width()/8)*4)+"; left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";height: "+(($( window ).width()/8)*4)+"; '><table style='width: 100%; height: 100%;' cellspacing='0' cellpadding='0'>"+
                         "<tr><td style='background: #26cafd; width: 25% !important; height: 25%; color:white;padding: 10px;'>Title</td><td><input id='set_title' type='text'/></td></tr>"+
                         "<tr><td style='background: #8be3fe; width: 25% !important; height: 25%; color:white;padding: 10px;'>Author</td><td><input id='set_author' type='text'/></td></tr>"+
                         "<tr><td style='background: #a1e8fe; width: 25% !important; height: 25%; color:white;padding: 10px;'>Date</td><td><input id='set_date' type='date'/></td></tr>"+
                         "<tr><td style='background: #7adffe; width: 25% !important; height: 25%; color:white;padding: 10px;'>Location</td><td><input id='set_location' type='text'/></td></tr>"+
                         "</table><div style='width: 100%; text-align: center;'><img onclick='newSetDone($(\"#newset_dlg\"))' style='width: 80px; position: absolute;top: 150px;right: -120px' src='icons/btn_done.png'  alt=''></div>"+
                         "<div style='width: 100%; text-align: center;'><img onclick='dialogDone()' style='width: 80px; position: absolute;top: 150px;left: -120px' src='icons/btn_done.png'  alt=''></div></form>");
    displayHover();
    showBlurEffect();
   

}

function displaySetInfo(){
        displayHover();
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='setInfo_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+"; background: white; position: absolute; z-index: 55'><table  cellspacing='0' cellpadding='0' style='width: 100%; height: 100%;'><tr>"+
                         "<td style='height: 75%;'></td><td></td><td></td><td></td></tr>"+
                         "<tr id='setInfo_row2'>"+
                         "<td style='background: #6cc2d9; vertical-align: bottom;height: 90px;><img src='icons/share.png'  alt=''></br><div>Share</div></td>"+
                         "<td style='background: #5cbbd5;vertical-align: bottom;height: 90px;'><img src='icons/edit.png'  alt=''></br><div>Edit</div></td>"+
                         "<td style='background: #9ad4e5;vertical-align: bottom;height: 90px;'><img src='icons/perform.png'  alt=''></br><div>Perform</div></td>"+
                         "<td style='background: #72c5db;vertical-align: bottom;height: 90px;'><img src='icons/delete.png'  alt=''></br><div>Delete</div></td></tr></table></div>");
showBlurEffect();
}



function displayChartInfo(element){
   // console.log(jObj.charts[element.id]);
    chordNum = element.id;
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='chartInfo_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+"; background: white; position: absolute; z-index: 55'><table cellspacing='0' cellpadding='0' style='width: 100%; height: 100%;'>"+
                         "<tr id='chartInfoRow'><td style='height: 16.6%;' colspan='4'></td></tr>"+
                         "<tr id='chartInfoRow'><td style='height: 16.6%;' colspan='4'>"+jObj.sets[0].chords[element.id].title+"</td></tr>"+
                         "<tr id='chartInfoRow'><td style='height: 16.6%;' colspan='4'>"+jObj.sets[0].chords[element.id].artist+"</td></tr>"+
                         "<tr id='chartInfoRow'><td style='height: 16.6%;' colspan='4'>"+jObj.sets[0].chords[element.id].key+" • "+jObj.sets[0].chords[element.id].time_sig+" • "+jObj.sets[0].chords[element.id].bpm+"</td></tr>"+
                         "<tr id='chartInfoRow'><td style='height: 16.6%;' colspan='4'>"+jObj.sets[0].chords[element.id].genre+"</td></tr>"+
                         "<tr id='setInfo_row2'>"+
                         "<td style='background: #f36b74; vertical-align: bottom;height: 90px;'><img src='icons/share.png'  alt=''></br><div>Share</div></td>"+
                         "<td style='background: #f79a9f; vertical-align: bottom;height: 90px;'><img src='icons/edit.png'  alt=''></br><div>Edit</div></td>"+
                         "<td style='background: #f6949a; vertical-align: bottom;height: 90px;'><img src='icons/perform.png'  alt=''></br><div>Perform</div></td>"+
                         "<td style='background: #f25963; vertical-align: bottom;height: 90px;' onClick='deleteChord()'><img src='icons/delete.png'  alt=''></br><div>Delete</div></td></tr></table><div style='width: 100%; text-align: center;'><img onclick='dialogDone()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>");
    displayHover();
    showBlurEffect();
}

function displayHover(){
    $("#dialogs").append("<div  class='dialog' style='width: 100%; height: "+$(window).height()+"px;position: absolute; z-index: 5'></div>");
}

function hideDialogsAndBlur(){
    $("#dialogs").html("");
    removeBlurEffect();
}



function dialogDone(){
    hideDialogsAndBlur();
}


