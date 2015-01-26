function showMailDlg(){
    $(".settings_dlg").html("");
    $(".settings_dlg").html("<table style='background: white;'>"+
    "<tr style='background: #e6e7e8;'><td style='height: 10px; width: 8%; color: #277cbd;'>Cancel</td><td><b>Check out 12Bar!</b></td ><td style='width: 8%;'onClick='sendEmail()'>Send</td></tr>"+
    "<tr ><td colspan='3' style='border-bottom: 1px solid black; text-align: left;vertical-align: middle; height: 25px;'><span style='color: #808184'>To: </span><input style='border: none; width: 85%;' type='text'></td></tr>"+
    "<tr ><td colspan='3' style='border-bottom: 1px solid black; text-align: left;vertical-align: middle; height: 25px;'><span style='color: #808184'>Cc/Bcc, From:</span> <input style='border: none; width: 65%;' type='text'></td></tr>"+
    "<tr ><td colspan='3' style='text-align: left; font-weight: bold; border-bottom: 1px solid black;vertical-align: middle; height: 25px;'><span style='color: #808184'>Subject: </span><input style='border: none; width: 80%;' type='text'></td></tr>"+
    "<tr ><td colspan='3' style='text-align: left;vertical-align: middle; height: 25px;'><span id='myText' style='color: #808184'>Check out this app called 12Bar! It really is the easist way to create and share charts and sets!</br></br>Sent from my iPad</span></td></tr>"+"</table><div style='width: 100%; text-align: center;'><img onClick='getSettings()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>");
}

function sendEmail(){
    var link = "mailto:alexandrharchenko106@gmail.com"
    + "?cc=alexandrharchenko106@gmail.com"
    + "&subject=" + escape("This is my subject")
    + "&body=" + escape(document.getElementById('myText').value)
    ;
    
    window.location.href = link;
}

function showSettingsDialog(){
    
    $("#dialogs").html("");
    $("#dialogs").append("<div class='settings_dlg' style='width: "+(($( window ).width()/8)*4)+";left:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+";top:"+(($(window).width()/2) - (($( window ).width()/8)*4)/2)+"; height: "+(($( window ).width()/8)*4)+";  position: absolute; z-index: 55'><table style='color: white;'>"+
                         "<tr><td colspan='4' style='height: 50%; width: 100%'></td></tr>"+
                         "<tr>"+
                         "<td style='width: 25%; height: 25%; background: #58595b' onClick='changeTheme()'>Light/Dark</td>"+
                         "<td style='width: 25%; height: 25%; background: #a6a8ab'>Chords</td>"+
                         "<td style='width: 25%; height: 25%; background: #bbbdbf'>Lyrics</td>"+
                         "<td style='width: 25%; height: 25%; background: #ee4036'>Chords</br>& Lyrica</td>"+
                         "</tr>"+
                         "<tr>"+
                         "<td style='width: 25%; height: 25%; background: #24adee'>Sound</td>"+
                         "<td style='width: 25%; height: 25%; background: #929497'>Log Out</td>"+
                         "<td style='width: 25%; height: 25%; background: #6d6e70'>Tell a Friend</td>"+
                         "<td style='width: 25%; height: 25%; background: #a6a8ab' onClick='showAbout()'>About</td>"+
                         "</tr>"+
                         "</table><div style='width: 100%; text-align: center;'><img style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>"+
                         "");
    showBlurEffect();
}