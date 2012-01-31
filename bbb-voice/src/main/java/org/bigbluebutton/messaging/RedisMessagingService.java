package org.bigbluebutton.messaging;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RedisMessagingService implements MessagingService {
	private static Logger log = Red5LoggerFactory.getLogger(RedisMessagingService.class, "sip");
	
	JedisPool pool;

	@Override
	public void start() {
		log.debug("Start RedisMessagingService...");
	}

	@Override
	public void stop() {
		log.debug("Stop RedisMessagingService...");
		try{
			pool.destroy();
		}catch(Exception e){
			log.warn("Exception: " + e.getMessage());
		}
	}

	@Override
	public void send(String channel, String message) {
		Jedis jedis = pool.getResource();
		try {
			jedis.publish(channel, message);
		} catch(Exception e){
			log.warn("Cannot publish the message to redis", e);
		}finally{
			pool.returnResource(jedis);
		}
	}
	
	public void setRedisPool(JedisPool pool){
		this.pool = pool;
	}

}
