var $mainJson;

function insertNewChord(jsonObject, setsNum, cTitle, cArtist, cKey, cTime, cBpm, cGenre){
    if (jsonObject.sets.length > 0){
        jsonObject.sets[setsNum].chords.push({"title": cTitle, "key": cKey, "time_sig": cTime, "genre": cGenre, "bpm": cBpm, "notes":"", "lyrics":"[]"});
    }else{
        return jsonObject;
    }
    return jsonObject;
}

function deleteChordFromSet(jsonObject, setNum, chordNum){
    console.log(jsonObject);
    console.log(setNum+" "+chordNum);
    delete (jsonObject.sets[setNum]).chords.splice(chordNum, 1);
    console.log(jsonObject);
    return jsonObject;
}

function insertNewSet(jsonObject, cTitle, cArtist, cDate, cLocation){
    jsonObject.sets.push({"title":cTitle, "date":cDate, "artist":cArtist, "location":cLocation, "chords":"[]"});
    return jsonObject;
}