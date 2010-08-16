package com.keithcraigo.AccessControl.services
{
	import com.keithcraigo.AccessControl.models.APPModel;
	import com.keithcraigo.AccessControl.models.UserModel;
	import com.keithcraigo.AccessControl.vo.AuthVO;

	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	import org.osmf.utils.URL;


	public class AuthenticateService implements IAuthService
	{
		[Inject]
		public var loginFormData : AuthVO;

		[Inject]
		public var appModel : APPModel;

		[Inject]
		public var userModel : UserModel;

		protected var authRO : RemoteObject;

		public function AuthenticateService()
		{
			super();
		}

		/**
		 * Setup the RemoteObject to talk to our service on the server
		 *
		 * @param loginFormData - users login credentials passed as an object
		 *
		 * @return none
		 *
		 */
		public function authenticate( loginFormData : AuthVO ) : void
		{
			//Alert.show( "SERVICE " + loginFormData.userID + " " + loginFormData.password );
			authRO = new RemoteObject();
			authRO.destination = "zend";
			authRO.source = "Authenticate";
			authRO.showBusyCursor = true;
			authRO.endpoint = "gateway.php";
			authRO.verifyuser.addEventListener( "result", getACL );
			authRO.addEventListener( "fault", faultHandler );
			authRO.verifyuser( loginFormData );

		}


		/**
		 * Get the users access level, sessionID from the service response.
		 *
		 * @param event - service results
		 *
		 * @return none
		 *
		 */
		public function getACL( event : ResultEvent ) : void
		{


			if ( event.result.hasOwnProperty( "userRole" ) )
			{
				// Reset the login form	VO	
				loginFormData.password = '';
				loginFormData.userID = '';

				// we may not need the users role since all we care about is their access priviledge level
				userModel.accesslevel = event.result.userRole;
				userModel.sessionID = event.result.sessionID;


				if ( event.result.viewRestrictedUI === 'allowed' )
				{
					appModel.currentUserHome = "adminState";
				}
				else if ( event.result.logReports === 'allowed' )
				{
					appModel.currentUserHome = "userState";
				}
				else
				{
					appModel.currentUserHome = "loginState";
				}
			}
			else
			{
				Alert.show( "Sorry! Either your UserID or Password is invalid." );
				// Reset the login form	VO
				loginFormData.password = '';
				loginFormData.userID = '';
			}
		}

		public function faultHandler( event : FaultEvent ) : void
		{
			// Deal with event.fault.faultString, etc.
			Alert.show( event.fault.faultString, 'Error' );
		}

		public function logout() : void
		{
			trace( "[AuthenticateService] Logout Called" );
			navigateToURL(new URLRequest("main.html"),'_self');

		}

	}
}

