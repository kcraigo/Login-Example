package com.keithcraigo.AccessControl.models
{
	import org.robotlegs.mvcs.Actor;

	public class UserModel extends Actor
	{
		private var _accessLevel:String = 'guest';
		private var _userid:String;
		private var _sessionID : String;

		public function UserModel()
		{
			super();
		}

		/**
		 * Set the users accesslevel
		 *
		 * @param lvl - users access level
		 *
		 * @return none
		 *
		 */
		public function set accesslevel(lvl:String):void 
		{
			_accessLevel = lvl;
		}

		/**
		 * Get the users current view
		 *
		 * @param none
		 *
		 * @return _accessLevel
		 *
		 */
		public function get accesslevel():String
		{
			return _accessLevel;
		}

		/**
		 * Set the users id
		 *
		 * @param id
		 *
		 * @return none
		 *
		 */
		public function set userid(id:String):void 
		{
			_userid = id;
		}

		/**
		 * get the users id
		 *
		 * @param none
		 *
		 * @return _userid
		 *
		 */
		public function get userid():String
		{
			return _userid;
		}

		/**
		 * Set the users session id
		 *
		 * @param id
		 *
		 * @return none
		 *
		 */
		public function set sessionID(id:String):void 
		{
			_sessionID = id;
		}

		/**
		 * Get the users session id
		 *
		 * @param vanonelue
		 *
		 * @return _sessionID
		 *
		 */
		public function get sessionID():String
		{
			return _sessionID;
		}



	}
}

