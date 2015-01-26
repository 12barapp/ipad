// Network indicator


/*
 page size:
    width is: 6396
    height is:  8533
    
    dialog size for new chord:
        width:  3200
        height: 3410
 
    for order:
        width: 3232
        height: 3426
        done button distance: 420;
 
    done button size:
        width:  781
        height: 830
 
    notes dialog size: 
        width: 3210
        height: 3400

 
 width: 384;
 left: 192;
 top: 192;
 height: 384;
 
*/

var red_colors = ["#ED1C24", "#E53E3E", "#E25D5D", "#E07E7E", "#ED9D9D"];
var blue_colors = ["#36abe0", "#59B0D3", "#7CC2D8", "#94CFDD", "#AFDBE2"];
var black_colors = ["#4C4C4E", "#626366", "#76787A", "#898B8E", "#9D9FA1"];
var words1 = ["Intro", "V1", "V2", "V3", "V4", "V5", "V6"];
var words2 = ["Pre Chorus", "Chorus", "Bridge", "Instrumental", "Outro", "Custom", "Custom"];
var majors = ["Major", "Major 7", "Major 9", "Major 11", "Minor", "Minor 7", "Minor 9", "Minor 11", "6", "m6", "add 9", "m add 9", "sus", "aug", "dim", "dim7"];
var keys = ["C", "G", "D", "A", "E", "B", "F#", "C#", "C", "F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb"];

var json_string_example = '{"sets":[{"title":"Adairs Saloon","date":"Feb 24 2014","artist":"Greg Reichel","location":"Dallas, Texas","chords":[{"title":"Title","artist":"Artist","key":"G","time_sig":"4/4","genre":"Rock","bpm":"125","notes":"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","lyrics":[{"row":1,"text":"When i ﬁnd myself in times of trouble Mother mary comes to me Speaking words of wisdom, let it be. And in my hour of darkness  She is standing right in front of me Speaking words of wisdom, let it be.","chords":[{"type":"Major","title":"G","top":50,"left":20}]}]}]}]}';//'{"charts":[{"title":"Love Me Do","author":"The Beatles","key":"G","time":"4/4","bpm":"125","genre":"Rock","sets":[{"title":"Adairs 5/16/14"},{"title":"Easter Sunday"},{"title":"The Wormy Dog"}]},{"title":"Love Me Do","author":"The Beatles","key":"","time":"","bpm":"","sets":[{"title":"Adairs 5/16/14"},{"title":"Easter Sunday"},{"title":"The Wormy Dog"}]},{"title":"Love Me Do","author":"The Beatles","key":"C#","time":"4/4","bpm":"125","genre":"Rock","sets":[{"title":"Adairs 5/16/14"},{"title":"Easter Sunday"},{"title":"The Wormy Dog"}]},{"title":"Love Me Do","author":"","key":"","time":"","bpm":"","genre":"Rock","sets":[{"title":"Adairs 5/16/14"},{"title":"Easter Sunday"},{"title":"The Wormy Dog"}]},{"title":"Love Me Do","author":"","key":"","time":"","bpm":"","genre":"Rock","sets":[{"title":"Adairs 5/16/14"},{"title":"Easter Sunday"},{"title":"The Wormy Dog"}]},{"title":"Love Me Do","author":"The Beatles","key":"C","time":"3/4","bpm":"128","genre":"Rock","sets":[{"title":"Adairs 5/16/14"},{"title":"Easter Sunday"},{"title":"The Wormy Dog"}]},{"title":"Runaway","author":"The Beatles","key":"G","time":"4/4","bpm":"130","genre":"Rock","sets":[{"title":"Peters Piano Bar"},{"title":"Creep"},{"title":"Soak up the Sun"}]}]}';



/*{
  "charts": [
    {
      "title":"Some title",
      "author":"Some author",
      "key":"G",
      "time_sig":"4/4",
      "bpm":"125",
      "lyrics":[
        ],
      "chords":[ {"char":"", "position":""},{}
 ]
    }
    ]
}*/