package org.bigbluebutton.conference.service;

import java.util.ArrayList;
import java.util.HashMap;
import org.red5.server.api.Red5;
import org.slf4j.Logger;
import org.bigbluebutton.conference.RoomsManager;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.service.ServiceUtils;

public class BigBlueButton {
	private static Logger log = Red5LoggerFactory.getLogger( BigBlueButton.class, "bigbluebutton" );
	
	private RoomsManager roomsManager;
	
	public void sendMessage(HashMap<String, Object> params) {
		String roomName = Red5.getConnectionLocal().getScope().getName();
		
		log.debug(params.get("messageEvent") + " " + params.get("message") + " " + params.get("count"));
		ArrayList<HashMap> ar = (ArrayList<HashMap>)params.get("array");

		for (int i=0; i < ar.size(); i++) {
			HashMap<String, Object> elem = (HashMap<String, Object>) ar.get(i);
			log.debug(elem.get("e1") + "=" + elem.get("e2"));
		}		
		
		ArrayList<Object> m = new ArrayList<Object>();
		m.add("Hello World!");
		ServiceUtils.invokeOnAllConnections(Red5.getConnectionLocal().getScope(), "handleMessage", new Object[] {"publicChatMessageEvent", params.get("message")});
	}
	
	
	public void setRoomsManager(RoomsManager r) {
		log.debug("Setting room manager");
		roomsManager = r;
	}
	
}
