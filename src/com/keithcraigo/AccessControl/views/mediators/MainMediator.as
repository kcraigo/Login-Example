package com.keithcraigo.AccessControl.views.mediators
{

	import com.keithcraigo.AccessControl.models.APPModel;
	import com.keithcraigo.AccessControl.models.UserModel;
	import com.keithcraigo.AccessControl.signals.AppChangeStateSignal;
	import com.keithcraigo.AccessControl.signals.CurrrentUserHomeInitSignal;
	import com.keithcraigo.AccessControl.signals.LogOutSignal;
	import com.keithcraigo.AccessControl.views.components.interfaces.IMain;

	import mx.managers.SystemManager;

	import org.robotlegs.mvcs.Mediator;


	public class MainMediator extends Mediator
	{
		[Inject]
		public var main : IMain;

		[Inject]
		public var changeAPPStateSignal : AppChangeStateSignal;

		[Inject]
		public var authService : LogOutSignal;

		[Inject]
		public var appModel : APPModel;

		[Inject]
		public var cInit: CurrrentUserHomeInitSignal;

		[Inject]
		public var uModel: UserModel;

		public var systemMngr : SystemManager;

		/**
		 * Sets the active view of the main application
		 * Adds a listener for the AppStateChanged signal
		 * Adds a listner for the CurrentUserHomeInitSignal
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		override public function onRegister() : void
		{

			main.activeViewState = appModel.currentUserHome;
			changeAPPStateSignal.add( handleAppStateChange );
			cInit.add( initCurrentUserHome );

		}


		/**
		 * Sets the activeViewState of the main view
		 *
		 * @param btn - id of the button clicked in main menu bar
		 *
		 * @return none
		 *
		 */
		protected function handleAppStateChange(btn : String) : void
		{
			var s:String = btn.toString() + "State";
			//Alert.show("mainMediator Item: " + btn); 
			if(s === "HomeState"){
				main.activeViewState = appModel.currentUserHome;
			}else{
				main.activeViewState = s;
			}


		}

		/**
		 * Sets the current users home
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		private function initCurrentUserHome() : void
		{
			main.activeViewState = appModel.currentUserHome;
			main.currentUserSessionID = uModel.sessionID;
		}

		/**
		 * Dispatch the logout signal
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		private function logout() : void
		{
			uModel.accesslevel = '';
			uModel.sessionID ='';
			authService.dispatch();
		}

	}
}

