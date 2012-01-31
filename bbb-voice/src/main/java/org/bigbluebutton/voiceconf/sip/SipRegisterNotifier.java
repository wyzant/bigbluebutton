package org.bigbluebutton.voiceconf.sip;

import java.util.HashMap;

import org.bigbluebutton.messaging.MessagingConstants;
import org.bigbluebutton.messaging.MessagingService;

import com.google.gson.Gson;

public class SipRegisterNotifier implements SipRegisterAgentListener {

	MessagingService messagingService;
	
	static final String REGISTER_SUCCESS_EVENT = "REGISTER_SUCCESS_EVENT";
	static final String REGISTER_FAILURE_EVENT = "REGISTER_FAILURE_EVENT";
	static final String UNREGISTER_SUCCESS_EVENT = "UNREGISTER_SUCCESS_EVENT";
	
	@Override
	public void onRegistrationSuccess(String result) {
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("event", REGISTER_SUCCESS_EVENT);
		map.put("result", result );
		Gson gson = new Gson();
		messagingService.send(MessagingConstants.VOICE_CHANNEL, gson.toJson(map));
	}

	@Override
	public void onRegistrationFailure(String result) {
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("event", REGISTER_FAILURE_EVENT);
		map.put("result", result );
		Gson gson = new Gson();
		messagingService.send(MessagingConstants.VOICE_CHANNEL, gson.toJson(map));
	}

	@Override
	public void onUnregistedSuccess() {
		HashMap<String,String> map = new HashMap<String, String>();
		map.put("event", REGISTER_FAILURE_EVENT);
		Gson gson = new Gson();
		messagingService.send(MessagingConstants.VOICE_CHANNEL, gson.toJson(map));
	}
	
	public void setMessagingService(MessagingService messagingService){
		this.messagingService = messagingService;
	}

}
