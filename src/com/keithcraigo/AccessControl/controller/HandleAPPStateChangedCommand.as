package com.keithcraigo.AccessControl.controller
{
	import com.keithcraigo.AccessControl.model.APPModel;
	import com.keithcraigo.AccessControl.signals.AppChangeStateSignal;

	import org.robotlegs.mvcs.SignalCommand;

	public class HandleAPPStateChangedCommand extends SignalCommand
	{
		[Inject]
		public var _model:APPModel;

		[Inject]
		public var _State:AppChangeStateSignal;		

		/**
		 * Dispatches signal that the applications state has changed
		 *
		 * @param none
		 *
		 * @return none
		 *
		 */
		private function setAppState() : void
		{

			_State.dispatch();
		}

	}
}

