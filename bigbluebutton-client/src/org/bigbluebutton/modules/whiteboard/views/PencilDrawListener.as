package org.bigbluebutton.modules.whiteboard.views
{
    import org.bigbluebutton.common.LogUtil;
    import org.bigbluebutton.modules.whiteboard.business.shapes.DrawObject;
    import org.bigbluebutton.modules.whiteboard.business.shapes.Pencil;
    import org.bigbluebutton.modules.whiteboard.business.shapes.ShapeFactory;
    import org.bigbluebutton.modules.whiteboard.business.shapes.WhiteboardConstants;
    import org.bigbluebutton.modules.whiteboard.events.WhiteboardDrawEvent;
    import org.bigbluebutton.modules.whiteboard.models.Annotation;
    import org.bigbluebutton.modules.whiteboard.views.models.WhiteboardTool;
    
    public class PencilDrawListener implements IDrawListener
    {
        private var _drawStatus:String = DrawObject.DRAW_START;
        private var _isDrawing:Boolean; 
        private var _segment:Array = new Array();
        private var _wbCanvas:WhiteboardCanvas;
        private var _sendFrequency:int;
        private var _shapeFactory:ShapeFactory;
        
        public function PencilDrawListener(wbCanvas:WhiteboardCanvas, sendShapeFrequency:int, shapeFactory:ShapeFactory)
        {
            _wbCanvas = wbCanvas;
            _sendFrequency = sendShapeFrequency;
            _shapeFactory = shapeFactory;
        }
        
        public function onMouseDown(mouseX:Number, mouseY:Number, tool:WhiteboardTool):void
        {
            if (tool.graphicType == WhiteboardConstants.TYPE_SHAPE) {
                _isDrawing = true;
                _drawStatus = DrawObject.DRAW_START;
                _segment = new Array();               
                _segment.push(mouseX);
                _segment.push(mouseY);
            } 
        }
        
        public function onMouseMove(mouseX:Number, mouseY:Number, tool:WhiteboardTool):void
        {
            if (tool.graphicType == WhiteboardConstants.TYPE_SHAPE) {
                if (_isDrawing){
                    _segment.push(mouseX);
                    _segment.push(mouseY);
                    if (_segment.length > _sendFrequency) {                       
                        sendShapeToServer(_drawStatus, tool);
                    }	
                }                
            }
        }
        
        public function onMouseUp(mouseX:Number, mouseY:Number, tool:WhiteboardTool):void
        {
            if(tool.graphicType == WhiteboardConstants.TYPE_SHAPE) {
                if (_isDrawing) {
                    /**
                     * Check if we are drawing because when resizing the window, it generates
                     * a mouseUp event at the end of resize. We don't want to dispatch another
                     * shape to the viewers.
                     */
                    _isDrawing = false;
                    
                    //check to make sure unnecessary data is not sent ex. a single click when the rectangle tool is selected
                    // is hardly classifiable as a rectangle, and should not be sent to the server
                    if (tool.toolType == DrawObject.RECTANGLE || tool.toolType == DrawObject.ELLIPSE || tool.toolType == DrawObject.TRIANGLE) {						
                        var x:Number = _segment[0];
                        var y:Number = _segment[1];
                        var width:Number = _segment[_segment.length-2]-x;
                        var height:Number = _segment[_segment.length-1]-y;
                        
                        if (!(Math.abs(width) <= 2 && Math.abs(height) <=2)) {
                            sendShapeToServer(DrawObject.DRAW_END, tool);
                        }
                    } else {
                        sendShapeToServer(DrawObject.DRAW_END, tool);
                    } /* (tool.toolType */					
                } /* (_isDrawing) */                
            }
        }
    
        private function sendShapeToServer(status:String, tool:WhiteboardTool):void {
            if (_segment.length == 0) return;
                       
            var dobj:DrawObject = _shapeFactory.createDrawObject(tool.toolType, _segment, tool.drawColor, tool.thickness, tool.fillOn, tool.fillColor, tool.transparencyOn);
            
            switch (status) {
                case DrawObject.DRAW_START:
                    dobj.status = DrawObject.DRAW_START;
                    _drawStatus = DrawObject.DRAW_UPDATE;
                    break;
                case DrawObject.DRAW_UPDATE:
                    dobj.status = DrawObject.DRAW_UPDATE;								
                    break;
                case DrawObject.DRAW_END:
                    dobj.status = DrawObject.DRAW_END;
                    _drawStatus = DrawObject.DRAW_START;
                    break;
            }
            
            /** PENCIL is a special case as each segment is a separate shape **/
            if (tool.toolType == DrawObject.PENCIL) {
                dobj.status = DrawObject.DRAW_START;
                _drawStatus = DrawObject.DRAW_START;
                _segment = new Array();	
                var xy:Array = _wbCanvas.getMouseXY();
                _segment.push(xy[0], xy[1]);
            }
           
            var annotation:Object = new Object();
            annotation["type"] = dobj.getType();
            annotation["points"] = dobj.getShapeArray();
            annotation["color"] = dobj.getColor();
            annotation["thickness"] = dobj.getThickness();
            annotation["id"] = dobj.getGraphicID();
            annotation["status"] = dobj.status;
            annotation["fill"] = dobj.getFill();
            annotation["fillColor"] = dobj.getFillColor();
            annotation["transparency"] = dobj.getTransparency();
            
            var msg:Annotation = new Annotation(dobj.getGraphicID(), dobj.getType(), annotation);
            _wbCanvas.sendGraphicToServer(msg, WhiteboardDrawEvent.SEND_SHAPE);			
        }
    }
}