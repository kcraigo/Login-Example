package com.keithcraigo.AccessControl
{
	import com.keithcraigo.AccessControl.controller.HandleLogOutCommand;
	import com.keithcraigo.AccessControl.controller.HandleLoginFormDataCommand;
	import com.keithcraigo.AccessControl.models.APPModel;
	import com.keithcraigo.AccessControl.models.LoginFormModel;
	import com.keithcraigo.AccessControl.models.UserModel;
	import com.keithcraigo.AccessControl.services.AuthenticateService;
	import com.keithcraigo.AccessControl.services.IAuthService;
	import com.keithcraigo.AccessControl.signals.AppChangeStateSignal;
	import com.keithcraigo.AccessControl.signals.AuthSignal;
	import com.keithcraigo.AccessControl.signals.CurrrentUserHomeInitSignal;
	import com.keithcraigo.AccessControl.signals.LogOutSignal;
	import com.keithcraigo.AccessControl.views.components.AdminView;
	import com.keithcraigo.AccessControl.views.components.LoginView;
	import com.keithcraigo.AccessControl.views.components.MainMenuView;
	import com.keithcraigo.AccessControl.views.components.interfaces.IAdmin;
	import com.keithcraigo.AccessControl.views.components.interfaces.IMain;
	import com.keithcraigo.AccessControl.views.mediators.AdminViewMediator;
	import com.keithcraigo.AccessControl.views.mediators.LoginViewMediator;
	import com.keithcraigo.AccessControl.views.mediators.MainMediator;
	import com.keithcraigo.AccessControl.views.mediators.MainMenuViewMediator;

	import org.robotlegs.mvcs.SignalContext;

	public class AccessControl_context extends SignalContext
	{
		override public function startup() : void
		{
			injector.mapSingleton( AppChangeStateSignal );
			injector.mapSingleton( CurrrentUserHomeInitSignal );

			injector.mapSingleton( APPModel );
			injector.mapSingleton( UserModel );
			injector.mapSingleton( LoginFormModel );
			injector.mapSingletonOf( IAuthService, AuthenticateService );

			// Map Signals
			signalCommandMap.mapSignalClass( AuthSignal, HandleLoginFormDataCommand );
			signalCommandMap.mapSignalClass( LogOutSignal, HandleLogOutCommand );

			// Map View
			mediatorMap.mapView( AdminView, AdminViewMediator, IAdmin );
			mediatorMap.mapView( LoginView, LoginViewMediator );
			mediatorMap.mapView( MainMenuView, MainMenuViewMediator );
			mediatorMap.mapView( main, MainMediator, IMain );

		}

	}
}

