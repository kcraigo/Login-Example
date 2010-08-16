package com.keithcraigo.AccessControl.views.mediators
{
	import com.keithcraigo.AccessControl.models.UserModel;
	import com.keithcraigo.AccessControl.views.components.interfaces.IAdmin;

	import org.robotlegs.mvcs.Mediator;

	public class AdminViewMediator extends Mediator
	{
		[Inject]
		public var adminView : IAdmin;

		[Inject]
		public var userModel : UserModel;

		/**
		 * Set the views view state according to the logged in users accesslevel
		 *
		 * @param none
		 *
		 * @return activeViewState
		 *
		 */
		override public function onRegister() : void
		{
			if(userModel.accesslevel === "Super")
			{

				adminView.activeViewState = "superAdminState";


			}else {

				adminView.activeViewState  = "adminState";

			} 

		}

	}
}

