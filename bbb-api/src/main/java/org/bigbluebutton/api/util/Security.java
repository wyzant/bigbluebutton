package org.bigbluebutton.api.util;

import java.io.IOException;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.bigbluebutton.api.Create;
import org.bigbluebutton.api.xml.StandardResponse;
import org.bigbluebutton.api.xml.XMLConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Security {
	
	static final Logger log = LoggerFactory.getLogger(Security.class);
	static final XMLConverter xmlConverter = XMLConverter.getInstance();
	
	public static Boolean doChecksumSecurity(String callName, HttpServletRequest request, HttpServletResponse response){
		log.debug("Security: #doChecksumSecurity");
		log.debug("checksum: " + request.getParameter("checksum") + "; query string: " + request.getQueryString());
		
		if (StringUtils.isEmpty(callName)){
			throw new RuntimeException("Programming error - you must pass the call name to doChecksumSecurity so it can be used in the checksum");
		}
		if (StringUtils.isEmpty(request.getQueryString())){
			invalid("noQueryString", "No query string was found in your request.", response);
			return false;
		}
		
		return true;
	}
	
	private static void invalid(String key, String message, HttpServletResponse response){
		log.debug("Security : #invalid");
		try{
			response.addHeader("Cache-Control", "no-cache");
			response.setContentType("text/xml");
			StandardResponse responseBody = new StandardResponse(StandardResponse.RESP_CODE_FAILED, key, message);
			response.getWriter().println(xmlConverter.xml().toXML(responseBody));
		} catch (IOException e){
			
		}
		
	}
}
