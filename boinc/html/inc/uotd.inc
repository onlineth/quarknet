<?php

require_once('../inc/profile.inc');

define('UOTD_THRESHOLD', 7);

function uotd_thumbnail($profile, $user) {
    if ($profile->has_picture) {
        return "<a href=view_profile.php?userid=$user->id><img border=0 vspace=4 hspace=8 align=left src=" . IMAGE_URL . $user->id . "_sm.jpg></a>";
    } else {
        return "";
    }
}

function generate_uotd_page($profile, $user) {
    $filename = PROFILE_PATH."uotd.html";
    $descriptor = fopen($filename, "w");

    if ($profile->has_picture) {
        fwrite($descriptor, uotd_thumbnail($profile, $user));
    }
    $x = user_links($user);
    fwrite($descriptor, "The " . PROJECT . " User of the Day is $x");
    fclose($descriptor);
}

// return the last UOTD profile, or null
//
function get_current_uotd() {
    $result = mysql_query("SELECT * FROM profile ORDER BY uotd_time DESC LIMIT 1");
    $p = null;
    if (mysql_num_rows($result) > 0) {
        $p = mysql_fetch_object($result);
    }
    mysql_free_result($result);
    return $p;
}

// Generate the UOTD page;
// see if it's time to pick a new UOTD.
//
function build_uotd_page() {
    echo date("F d Y", time())."\n";
    $current_uotd = get_current_uotd();
    if ($current_uotd) {
        $assigned = getdate($current_uotd->uotd_time);
        $now = getdate(time());
        if ($assigned['mday'] == $now['mday']) {
            $user = lookup_user_id($current_uotd->userid);
            generate_uotd_page($current_uotd, $user);
            echo "Already have UOTD for today\n";
            exit();
        }
    }

    // get a list of profiles that have been 'approved' for UOTD,
    // using a project-specific query if supplied in project.inc
    //
    if (function_exists('uotd_candidates_query')) {
        $query = uotd_candidates_query();
    } else {
        $query = default_uotd_candidates_query();
    }
    $result = mysql_query($query);

    if ( !$result ){
        // No valid users of the day - do something.
        error_log("No UOTD candidate results returned from database.\n");
        exit();
    }

    // If the number of approved profiles dips below a threshold,
    // email the sys admin every time we pick a new one.
    //
    if ($result && mysql_num_rows($result) < UOTD_THRESHOLD) {
        mail(SYS_ADMIN_EMAIL,
            PROJECT . ": User of the Day pool is running low!",
            "The pool of approved candidates for User of the Day has".
            " reached your assigned threshold: there are now only " . mysql_num_rows($result) . " approved users.\n\n".
            "To approve more candidates for User of the Day,".
            " go to the " . PROJECT . " administration page and click \"Unrated profile\""
        );
    }

    if ( $result && mysql_num_rows($result) == 0) {
        // If all verified profiles have been selected as UOTD,
        // reshow the one that was shown least recently.
        //
        // $result = mysql_query("SELECT * FROM profile,user WHERE profile.userid=user.id AND total_credit>0 AND verification=1 ORDER BY uotd_time ASC LIMIT 1");
        // NO, JUST LEAVE THEM ALONE.
        error_log("No UOTD candidate found.\n");
        echo "No UOTD candidates found.\n";
        mysql_free_result($result);
        exit();
    }

    $profile = mysql_fetch_object($result);
    mysql_free_result($result);
    $user = lookup_user_id($profile->userid);
    generate_uotd_page($profile, $user);

    $sql = "UPDATE profile SET uotd_time = ".time()." WHERE userid=$user->id";
    mysql_query($sql);

    send_email($user,
        "You are the " . PROJECT . " User of the day!",
        "Congratulations!\n\nYou have been chosen as the "
        . PROJECT . " User of the day!\n"
        . "Your profile will be featured on the " . PROJECT
	. " website for the next 24 hours."
    );

    echo "User $user->id ($user->name) is now UOTD\n";
}


// This is the default policy for choosing the UOTD on any BOINC project.
// To override this with your own policy, create a similar function in
// your own project.inc called uotd_candidates_query()
//
function default_uotd_candidates_query(){
    if (profile_screening()) {
        $query = "SELECT * FROM profile,user WHERE profile.userid=user.id ";
        $query .= " AND verification=1 ";
        $query .= " AND expavg_credit>1 ";
        $query .= " AND uotd_time IS NULL ";
        $query .= "ORDER BY RAND()";
    } else {
        $query = "SELECT * FROM profile,user WHERE profile.userid=user.id ";
        $query .= " AND verification=1 ";
        $query .= " AND uotd_time IS NULL ";
        $query .= "ORDER BY RAND()";
    }
    return $query;
}

// get a list of profiles that have been 'approved' for UOTD,
// using a project-specific query if supplied in project.inc
//
function count_uotd_candidates(){
    $n = -1;                    // negative value returned on error
    if (function_exists('uotd_candidates_query')) {
        $query = uotd_candidates_query();
    } else {
        $query = default_uotd_candidates_query();
    }
                                                
    $result = mysql_query($query);
    if($result) {
        $n = mysql_num_rows($result);
    }
    mysql_free_result($result);
                                                                        
    return $n;
}

?>
