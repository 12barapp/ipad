<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title></title>
        <style>
            .button {
                display: inline-block;
                outline: none;
                cursor: pointer;
                text-align: center;
                text-decoration: none;
                font: 14px/100% Arial, Helvetica, sans-serif;
                padding: .5em 2em .55em;
                text-shadow: 0 1px 1px rgba(0,0,0,.3);
                -webkit-border-radius: .5em; 
                -moz-border-radius: .5em;
                border-radius: .5em;
                -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.2);
                -moz-box-shadow: 0 1px 2px rgba(0,0,0,.2);
                box-shadow: 0 1px 2px rgba(0,0,0,.2);
                text-shadow: 2px 8px 6px rgba(0,0,0,0.2),
                 0px -5px 5px rgba(255,255,255,0.3);
            }
            .button:hover {
                    text-decoration: none;
            }
            .button:active {
                position: relative;
                top: 1px;
            }
            form {
                text-align: center;
                width: 100%;
                height: 100%;
                margin-bottom: 15px;
            }
            
            input {
                color: white;
                background: red;
                border-radius: 5px;
                padding: 10px;
                margin-top: 10%;
            }
            
            body{
                padding: 0px;
                margin: 0px;
                background: black;
                text-align: center;
            }
            
            label{
                color: white;
            }
            
            span{
                margin: 4px;
            }
            
        </style>
    </head>
    <body>
        <form method="post">
            <input type="submit" class="button" value="Install server"></br>
            <label><input type="checkbox" name="agree"/>I agree to install server tables</label>
        </form>
        <?php        
        if (isset($_REQUEST['agree'])){
            startInstalation();
        } else {
            echo "<span style='color: red'>Please agree with instalation.</span></br>";
        }
        
        function startInstalation(){
            echo "<span style='color: green'>Connection to the database</span></br>";
            require_once( $_SERVER['DOCUMENT_ROOT'] . '/app12Bar/bar_acp/wp-config.php' );
            require_once( 'install_config.php' );
            require_once( $_SERVER['DOCUMENT_ROOT'] . '/app12Bar/bar_acp/wp-includes/wp-db.php' );
            $db = new wpdb( DB_USER, DB_PASSWORD, DB_NAME, DB_HOST);
            echo "<span style='color: green'>Connected.</span></br>";
            echo "<span style='color: green'>Checking db tables.</span></br>";            
            if ($db->get_var("SHOW TABLES LIKE 'chords'") != "chords"){
                $db->query(CHORDS_TABLE);
            } else {
                echo "<span style='color: green'>Table `chords` exist.</span></br>";
            }
            if ($db->get_var("SHOW TABLES LIKE 'chord_owner'") != "chord_owner"){
                $db->query(CHORDS_OWNER);
            } else {
                echo "<span style='color: green'>Table `chord_owner` exist.</span></br>";
            }
            if ($db->get_var("SHOW TABLES LIKE 'chords_inside_sets'") != "chords_inside_sets"){
                $db->query(CHORDS_INSIDE_SETS);
             } else {
                echo "<span style='color: green'>Table `chords_inside_sets` exist.</span></br>";
            }
            if ($db->get_var("SHOW TABLES LIKE 'set_owner'") != "set_owner"){
                $db->query(SETS_OWNER);
            } else {
                echo "<span style='color: green'>Table `set_owner` exist.</span></br>";
            }
             if ($db->get_var("SHOW TABLES LIKE 'sets'") != "sets"){
                $db->query(SETS_TABLE);
             } else {
                echo "<span style='color: green'>Table `sets` exist.</span></br>";
            }
            echo "<span style='color: green'>Checking fields in table `vf_users`</span></br>";
            $field = $db->get_var("SELECT * 
FROM information_schema.COLUMNS 
WHERE 
    TABLE_SCHEMA = '".DB_NAME."' 
AND TABLE_NAME = 'vf_users' 
AND COLUMN_NAME = 'facebook_ID'");
            $deviceToken = $db->get_var("SELECT * 
FROM information_schema.COLUMNS 
WHERE 
    TABLE_SCHEMA = '".DB_NAME."' 
AND TABLE_NAME = 'vf_users' 
AND COLUMN_NAME = 'devices'");
            if ($field == NULL){
                 echo "<span style='color: green'>Column 'facebook_ID' doesn't exist. Adding now.</span></br>";
                  $db->query("ALTER TABLE vf_users ADD facebook_ID text NOT NULL");
                 echo "<span style='color: yellow'>".$db->last_error."</span></br>"; 
            } else {
                echo "<span style='color: green'>Needed fields exist</span></br>";
            }
            
            if ($deviceToken == NULL) {
                echo "<span style='color: green'>Column 'devices' doesn't exist. Adding now.</span></br>";
                $db->query("ALTER TABLE vf_users ADD devices text NOT NULL");
                 echo "<span style='color: yellow'>".$db->last_error."</span></br>";
            } else {
                echo "<span style='color: green'>Needed fields for tokens are exist</span></br>";
            }
            echo "<span style='color: green'>Done</span></br>";
        } 
        ?>
    </body>
</html>
