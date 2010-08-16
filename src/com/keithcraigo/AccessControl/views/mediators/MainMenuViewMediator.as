package com.keithcraigo.AccessControl.views.mediators
{

	import com.keithcraigo.AccessControl.signals.AppChangeStateSignal;
	import com.keithcraigo.AccessControl.signals.LogOutSignal;
	import com.keithcraigo.AccessControl.views.components.MainMenuView;

	import mx.controls.Alert;

	import org.robotlegs.mvcs.Mediator;

	public class MainMenuViewMediator extends Mediator
	{
		[Inject]
		public var mainMenuView : MainMenuView;

		[Inject]
		public var authService : LogOutSignal;

		[Inject]
		public var appChangedService : AppChangeStateSignal;


		/**
		 * Adds a listener for the logout button
		 * Adds a listener for the AppStateChanged signal
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		override public function onRegister() : void
		{
			mainMenuView.logoutClicked.add( onLogOut );
			mainMenuView.handleAppStateChange.add( ChangeAppState );

		}

		/**
		 * Listener for the logout button
		 *
		 * @param loginFormData
		 *
		 * @return none
		 *
		 */
		private function onLogOut() : void
		{
			authService.dispatch();
		}

		/**
		 * Listener for the AppStateChanged signal
		 *
		 * @param btn - id of the logout button
		 *
		 * @return none
		 *
		 */
		private function ChangeAppState(btn:String) : void
		{	
			appChangedService.dispatch(btn);
		}



	}
}

