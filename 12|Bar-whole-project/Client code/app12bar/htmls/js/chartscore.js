function initTitleSCreen(){
	
	//console.log(jObj.charts.length);
   // alert($(window).width());
   //  alert($(window).height());
    /*$("#title_dialog").width(($( window ).width()/2));
    $("#title_dialog").height(($( window ).height()/2.5));
    $("#title_dialog").css("top",((($( window ).height()-32)/10)*3));*/
  //  $("#title_dialog").css("left",(($( window ).width()/8)*2));
	for (i = 0; i < 80; i++){
		$("#title_screen").append("<li class='' style='background:"+red_colors[Math.floor(Math.random()*red_colors.length)]+"; width:"+($( window ).width()-32)/8+"px; height:"+($( window ).height()-32)/10+"px;'></li>");
        
        
	}
}



function initSortableLists(){
    $( "#sortable" ).sortable();
    $( "#sortable" ).disableSelection();
    $( "#sortable_sets" ).sortable();
    $( "#sortable_sets" ).disableSelection();
}

function initDashboard(){
    
    $("#sortable_lists").html("");
    
    $("#title_dialog").remove();
    $("#title_screen").html("");
    
    initBGTiles();
    if ($.cookie("displayMode")== 1)
        $("#sortable_lists").append(getChartsContainer());
    initRedTiles();
    if ($.cookie("displayMode")== 2)
        $("#sortable_lists").append(getSetsContainer());
    initBlueTiles(null);
    if (($.cookie("displayMode")== 3)|| ($.cookie("displayMode")== null)){
        $("#sortable_lists").append(getChartsContainer()+""+getSetsContainer());
        initRedTiles();
        initBlueTiles(null);
    }
    
    initSortableLists();
    
}


function initBGTiles(){
    var cur_row = 0;
    var tile_num = 1;
    for (i = 0; i < 80; i++){
        $("#bg_tiles").append("<li class='ui-state-default' style='width:"+(($( window ).width()-15)/8)+"px; height: "+(($( window ).height()-15)/10)+"px; background:"+black_colors[Math.floor(Math.random()*black_colors.length)]+"'></li>");
        
    }
    
    
}



function getChartsContainer(){
    return "<div id='chords_container'><ul id='menu_charts'><li class='tile' id='name' style='color: #f04e54 !important'>Charts</li><li class='tile' id='icon'><div onclick='displayChartOrderDialog()' class='box'><img  src='icons/order.png' width='60' height='60' alt=''/></div></li><li class='tile' id='icon'><div onclick='displayChartSearchDialog()' class='box'><img src='icons/search.png' width='60' height='60' alt=''/></div></li><li class='tile' id='icon'  onclick='addNewChart()' style='padding-right: 2px;'><div class='box'><img src='icons/new.png' width='60' height='60' alt=''/></div></li></ul><ul id='sortable' class='ui-sortable'>  <!-- Chords --></ul></div>";
}

function getSetsContainer(){
    return "<div id='sets_container'><ul id='menu_sets'><li class='tile' id='name' style='color: #29ABE2 !important'>Sets</li><li class='tile' id='icon'><div class='box' onclick='displaySetsOrderDialog()'><img src='icons/order_blue.png' width='60' height='60' alt=''/></div></li><li class='tile' id='icon'><div onclick='displaySetsSearchDialog()' class='box'><img src='icons/search_blue.png' width='60' height='60' alt=''/></div></li><li class='tile' id='icon' onclick='addNewSet()' style='padding-right: 1px;'><div class='box'><img src='icons/new_blue.png' width='60' height='60' alt=''/></div></li></ul><ul id='sortable_sets' class='ui-sortable'></ul></div>";
}


function goFBLogin(){
    document.location = "dashboard.html";
}

function getListForGenre(){
    return "<select id='chord_genre'>"+
    "<option>Folk/Acoustic</option>"+
    "<option>Alternative/Indie</option>"+
    "<option>Blues</option>"+
    "<option>Children’s</option>"+
    "<option>Classical/New Age</option>"+
    "<option>Country</option>"+
    "<option>Dance/Electronic</option>"+
    "<option>R&B/Funk/Soul</option>"+
    "<option>Gospel</option>"+
    "<option>Rap/Hip Hop</option>"+
    "<option>Instrumental</option>"+
    "<option>Jazz</option>"+
    "<option>Metal</option>"+
    "<option>Pop</option>"+
    "<option>Praise and Worship</option>"+
    "<option>Punk</option>"+
    "<option>Reggae</option>"+
    "<option selected='selected'>Rock and Roll</option>"+
    "<option>Americana/Roots</option>"+
    "<option>World</option>"+
    "</select>";
}

function getListForSignature(){
  var list = "<select id='chord_time'>"+
  "<option selected='selected'>4/4</option>"+
  "<option>2/2</option>"+
  "<option>4/2</option>"+
  "<option>3/4</option>"+
  "<option>3/8</option>"+
  "<option>6/8</option>"+
  "<option>12/8</option>"+
  "<option>5/8</option>"+
  "<option>7/8</option>"+
  "</select>";
  return list;
}

function getListForKeys(){
  var list = "<select id='chord_keys'>"+
  "<option>C</option>"+
  "<option>C#</option>"+
  "<option>D</option>"+
  "<option>Eb</option>"+
  "<option>E</option>"+
  "<option>F</option>"+
  "<option>F#</option>"+
  "<option>G</option>"+
  "<option>Ab</option>"+
  "<option>A</option>"+
  "<option>Bb</option>"+
  "<option>B</option>"+
  "</select>";
  return list;
}


var vague;

function showBlurEffect(){
    console.log($("#dialogs"));
    $("#dialogs").append("<div class='blur'></div>");
  //  vague = $("#all_tiles").Vague({intensity:3});
  //  vague.blur();
  // $("#dialog").addClass("blur");
 /* $("#sortable_lists").addClass("blur");
  $("#bg_tiles").addClass("blur");*/
}

function removeBlurEffect(){
  $("#all_tiles").removeClass("blur");
 //   $("#sortable_lists").removeClass("blur");
 // $("#bg_tiles").removeClass("blur"); */
   //  vague.destroy();
}



function getWidthForTile(){
    return (($( window ).width()-32)/8);
}



function getHeightForTile(){
    return (($( window ).height()-32)/10);
}



function wordsClicked(){
    $("#tr1").empty();
    $("#tr2").empty();
    
    
    insertCellForWords();
    
    $("#td22").addClass("inactive");
    $("#td22").removeClass("active");
    
    $("#td11").addClass("active");
    $("#td11").removeClass("inactive");
}

function tempoClicked(){
    
    $("#tr1").empty();
    $("#tr2").empty();
    
    $("<td id='td11' class='active' style='background: "+red_colors[Math.floor(Math.random()*red_colors.length)]+"; color: white; width: 92px; height: 99.2px; text-align: center;'><img src='icons/nejasno.png' style='width: 50%;' alt=''></td>").click(function(e) {e.preventDefault();wordsClicked()}).appendTo('tr#tr1');
    
    $("<td id='td22' class='inactive' style='background: "+red_colors[Math.floor(Math.random()*red_colors.length)]+"; color: white; width: 92px; height: 99.2px; text-align: center;'><img src='icons/nejasno.png' style='width: 50%;' alt=''></td>").click(function(e) {e.preventDefault();tempoClicked();}).appendTo('tr#tr2');
    
    
    insertCellForTempo();
    
    $("#td11").addClass("inactive");
    $("#td11").removeClass("active");
    
    $("#td22").removeClass("inactive");
    $("#td22").addClass("active");
}

function setRow1Text(element){
    $("#first_row").text($(element).text());
}

function setRow2Text(element){
    $("#second_row").text($(element).text());
}

function setWords(){
    for (i = 0; i < words1.length; i++){
        console.log(words1[i]);
        $("#w"+i).text(words1[i]);
        $("#v"+i).text(words2[i]);
    }
}