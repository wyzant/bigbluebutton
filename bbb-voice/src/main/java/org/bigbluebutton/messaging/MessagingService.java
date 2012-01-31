package org.bigbluebutton.messaging;

public interface MessagingService {
	public void start();
	public void stop();
	public void send(String channel, String message);

}
