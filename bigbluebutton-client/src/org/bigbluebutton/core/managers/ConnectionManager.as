package org.bigbluebutton.core.managers
{
	import org.bigbluebutton.core.model.Connection;

	public class ConnectionManager {
		
		private var conns:Object = new Object();
		
		public function createConnection(alias:String):void {
			if (conns[alias] == null || conns[alias] == undefined) {				
				conns[alias] = new Connection(alias);
			}				
		}
		
		public function getConnection(alias:String):Connection {
			if (conns[alias] == null || conns[alias] == undefined) return null;
			return conns[alias];
		}
	}
}