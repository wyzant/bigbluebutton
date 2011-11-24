package org.bigbluebutton.core.managers
{
	import org.bigbluebutton.core.model.Connection;

	public class ConnectionManager {
		
		private var conns:Object = new Object();
		
		public function addConnection(alias:String, connection:Connection):void {
			conns[alias] = connection;	
		}
		
		public function getConnection(alias:String):Connection {
			if (conns[alias] == null || conns[alias] == undefined) return null;
			return conns[alias];
		}
	}
}