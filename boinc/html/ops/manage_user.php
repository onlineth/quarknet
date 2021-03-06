<?php
/***********************************************************************\
 * Manage user settings
 *  
 * Displays user settings, allows one to control special user status
 * and forum suspension (banishment).   Put this in html/ops,
 * (or could be used by moderators for bans < 24 hrs).
 *
 * @(#) $Id: manage_user.php,v 1.7 2008/11/13 21:23:15 myers Exp $
\***********************************************************************/

require_once("../inc/util.inc");
require_once("../inc/user.inc");
require_once("../inc/team.inc");
require_once("../inc/forum.inc");
require_once("../inc/util_ops.inc");
require_once("../inc/profile.inc");

require_once("../project/project.inc");

$self = $_SERVER['PHP_SELF'];
$Nbf = sizeof($special_user_bitfield);

db_init();

/*******************************\
 * Authorization
\*******************************/

$logged_in_user = get_logged_in_user(true);
$logged_in_user = getForumPreferences($logged_in_user);

$is_mod =   isSpecialUser($logged_in_user, S_MODERATOR);  
$is_admin = isSpecialUser($logged_in_user, S_ADMIN)
    || isSpecialUser($logged_in_user, S_DEV);

if( !is_admin && !$is_mod ){
    error_page("You must be a project administrator to use this page.");
 }


/*******************************\
 * Functions
\*******************************/

function manage_user_search_box(){
    echo "Search for a participant by name. <P>
        Enter user name:
        <blockquote>
         <input type='text' name='search_text' >
         <input type='submit' name='search_submit' value='Search'>
        </blockquote>
        ";
}

// To trigger banishment on wiki (if there is one)
//
if( file_exists("../include/mediawiki.php") ){
     require_once("../include/mediawiki.php");
 }


// Delete a user (or at least try to)
//
function delete_user($user){
    global $delete_problem;
  
    if( !empty($user->teamid) ){
        user_quit_team($user);
        #$delete_problem .= "Removed user from team.<br/>";
    }
    if( $user->has_profile ){
        mysql_query("DELETE FROM profile WHERE userid = $user->id");
        delete_user_pictures($user->id);
        mysql_query("UPDATE user SET has_profile=0 WHERE id=$user->id");
        #$delete_problem .= "Deleted profile.<br/>";
    }

    if( $user->total_credit > 0.0 ){
        $delete_problem .= "Cannot delete user: User has credit.<br/>";
        return false;
    }  

    // Don't delete user if they have any outstanding Results
    //
    $q = "SELECT COUNT(*) AS count FROM result WHERE userid=".$user->id;
    $result = mysql_query($q);
    $c = mysql_fetch_object($result);
    mysql_free_result($result);
    if($c->count){
        $delete_problem .= "Cannot delete user: User has ". $c->count.
            " Results in the database.<br/>";
    }

    // Don't delete user if they have posted to the forums
    //
    $q = "SELECT COUNT(*) AS count FROM post WHERE user=".$user->id;
    $result = mysql_query($q);
    $c = mysql_fetch_object($result);
    mysql_free_result($result);
    if($c->count){
        $delete_problem .= "Cannot delete user: User has ". $c->count.
            " forum posts.<br/>";
    }
    if($delete_problem) return false;

    $q = "DELETE FROM user WHERE id=".$user->id;
    $result = mysql_query($q);
    $delete_problem .= "User ".$user->id." deleted.";
}
$delete_problem="";


/***********************************************************************\
 * Action: Process user search form
\***********************************************************************/

$matches="";

if( isset($_POST['search_submit']) ){
    $search_name = post_str('search_text');
    $search_name = process_user_text(strip_tags($search_name));

    if( !empty($search_name) ){ 
        $result = mysql_query("SELECT * FROM user WHERE name='$search_name'");

        if( mysql_num_rows($result)==1 ) {
            $user = mysql_fetch_object($result);
            mysql_free_result($result);
        }
        else {
            $q = "SELECT * FROM user WHERE name LIKE '%".$search_name."%'";
            $result = mysql_query($q);
            if( mysql_num_rows($result)==1 ) {
                $user = mysql_fetch_object($result);
                mysql_free_result($result);
            }
            if( mysql_num_rows($result)>1 ) { 
                while( $row = mysql_fetch_object($result) ){ 
                    if( !empty($matches) ) $matches .= ",  ";
                    $matches .= $row->name;
                }
                mysql_free_result($result);
            }
        }
    }
}



/**
 * Look up the user 
 */

$id = get_int("userid", true);
if( empty($id) ) $id = post_int("userid", true);
if( !empty($id) ){ 
    $user = lookup_user_id($id);
}

// but clear if page was reset (forcing search form) 

if( isset($_POST['reset_page']) ){
    unset($user);
}


/**
 * Process special user settings
 */

if( isset($_POST['special_user']) && $user && $is_admin ){
    $bits="";
    for($i=0;$i<$Nbf;$i++) {
        $bits .= $_POST['special_user_'.$i] ? "1" : "0" ;
    }
    $q = "UPDATE forum_preferences SET special_user=\"$bits\" WHERE userid=$id";
    mysql_query($q);
}


/**
 * Process a suspension:
 */

if( isset($_POST['suspend_submit']) && !empty($user) && $is_admin ){
    $dt = post_int('suspend_for',true);

    if( $is_admin || ($is_mod && $dt < 86400) ){
        $reason = $_POST['suspend_reason'];
        if( $dt > 0 && empty($reason)  ) {
            error_page("You must supply a reason for a suspension.
                <p><a href='$self?userid=$user->id'>Try again</a>");
        }
        else {
            if( is_numeric($dt) ) {
                $t = time()+$dt;
                $q = "UPDATE forum_preferences SET banished_until=$t WHERE userid=$id";
                mysql_query($q);

                /* put a timestamp in wiki to trigger re-validation of credentials */

                if( function_exists('touch_wiki_user') ){
                    touch_wiki_user($user);  
                }

                /* Send suspension e-mail to user and administrators */

                if( $dt>0 ){
                    $subject = PROJECT." posting privileges suspended for ". $user->name;
                    $body = "
Forum posting privileges for the " .PROJECT. " user \"".$user->name."\"
have been suspended for " .time_diff($dt). " by ".$logged_in_user->name.". 
The reason given was:
  
   $reason
   
The suspension will end at " .time_str($t)."\n";
                }
                else {
                    $subject = PROJECT." user ". $user->name. " unsuspended";
                    $body = "
Forum posting privileges for the " .PROJECT. " user \"".$user->name."\"
have been restored by ".$logged_in_user->name."\n";
                    if($reason) $body.="The reason given was:\n\n   $reason\n";
                }

                send_email($user, $subject, $body);

                $emails = explode(",", POST_REPORT_EMAILS);
                foreach ($emails as $email) {
                    $admin->email_addr = $email;
                    send_email($admin, $subject, $body);
                }
            }//numerical($dt)
        }
    }
}// suspend_submit


// Process a delete request.  Empty user will trigger search form.
//
if( isset($_POST['delete_user']) && !empty($user) && $is_admin ){
    delete_user($user);
}



// Now update from whatever might have been set above
//
if( !empty($user) ) {
    $user = lookup_user_id($user->id);        // refresh user
    $user=getForumPreferences($user);           // refresh prefs
}

/***********************************************************************\
 * Display the page:
\***********************************************************************/

admin_page_head("User Management: $user->name");
echo "\n<link rel='stylesheet' type=text/css href='". URL_BASE. "new_forum.css'>\n";
echo "\n<link rel='stylesheet' type=text/css href='" .URL_BASE. "arrgh.css'>\n";

echo "<h2>User Managment</h2>\n";

if (!defined("POST_REPORT_EMAILS")) {
    echo "<p><font color='RED'>
   There is no addministrative e-mail address defined for reporting problems
or abuse in the forums.  Please define POST_REPORT_EMAILS in project.inc
        </font></p>\n";
}

echo "<form name='manage_user' action='$self' method='POST'>
        <input type='hidden' name='userid' value='". $user->id."'>  \n";

// If no userid then just show user search form:
//
if( empty($user->id) ) {
    if( !empty($search_name) ){
        echo "No match found. ";
        if( !empty($matches) ) {
            echo " Partial matches are:
                   <blockquote> $matches </blockquote>\n";
        }
    }
    manage_user_search_box();
    echo "\n</form>\n";
 
    if( $delete_problem ){
        echo "<br/><font color='RED'>$delete_problem</font><br/>\n";
    }

    echo "<p>List New Users:
           <a href='list_new_users.php?limit=50'>50</a>,
           <a href='list_new_users.php?limit=100'>100</a>,
           <a href='list_new_users.php?limit=200'>200</a>
        ";

    admin_page_tail();
    exit();
}


start_table();

row1("<div align='right'>
        <input name='reset_page'  type='submit' value='Someone else?'>
      </div>");

$x = "";
if($delete_problem){
    $x = "<br/><font color='RED'>$delete_problem</font><br/>\n";
 }
row1("<table  align='right'><tr><td>
         <input name='delete_user'  type='submit' value='Delete User'>
        </td></tr></table>
        <b>User: </b> ".$user->name. "<br/>  Id# ". $user->id 
        .$x );

show_user_summary_public($user);

// Profile, possibly with picture and review status
//
if($user->has_profile){
    $profile=get_profile($user->id);
    if( ! $profile->has_picture ){
        show_profile_link($user);
    }
    else {
        $status=$profile->verification ;
        $x = "not reviewed";
        if($status>0) $x = "approved";
        if($status<0) $x = "rejected";

        row2("Profile", "<a target='_blank'
                href='" .URL_BASE. "view_profile.php?userid=$user->id'>
             <img align='left' border='1'
                  src='/" . IMAGE_URL . $profile->userid . '_sm.jpg' 
             . "'></a> ($x)");
    }
 }

// Show e-mail address only to admin users
//
if( $is_admin ) {
    $c='RED';
    if($user->email_validated) $c='GREEN';
    row2("E-mail:", "<font color='$c'>$user->email_addr</font>");
}

project_user_summary($user);
end_table();
project_user_page_private($user);

echo "</form>\n";


/**********************
 * Special User status:
 */

echo "\n\n<P>
   <table width='100%'><tr>
   <td width='50%' valign='TOP'> \n";

echo "<form name='special_user' action='$self' method=\"POST\">
        <input type='hidden' name='userid' value='".$user->id."'>  \n";

start_table();
row1("Special User Status: $user->name");

echo "<tr>\n";
for($i=0; $i < $Nbf;$i++) {
    $bit = substr($user->special_user, $i, 1);
    echo "<tr><td>$i)<input type='checkbox'' name='special_user_".$i."' value='1'";
    if ($bit == 1) {
        echo " checked='checked'";
    }
    echo ">". $special_user_bitfield[$i] ."</td></tr>\n";
}
echo "</tr>";

if( $is_admin ) {
    echo "</tr><td colspan=$Nbf align='LEFT'>
        <input name='special_user' type='SUBMIT' value='Apply'>
        </td></tr>\n";
}
end_table();
echo "</form>\n";

echo "\n\n</td><td valign='TOP'>\n\n";


/**********************
 * Suspended posting privileges
 */

echo "<form name='banishment' action='$self' method=\"POST\">
        <input type='hidden' name='userid' value='".$user->id."'>  \n";
start_table();
row1("Suspension: $user->name");

if( $user->banished_until ) {
    $dt = $user->banished_until - time();
    if( $dt > 0 ) {
        $x = " Suspended until " . time_str($user->banished_until)
            ."<br/> (Expires in " . time_diff($dt) .")" ;
    }
    else {
        $x = " last suspended " . time_str($user->banished_until);
    }
    row1($x);
 }

echo "<tr><td>
Suspend user for:
 <blockquote>
        <input type='radio' name='suspend_for' value='3600'> 1 hour   <br/>
        <input type='radio' name='suspend_for' value='7200'> 2 hours  <br/>
        <input type='radio' name='suspend_for' value='18000'> 6 hours  <br/>
        <input type='radio' name='suspend_for' value='36000'> 12 hours  <br/>
        <input type='radio' name='suspend_for' value='86400'> 24 hours  <br/>
";
if( $is_admin ){ // in case we are only a moderator
    echo "
        <input type='radio' name='suspend_for' value='172800'> 48 hours  <br/>
        <input type='radio' name='suspend_for' value='",86400*7,"'> 1 week  <br/>
        <input type='radio' name='suspend_for' value='",86400*14,"'> 2 weeks  <br/>
";
 }


if($dt>0) {
    echo "
        <input type='radio' name='suspend_for' value='-1'>  <b>unsuspend</b>   <br/>";
}
echo "
 </blockquote>

";

echo "<P>Reason (required):\n";
echo "<textarea name='suspend_reason' cols='40' rows='4'></textarea>";
echo "<br><font size='-2' >The reason will be sent to both the user
        and to the project administrators.</font>\n";


echo "<p align='LEFT'><input name='suspend_submit' type='SUBMIT' value='Apply'></P>\n";
echo " </td></tr>\n";

end_table();
echo "</form>\n";

echo "</td></tr>
        </table>\n";


if($q) {
    echo "<P><font color='grey'>Query: $q </font>";
 }
admin_page_tail();

$cvs_version_tracker[]=        //Generated automatically - do not edit
    "\$Id: manage_user.php,v 1.7 2008/11/13 21:23:15 myers Exp $"; 
?>
