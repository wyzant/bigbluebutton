/**
 * BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
 *
 * Copyright (c) 2010 BigBlueButton Inc. and by respective authors (see below).
 *
 * This program is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 2.1 of the License, or (at your option) any later
 * version.
 *
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
 * 
 */

package org.bigbluebutton.modules.videoconf.business
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Video;
	
	import flexlib.mdi.containers.MDIWindow;
	import flexlib.mdi.events.MDIWindowEvent;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import org.bigbluebutton.common.IBbbModuleWindow;
	import org.bigbluebutton.common.Images;
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.common.events.CloseWindowEvent;
	import org.bigbluebutton.common.events.DragWindowEvent;
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.main.views.MainCanvas;
	import org.bigbluebutton.util.i18n.ResourceUtil;
	
	public class VideoWindowItf extends MDIWindow implements IBbbModuleWindow
	{
		protected var _video:Video;
		protected var _videoHolder:UIComponent;
		// images must be static because it needs to be created *before* the PublishWindow creation
		static protected var images:Images = new Images();
		
		static public var PADDING_HORIZONTAL:Number = 6;
		static public var PADDING_VERTICAL:Number = 29;
		protected var _minWidth:int = 160 + PADDING_HORIZONTAL;
		protected var _minHeight:int = 120 + PADDING_VERTICAL;
		protected var aspectRatio:Number = 1;
		protected var keepAspect:Boolean = false;
		protected var originalWidth:Number;
		protected var originalHeight:Number;
		
		protected var mousePositionOnDragStart:Point;
		
		public var streamName:String;

		[Bindable] public var resolutions:Array;
		
		protected function getVideoResolution(stream:String):Array {
			var pattern:RegExp = new RegExp("(\\d+x\\d+)-[A-Za-z0-9]+-\\d+", "");
			if (pattern.test(stream)) {
				LogUtil.debug("The stream name is well formatted [" + stream + "]");
        var uid:String = UserManager.getInstance().getConference().getMyUserId();
        LogUtil.debug("Stream resolution is [" + pattern.exec(stream)[1] + "]");
        return pattern.exec(stream)[1].split("x");
			} else {
				LogUtil.error("The stream name doesn't follow the pattern <width>x<height>-<userId>-<timestamp>. However, the video resolution will be set to the lowest defined resolution in the config.xml: " + resolutions[0]);
				return resolutions[0].split("x");
			}
		}
		
		protected function get paddingVertical():Number {
			return this.borderMetrics.top + this.borderMetrics.bottom;
		}
		
		protected function get paddingHorizontal():Number {
			return this.borderMetrics.left + this.borderMetrics.right;
		}
		
		static private var RESIZING_DIRECTION_UNKNOWN:int = 0; 
		static private var RESIZING_DIRECTION_VERTICAL:int = 1; 
		static private var RESIZING_DIRECTION_HORIZONTAL:int = 2; 
		static private var RESIZING_DIRECTION_BOTH:int = 3;
		private var resizeDirection:int = RESIZING_DIRECTION_BOTH;
		
		/**
		 * when the window is resized by the user, the application doesn't know
		 * about the resize direction
		 */
		public function onResizeStart(event:MDIWindowEvent = null):void {
			resizeDirection = RESIZING_DIRECTION_UNKNOWN;
		}
		
		/**
		 * after the resize ends, the direction is set to BOTH because of the
		 * non-user resize actions - like when the window is docked, and so on
		 */
		public function onResizeEnd(event:MDIWindowEvent = null):void {
			resizeDirection = RESIZING_DIRECTION_BOTH;
		}
		
		protected function onResize():void {
			if (_video == null || _videoHolder == null || this.minimized) return;
			
			// limits the window size to the parent size
			this.width = (this.parent != null? Math.min(this.width, this.parent.width): this.width);
			this.height = (this.parent != null? Math.min(this.height, this.parent.height): this.height); 
			
			var tmpWidth:Number = this.width - PADDING_HORIZONTAL;
			var tmpHeight:Number = this.height - PADDING_VERTICAL;
			
			// try to discover in which direction the user is resizing the window
			if (resizeDirection != RESIZING_DIRECTION_BOTH) {
				if (tmpWidth == _video.width && tmpHeight != _video.height)
					resizeDirection = (resizeDirection == RESIZING_DIRECTION_VERTICAL || resizeDirection == RESIZING_DIRECTION_UNKNOWN? RESIZING_DIRECTION_VERTICAL: RESIZING_DIRECTION_BOTH);
				else if (tmpWidth != _video.width && tmpHeight == _video.height)
					resizeDirection = (resizeDirection == RESIZING_DIRECTION_HORIZONTAL || resizeDirection == RESIZING_DIRECTION_UNKNOWN? RESIZING_DIRECTION_HORIZONTAL: RESIZING_DIRECTION_BOTH);
				else
					resizeDirection = RESIZING_DIRECTION_BOTH;
			}
			
			// depending on the direction, the tmp size is different
			switch (resizeDirection) {
				case RESIZING_DIRECTION_VERTICAL:
					tmpWidth = Math.floor(tmpHeight * aspectRatio);
					break;
				case RESIZING_DIRECTION_HORIZONTAL:
					tmpHeight = Math.floor(tmpWidth / aspectRatio);
					break;
				case RESIZING_DIRECTION_BOTH:
					// this direction is used also for non-user window resize actions
					tmpWidth = Math.min (tmpWidth, Math.floor(tmpHeight * aspectRatio));
					tmpHeight = Math.min (tmpHeight, Math.floor(tmpWidth / aspectRatio));
					break;
			}
			
			_video.width = _videoHolder.width = tmpWidth;
			_video.height = _videoHolder.height = tmpHeight;
			
			if (!keepAspect || this.maximized) {
				// center the video in the window
				_video.x = Math.floor ((this.width - PADDING_HORIZONTAL - tmpWidth) / 2);
				_video.y = Math.floor ((this.height - PADDING_VERTICAL - tmpHeight) / 2);
			} else {
				// fit window dimensions on video
				_video.x = 0;
				_video.y = 0;
				this.width = tmpWidth + PADDING_HORIZONTAL;
				this.height = tmpHeight + PADDING_VERTICAL;
			}
			
			// reposition the window to fit inside the parent window
			if (this.parent != null) {
				if (this.x + this.width > this.parent.width)
					this.x = this.parent.width - this.width;
				if (this.x < 0)
					this.x = 0;
				if (this.y + this.height > this.parent.height)
					this.y = this.parent.height - this.height;
				if (this.y < 0)
					this.y = 0;
			}
			
			updateButtonsPosition();
		}
		
		public function updateWidth():void {
			this.width = Math.floor((this.height - paddingVertical) * aspectRatio) + paddingHorizontal;
			onResize();
		}
		
		public function updateHeight():void {
			this.height = Math.floor((this.width - paddingHorizontal) / aspectRatio) + paddingVertical;
			onResize();
		}
		
		protected function setAspectRatio(width:int,height:int):void {
			aspectRatio = (width/height);
			this.minHeight = Math.floor((this.minWidth - PADDING_HORIZONTAL) / aspectRatio) + PADDING_VERTICAL;
		}
		
		public function getPrefferedPosition():String{
			if (_buttonsEnabled)
				return MainCanvas.POPUP;
			else
				// the window is docked, so it should not be moved on reset layout
				return MainCanvas.ABSOLUTE;
		}
		
		public function onDrag(event:MDIWindowEvent = null):void {
			var e:DragWindowEvent = new DragWindowEvent(DragWindowEvent.DRAG);
			e.mouseGlobal = this.localToGlobal(new Point(mouseX, mouseY));
			e.window = this;
			dispatchEvent(e);
		}
		
		public function onDragStart(event:MDIWindowEvent = null):void {
			var e:DragWindowEvent = new DragWindowEvent(DragWindowEvent.DRAG_START);
			e.window = this;
			dispatchEvent(e);
		}
		
		public function onDragEnd(event:MDIWindowEvent = null):void {
			var e:DragWindowEvent = new DragWindowEvent(DragWindowEvent.DRAG_END);
			e.mouseGlobal = this.localToGlobal(new Point(mouseX, mouseY));
			e.window = this;
			dispatchEvent(e);
		}
		
		override public function close(event:MouseEvent = null):void{
			var e:CloseWindowEvent = new CloseWindowEvent();
			e.window = this;
			dispatchEvent(e);
			
			super.close(event);
		}
		
		private var _buttons:ButtonsOverlay = null;
		private var _buttonsEnabled:Boolean = true;
		
		private var img_unlock_keep_aspect:Class = images.lock_open;
		private var img_lock_keep_aspect:Class = images.lock_close;
		private var img_fit_video:Class = images.arrow_in;
		private var img_original_size:Class = images.shape_handles;
		
		protected function get buttons():ButtonsOverlay {
			if (_buttons == null) {
				_buttons = new ButtonsOverlay;
				_buttons.add("originalSizeBtn", img_original_size, ResourceUtil.getInstance().getString('bbb.video.originalSizeBtn.tooltip'), onOriginalSizeClick);
				
				// hiding the other buttons
				//_buttons.add("keepAspectBtn", img_lock_keep_aspect, ResourceUtil.getInstance().getString('bbb.video.keepAspectBtn.tooltip'), onKeepAspectClick);
				//_buttons.add("fitVideoBtn", img_fit_video, ResourceUtil.getInstance().getString('bbb.video.fitVideoBtn.tooltip'), onFitVideoClick);
				
				_buttons.visible = false;
				
				this.addChild(_buttons);
			} 
			return _buttons;
		}
		
		protected function createButtons():void {
			// creates the window keeping the aspect ratio 
			onKeepAspectClick();
		}
		
		protected function updateButtonsPosition():void {
			if (buttons.visible == false) {
				buttons.y = buttons.x = 0;
			} else {
				buttons.y = _video.y + _video.height - buttons.height - buttons.padding;
				buttons.x = _video.x + _video.width - buttons.width - buttons.padding;
			}
		}
		
		protected function showButtons(event:MouseEvent = null):void {
			if (_buttonsEnabled && buttons.visible == false) {
				buttons.visible = true;
				updateButtonsPosition();
			}
		}
		
		protected function hideButtons(event:MouseEvent = null):void {
			if (_buttonsEnabled && buttons.visible == true) {
				buttons.visible = false;
				updateButtonsPosition();
			}
		}
		
		protected function onDoubleClick(event:MouseEvent = null):void {
			// it occurs when the window is docked, for example
			if (!this.maximizeRestoreBtn.visible) return;
			
			this.maximizeRestore();
		}
		
		override public function maximizeRestore(event:MouseEvent = null):void {
			// if the user is maximizing the window, the control buttons should disappear
			buttonsEnabled = this.maximized;
			super.maximizeRestore(event);
		}
		
		public function set buttonsEnabled(enabled:Boolean):void {
			if (!enabled) 
				hideButtons();
			_buttonsEnabled = enabled;
		}
		
		protected function onOriginalSizeClick(event:MouseEvent = null):void {
			_video.width = _videoHolder.width = originalWidth;
			_video.height = _videoHolder.height = originalHeight;
			onFitVideoClick();
		}		
		
		protected function onFitVideoClick(event:MouseEvent = null):void {
			var newWidth:int = _video.width + paddingHorizontal;
			var newHeight:int = _video.height + paddingVertical;
			
			this.x += (this.width - newWidth)/2;
			this.y += (this.height - newHeight)/2;
			this.width = newWidth;
			this.height = newHeight;
			onResize();
		}
		
		protected function onKeepAspectClick(event:MouseEvent = null):void {
			keepAspect = !keepAspect;
			
			var keepAspectBtn:Button = buttons.get("keepAspectBtn");
			if (keepAspectBtn != null) { 
				keepAspectBtn.selected = keepAspect;
				keepAspectBtn.setStyle("icon", (keepAspect? img_lock_keep_aspect: img_unlock_keep_aspect));
			}
			
			var fitVideoBtn:Button = buttons.get("fitVideoBtn");
			if (fitVideoBtn != null) {
				fitVideoBtn.enabled = !keepAspect;
			}		
			
			onFitVideoClick();
		}
		
	}
}