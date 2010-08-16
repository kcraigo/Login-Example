package com.keithcraigo.AccessControl.services
{
	import com.keithcraigo.AccessControl.vo.AuthVO;

	public interface IAuthService
	{
		function authenticate(loginFormData:AuthVO):void;
		function logout():void;
	}

}

