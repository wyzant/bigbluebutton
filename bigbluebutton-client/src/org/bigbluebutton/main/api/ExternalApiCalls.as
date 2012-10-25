package org.bigbluebutton.main.api
{
  import flash.external.ExternalInterface;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.EventConstants;
  import org.bigbluebutton.core.UsersUtil;
  import org.bigbluebutton.core.events.CoreEvent;
  import org.bigbluebutton.core.managers.UserManager;
  import org.bigbluebutton.main.events.ParticipantJoinEvent;
  import org.bigbluebutton.main.model.users.BBBUser;

  public class ExternalApiCalls
  {   
    public function handleSwitchToNewRoleEvent(event:CoreEvent):void {
      var payload:Object = new Object();
      payload.eventName = EventConstants.NEW_ROLE;
      payload.role = event.message.role;
      LogUtil.debug("Switch to new role [" + payload.role + "]");
      broadcastEvent(payload);        
    }
        
    public function handleGetMyRoleResponse(event:CoreEvent):void {
      var payload:Object = new Object();
      payload.eventName = EventConstants.GET_MY_ROLE_RESP;
      payload.myRole = event.message.myRole;
      broadcastEvent(payload);        
    }
    
    public function handleUserJoinedVoiceEvent():void {
      LogUtil.debug("User has joined voice conference.");
      var payload:Object = new Object();
      payload.eventName = "userHasJoinedVoiceConference";
      broadcastEvent(payload);
    }
    
    public function handleSwitchedLayoutEvent(layoutID:String):void {
      var payload:Object = new Object();
      payload.eventName = "switchedLayoutEvent";
      payload.layoutID = layoutID;
      broadcastEvent(payload);
    }
        
    public function handleNewPublicChatEvent(event:CoreEvent):void {
      LogUtil.debug("handleNewPublicChatEvent");
      var payload:Object = new Object();
      payload.eventName = EventConstants.NEW_PUBLIC_CHAT;
      payload.chatType = event.message.chatType;      
      payload.fromUsername = event.message.fromUsername;
      payload.fromColor = event.message.fromColor;
      payload.fromLang = event.message.fromLang;
      payload.fromTime = event.message.fromTime;      
      payload.fromTimezoneOffset = event.message.fromTimezoneOffset;
      payload.message = event.message.message;
      
      // Need to convert the internal user id to external user id in case the 3rd-party app passed 
      // an external user id for it's own use.
      LogUtil.debug("Looking externUserID for userID [" + event.message.fromUserID + "]");
      payload.fromUserID = UsersUtil.internalUserIDToExternalUserID(event.message.fromUserID);
      
      broadcastEvent(payload);
    }
    
    public function handleNewPrivateChatEvent(event:CoreEvent):void {
      LogUtil.debug("handleNewPrivateChatEvent");
      var payload:Object = new Object();
      payload.eventName = EventConstants.NEW_PRIVATE_CHAT;
      payload.chatType = event.message.chatType;      
      payload.fromUsername = event.message.fromUsername;
      payload.fromColor = event.message.fromColor;
      payload.fromLang = event.message.fromLang;
      payload.fromTime = event.message.fromTime;    
      payload.fromTimezoneOffset = event.message.fromTimezoneOffset;
      payload.toUsername = event.message.toUsername;
      payload.message = event.message.message;
      
      // Need to convert the internal user id to external user id in case the 3rd-party app passed 
      // an external user id for it's own use.
      payload.fromUserID = UsersUtil.internalUserIDToExternalUserID(event.message.fromUserID);
      payload.toUserID = UsersUtil.internalUserIDToExternalUserID(event.message.toUserID);
      
      broadcastEvent(payload);
    }
        
    public function handleParticipantJoinEvent(event:ParticipantJoinEvent):void {
      var payload:Object = new Object();
      var user:BBBUser = UserManager.getInstance().getConference().getUser(event.userID);
      
      if (user == null) {
        LogUtil.warn("[ExternalApiCall:handleParticipantJoinEvent] Cannot find user with ID [" + event.userID + "]");
        return;
      }
      
      if (event.join) {
        payload.eventName = EventConstants.USER_JOINED;
        payload.userID = user.userID;
        payload.userName = user.name;        
      } else {
        payload.eventName = EventConstants.USER_LEFT;
        payload.userID = user.userID;
      }
      
      broadcastEvent(payload);        
    }    
    
    private function broadcastEvent(message:Object):void {
      if (ExternalInterface.available) {
        ExternalInterface.call("BBB.handleFlashClientBroadcastEvent", message);
      }      
    }
  }
}