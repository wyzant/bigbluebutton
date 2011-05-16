package org.bigbluebutton.api;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bigbluebutton.api.conference.DynamicConference;
import org.bigbluebutton.api.conference.DynamicConferenceService;
import org.bigbluebutton.api.util.Invalid;
import org.bigbluebutton.api.util.Security;
import org.bigbluebutton.api.xml.XMLConverter;
import org.bigbluebutton.conference.Room;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet Filter implementation class GetMeetingInfo
 */
public class GetMeetingInfo implements Filter {
	
	private static final String CALL_NAME = "create";

	static final Logger log = LoggerFactory.getLogger(Join.class);
	static final DynamicConferenceService dynamicConferenceService = DynamicConferenceService.getInstance();
	static final XMLConverter xmlConverter = XMLConverter.getInstance();
	
    /**
     * Default constructor. 
     */
    public GetMeetingInfo() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)){
			throw new RuntimeException("Only HTTP is supported by the BigBlueButton API");
		}
		
		HttpServletRequest httpReq = (HttpServletRequest)request;
		HttpServletResponse httpRes = (HttpServletResponse)response;
		
		log.debug("entered /getMeetingInfo");
		
		if (!Security.doChecksumSecurity(CALL_NAME, httpReq, httpRes)) return;
		
		String mtgID = httpReq.getParameter("meetingID");
		String callPW = httpReq.getParameter("password");
		
		//check for existing
		DynamicConference conf = dynamicConferenceService.getConferenceByMeetingID(mtgID);
		Room room = dynamicConferenceService.getRoomByMeetingId(mtgID);
		
		if (conf == null){
			Invalid.invalid("notFound", "We could not find a meeting with that meeting ID", httpRes);
			return;
		}
		
		if (conf.getModeratorPassword().equals(callPW) == false){
			Invalid.invalid("invalidPassword", "You must supply the moderator password for this call.", httpRes);
		}
		
		respondWithConferenceDetails(conf, room, null, null, httpRes);

		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}
	
	private void respondWithConferenceDetails(DynamicConference conf, Room room, String messageKey, String message, HttpServletResponse response){
		response.addHeader("Cache-Control", "no-cache");
		
	}

}
