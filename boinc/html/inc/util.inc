<?php

require_once("../project/project.inc");
require_once("../inc/countries.inc");
require_once("../inc/db.inc");
require_once("../inc/translation.inc");

function db_init() {
    if (project_is_stopped()) {
        error_page("This page requires database access.
            Our database server is temporarily shut down for maintenance.
            Please try again later. ");
        exit();
    }
    $retval = db_init_aux();
    if ($retval == 1) {
        error_page("Unable to connect to database - please try again later\n".
		"<p><pre><font color='RED'>". mysql_errno(). ") "
		   . mysql_error(). "</font></pre>");
        exit();
    }
    if ($retval == 2) {
        error_page("Unable to select database - please try again later\n".
		"<p><pre><font color='RED'>". mysql_errno(). ") "
		   . mysql_error(). "</font></pre>");
        exit();
    }
}


function send_cookie($name, $value, $permanent, $ops=false) {
    // the following allows independent login for projects on the same server
    //
    $master_url = parse_config(get_config(), "<master_url>");
    $url = parse_url($master_url);
    $path = $url['path'];
    if ($ops) $path = "$path_ops";
    $expire = $permanent?time()+3600*24*365:0;
    setcookie($name, $value, $expire, $path);
}

function clear_cookie($name) {
    $master_url = parse_config(get_config(), "<master_url>");
    $url = parse_url($master_url);
    $path = $url['path'];
    setcookie($name, '', time()-3600, $path);
}


// Initializes the session and returns the authenticator
// for the session (if any)
//
function init_session() {
    $url = parse_url(MASTER_URL);
    $path = $url['path'];
    if (strlen($path)) {
        session_set_cookie_params(0, $path);
    }

    if (session_id() == "") {// first check if there is a session
        session_name( isset($bgSessionName) ? $bgSessionName : "boinc_session");
        session_start(); 
    }
    // NOTE: in PHP 4.1+, s/key_exists/array_key_exists/
    if (array_key_exists('authenticator', $_SESSION)) {
        return $_SESSION["authenticator"];
    } else {
        return NULL;
    }
}

// if not logged in, put up login form and exit
//
function require_login($user) {
    if (!$user) {
        print_login_form();
        page_tail();
        exit();
    }
}

function get_user_from_auth($auth) {
    if ($auth) return lookup_user_auth($auth);
    return NULL;
}

function get_user_from_id($id) {
    if ($id) return lookup_user_id($id);
    return NULL;
}

function get_logged_in_user($must_be_logged_in=true) {
    $authenticator = init_session();
    if (!$authenticator) {
        if (isset($_COOKIE['auth'])) $authenticator = $_COOKIE['auth'];
    }
    if (!$authenticator) {
        if (isset($_COOKIE['boinc_auth'])) $authenticator = $_COOKIE['boinc_auth'];
    }

    $authenticator = process_user_text($authenticator);
    $user = get_user_from_auth($authenticator);
    if ($must_be_logged_in) {
        require_login($user);
    }

    ///////TODO: BOINC/Mediawiki cross-authentication: -EAM 14Jun2006
    if( !empty($authenticator) ) {
        $_SESSION['i2u2_auth']=$authenticator;
    }
    //////////

    return $user;
}

function show_login($user) {
    if ($user) {
        echo "Logged in as %s.\n", $user->name;
        echo "<br><a href='".URL_BASE."login_form.php'>Log in as someone else.</a>\n";
    } else {
        echo "Not logged in";
    }
}

// Page_head() is overridable so that projects that want to integrate BOINC
// with an existing web framework can more easily do so.
// To do so, define page_head() in the project include file.
//
if (!function_exists("page_head")){
function page_head($title, $java_onload=null, $title_plain=null, $prefix="") {
    global $caching;

    if (defined("CHARSET")) {
        header("Content-type: text/html; charset=".tr(CHARSET));
    }

    if (!$caching) {
        header ("Expires: Mon, 26 Jul 1997 05:00:00 UTC");    // Date in the past
        header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " UTC"); // always modified
        header ("Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0");  // HTTP/1.1
        header ("Pragma: no-cache");                          // HTTP/1.0
    }
    
    echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd\">\n";

    if (!$title_plain) {
        echo "<HTML>\n<HEAD><title>".strip_tags($title)."</title>";
    } else {
        echo "<HTML>\n<HEAD><title>".strip_tags($title_plain)."</title>";
    }
    echo "
        <link rel=stylesheet type=text/css href=\"$styleSheet\">
        <link rel='stylesheet' type='text/css' href='" . URL_BASE . "new_forum.css'>
        <link rel='alternate' type='$rsstype' title='$rssname' href='$rsslink' />
        </HEAD>\n";

    if ($java_onload){
        echo "<body bgcolor=ffffff onload=\"".$java_onload."\">"; }
    else {
        echo "<body bgcolor=ffffff>";
    }
    display_cvs_versions();
    project_banner($title, $prefix);
}
}



function page_tail_aux($show_return, $show_date, $prefix="") {
    project_footer($show_return, $show_date, $prefix);
    echo "</body>\n</html>";
}
function page_tail_main($show_date=false) {
    page_tail_aux(false, $show_date);
}

// See the comments for page_head()
//
if (!function_exists("page_tail")){
function page_tail($show_date=false, $prefix="") {
    page_tail_aux(true, $show_date, $prefix);
}
}

function display_cvs_versions(){
    global $cvs_version_tracker;
    echo "\n<!-- CVS VERSIONS -->\n";
    for ($i=0;$i<sizeof($cvs_version_tracker);$i++) {
        echo "<!-- ".$cvs_version_tracker[$i]." -->\n";
    }
}

function db_error_page() {
    page_head("Database error");
    echo "A database error occurred while handling your request.
        <br>Please try again later.
        <br>If the error persists, please submit a
        <a href=bug_report_form.php>problem report</a>.
    ";
    page_tail();
}

function error_page($msg) {
    page_head("Unable to handle request");
    echo $msg;

    // I2U2 additions:

    if( function_exists('show_error_messages') ){
        show_error_messages();
    }

    page_tail();
    exit();
}

// takes argument in second and returns a human formatted time string
// in the form D days + h Hours + m Min + s sec.

function time_diff($x) {
    $days    = (int)($x/86400);
    $hours   = (int)(($x-$days*86400)/3600);
    $minutes = (int)(($x-$days*86400-$hours*3600)/60);
    $seconds = (int)($x % 60);

    $datestring = "";
    if ($days) {
        $datestring .= "$days days ";
    }
    if ($hours || strlen($datestring)) {
        $datestring .= "$hours hr ";
    }
    if ($minutes || (!$hours && !$days) ) {
        $datestring .= "$minutes min ";
    }
    if ($seconds) {
        $datestring .= "$seconds sec";
    }

    return $datestring;
}


function date_str($x) {
    if ($x == 0) return "---";
    return gmdate('j M Y', $x);
}

function time_str($x) {
    if ($x == 0) return "---";
    return gmdate('j M Y G:i:s', $x) . " UTC";
}

function pretty_time_str($x) {
    return time_str($x);
}
function start_table($extra="width=100%") {
    echo "<table border=1 cellpadding=5 $extra>";
}

function start_table_noborder($width="100%") {
    echo "<table border=0 cellpadding=5 width=$width>";
}

function end_table() {
    echo "</table>\n";
}

function row1($x, $ncols=2, $class="heading") {
    echo "<tr><td class=$class colspan=$ncols>$x</td></tr>\n";
}

function row2($x, $y) {
    if ($x=="") $x="<br>";
    if ($y=="") $y="<br>";
    echo "<tr><td width=25% class='fieldname'>$x</td><td class='fieldvalue'>$y</td></tr>\n";
}
function row2_init($x, $y) {
    echo "<tr><td class=fieldname width=40%>$x</td><td valign=top><b>$y\n";
}

function row2_plain($x, $y) {
    echo "<tr><td>$x</td><td>$y</td></tr>\n";
}

function row3($x, $y, $z) {
    echo "<tr><td width=30% valign=top align=right>$x</td><td>$y</td><td>$z</td></tr>\n";
}

function row4($xx, $xy, $yx, $yy) {
    echo "<tr><td width=25% valign=top>$xx</td><td width=25%>$xy</td>"
        . "<td width=25% >$yx</td><td width=%25>$yy</td></tr>
    ";
}

function row5($c1, $c2, $c3, $c4, $c5) {
    echo "<tr>
	<td width=20% valign=top>$c1</td>
	<td width=20% valign=top>$c2</td>
	<td width=20% valign=top>$c3</td>
	<td width=20% valign=top>$c4</td>
	<td width=20% valign=top>$c5</td>
    </tr>
    ";
}



function rowify($string) {
    echo "<tr><td>$string</td></tr>";
}

function row_array($x) {
    echo "<tr>";
    foreach ($x as $h) {
        if (!$h) $h = '<br>';
        echo "<td>$h</td>";
    }
    echo "</tr>\n";
}

function row_heading_array($x) {
    echo "<tr>";
    foreach ($x as $h) {
        echo "<th class=heading>$h</th>";
    }
    echo "</tr>\n";
}

function random_string() {
    return md5(uniqid(rand(), true));
}

function print_login_form_aux($next_url, $user) {
    echo "<P>
        If you do not yet have an account, you can
        <a href='/create_account_form.php'>create one here</a>.
        </P>\n";

    echo "
        <form name='f' method='post' action='login_action.php'>
        <input type='hidden' name='next_url' value='$next_url'>
    ";
    start_table();
    row1("Log in with email/password");
    row2("Email address:", "<input name=email_addr size=40>");
    row2("Password:<br>",
        "<input type='password' name='passwd' size='40'>
         <font size=-2>(<a href='get_passwd.php'>Forgot password?</a>)"
    );
    row2("", "<input type=submit name=mode value='Log in with email/password'>");


    row1("Stay logged in");
    row2("Stay logged in on this computer <br/>
	        <span class='description'>Not recommended for public terminals
		</span>",
        "<input type=checkbox name=send_cookie checked>"
    );

    if ($user) {
        row1("Log out");
        row2("You are logged in as $user->name",
            "<a href=logout.php>Log out</a>"
        );
    }

    if( PROJECT != "I2U2" ){
    row1("Log in with account key:
        <P><font style='font-weight: normal'>
        If you do not remember your password you can 
        <a href='get_passwd.php'>ask for your account key via e-mail</a> 
        and then use that to log in and reset your password. </font>");


    row2("Your account key:",   "<input name=authenticator size=40>"    );
    row2("", "<input type=submit name=mode value='Log in with account key'>");
    }

    end_table();
    echo "
        </form>
        <script>
            document.f.email_addr.focus();
        </script>
    ";
}

function print_login_form() {
    page_head("Please log in");
    echo "<font color='RED'>
        This function requires that you log in.
	</font></br>
    ";
    global $next_url;
    if( empty($next_url) ){
      $next_url = $_SERVER['REQUEST_URI']; // Come back here!
    }
    print_login_form_aux($next_url, null);
    page_tail();
    exit();
}

// Look for an element in a line of XML text
// If it's a single-tag element, and it's present, just return the tag
//
function parse_element($xml, $tag) {
    $element = null;
    $closetag = "</" . substr($tag,1);
    $x = strstr($xml, $tag);
    if ($x) {
        if (strstr($tag, "/>")) return $tag;
        $y = substr($x, strlen($tag));
        $n = strpos($y, $closetag);
        if ($n) {
            $element = substr($y, 0, $n);
        }
    }
    return trim($element);
}

function parse_next_element($xml, $tag, &$cursor) {
    $element = null;
    $closetag = "</" . substr($tag,1);
    $pos = substr($xml,$cursor);
    $x = strstr($pos, $tag);
    if ($x) {
        if (strstr($tag, "/>")) return $tag;
        $y = substr($x, strlen($tag));
        $n = strpos($y, $closetag);
        if ($n) {
            $element = substr($y, 0, $n);
        }
        $cursor = (strlen($xml) - strlen($x)) + strlen($tag) + strlen($closetag) + strlen($element);
    }
    return trim($element);
}

if (!function_exists("file_get_contents")) {
function file_get_contents($path) {
    $x = "";
    $f = fopen($path, "r");
    if ($f) {
        while (!feof($f)) $x .= fread($f, 4096);
        fclose($f);
    }
    return $x;
}
}

$g_config = null;
function get_config() {
    global $g_config;
    if ($g_config == null) {
       $g_config = file_get_contents("../../config.xml");
    }
    return $g_config;
}

// look for a particular element in the ../../config.xml file
//
function parse_config($config, $tag) {
    $element = parse_element($config, $tag);
    return $element;
}

// return true if XML contains either <tag/> or <tag>1</tag>
//
function parse_bool($xml, $tag) {
    $x = "<$tag/>";
    if (strstr($xml, $x)) return true;
    $x = "<$tag>";
    $y = (int)parse_element($xml, $x);
    if ($y != 0) return true;
    return false;
}

// Call this if for dynamic pages
//
function no_cache() {
    header ("Expires: Mon, 26 Jul 1997 05:00:00 UTC");    // Date in the past
    header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " UTC"); // always modified
    header ("Cache-Control: no-cache, must-revalidate");  // HTTP/1.1
    header ("Pragma: no-cache");                          // HTTP/1.0
}

// Generates a legal filename from a parameter string.

function get_legal_filename($name) {
    $name = ereg_replace(',', '', $name);
    return ereg_replace(' ', '_', $name);
}

// Returns a string containing as many words
// (being collections of characters separated by the character $delimiter)
// as possible such that the total string length is <= $chars characters long.
// If $ellipsis is true, then an ellipsis is added to any sentence which
// is cut short.

function sub_sentence($sentence, $delimiter, $max_chars, $ellipsis=false) {
    $words = explode($delimiter, $sentence);
    $total_chars = 0;
    $count = 0;
    $result = '';

    do {
        if ($count > 0) {
            $result = $result . ' ' . $words[$count];
        } else {
            $result = $result . $words[$count];
        }
        $total_chars += strlen($words[$count]) + 1;
        $count++;
    } while ($count < count($words) && ($total_chars + strlen($words[$count])) <= $max_chars);

    if ($ellipsis && ($count < count($words))) {
        $result = $result . '...';
    }

    return $result;
}

function format_credit($x) {
    return number_format($x, 2);
}

function project_is_stopped() {
    if (file_exists("../../stop_web")) return true;
    return false;
}

function user_links($user) {
    $x = "<a href=show_user.php?userid=$user->id>$user->name</a>";
    if ($user->has_profile) {
        $x .= " <a href=view_profile.php?userid=$user->id><img border=0 src=img/head_20.png></a>";
    }
    # Does this project accept donations?
    # If so, do you want to have a link next to user name as it appears on the web site?
    if ($user->donated == 1) { 
        require_once("../project/donations.inc");
        $x .= DONATION_LINK;
    }
    return $x;
}

function host_link($hostid) {
    if ($hostid) {
        return "<a href=show_host_detail.php?hostid=$hostid>$hostid</a>";
    } else {
        return "---";
    }
}

function open_output_buffer() {
    ob_start();
    ob_implicit_flush(0);
}

function close_output_buffer($filename) {
    $fh = fopen($filename, "w");
    $page = ob_get_contents();
    ob_end_clean();
    fwrite($fh, $page);
    fclose($fh);
}

function html_info() {
    return "<br><a href=\"bbcode.php\" target=\"_new\"><font size=-2>".tr(FORUM_HTML_INFO)."</font></a>\n";
}

function get_int($name, $optional=false) {
    $x=null;
    if (isset($_GET[$name])) $x = $_GET[$name];
    if (!is_numeric($x)) {
        if ($optional) {
            return null;
        } else {
            error_page("missing or bad parameter: $name $x");
        }
    }
    return (int)$x;
}

function post_int($name, $optional=false) {
    $x = null;
    if (isset($_POST[$name])) $x = $_POST[$name];
    if (!is_numeric($x)) {
        if ($optional) {
            return null;
        } else {
            error_page("missing or bad parameter: $name $x");
        }
    }
    return (int)$x;
}

function get_str($name, $optional=false) {
    $x = null;
    if (isset($_GET[$name])) $x = $_GET[$name];
    if (!$x && !$optional) {
        error_page("missing or bad parameter: $name");
    }
    return $x;
}

function get_venue($name) {
    $x = $_GET[$name];
    if ($x == "") return $x;
    if ($x == "home") return $x;
    if ($x == "work") return $x;
    if ($x == "school") return $x;
    error_page("no such venue: $x");
}

function post_str($name, $optional=false) {
    if( !isset($_POST[$name]) ) return NULL;
    $x = $_POST[$name];
    if (!$x && !$optional) {
        error_page("missing or bad parameter: $name");
    }
    return $x;
}

function is_ascii($str) {
    // the mb_* functions are not included by default
    // return (mb_detect_encoding($passwd) -= 'ASCII');

    for ($i=0; $i<strlen($str); $i++) {
        $c = ord(substr($str, $i));
        if ($c < 32 || $c > 127) return false;
    }
    return true;
}

// This function takes as input a GET variable name X and value Y.
// It returns the corresponding text GET variable string, appended with
// any existing GET variable names and values, with &X=Y.
//
// This is useful for constructing urls for sorting a table by different
// columns.
//
function make_GET_list($variable_name, $variable_value) {
    $retval="";
    $sepchar='?';
    $modified=false;
    foreach ($_GET as $key => $value) {
        $retval .= "$sepchar"."$key=";
        $sepchar='&';
        if ($key==$variable_name) {
            $modified=true;
            if ($value!=$variable_value) {
                $retval .= "$variable_value";
            } else {
                $retval .= "$variable_value"."_reversed";
            }
        }
        else {
            $retval .= "$value";
        }
    }
    if (!$modified) $retval .= "$sepchar$variable_name=$variable_value";
    return $retval;
}

function link_with_GET_variables($text, $baseurl, $variable_name, $variable_value) {
        $list=make_GET_list($variable_name, $variable_value);
        return "<a href=\"$baseurl$list\">$text</a>";
}

//Generated automatically - do not edit
$cvs_version_tracker[]="\$Id: util.inc,v 1.13 2009/05/29 13:22:31 myers Exp $";  
?>
