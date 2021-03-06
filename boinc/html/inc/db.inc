<?php

require_once('../inc/util.inc');

// database-related functions.
// Presentation code (HTML) shouldn't be here

function db_init_aux() {
    $config = get_config();
	$user = parse_config($config, "<db_user>");
	$pass = parse_config($config, "<db_passwd>");
	$host = parse_config($config, "<db_host>");

    if( empty($pass) ) return 3;

    if ($host == null) {
        $host = "localhost";
    }
    $retval = @mysql_pconnect($host, $user, $pass);
    if (!$retval) {
        return 1;
    }

    $db_name = parse_config($config, "<db_name>");
    if(!mysql_select_db($db_name)) {
        return 2;
    }

    return 0;
}

function lookup_user_auth($auth) {
    $result = @mysql_query("select * from user where authenticator='$auth'");
    if ($result) {
        $user = mysql_fetch_object($result);
        mysql_free_result($result);
        return $user;
    }
    return null;
}

function lookup_user_id($id) {
    $result = @mysql_query("select * from user where id=$id");
    if ($result) {
        $user = mysql_fetch_object($result);
        mysql_free_result($result);
        return $user;
    }
    return null;
}

function lookup_user_email_addr($email_addr) {
    $result = @mysql_query("select * from user where email_addr='$email_addr'");
    if ($result) {
        $user = mysql_fetch_object($result);
        mysql_free_result($result);
        return $user;
    }
    return null;
}

function lookup_host($id) {
    $result = mysql_query("select * from host where id=$id");
    if ($result) {
        $host = mysql_fetch_object($result);
        mysql_free_result($result);
        return $host;
    }
    return null;
}

function lookup_team($id) {
    $result = mysql_query("select * from team where id=$id");
    if ($result) {
        $team = mysql_fetch_object($result);
        mysql_free_result($result);
        return $team;
    }
    return null;
}

function lookup_team_founder($id) {
    $result = mysql_query("select * from team where userid=$id");
    return $result;
}

function lookup_wu($id) {
    $result = mysql_query("select * from workunit where id=$id");
    if ($result) {
        $wu = mysql_fetch_object($result);
        mysql_free_result($result);
        return $wu;
    }
    return null;
}

function lookup_result($id) {
    $result = mysql_query("select * from result where id=$id");
    if ($result) {
        $r = mysql_fetch_object($result);
        mysql_free_result($result);
        return $r;
    }
    return null;
}

function lookup_app($id) {
    $result = mysql_query("select * from app where id=$id");
    if ($result) {
        $app = mysql_fetch_object($result);
        mysql_free_result($result);
        return $app;
    }
    return null;
}

function lookup_tentative_user($nonce) {
    $result = mysql_query("select * from tentative_user where nonce='$nonce'");
    if ($result) {
        $tu = mysql_fetch_object($result);
        mysql_free_result($result);
        return $tu;
    }
    return null;
}

// apply this to any user-supplied strings used in queries
//
function boinc_real_escape_string($x) {
    if( !$x ) return $x;          // save us the grief
    $a = $x;
     if(0 && version_compare(phpversion(),"4.3.0")>=0 ) {
        return mysql_real_escape_string($x);
    }
    else {
        $slash="\\"; 
        $x = str_replace($slash, $slash.$slash, $x);
        $x = str_replace('"', '\"', $x);
        $x = str_replace("'", "\'", $x);

        // These need to be literal replacements, so don't 
	// treat single/double quote distinction lightly.

        $x = str_replace("\n", '\n', $x);
        $x = str_replace("\r", '\r', $x);
        $x = str_replace("\x00", '\x00', $x);
        $x = str_replace("\x1a", '\x1a', $x);
        debug_msg(3,"string '$a'  replaced with '$x' ");
        return $x;
    }
}

// Process user-supplied text prior to using in query;
// trims whitespace and escapes quotes.
// Does NOT remove HTML tags.
//
function process_user_text($value) {
    $value = trim($value);
    if (get_magic_quotes_gpc()) {
        $value = stripslashes($value);
    }
    return boinc_real_escape_string($value);
}

// escape a string for MySQL "like"
//
function escape_pattern($str) {
    $str = str_replace('_', '\\\\_', $str);
    $str = str_replace('%', '\\\\%', $str);
    return $str;
}

?>
