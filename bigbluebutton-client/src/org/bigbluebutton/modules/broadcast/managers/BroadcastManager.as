package org.bigbluebutton.modules.broadcast.managers
{
	import com.asfusion.mate.events.Dispatcher;	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;	
	import mx.core.UIComponent;	
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.common.events.OpenWindowEvent;
	import org.bigbluebutton.main.events.BBBEvent;
	import org.bigbluebutton.modules.broadcast.models.BroadcastOptions;
	import org.bigbluebutton.modules.broadcast.models.Stream;
	import org.bigbluebutton.modules.broadcast.models.Streams;
	import org.bigbluebutton.modules.broadcast.services.BroadcastService;
	import org.bigbluebutton.modules.broadcast.services.StreamsService;
	import org.bigbluebutton.modules.broadcast.views.BroadcastWindow;
	
	public class BroadcastManager {	
		private var broadcastWindow:BroadcastWindow;
		private var dispatcher:Dispatcher;
		private var broadcastService:BroadcastService = new BroadcastService();
		private var streamService:StreamsService;
		
		[Bindable]
		public var streams:Streams = new Streams();	
		private var curStream:Stream;
		
		public function BroadcastManager() {
			streamService = new StreamsService(this);
			LogUtil.debug("BroadcastModule Created");
		}
		
		public function start():void {
			LogUtil.debug("BroadcastModule Start");
			dispatcher = new Dispatcher();
			if (broadcastWindow == null){
				LogUtil.debug("*** Opening BroadcastModule Window");
				var opt:BroadcastOptions = new BroadcastOptions();
				
				
				broadcastWindow = new BroadcastWindow();
				broadcastWindow.options = opt;
				broadcastWindow.streams = streams;
				broadcastWindow.broadcastManager = this;
				var options:BroadcastOptions = new BroadcastOptions();
				
				var e:OpenWindowEvent = new OpenWindowEvent(OpenWindowEvent.OPEN_WINDOW_EVENT);
				e.window = broadcastWindow;
				dispatcher.dispatchEvent(e);
				streamService.queryAvailableStreams(options.streamsUri);
			} else {
				LogUtil.debug("*** Not Opening BroadcastModule Window");
			}
		}
		
		public function playVideo(index:int):void {
			broadcastService.playStream(streams.streamUrls[index], streams.streamIds[index], streams.streamNames[index]);
		}
				
		public function stopVideo():void {
			broadcastService.stopStream();
		}
			
		public function playStream(event:BBBEvent):void {
			LogUtil.debug("Received " + event.payload["messageId"]);
			curStream = new Stream(event.payload["uri"], event.payload["streamId"], event.payload["streamName"]);
			broadcastWindow.addDisplay();
			curStream.play(broadcastWindow.videoHolder2);
		}
		
		public function stopStream(event:BBBEvent):void {
			LogUtil.debug("Received " + event.payload["messageId"]);
			broadcastWindow.removeDisplay();
			curStream.stop();
		}
	}
}