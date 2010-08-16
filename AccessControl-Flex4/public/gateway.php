<?php
ini_set("display_errors", 1);
error_reporting(E_ALL | E_STRICT);

$dir = dirname(__FILE__);
$webroot = $_SERVER['DOCUMENT_ROOT'];
$configfile = "$dir/amf_config.ini";

//$configfile = "../application/configs/application.ini";

date_default_timezone_set('America/Los_Angeles');

//default zend install directory
$zenddir = $_SERVER['DOCUMENT_ROOT']. '../library/';

//Load ini file and locate zend directory
if(file_exists($configfile)) {
	$arr=parse_ini_file($configfile,true);
	if(isset($arr['zend']['zend_path'])){
		$zenddir = $arr['zend']['zend_path'];
	}
}


// Setup include path
	//add zend directory to include path
set_include_path(get_include_path().PATH_SEPARATOR.$zenddir);
// Initialize Zend Framework loader
require_once 'Zend/Loader/Autoloader.php';
Zend_Loader_Autoloader::getInstance();

Zend_Session::start();

// Load configuration
$default_config = new Zend_Config(array("production" => false), true);
$default_config->merge(new Zend_Config_Ini($configfile, 'zendamf'));
$default_config->setReadOnly();
$amf = $default_config->amf;

// Setup database connection params
$dbAdapter = $default_config->dbAdapter;
$host = $default_config->host;
;$port = $default_config->port;
$username = $default_config->username;
$password = $default_config->password;
$dbname = $default_config->dbname;
$salt = $default_config->salt;
$api_key = $default_config->api_key;

// Store configuration in the registry
Zend_Registry::set("amf-config", $amf);
Zend_Registry::set('dbAdapter', $dbAdapter);
Zend_Registry::set('dbname', $dbname);
Zend_Registry::set('username', $username);
Zend_Registry::set('password', $password);
Zend_Registry::set('host', $host);
;Zend_Registry::set('port', $port);
Zend_Registry::set('salt', $salt);
Zend_Registry::set('api_key', $api_key);



// Initialize AMF Server
$server = new Zend_Amf_Server();
$server->setProduction($amf->production);
if(isset($amf->directories)) {
	$dirs = $amf->directories->toArray();
	foreach($dirs as $dir) {
		$server->addDirectory($dir);
	}
}


// Initialize introspector for non-production
if(!$amf->production) {
	$server->setClass('Zend_Amf_Adobe_Introspector', '', array("config" => $default_config, "server" => $server));
        $server->setClassMap('UserVO', 'UserVO');
       
}
// Handle request
echo $server->handle();
