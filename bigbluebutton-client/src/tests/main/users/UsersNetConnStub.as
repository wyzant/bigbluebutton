package tests.main.users
{
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	import org.bigbluebutton.core.model.Connection;
	
	public class UsersNetConnStub extends NetConnection
	{
		private var connectionDelegate:Connection;
		
		public function UsersNetConnStub()
		{
			super();
		}
		
		override public function call(command:String, responder:Responder, ...parameters):void{
			var callback:Function = connectionDelegate[command];
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			
		}
		
		override public function connect(command:String, ...parameters):void{
			
		}
		
		override public function close():void{
			
		}
	}
}