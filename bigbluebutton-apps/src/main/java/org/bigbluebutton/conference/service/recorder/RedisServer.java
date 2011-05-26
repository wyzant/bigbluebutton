package org.bigbluebutton.conference.service.recorder;

import redis.clients.jedis.Jedis;

public class RedisServer {
	protected Jedis jedis;

	public RedisServer(String server, int port) {
		jedis = new Jedis(server, port,0);
		jedis.set("foo", "bar");
	}

	public Jedis getJedis(){
		return jedis;
	}
	
	public void closeConnection(){
		try {
			jedis.disconnect();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
