<?php

require_once('../inc/forum.inc');
require_once('../inc/util.inc');
require_once('../inc/translation.inc');

db_init();

$logged_in_user = get_logged_in_user();

// decorate object with forum preference info (uses DB)
// needed to see if user is 'special'.
$logged_in_user = getForumPreferences($logged_in_user);

// if user is a project admin or project developer or forum admin,
// allow them to edit their own posts indefinitely.
$is_spec = isSpecialUser($logged_in_user,0) ||
           isSpecialUser($logged_in_user,1) ||
           isSpecialUser($logged_in_user,2);

$postid = get_int("id");
$post = getPost($postid);
if( !$post ) {
    error_page("No such post");
}

/* Process posted edit */

if ($_POST['submit']) {    
    $thread = getThread($post->thread);

    if (!$is_spec && (time() > $post->timestamp + MAXIMUM_EDIT_TIME)){
	echo "You can no longer edit this post.<br />Posts can only be edited at most ".(MAXIMUM_EDIT_TIME/60)." minutes after they have been created.";
	exit();
    }
    if ($logged_in_user->id != $post->user) {
	//if (!(isSpecialUser($logged_in_user,0)) && ($logged_in_user->id != $post->user)) {
        // Can't edit other's posts unless you're a moderator
        echo "You are not authorized to edit this post.";
        exit();
    }
    
    
    updatePost($post->id, $_POST['content']);
    if ($post->parent_post==0 and $thread->owner==$logged_in_user->id){
        updateThread($thread->id, $_POST['title']);
    }

    header('Location: forum_thread.php?id='.$thread->id);
    exit;
}


$thread = getThread($post->thread);
$forum = getForum($thread->forum);
$category = getCategory($forum->category);


/* Check to see that posting is allowed by this user in this forum/thread  */

if( function_exists('check_posting_is_allowed') ){
    if( !check_posting_is_allowed($logged_in_user, $forum, $thread) ){
        error_page("You are not allowed to post to this forum");
    }
 }

page_head('Forum');

if (!$is_spec && (time() > $post->timestamp + MAXIMUM_EDIT_TIME)){
	echo "You can no longer edit this post.<br />Posts can only be edited at most ".(MAXIMUM_EDIT_TIME/60)." minutes after they have been created.";
	exit();
}

if ($logged_in_user->id != $post->user) {
    //if (!(isSpecialUser($logged_in_user,0)) && ($logged_in_user->id != $post->user)) {
    // Can't edit other's posts 
    echo "You are not authorized to edit this post.";
    exit();
}

show_forum_title($forum, $thread, $category->is_helpdesk);

echo "<form action=forum_edit.php?id=$post->id method=POST>\n";

start_table();
row1("Edit your post");
if ($post->parent_post==0 and $thread->owner==$logged_in_user->id) {
	//If this is the first post enable the user to change title
    row2(
	    tr(FORUM_SUBMIT_NEW_TITLE).html_info(),
	    "<input type=text name=title value='".stripslashes($thread->title)."'>"
    );
};

row2(tr(FORUM_MESSAGE).html_info().post_warning(),
    "<textarea name='content' rows=12 cols=80>".cleanTextBox(stripslashes($post->content))."</textarea>"
);
row2("",
    "<input type=submit name=submit value=OK>"
);

end_table();

echo "</form>";

page_tail();

?>
