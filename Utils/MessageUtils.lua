EasyRecruitingProxy.Utils.Message = {};

function EasyRecruitingProxy.Utils.Message.parseMessage(message)
  local parts = EasyRecruitingProxy.Utils.General.explode(EasyRecruitingProxy.Constants.MSG_PREFIX, message);
  local parsedMessage = {};
  if( parts[2] ) then
    parsedMessage = Json.parse(parts[2]);
    if(type(parsedMessage) == "table") then
      return parsedMessage;
    else
      EasyRecruitingProxy.Utils.General.log('Could not parse the incoming message');
      return false;
    end
  end
end

function EasyRecruitingProxy.Utils.Message.stringifyMessage(msg)
  return EasyRecruitingProxy.Constants.MSG_PREFIX..Json.stringify(msg);
end

function EasyRecruitingProxy.Utils.Message.createNotifyMessage(event, ...)
  return { type = "notify", event = event, args = ... };
end

function EasyRecruitingProxy.Utils.Message.createSpamAckMessage(num)
  return { type = "ack", num = num, event = "spam" };
end

function EasyRecruitingProxy.Utils.Message.createMessage(msg, sender, cId)
  return { msg = msg, sender = sender, cId = cId };
end

function EasyRecruitingProxy.Utils.Message.toUserFromOfficer(parsedMessage)
  if ( parsedMessage ) then
    SendChatMessage(parsedMessage.msg, "WHISPER", "Common", parsedMessage.to);
  end
end

function EasyRecruitingProxy.Utils.Message.toOfficerFromUser(message, sender, GUID)
  local msg, firstMessagePart, nextMessagePart, stringifiedMessage, guid, cId, className;
  firstMessagePart = string.sub(message, 1, 150);
  nextMessagePart = string.sub(message, 151);
  className = GetPlayerInfoByGUID(GUID);
  cId = EasyRecruitingProxy.Utils.Table.indexOf(EasyRecruitingProxy.Constants.CLASS_LIST, className);
  msg = EasyRecruitingProxy.Utils.Message.createMessage(firstMessagePart, sender, cId);
  stringifiedMessage = EasyRecruitingProxy.Utils.Message.stringifyMessage(msg);

  EasyRecruitingProxy.Utils.Message.toOfficerFromProxy(stringifiedMessage);

  if (string.len(nextMessagePart) > 0 ) then
    EasyRecruitingProxy.Utils.Message.toOfficerFromUser(nextMessagePart, sender, GUID);
  end
end

function EasyRecruitingProxy.Utils.Message.notifyToOfficers(event, ...)
  local msg, stringifiedMessage;
  msg = EasyRecruitingProxy.Utils.Message.createNotifyMessage(event, ...);
  stringifiedMessage = EasyRecruitingProxy.Utils.Message.stringifyMessage(msg);
  EasyRecruitingProxy.Utils.Message.toOfficerFromProxy(stringifiedMessage);
end

function EasyRecruitingProxy.Utils.Message.spamAkcToOfficers(num)
  local msg, stringifiedMessage;
  msg = EasyRecruitingProxy.Utils.Message.createSpamAckMessage(num);
  stringifiedMessage = EasyRecruitingProxy.Utils.Message.stringifyMessage(msg);
  EasyRecruitingProxy.Utils.Message.toOfficerFromProxy(stringifiedMessage);
end

function EasyRecruitingProxy.Utils.Message.toOfficerFromProxy(message)
  for index, value in pairs(ERPSettings.officers) do
    SendChatMessage(message, "WHISPER", "Common", value);
  end;
end

function EasyRecruitingProxy.Utils.Message.routeWshipers(self, message, sender, language, channelString, target, flags, arg7, channelNumber, channelName, arg10, arg11, GUID, arg13)
  if( EasyRecruitingProxy.Utils.Table.indexOf(ERPSettings.officers, sender) >= 1) then
    --DEFAULT_CHAT_FRAME:AddMessage("message from officers - proxy to user");
    local parsedMessage = EasyRecruitingProxy.Utils.Message.parseMessage(message);

    if ( parsedMessage ) then
      if (parsedMessage.type == "notify") then
        return true;
      end
      if ( parsedMessage.type == "action" ) then
        -- do action
        return true;
      end

      if ( parsedMessage.type == "spam" ) then
        for index, value in pairs(ERPSettings.channelsToSpam) do
          local channelId = GetChannelName(value);
          SendChatMessage(parsedMessage.msg, "CHANNEL", "Common", channelId);
        end;

        EasyRecruitingProxy.Utils.Message.spamAkcToOfficers(parsedMessage.num);
        return true;
      end

      EasyRecruitingProxy.Utils.Message.toUserFromOfficer(parsedMessage);
    end
  else
    EasyRecruitingProxy.Utils.Message.toOfficerFromUser(message, sender, GUID);
    --DEFAULT_CHAT_FRAME:AddMessage("message from user - proxy to officers");
  end
end