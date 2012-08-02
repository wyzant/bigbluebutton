package org.bigbluebutton.conference.service.recorder.whiteboard;

import java.util.Map;
import org.bigbluebutton.conference.service.recorder.RecorderApplication;
import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.bigbluebutton.conference.service.whiteboard.IWhiteboardRoomListener;
import org.bigbluebutton.conference.service.whiteboard.Presentation;
import org.bigbluebutton.conference.service.whiteboard.ShapeGraphic;
import org.bigbluebutton.conference.service.whiteboard.TextGraphic;
import org.bigbluebutton.conference.service.whiteboard.shapes.Annotation;

public class WhiteboardEventRecorder implements IWhiteboardRoomListener{
	private static Logger log = Red5LoggerFactory.getLogger( WhiteboardEventRecorder.class, "bigbluebutton" );
	private final RecorderApplication recorder;;
	private final String session;
	String name = "RECORDER:WHITEBOARD";

	public WhiteboardEventRecorder(String session, RecorderApplication recorder){
		this.recorder = recorder;
		this.session = session;
	}

	@Override
	public String getName() {
		return name;
	}


	@Override
	public void addAnnotation(Annotation annotation, Presentation presentation) {
		AddShapeWhiteboardRecordEvent event = new AddShapeWhiteboardRecordEvent();
		event.setMeetingId(session);
		event.setTimestamp(System.currentTimeMillis());
		event.setPresentation(presentation.getName());
		event.setPageNumber(presentation.getActivePage().getPageIndex());
		event.addAnnotation(annotation.getAnnotation());
		
//		event.setDataPoints(shape.getShape());
//		event.setType(shape.getType());
//		event.setColor(shape.getColor());
//		event.setThickness(shape.getThickness());
//	    event.setFill(shape.isFill());
//		event.setTransparent(shape.isTransparent());	
		recorder.record(session, event);	
	}
	
	@Override
	public void addText(Annotation text, Presentation presentation) {
		AddTextWhiteboardRecordEvent event = new AddTextWhiteboardRecordEvent();
		event.setMeetingId(session);
		event.setTimestamp(System.currentTimeMillis());
		event.setPresentation(presentation.getName());
		event.setPageNumber(presentation.getActivePage().getPageIndex());
//		event.setText(text.getText());
//		event.setTextColor(text.getTextColor());
//		event.setBGColor(text.getBgColor());
//		event.setBGColorVisible(text.getBgColorVisible());
//		event.setDataPoints(text.getLocation());
		recorder.record(session, event);	
	}
	
	@Override
	public void clearPage(Presentation presentation) {
		ClearPageWhiteboardRecordEvent event = new ClearPageWhiteboardRecordEvent();
		event.setMeetingId(session);
		event.setTimestamp(System.currentTimeMillis());		
		event.setPresentation(presentation.getName());
		event.setPageNumber(presentation.getActivePage().getPageIndex());
		
		recorder.record(session, event);		
	}

	@Override
	public void undoWBGraphic(Presentation presentation) {
		UndoShapeWhiteboardRecordEvent event = new UndoShapeWhiteboardRecordEvent();
		event.setMeetingId(session);
		event.setTimestamp(System.currentTimeMillis());		
		event.setPresentation(presentation.getName());
		event.setPageNumber(presentation.getActivePage().getPageIndex());
		
		recorder.record(session, event);			
	}

	@Override
	public void toggleGrid(boolean enabled, Presentation presentation) {
		ToggleGridWhiteboardRecordEvent event = new ToggleGridWhiteboardRecordEvent();
		event.setMeetingId(session);
		event.setTimestamp(System.currentTimeMillis());		
		event.setPresentation(presentation.getName());
		event.setPageNumber(presentation.getActivePage().getPageIndex());
		event.setGridEnabled(enabled);
		
		recorder.record(session, event);	
		
	}

	@Override
	public void modifyText(Annotation text, Presentation presentation) {
		ModifyTextWhiteboardRecordEvent event = new ModifyTextWhiteboardRecordEvent();
		event.setMeetingId(session);
		event.setTimestamp(System.currentTimeMillis());
		event.setPresentation(presentation.getName());
		event.setPageNumber(presentation.getActivePage().getPageIndex());
//		event.setText(text.getText());
//		event.setTextColor(text.getTextColor());
//		event.setBGColor(text.getBgColor());
//		event.setBGColorVisible(text.getBgColorVisible());
//		event.setDataPoints(text.getLocation());
//		event.setModifyingID(text.getID());
		recorder.record(session, event);	
	}

	@Override
	public void undoShape(Presentation presentation) {
		// TODO Auto-generated method stub
		
	}

//	@Override
//	public void addShape(ShapeGraphic shape, Presentation presentation) {
		// TODO Auto-generated method stub
//		
//	}

}
