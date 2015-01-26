var prevElement;

function getMainSettings(){
    
    var bgColor = "#929396";
    var soundColor;
    if ($.cookie("sound") === "on"){
        soundColor = "#24aced";
    }else
        if ($.cookie("sound") === "off"){
            soundColor = "#929396";
        }
    if ($.cookie("sound") == null){
        soundColor = "#24aced";
    }
    

    if ($.cookie("theme") === "dark"){       
        bgColor = "#57585b";
    }
    if ($.cookie("theme") === "light"){
            bgColor = "#929396";
        }
    if ($.cookie("theme") == null){
        bgColor = "#929396";
        }
      
    
    return "<div class='settings_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+";  position: absolute; z-index: 55'><table cellspacing='0' cellpadding='0' style='color: white;'>"+
    "<tr><td colspan='4' style='height: 50%; width: 100%; font-size: 2.5em;padding-right: 15px;padding-bottom: 15px; color: #bbbbbb;'>Settings</td></tr>"+
    "<tr>"+
    "<td style='width: 25%; height: 25%; background: "+bgColor+"' onClick='changeTheme(this)'>Light/Dark</td>"+
    "<td style='width: 25%; height: 25%; background: #a6a8ab' onClick='chooseDisplayMode(this)'>Chords</td>"+
    "<td style='width: 25%; height: 25%; background: #bbbdbf' onClick='chooseDisplayMode(this)'>Lyrics</td>"+
    "<td style='width: 25%; height: 25%; background: #ee4036' onClick='chooseDisplayMode(this)' id='prevEl'>Chords</br>& Lyrics</td>"+
    "</tr>"+
    "<tr>"+
    "<td style='width: 25%; height: 25%; background: "+soundColor+"' onClick='toogleSound(this)'>Sound</td>"+
    "<td style='width: 25%; height: 25%; background: #929497'>Log Out</td>"+
    "<td style='width: 25%; height: 25%; background: #6d6e70' onClick='showMailDlg()'>Tell a Friend</td>"+
    "<td style='width: 25%; height: 25%; background: #a6a8ab' onClick='showAbout()'>About</td>"+
    "</tr>"+
    "</table><div style='width: 100%; text-align: center;'><img onClick='doneSettings()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>"+
    "";
}




function chooseDisplayMode(element){
   
    console.log($(element).html());
    if ($(element).html() === "Chords"){
        $.cookie("displayMode", 1);
    }else if ($(element).html() === "Lyrics"){
        $.cookie("displayMode", 2);
    }else{
        $.cookie("displayMode", 3);
    }
    
    if (prevElement == null){
        prevElement =$("#prevEl");// element;
    }
    
    $(prevElement).css("background","#babcbe");
    $(element).css("background","#ed4036");
    prevElement = element;
    
}

function doneSettings(){
    $("#dialogs").html("");
    removeBlurEffect();
    
    initDashboard();
    
}

function changeTheme(element){
    var bgColor = "#929497";
    if ($.cookie("theme") === "dark"){
        $.cookie("theme", "light");
        bgColor = "#929497";
    }else
        if ($.cookie("theme") === "light"){
            $.cookie("theme", "dark");
            bgColor = "#58595b";
        }
    if ($.cookie("theme") == null){
        $.cookie("theme", "dark");
        bgColor = "#58595b";
    }
    $(element).css("background", bgColor);
}

function toogleSound(element){
    var bgColor;
   
    if ($.cookie("sound") === "on"){
        $.cookie("sound", "off");
        bgColor = "#929396";
    }else
        if ($.cookie("sound") === "off"){
            $.cookie("sound", "on");
            bgColor = "#24aced";
        }
    if ($.cookie("sound") == null){
        $.cookie("sound", "off");
        bgColor = "#929396";
    }
    
     console.log($.cookie("sound"));
    $(element).css("background", bgColor);
}
