package org.bigbluebutton.modules.broadcast.models
{
	import org.bigbluebutton.core.BBB;

	public class BroadcastOptions {
		[Bindable]
		public var streamsUri:String;
				
		[Bindable]
		public var position:String = "middle";
		
		public function BroadcastOptions() {
			var cxml:XML = 	BBB.getConfigForModule("BroadcastModule");
			if (cxml != null) {
				if (cxml.@streamsUri != undefined) {
					streamsUri = cxml.@streamsUri.toString();
				}
				if (cxml.@position != undefined) {
					position = cxml.@position.toString();
				}
			}
		}
	}
}