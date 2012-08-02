/**
 * BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
 *
 * Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
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
 * Author: Ajay Gopinath <ajgopi124(at)gmail(dot)com>
 */
package org.bigbluebutton.modules.whiteboard.business.shapes
{
	import flash.display.Shape;
	
	public class Eraser extends DrawObject
	{
		/**
		 * The dafault constructor. Creates a Eraser DrawObject 
		 * @param segment the array representing the points needed to create this Eraser
		 * @param color the Color of this Eraser
		 * @param thickness the thickness of this Eraser
		 * @param trans the transparency of this Eraser
		 */	
		
		public function Eraser(segment:Array, color:uint, thickness:uint, trans:Boolean)
		{
			super(DrawObject.ERASER, segment, 0xFFFFFF, thickness, false, 0x000000, false);
		}
		
		/**
		 * Gets rid of the unnecessary data in the segment array, so that the object can be more easily passed to
		 * the server 
		 * 
		 */		
		override protected function optimize():void{
			var x1:Number = this.shape[0];
			var y1:Number = this.shape[1];
			var x2:Number = this.shape[this.shape.length - 2];
			var y2:Number = this.shape[this.shape.length - 1];
			
			this.shape = new Array();
			this.shape.push(x1);
			this.shape.push(y1);
			this.shape.push(x2);
			this.shape.push(y2);
		}
		
		override public function makeGraphic(parentWidth:Number, parentHeight:Number):void {
			this.graphics.lineStyle(getThickness(), 0xFFFFFF);
			
			var graphicsCommands:Vector.<int> = new Vector.<int>();
			graphicsCommands.push(1);
			var coordinates:Vector.<Number> = new Vector.<Number>();
			coordinates.push(denormalize(getShapeArray()[0], parentWidth), denormalize(getShapeArray()[1], parentHeight));
			
			for (var i:int = 2; i < getShapeArray().length; i += 2){
				graphicsCommands.push(2);
				coordinates.push(denormalize(getShapeArray()[i], parentWidth), denormalize(getShapeArray()[i+1], parentHeight));
			}
			
			this.graphics.drawPath(graphicsCommands, coordinates);
			this.alpha = 1;
		}
		
		override public function getProperties():Array {
			var props:Array = new Array();
			props.push(this.type);
			props.push(this.shape);
			props.push(0xFFFFFF);
			props.push(this.thickness);
			props.push(false);
			props.push(false);
			props.push(this.width);
			props.push(this.height);
			return props;
		}
	}
}