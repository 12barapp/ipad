function showAbout(){
    $(".settings_dlg").html("");
    $(".settings_dlg").html("<table style='color: white; background: #2d2a2a; ' cellspacing='0' cellpadding='0'>"+
                            "<tr><td colspan='4' style='height: 50%; width: 100%; font-size: 2.5em;font-weight: bold; line-height: 1em;'>12Bar was</br>created</br>by 2 guys</td></tr>"+
                            "<tr>"+
                            "<td style='width: 50%; height: 25%; background: #f05d54; color: white; text-align: center;vertical-align: middle;font-size: 1.4em;' >Jonny Mack</br><img style='height: 25px; margin: 4px;' src='icons/facebook.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/twitter.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/instagram.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/mail-1.png' alt=''/></td>"+
                            "<td style='width: 50%; height: 25%; background: #f48c86; color: white; text-align: center; vertical-align: middle;font-size: 1.4em;'>Rich Williams</br><img style='height: 25px;' src='icons/facebook.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/twitter.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/instagram.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/mail-1.png' alt=''/></td>"+
                            "</td>"+
                            "</tr>"+
                            "<tr>"+
                            "<td colspan='2' style='width: 100%; height: 25%; background: #73d1f5; color: white; text-align: right; vertical-align: middle;font-size: 1.4em; padding-right: 1.4em;'>12bar.com</br><img style='height: 25px; margin: 4px;' src='icons/facebook.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/twitter.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/instagram.png' alt=''/>"+
                            "<img style='height: 25px; margin: 4px;' src='icons/mail-1.png' alt=''/></td>"+
                            "</td>"+
                            "</tr>"+
                            "</table><div style='width: 100%; text-align: center;'><img onClick='getSettings()' style='width: 80px; margin-top: 100px;' src='icons/btn_done.png'  alt=''></div></div>");
}


function getSettings(){
    $("#dialogs").html("");
    $("#dialogs").append(getMainSettings());

}