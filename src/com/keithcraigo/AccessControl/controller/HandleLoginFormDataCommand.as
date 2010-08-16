package com.keithcraigo.AccessControl.controller
{
	import com.keithcraigo.AccessControl.services.IAuthService;
	import com.keithcraigo.AccessControl.vo.AuthVO;

	import org.robotlegs.mvcs.SignalCommand;

	public class HandleLoginFormDataCommand extends SignalCommand
	{
		[Inject]
		public var service:IAuthService;

		[Inject]
		public var loginFormData:AuthVO;

		/**
		 * Calls the authenticate service on the server
		 *
		 * @param loginFormData
		 *
		 * @return none
		 *
		 */
		override public function execute():void
		{
			trace( "[HandleLoginFormDataCommand] SERVICE Execute called" );

			service.authenticate( loginFormData );
		}

	}
}

