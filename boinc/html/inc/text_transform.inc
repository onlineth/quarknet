<?php
require_once('../inc/sanitize_html.inc');

class output_options {
	var $bb2html;		// BBCode as HTML? (on)
	var $boincdoc;		// Transform [[Wikiwords]] in to wiki links (on)
	var $images_as_links;	// Images as hyperlinks? (off)
	var $link_popup;	// Links in new windows? (off)
	var $closeTags;		// Close extra HTML tags? (on)
	var $nl2br;		// Convert newlines to <br>'s? (on)
	var $htmlitems;		// Convert special chars to HTML entities? (on)
	var $htmlscrub;		// Scrub "bad" HTML tags? (off)
	var $stripslashes;	// Strip slashes (depends)
	
	function output_options() {
		// Set defaults - should we DEFINE these somewhere else?
		$this->bb2html = 1;
		$this->boincdoc = 1;
		$this->images_as_links = 0;
		$this->link_popup = 0;
		$this->closeTags = 1;
		$this->nl2br = 1;
		$this->htmlitems = 1;
		$this->htmlscrub = 1;
	    if (get_magic_quotes_gpc()) {
     	   $this->stripslashes = 1;
    	}
		return true;
	}
}

function output_transform($text, $options = NULL) {
	// Options is a output_options object, defined above
	if (!$options) {
		$options = new output_options; // Defaults in the class definition
	}
	
	if ($options->stripslashes) {
		$text = stripslashes($text);
	}
	if ($options->htmlitems) {
		//$text = htmlentities($text);
		$text = htmlspecialchars($text);
	}
	if ($options->htmlscrub) {
		$text = sanitize_html($text);
	}
	if ($options->nl2br) {
		$text = nl2br($text);
	}
	if ($options->bb2html) {
		$text = bb2html($text);
	}
	if ($options->boincdoc) {
		$text = boincdoc($text);
	}
	if ($options->images_as_links) {
		$text = image_as_link($text);
	}
	if ($options->link_popup) {
		$text = externalize_links($text);
	}
	
	return $text;
}

function get_transform_settings_from_user($user, $options = '') {
	// $user - a user object
	// $options - a output_options object (optional)
	if (!$options) {
		$options = new output_options; // Give defaults
	}
	if ($user->images_as_links==1){
		$options->images_as_links = 1;
	}
	if ($user->link_popup==1){
		$options->link_popup = 1;
	}
	return $options;
}

function bb2html($text) {
	// Function converts bbcode to HTML
	
	$urlregex = "(?:\"?)(?:(http\:\/\/)?)([^\[\"<\ ]+)(?:\"?)";
	// List of allowable tags
	$bbtags = array (
		"@\[b\](.*?)\[/b\]@is",
		"@\[i\](.*?)\[/i\]@is",
		"@\[u\](.*?)\[/u\]@is",
		"@\[link=$urlregex\](.*?)\[/link\]@i",		
		"@\[link\]$urlregex\[/link\]@i",
		"@\[url=$urlregex\](.*?)\[/url\]@i",		
		"@\[url\]$urlregex\[/url\]@i",
		"@\[quote=(.*?)\](.*?)\[/quote\]@is",
		"@\[quote\](.*?)\[/quote\]@is",
		"@\[font=(.*?)\](.*?)\[/font\]@is",
		"@\[list\](.*?)\[/list\]@is",
		"@\[list=1\](.*?)\[/list\]@is",  
		"@\[pre\](.*?)\[/pre\]@is",
		"@\[img\]$urlregex\[/img\]@is",
		"@\[color=(?:\"?)(.{3,8})(?:\"?)\](.*?)\[/color\]@is",
		"@((?:<ol>|<ul>).*?)\n\*([^\n]+)\n(.*?(</ol>|</ul>))@is",
		"@\[size=([1-9]|[0-2][0-9])\](.*?)\[/size\]@is",
		"@\[code\](.*?)\[/code\]@is",
		"@\[mailto\](.*?)\[/mailto\]@is",
		"@\[email\](.*?)\[/email\]@is",		  
		"@\[size=((\+|-)[1-7])\](.*?)\[/size\]@is"
		//Note:	The above list array member ensures we're within a list
		//		when doing list item transformations.
		//TODO: Make sure we're not between two lists
		);
	
	// What the above tags are turned in to
	$htmltags = array (
		"<b>\\1</b>",
		"<i>\\1</i>",
		"<u>\\1</u>",
		"<a href=\"http://\\2\">\\3</a>",
		"<a href=\"http://\\2\">http://\\2</a>",
		"<a href=\"http://\\2\">\\3</a>",
		"<a href=\"http://\\2\">http://\\2</a>",
		"<div style='font-style: oblique'>\\1 wrote:</div><blockquote class='postbody'>\\2</blockquote>",
		"<blockquote class='postbody'>\\1</blockquote>",
		"<font face=\\1>\\2</font>",
		"<ul>\\1</ul><p>",
		"<ol>\\1</ol><p>",
		"<pre>\\1</pre>",
		"<img src=\"http://\\2\">",
		"<font color=\"\\1\">\\2</font>",
		"\\1<li>\\2</li>\n\\3",
		"<span style=\"font-size: \\1px;\">\\2</span>",
		"<div class=\"code\">\\1</div>",
		"<a href=\"mailto:\\1\">\\1</a>",
		"<a href=\"mailto:\\1\">\\1</a>",
		"<font size='\\1'>\\3</font>"
		);
		
	// Do the actual replacing - iterations for nested items
	$lasttext = "";
	$i = 0;
	// $i<10 to prevent DoS
	while ($text != $lasttext && $i<11) {
		$lasttext = $text;
		$text = preg_replace($bbtags,$htmltags,$text,11);
		$i = $i + 1;
	}
	return $text;
}

function boincdoc ($text) {
	$wikimatch = "@\[\[(.[\'0-9a-zA-Z\@\ \_\-\:]+)\]\]@ise";
	$wikititlematch = "@\[\[(.[\'0-9a-zA-Z\@\ \_\-]+)([|])([0-9a-zA-Z\_\-\ ]+)\]\]@ise";
	$wikichange = "boincdoc_linkcreate('\\1')";
	$wikititlechange = "boincdoc_linkcreate('\\1', '\\3')";
	$text = preg_replace($wikititlematch, $wikititlechange, $text);
	$text = preg_replace($wikimatch, $wikichange, $text);
	return $text;
}


/**
 * Callback function for the above.
 * This function is only called from boincdoc() 
 * MODIFIED TO ALLOW w:Word to link to wikipdedia
 * MODIFIED for QNFL:word to link to QuarkNet Fellows Library
 * MODIFIED for bz:number to link to Bugzilla
 * TODO: allow all the interwiki links allowed on our wiki
 */

function boincdoc_linkcreate ($wikitext,$title = '') {

    // Plain wiki links, no namespace
    $wiki_url="/library/index.php?title=";

    $wikitext = str_replace(' ', '_', $wikitext); // Spaces become underscores
    $wiki_text= urlencode($wikitext);

    // Interwiki Link to Wikipedia 
    //
    if( strpos($wikitext, 'w:') === 0 ) {
        $wikitext= preg_replace('/^w\:/', '', $wikitext);
        $wiki_url="http://en.wikipedia.org/wiki/";
    }

    // QuarkNet Fellows Library  (IS TO BE MERGED IN WITH main wiki)
    //
    if( strpos($wikitext, 'QNFL:') === 0 ) {
        $wikitext= preg_replace('/^QNFL\:/', '', $wikitext);
        $wiki_url="http://www.i2u2.org/cosmic/library/index.php/";
    }

    // Bugzilla
    //
    if( strpos($wikitext, 'bz:') === 0 ) {
        $wikitext= preg_replace('/^bz\:/', '', $wikitext);
        $wiki_url="http://bugzilla.mcs.anl.gov/i2u2/show_bug.cgi?id=";
    }
 

    $hyperlink = "<a href=\"".$wiki_url.$wikitext."\">";

	if ($title != '') {
		$hyperlink .= "$title</a>";
	} else {
		$hyperlink .= "$wikitext</a>";
	}
	return $hyperlink;
}




function externalize_links($text) {
	// TODO:  Convert this to PCRE
    $out="";
    $i=0; $linkpos=true;
    while (true){                                //Find a link
        $linkpos=strpos($text,"<a ",$i);
        if ($linkpos===false) break;
        $out.= substr($text,$i,$linkpos-$i)."<a target=\"_new\" ";        //Replace with target='_new'
        $i=$linkpos+3;
    }
    $out.=substr($text,$i);
    return $out;
}

function image_as_link($text){ /* This function depends on sanitized HTML */
    // Build some regex (should be a *lot* faster)
    $pattern = '@<img src=([^>]+)>@si'; // Gives us the URL in ${1}...
    $replacement = '<a href=${1}>[Image Link]</a>'; // Turns that URL into a hyperlink
    $text = preg_replace($pattern, $replacement, $text);
    return $text;
}

function closeTags($str = null) {
	// Function from http://episteme.arstechnica.com/eve/ubb.x/a/tpc/f/6330927813/m/139006252731/r/287008552731#287008552731
	// (thanks Ageless for finding it)
	// Edited by Rob to better fit in with boinc's needs
	
	// List of tags to check $str for
	// TODO:  Adapt to use the pre-existing array of tags above
	$tags = array('b', 'i', 'a', 'p', 'font[^>]?', 'strong', 'ul', 'li', 'pre', 'blockquote', 'u');
	// Note on $tags - no br or img, as they have no closing tags - can we define this above?
	// Maybe define two arrays, those with closing tags and those without, and combine the
	// two of them for the standard HTML sanitizing function?

	// Don't do anything if the string is too short
	if (strlen($str) < 3) {
		return $str;
	} else {
		// Loop over $str and count the opening and closing for each tag in $tags
		foreach ($tags as $tag) {
			$m = array();
			$o = preg_match_all("/<(".$tag.")>/", $str, $m);
			$c = substr_count($str, "</{$tag}>");

			$open[$tag]  = ($o < $c) ? $c - $o : 0;
			$close[$tag] = ($c < $o) ? $o - $c : 0;

			// Debuggin'
			//echo "<pre>Tag: {$tag}\nOpen: {$o}\nClose: {$c}\nOT: {$open[$tag]}\nCT: {$close[$tag]}</pre><hr />";
		}

		// Prepend the return string with an opening tag as needed
		/* $pre = '';  ...uhh... doesn't work right

		foreach ($open as $tag => $cnt) {
			$pre .= ($cnt > 0) ? "<{$tag}>" : '';
		}  */

		// Append the return string with a closing tag as needed
		$post = '';

		foreach ($close as $tag => $cnt) {
			$post .= ($cnt > 0) ? "</{$tag}>" : '';
		}

		return /*$pre.*/$str.$post;
	}
}

function cleanTextBox($content) {
	/* Cleans current text boxes for display.  Will be replaced with just an
	 * htmlentities() call after we stop allowing HTML posting.
	 */
	$answer  = preg_replace('/&lt;/','&amp;lt;',preg_replace('/&gt;/','&amp;gt;',$content));
	return $answer;
}


/**
 * Highlight terms in text (most likely used with searches)
 **/
function highlight_terms($text, $terms) {
    $search = $terms;
    $replace = array();

    foreach ($search as $key => $value) {
	$replace[$key] = "<span class=\"highlight\">".$value."</span>";
    }
    if (substr(phpversion(), 0, 1) > 4) {   // PHP 4.x doesn't support str_ireplace
        return str_ireplace($search, $replace, $text);
    } else {
        return str_replace($search, $replace, $text);
    }
}

?>
