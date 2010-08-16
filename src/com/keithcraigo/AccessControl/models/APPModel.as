package com.keithcraigo.AccessControl.models
{
	import com.keithcraigo.AccessControl.signals.CurrrentUserHomeInitSignal;

	import mx.events.FlexEvent;

	import org.osflash.signals.Signal;
	import org.robotlegs.mvcs.Actor;

	public class APPModel extends Actor
	{
		[Inject]
		public var cInit : CurrrentUserHomeInitSignal;

		private var _AppState : String = null;
		private var _AppStateChanged : Signal = null;
		private var _currentUserHome : String = "loginState";


		public function APPModel(){}



		/**
		 * Get the current state of the application
		 *
		 * @param none
		 *
		 * @return _AppState
		 *
		 */
		public function get AppState() : String
		{
			return _AppState;
		}

		/**
		 * Set the current state of the application
		 *
		 * @param value
		 *
		 * @return none
		 *
		 */
		public function set AppState( value : String ) : void
		{
			_AppState = value;
			_AppStateChanged.dispatch( value );
			trace( "APP_STATE: " + value );
		}

		/**
		 * Set the users current view
		 *
		 * @param value
		 *
		 * @return none
		 *
		 */
		public function set currentUserHome( value : String ) : void
		{
			_currentUserHome = value;
			cInit.dispatch();

		}

		/**
		 * Get the users current view
		 *
		 * @param value
		 *
		 * @return _currentUserHome
		 *
		 */
		public function get currentUserHome() : String
		{
			return _currentUserHome;
		}


	}
}

