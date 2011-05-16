package org.bigbluebutton.api.xml;

import com.thoughtworks.xstream.annotations.XStreamAlias;

@XStreamAlias("response")
public class GetMeetingInfoResponse extends StandardResponse {

	public GetMeetingInfoResponse(String returncode, String messageKey, String message) {
		super(returncode, messageKey, message);
		
	}

}
