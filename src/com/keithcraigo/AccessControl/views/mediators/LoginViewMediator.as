package com.keithcraigo.AccessControl.views.mediators
{
	import com.keithcraigo.AccessControl.signals.AuthSignal;
	import com.keithcraigo.AccessControl.views.components.LoginView;
	import com.keithcraigo.AccessControl.vo.AuthVO;

	import mx.controls.Alert;

	import org.robotlegs.mvcs.Mediator;

	public class LoginViewMediator extends Mediator
	{
		[Inject]
		public var loginView:LoginView;

		[Inject]
		public var authService:AuthSignal;

		/**
		 * Adds a listener for the login button
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		override public function onRegister():void
		{
			//Alert.show("LOGINMEDIATOR Registered");
			loginView.loginClicked.add( onLoginSubmitted );

		}

		/**
		 * Dispatches signal that the login button has been clicked
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		private function onLoginSubmitted():void
		{
			//Alert.show("LOGIN SUBMITTED CALLED");
			authService.dispatch( userData );
		}

		/**
		 * Gets the users login credentials and populates the AuthVO object
		 *
		 * @param none
		 *
		 * @return credentials
		 *
		 */
		protected function get userData():AuthVO
		{
			var credentials:AuthVO = new AuthVO();
			credentials.userID = loginView.userid.text;
			loginView.userid.text ='';
			credentials.password = loginView.pw.text;
			loginView.pw.text='';
			return credentials;

		}

	}
}

