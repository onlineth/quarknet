<?php  
/***********************************************************************\ 
 * LocalSettings.php for I2U2 libraries.
 * 
 * This file was originally generated by the MediaWiki installer
 * on 11 September 2007, then modified by Eric Myers <myers@spy-hill.net>
 * See includes/DefaultSettings.php for all configurable settings
 * and their default values, but don't forget to make changes in _this_
 * file, not there.
 *
 * If you customize your file layout, set $IP to the directory that contains
 * the other MediaWiki files. It will be used as a base to locate files.
 *
 * This version of LocalSettings.php should work for the several wikis
 * we are now using (June 2009) and for the variety of access points
 * (different URL paths) we provide.  At least that is the theory.
 *
 * First Created: -EAM 11Sep2007
 * Last changed:  -EAM 17Jun2009
 * 
 * @(#) $Id: LocalSettings.php,v 1.10 2009/05/07 20:33:07 myers Exp $ 
\***********************************************************************/

if( defined( 'MW_INSTALL_PATH' ) ) {
	$IP = MW_INSTALL_PATH;
} else {
	$IP = dirname( __FILE__ );
}

$path = array( $IP, "$IP/includes", "$IP/languages" );
set_include_path( implode( PATH_SEPARATOR, $path ) . PATH_SEPARATOR . get_include_path() );

require_once( "includes/DefaultSettings.php" );

# Command line scripts may also use the options set here.
# This is just a consistency check.
if ( $wgCommandLineMode ) {
  if ( isset( $_SERVER ) && array_key_exists( 'REQUEST_METHOD', $_SERVER ) ) {
    die( "This script must be run from the command line\n" );
  }
}


/*********************
 * Database settings are stored elsewhere (not in our public SVN!)
 */

include("DatabaseSettings.php");


/***********************************************************************
 * Default settings (some are overridden further below)
 */

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'standard', 'nostalgia', 'cologneblue', 'monobook':

$wgDefaultSkin = 'monobook';	// cosmic, when we can do so	
$wgAllowUserCss = true;

$wgSitename         = "I2U2";

# Set the session name to match the BOINC forums 
$wgSessionName      = "boinc_session"; //to match the BOINC project 

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.

$wgScriptPath       = "/library";
$wgLogo	= $wgScriptPath."/UUEOb-med.gif";
$wgFavicon    = $wgScriptPath."/UUEOb-favicon.jpg";

$wgMetaNamespace='Project';	// our semi-private namespace

$wgCookiePath = '/';		// whole site


$wgEnableEmail      = true;
$wgEnableUserEmail  = true;

$wgPasswordSender   = "help@i2u2.org";
$wgEmergencyContact = "myers@spy-hill.net";


/***********************************************************************
 * Different entry points: depending on the URL used to access us,
 * we adjust various things like the path, skin, and decorations.
 */

$elab = "";
$hostname=$_SERVER['SERVER_NAME'];
$self = $_SERVER['PHP_SELF']; 
$url_pattern=",^/elab/(\w+)/teacher/,";
$n = preg_match($url_pattern, $self, $matches);
if($n>0) list($all, $elab) = $matches;

$path_dir=dirname($self);  // how did we get here?
		// THIS MAY FAIL FOR .../index.php/Article_Name

// top-level access

if( $path_dir == "/library") {	// Public Library
  $wgScriptPath = $path_dir;
  $wgSitename   = "I2U2";  
  $wgLogo	= $wgScriptPath."/UUEOb-med.gif";
  $wgFavicon    = $wgScriptPath."/UUEOb-favicon.jpg";
}

if( $path_dir == "/teacher/library" || 
    $path_dir == "/cosmic/library" ) {  // Teachers Library
  $wgScriptPath=$path_dir;
  $wgSitename = "QNFellows";  
  $wgLogo              = $wgScriptPath."/QNsplat2.jpg";
  $wgFavicon           = $wgScriptPath."/blast_icon.gif";
}


// Individual e-Lab entry points

if( !empty($elab) )   {
  $wgScriptPath = "/elab/$elab/teacher/library";
  $wgDefaultSkin = 'cosmic';
}


if( $elab == "cosmic" ){
  $wgLogo = "/elab/cosmic/graphics/blast.jpg";
  $wgSitename    = "Teachers' Library";
  $wgMainPage = "Cosmic Ray e-Lab Teacher Community";
  $BOINC_prefix = "/elab/cosmic/teacher/forum";
}

if( $elab == "ligo" || $elab == "LIGO" ){
  $wgLogo = "/elab/ligo/graphics/ligo_logo.gif";
  $wgScriptPath = "/elab/cosmic/teacher/library";
  $wgDefaultSkin = 'ligo';
  $wgSitename    = "LIGO Teachers' Library";
  $wgMainPage = "LIGO e-Lab Teaching Community";
  $BOINC_prefix = "/elab/ligo/teacher/forum";
}


/***********************************************************************
 * Stuff below may be based on stuff above
 */

$wgScript           = "$wgScriptPath/index.php";
$wgRedirectScript   = "$wgScriptPath/redirect.php";


## For more information on customizing the URLs please see:
## http://www.mediawiki.org/wiki/Manual:Short_URL
## If using PHP as a CGI module, the ?title= style usually must be used.
$wgArticlePath      = "$wgScript/$1";
#$wgArticlePath      = "$wgScript?title=$1";


## For a detailed description of the following switches see
## http://meta.wikimedia.org/Enotif and http://meta.wikimedia.org/Eauthent
## There are many more options for fine tuning available see
## /includes/DefaultSettings.php
## UPO means: this is also a user preference option
$wgEnotifUserTalk = true; # UPO
$wgEnotifWatchlist = true; # UPO
$wgEmailAuthentication = true;

$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

$wgDiff3 = "/usr/bin/diff3";

## If you want to use image uploads under safe mode,
## create the directories images/archive, images/thumb and
## images/temp, and make them all writable. Then uncomment
## this, if it's not already uncommented:
# $wgHashedUploadDirectory = false;

## If you have the appropriate support software installed
## you can enable inline LaTeX equations:
$wgUseTeX           = true;

$wgLocalInterwiki   = $wgSitename;

$wgLanguageCode = "en";

$wgProxyKey = "9f44150580c1a0e8c85d74cbd17b899ab0d75b8b89d109ee7e86242f2365b462";


## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
# $wgEnableCreativeCommonsRdf = true;
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "";
$wgRightsText = "";
$wgRightsIcon = "";
# $wgRightsCode = ""; # Not yet used



/***********************************************************************
 * Cache control & settings:
 */

# When you make changes to this configuration file, this will make
# sure that cached pages are cleared.
#
$configdate = gmdate( 'YmdHis', @filemtime( __FILE__ ) );
$wgCacheEpoch = max( $wgCacheEpoch, $configdate );

$wgCachePages=false;
$wgUseFileCache = false;

# Shared memory (cache) settings: 

$wgMainCacheType = CACHE_NONE;
$wgMessageCacheType = CACHE_NONE;

/** Directory where the cached page will be saved */
$wgFileCacheDirectory = "{$wgUploadDirectory}/cache";

$wgParserCacheType = CACHE_NONE;
$wgEnableParserCache = false;
$wgParserCacheExpireTime = 60;

$wgMemCachedServers = array();
## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;


/***********************************************************************
 * Upload Configuration:
 */

$wgUploadPath       = "$wgScriptPath/upload";
$wgUploadDirectory  = "$IP/upload";

# If PHP's memory limit is very low, some operations may fail.
# If this is set in php.ini you don't need this here.
#ini_set( 'memory_limit', '20M' );    // Hard limit (error)

# This sets the size at which users are warned about the size of
# an upload file, but it does not actually set a hard limit.
# Limits are set in the PHP configuration file php.ini 
# (/usr/local/etc/php.ini on www13, perhaps /etc/php.ini elsewhere)
# Be sure to set both upload_max_filesize AND post_max_size
#
$wgUploadSizeWarning = 17*1024*1024;	// soft limit (warning)

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads		= true;


## If you want to use image uploads under safe mode,
## create the directories images/archive, images/thumb and
## images/temp, and make them all writable. Then uncomment
## this, if it's not already uncommented:
$wgHashedUploadDirectory = true;

## If you want to restrict file extension that can be uploaded:
#$wgStrictFileExtensions = false;

# Or specify file extenstions which are allowed, above and beyond
# the standard image extensions:
#
$wgFileExtensions =
    array_merge($wgFileExtensions,
                array( 'pdf', 'doc', 'ppt', 'xls', 'kml', 'kmz',
		'ps', 'eps' )
                );


# To show links to non-image uploaded files we need to allow
# embeded external images for the icon.  Could this be abused?
# Or use Image: namespace for the icons.
#
$wgAllowExternalImages = true;


## If PHP configuration does not have proper MIME type detection you
## may be able to fix MIME detection by being this specific:

#$wgMimeDetectorCommand= "/usr/bin/file -bi ";


/***********************************************************************
 * Debugging:
 */

# This debug log file should be not be publicly accessible if it is used, as it
# may contain private data. 
##$wgDebugLogFile         = '/home/i2u2/log_alvarez/mediawiki-debug.log';

# See meta:How_to_debug_MediaWiki for information on profiling

# DEBUG:

//require_once('/home/i2u2/boinc/html/include/debug.php');
//set_debug_level(3);


/***********************************************************************
 * Policy settings:
 */

// Disabled as per MediaWIki-announce of 22Jan2008
//  (We shouldn't be using this anyway, until we have a real need)
//
$wgEnableAPI = false;

# Disable edits until we can control user access!!!  
#$wgReadOnly="The wiki is read-only while we work on moving it";

# Turn this back to true for production, but have it off for design and development
$wgEnableParserCache = false;
if( $hostname == 'www18.i2u2.org' || $hostname == 'www.i2u2.org'  ){
  $wgEnableParserCache = true;
}

# Don't allow anonymouse comments on talk pages
$wgDisableAnonTalk=true;


/** 
 * Should editors be required to have a validated e-mail
 * address before being allowed to edit?   Not yet, but someday.
 */
$wgEmailConfirmToEdit=false;

unset($wgWhitelistAccount['user']);


/**
 * Settings added to this array will override the default globals for the user
 * preferences used by anonymous visitors and newly created accounts.
 */

//$wgDefaultUserOptions ['editsection'] = 0;


/***********************************************************************
 * Extensions:
 */ 
# Citations via <ref> text </ref> and <references/>
require_once( "{$IP}/extensions/Cite/Cite.php" ); 

# Allow editing of talk pages (or not) even if not allowed to edit articles
require_once("extensions/talkright.php");

# Allow permissions to be set on an entire namespace
require_once( "extensions/NamespacePermissions.php" ); 

# Turn the Media: pseudo-namespace into File:
require_once( "extensions/Media2File.php" );  

# Category mashups
require_once("extensions/intersection/DynamicPageList.php");

#  Automatic BOINC authentication:
#
require_once("extensions/BOINCAuthPlugin.php"); 
$BOINC_html = "/home/i2u2/boinc/html/";
$BOINC_config_xml = "/home/i2u2/boinc/config.xml";

# This is where login/logout forms will be obtained.
if( empty($BOINC_prefix ) ){
  $BOINC_prefix=$wgScriptPath;    
}


# Multiple languages in a single wiki 
##require_once( "$IP/extensions/Polyglot/Polyglot.php" );
#$wgPolyglotLanguages = array('en', 'es', 'de', 'fr', 'tw', 'ru');
#$wfPolyglotExcemptTalkPages=true;
#$wfPolyglotFollowRedirects=true;

# Parser Functions are used by the Google-trans template 
require_once( "$IP/extensions/ParserFunctions/ParserFunctions.php" );

# Display pages based on skin name as alternate page entry point 
require_once( "$IP/extensions/SkinByURL.php" );

# Display pages based on skin name as alternate page entry point 
require_once( "$IP/extensions/inputbox.php" );

# {{elab}} (and other magic words?)
require_once("$IP/extensions/MagicWords.php");	


/**
 * Permissions and Groups:
 */

/**********************
 * I think this causes a bug when you logout, so turn it off for now.
 * Only really needed if $wgGroupPermissions['*'    ]['read'] = false;
 * -EAM 20 Sept 2007

# Even if reading is disallowed, these pages are allowed.

$wgWhitelistRead = array( ":Main Page", "Special:Userlogin",
                          ":QuarkNet Fellows Library",
                          "-",
                          "MediaWiki:Monobook.css" );
************************/


// Implicit group for all visitors (hence all anonymous users)
// This is where we disable anonymous account creation, page creation, etc..

$wgGroupPermissions['*'    ]['read']            = true;
$wgGroupPermissions['*'    ]['talk']            = false; 
$wgGroupPermissions['*'    ]['edit']            = false;
$wgGroupPermissions['*'    ]['createtalk']      = false;
$wgGroupPermissions['*'    ]['createpage']      = false;
$wgGroupPermissions['*'    ]['upload']          = false;
$wgGroupPermissions['*'    ]['createaccount']   = false;


// General group for all _authenticated_ users 

$wgGroupPermissions['user' ]['read']            = true;
$wgGroupPermissions['user' ]['talk']            = true;
$wgGroupPermissions['user' ]['createtalk']      = true;
$wgGroupPermissions['user' ]['edit']            = false;
$wgGroupPermissions['user' ]['createpage']      = false;
$wgGroupPermissions['user' ]['upload']          = false;
$wgGroupPermissions['user' ]['createaccount']   = false;

$wgGroupPermissions['user' ]['edit']            = true;
$wgGroupPermissions['user' ]['createpage']      = true;
$wgGroupPermissions['user' ]['upload']          = true;

// 'bureaucrats" also get policing powers
 
$wgGroupPermissions['bureaucrat']['patrol']         = true;
$wgGroupPermissions['bureaucrat' ]['edit']          = true;
$wgGroupPermissions['bureaucrat' ]['createtalk']    = true;
$wgGroupPermissions['bureaucrat' ]['createpage']    = true;
$wgGroupPermissions['bureaucrat' ]['upload']        = true;
$wgGroupPermissions['bureaucrat' ]['createaccount'] = false;
$wgGroupPermissions['bureaucrat']['move']           = true;
$wgGroupPermissions['bureaucrat']['rollback'] = true;
$wgGroupPermissions['bureaucrat']['protect'] = true;
$wgGroupPermissions['bureaucrat']['block'] = true;

// The permissions for groups based on BOINC special-user bits
// are kept in a seprate file.  TODO: different ones for different wikis?
//
require_once("QNFellowsPermissions.php");

?>
