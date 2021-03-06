<?php

require_once("../project/project.inc");
require_once("../inc/profile.inc");
require_once("../inc/util.inc");
require_once("../inc/uotd.inc");


$alphabet = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9');


// Generates a standard set of links between associated multi-page documents.
//  All linked files must be of the form "$filename_<page number>.html".

function write_page_links($filename, $currPageNum, $numPages) {
    echo "<p>Page $currPageNum of $numPages</p>";

    $nextPageNum = $currPageNum + 1;
    $prevPageNum = $currPageNum - 1;

    // Make the 'previous' and 'next' page links as appropriate.
    if ($currPageNum > 1) {
        echo "<a href={$filename}_{$prevPageNum}.html>Previous page</a>";

        if ($currPageNum != $numPages) {
            echo " | ";
        }
    }
    if ($currPageNum != $numPages) {
        echo "<a href={$filename}_{$nextPageNum}.html>Next page</a>";
    }

    echo "<p>Jump to Page:\n";

    // Make the individual page links (or a bold non-link for the current page).
    //
    for ($i = 1; $i <= $numPages; $i++) {
        if ($i != $currPageNum) {
            echo "<a href={$filename}_{$i}.html>$i</a>\n";
        } else {
            echo "<b>$i</b>\n";
        }
    }

}

// Generates the html files which comprise the photo gallery.
//   $room: which gallery to generate (user, computer).
//   $width: the width of the table of images.
//   $height: the height of the table of images.
//
function build_picture_pages($width, $height) {

    // TODO: Add support for a computer image gallery.

    // TODO: Should we eliminate the has_picture flag?  Doesn't really
    // seem necessary when we're building static pages- could just use
    // file_exists on the username...

    // TODO: Standardize "Last modified" string to a function call (util.inc).

    if (profile_screening()) {
        $query = "SELECT userid FROM profile WHERE has_picture = 1 AND verification=1";
    } else {
        $query = "SELECT userid FROM profile WHERE has_picture = 1";
    }
    $result = mysql_query($query);
    $numIds = mysql_num_rows($result);

    //echo "Result has $numIds rows.<br>";

    // Build an array of IDs of all users with pictures in their profiles.
    while ($row = mysql_fetch_array($result, MYSQL_NUM)) {
        $userIds[] = $row[0];
    }

    mysql_free_result($result);

    if (count($userIds) > 0) {
        // Randomize the ordering of users.
        shuffle($userIds);
    }

    $numPages = ceil(count($userIds)/($width * $height));

    // Make sure that a page is generated even when no profiles with pictures
    // exist in order to avoid 404 errors from the profile_menu page.

    if ($numPages == 0) {
        $numPages = 1;
    }

    //echo "Generating $numPages pages.<br>";

    $count = 0;

    for ($page = 1; $page <= $numPages; $page++) {
        $filename = PROFILE_PATH . "user_gallery_" . $page . ".html";
        open_output_buffer();

        page_head("Profile gallery: page $page of $numPages", null, null, "../");

        echo "Last updated ", pretty_time_str(time()),
            "\n<p>Browse the user profiles by picture.
            Only user profiles with pictures are listed here.";


        echo "<table class=bordered border=1 cellpadding=5\n";

        for ($row = 0; $row < $height; $row++) {
            echo "<tr>";
            for ($col = 0; $col < $width; $col++) {
	            if ($count < $numIds) {
                    echo "<td class=bordered align=\"center\"><a href=\"",
                        URL_BASE, "view_profile.php?userid=",
                        $userIds[$count], "\"><img src=\"",
                        URL_BASE, IMAGE_URL, $userIds[$count],
                        "_sm.jpg\"></a></td>";

                    $count++;
                }
            }
            echo "</tr>\n";
            if ($count == $numIds) {
                break;
            }
        }

        echo "</table>\n";

        // Previous and Next links

        write_page_links("user_gallery", $page, $numPages);

        page_tail(false, "../");

        close_output_buffer($filename);
    }

    //echo "<br><br><a href=\""  .PROFILE_PATH . "user_gallery_1.html\">Go to the first generated page.</a>";
}

// Creates pages grouping user profiles by country.  Filenames are of the
// format "profile_country_<country name>_<page number>.html"
// Also creates a summary page listing all countries which have profiled
// members, the number of such members, and links to the created pages for
// each country.

function build_country_pages() {
    $query = "select * from profile";
    $result = mysql_query($query);
    $numIds = 0;

    // Build a multi-dimensional array of countries,
    // each element of which contains an array
    // of the userids who belong to those countries.
    // Format: array[country][index] = userid.

    while ($profile = mysql_fetch_object($result)) {
        $user = lookup_user_id($profile->userid);
        if ($user->country) {
            $countryMembers[$user->country][] = $user->id;
            $numIds++;
        } else if ($user) {
            $countryMembers['Other'][] = $user->id;
        }
    }

    mysql_free_result($result);

    //echo "$numIds users have profiles AND non-null country entries.<br>";

    $countries = array_keys($countryMembers);
    sort($countries);

    // Build the pages.
    // TODO: Define a constant for the desired number of rows per page.

    foreach ($countries as $country) {
        $baseFileName =  "profile_country_" . get_legal_filename($country);
        $filePath = PROFILE_PATH;
        build_profile_pages(
            $countryMembers[$country],
            "User Profiles from $country", $country, 5, 2,
            $filePath, $baseFileName, "../html/"
        );
    }

    // Build the summary page linking to the individual country pages.

    build_country_summary_page($countryMembers);

    //echo "<br><a href=\"" . PROFILE_PATH . "profile_country.html\">View Summary Page</a>";
    //echo "<br><br>Done";

}

// Creates pages grouping users by the first letter of their names.

function build_alpha_pages() {
    global $alphabet;

    $query = "select * from profile";
    $result = mysql_query($query);
    $numIds = 0;

    while ($profile = mysql_fetch_object($result)) {
        $user = lookup_user_id($profile->userid);

        if ($user->name) {
            $name = ltrim($user->name);
            $members[strtoupper($name[0])][] = $user->id;
            $numIds++;
        }
    }

    mysql_free_result($result);

    //echo "$numIds users have profiles AND non-null country entries.<br>";

    $letters = array_keys($members);

    foreach ($letters as $letter) {
        // NOTE: Array indexing is case sensitive.
        $filePath = PROFILE_PATH;
        if (in_array($letter, $alphabet)) {
            build_profile_pages(
                $members[$letter],
                "User Profiles - Names beginning with $letter",
                "Names beginning with $letter", 5, 2, $filePath,
                "profile_$letter"
            );
        } else {
            build_profile_pages(
                $members[$letter],
                "User Profiles - Names beginning with other characters",
                "Names beginning with other characters", 5, 2, $filePath,
                "profile_other"
            );
        }
        $letters_used[$letter] = 1;
    }

    build_alpha_summary_page($letters_used);
}

// A generalized function to produce some number of pages summarizing a
// set of user profiles.

function build_profile_pages($members, $pageHead, $pageTitle, $rowsPerPage, $colsPerPage, $filePath, $baseFileName) {
    $numMembers = count($members);
    $numPerPage = $rowsPerPage * $colsPerPage;
    $numPages = ceil(count($members) / $numPerPage);

    $count = 0;

    for ($page = 1; $page <= $numPages; $page++) {

        $filename = $filePath . $baseFileName . "_" . $page . ".html";
        open_output_buffer();

        //I2U2// Privacy restriction.  The page can only be read by logged in users
        echo "<?php\n   require_once(\"../inc/profile.inc\");\n db_init();
                \$logged_in_user=get_logged_in_user(true); \n?>\n";
        //I2U2//

        $head = $pageHead . ": Page $page of $numPages";
        page_head($pageTitle, null, null, "../");

        echo "Last updated ", pretty_time_str(time()), "<p>\n";

        $offset = (($page-1) * $rowsPerPage * $colsPerPage);

        show_user_table($members, $offset, $numPerPage, $colsPerPage);

        write_page_links($baseFileName, $page, $numPages);

        page_tail(false, "../");

        close_output_buffer($filename);
    }

}

function build_country_summary_page($countryMembers) {
    $countries = array_keys($countryMembers);

    $filename = PROFILE_PATH . "profile_country.html";
    open_output_buffer();

    page_head("User Profiles by State or Country", null, null, "../");
    echo "Last updated " . pretty_time_str(time()) . "<p>";

    echo "<table border=0>\n";
    echo "<tr><td><b>Country</b></td><td align=\"center\"><b>Profiles</b></td></tr>\n";

    foreach ($countries as $country) {
        $numMembers = count($countryMembers[$country]);
        $name = get_legal_filename($country);

        echo "<tr>\n<td><a href=\"profile_country_",
            "{$name}_1.html\">$country</a></td><td align=\"center\">$numMembers</td></td>\n";
    }

    echo "</table>";
    page_tail(false, "../");

    close_output_buffer($filename);
}

function build_alpha_summary_page($characters_used) {
    global $alphabet;

    $filename = PROFILE_PATH."profile_alpha.html";
    open_output_buffer();

    foreach ($alphabet as $character) {
        if (isset($characters_used[$character])) {
            echo "<a href=", URL_BASE, PROFILE_URL, "profile_{$character}_1.html>$character</a>&nbsp;";
            unset($characters_used[$character]);
        } else {
            echo "$character ";
        }
    }

    // Link to the 'Other' page if necessary.
    if (!empty($characters_used)) {
        echo "<a href=", URL_BASE, PROFILE_URL, "profile_other_1.html>Other</a>&nbsp;";
    }
    close_output_buffer($filename);
}

?>
