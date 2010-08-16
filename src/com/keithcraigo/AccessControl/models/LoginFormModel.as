package com.keithcraigo.AccessControl.models
{
	import com.keithcraigo.AccessControl.vo.AuthVO;

	import org.robotlegs.mvcs.Actor;

	public class LoginFormModel extends Actor
	{
		public function LoginFormModel(){}

		/**
		 * Get the users submitted credentials
		 *
		 * @param none
		 *
		 * @return _loginFormData
		 *
		 */
		public function get loginFormData():AuthVO
		{
			return _loginFormData;
		}

		/**
		 * Poupulate the loginFormData object with the users credentials
		 *
		 * @param value - users credentials
		 *
		 * @return none
		 *
		 */
		public function set loginFormData( value:AuthVO ):void
		{
			_loginFormData = value;

			trace( "MODEL: " + value.userID + " " + value.password );
		}

		protected var _loginFormData:AuthVO;



	}
}

