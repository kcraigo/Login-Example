<?php
require 'vo/AuthVO.php';
require 'models/DbTable/Admin.php';


/**
*	@License
 *
 * This source file is subject to the Creative Commons Attribution-Share Alike 3.0 United States License.
 * This license is available through the world-wide-web at this URL:
 * http://i.creativecommons.org/l/by-sa/3.0/us/88x31.png
 *
 * @category   AccessControl-Flex4
 * @package    AccessControl-Flex4
 * @copyright  Copyright (c) 2010 Keith Craigo (http://www.keithcraigo.com)
 * @license    http://creativecommons.org/licenses/by-nc-nd/3.0/  Creative Commons Attribution-Share Alike 3.0 United States License
 * @version    $Id: Authenticate.php Aug 12, 2010 4:00:00 AM keith $
 */

/*
 * Authenticate
 * 
 * Verify's the users login credentials and checks the users role against the ACL for access rights.
 * 
 * @return Access Privileges
 */

class Authenticate {

	private $dbAdapter;
	private $authAdapter;
   
	
	// test

	/** Code courtesy of Wade Arnold - wadearnold.com*/
	/** increment the current count session variable and return it's value */
    public function getCount()
    {
    	$_SESSION['count']++;
    	return $_SESSION['count']; 
    }
 
    /** return the php session id value */
    public function getSessionID()
    {
    	return session_id();
    }
 
    /** Tell's php to generate a new session id */
    public function updateSessionID()
    {
    	return session_regenerate_id(); 
    }
 
    /** clear the refrence to the count session variable */
    public function unregister() {
    	unset($_SESSION['count']);
    	return true;
     }
	/*******************************************************/
		
	public function generateNewSessionID() {
		$newSIDStatus = $this->updateSessionID();
		if($newSIDStatus===true) {
			return $this->getSessionID();
		}
	}
	
	/**
		 * @return void
		 */
		public function test() {
			echo  "Success! Test Completed Normally";
		}
	
		/**
	 *
	 * @param UserVO $usercreds
	 * @return string
	 *
	 */
	public function verifyuser($usercreds) {
		$userRolePrivs = new AccessPrivsVO();
		$userRole = new UserRole();
		//return "VerifyUser";
		// Get a reference to the singleton instance of Zend_Auth
		$this->auth = Zend_Auth::getInstance();
		$this->reg = Zend_Registry::getInstance();

		// Create database connection
		// As a best practice database connection information should be stored
		// outside of the Web Root
		try {

			$this->dbAdapter = Zend_Db::factory($this->reg->get('dbAdapter'),array('host' => $this->reg->get('host'),
			'dbname' 	=>  $this->reg->get('dbname'),
			'username' 	=>  $this->reg->get('username'),
			'password' 	=>  $this->reg->get('password')));

			//return "Connecting to: " . $this->reg->get('dbname');
		}
		catch ( Zend_Db_Exception $e){
		 return "Caught exception: " . get_class($e) . "\n Message: " . $e->getMessage() . "\n";
		}
		// Configure the instance with constructor parameters...
		$this->authAdapter = new Zend_Auth_Adapter_DbTable(
		$this->dbAdapter,
		    'admin',
		    'username',
		    'password');

		$userid = htmlspecialchars($usercreds->userID);
		$password = htmlspecialchars($usercreds->password);
		//return $userid. " - ".$password;
		
		$salt = $this->reg->get('salt');
		$userpassword = $password.$salt;
		
		if($userid === ''){
			$this->authAdapter
			->setIdentity('guest')
			->setCredential('guest')
			->setCredentialTreatment('MD5(?)');
			
		}else{
			$this->authAdapter
			->setIdentity($userid)
			->setCredential($userpassword)
			->setCredentialTreatment('MD5(?)');
		}
		$result = $this->authAdapter->authenticate();
		
		switch ($result->getCode()) {

			    case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND:
			         $userRole = "guest";
			         return "FAILURE_IDENTITY_NOT_FOUND";
			        break;
			
			    case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
			    	$userRole = "guest";
			      	return "FAILURE_CREDENTIAL_INVALID";
			        break;
			     
			    case Zend_Auth_Result::FAILURE:
			    	$userRole = 'guest';
			    	return "FAILURE";
			    	break;
			    
			     case Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS:
			    	$userRole = 'guest';
			    	return "FAILURE_IDENTITY_AMBIGUOUS";
			    	break; 
			    
			    case Zend_Auth_Result::FAILURE_UNCATEGORIZED:
			    	$userRole = 'guest';
			    	return "FAILURE_UNCATEGORIZED";
			    	break;
			
			    case Zend_Auth_Result::SUCCESS:
			        // We need to return the authenticated users role, this will be passed into the Zend_Acl
			        // getResultRowObject returns a stdClass object so we need to dereference the role in this manner.
			        $r=$this->authAdapter->getResultRowObject(array('role'));
			        $userRole = $r->role;
			        
			        //Generate a new sessionID if the session already exists
			        if (Zend_Session::sessionExists()){
    					$this->updateSessionID();
					}
			        $userRolePrivs->sessionID = $this->getSessionID();
			        
			        // use a separate namespace for authorized users
			        //$authorizedNamespace = new Zend_Session_Namespace('Authorized');
					//$authorizedNamespace->user = $usr;
					
			        break;
			
			    default:
			        return "Internal Error! If this problem persist, please contact your network administrator";
			        break;
			}
			
			// Set up the ACL (Access Control List)
			$acl = new Zend_Acl();
			// Add groups to the Role registry using Zend_Acl_Role
			// Guest does not inherit access controls.
			// Order matters here, we go from the most restricted to the least restricted
			$acl->addRole(new Zend_Acl_Role('guest'));
			$acl->addRole(new Zend_Acl_Role('manager'), 'guest');
			$acl->addRole(new Zend_Acl_Role('admin'), 'manager');
			
			// Administrator does not inherit access controls, All access is granted
			$acl->addRole(new Zend_Acl_Role('Super'));
			
			// setup the resource privs
			$acl->add(new Zend_Acl_Resource('viewPublicUI'));
			$acl->add(new Zend_Acl_Resource('viewRestrictedUI'));
			$acl->add(new Zend_Acl_Resource('logReports'));
			$acl->add(new Zend_Acl_Resource('createManager'));
			
			// Guest may only view the public interface
			$acl->allow('guest', null, 'viewPublicUI');
			
			// manager inherits viewPublicUI privilege from guest, but also needs additional
			// privileges
			$acl->allow('manager', null, array('logReports'));
			
			// admin inherits logReports privilege from
			// manager, but also needs additional privileges
			$acl->allow('admin', null, array('viewRestrictedUI','createManager'));
			
			// Super inherits nothing, but is allowed all privileges
			$acl->allow('Super');			
			
			
			$userRolePrivs->userRole = $userRole;
			$userRolePrivs->viewPublicUI = $acl->isAllowed($userRole, null, 'viewPublicUI') ? "allowed" : "denied";
			$userRolePrivs->logReports = $acl->isAllowed($userRole, null, 'logReports') ? "allowed" : "denied";
			$userRolePrivs->viewRestrictedUI = $acl->isAllowed($userRole, null, 'viewRestrictedUI') ? "allowed" : "denied";
			$userRolePrivs->createManager = $acl->isAllowed($userRole, null, 'createManager') ? "allowed" : "denied";
			$userRolePrivs->viewLogs = $acl->isAllowed($userRole, null, 'viewLogs') ? "allowed" : "denied";
			
							
			return $userRolePrivs;
			
		 }				
}
class AccessPrivsVO
{
	public $userRole='';
	public $viewPublicUI='';
	public $createManager = '';
	public $viewRestrictedUI = '';
	public $viewLogs = '';
	public $manageCase = '';

}

class UserRole
{
	public $role='';
	public $pid='';
	public $fname = '';
	public $lname = '';
	public $status = '';

	/** Session Handling */
	public $sessionID = '';

}