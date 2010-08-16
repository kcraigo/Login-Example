package com.keithcraigo.AccessControl.controller
{
	import com.keithcraigo.AccessControl.services.IAuthService;

	import org.robotlegs.mvcs.SignalCommand;

	public class HandleLogOutCommand extends SignalCommand
	{
		[Inject]
		public var service:IAuthService;

		/**
		 * Calls the logout function of the service
		 *
		 * @param none
		 *
		 * @return none
		 *
		 * @see AuthenticateService
		 *
		 */
		override public function execute():void
		{
			service.logout();
		}

	}
}

