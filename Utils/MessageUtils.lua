EasyRecruitingProxy.Utils.Message = {};

function EasyRecruitingProxy.Utils.Message.createMessage(msg, sender, isRead)
  isRead = isRead or false;
  return { msg = msg, sender = sender, isRead = isRead };
end

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

function EasyRecruitingProxy.Utils.Message.proxyToUserFromOfficer(parsedMessage)
  if ( parsedMessage ) then
    SendChatMessage(parsedMessage.msg, "WHISPER", "Common", parsedMessage.to);
  end
end

function EasyRecruitingProxy.Utils.Message.proxyToOfficerFromUser(message, sender)
  local jsonMessage, firstMessagePart, nextMessagePart, encodedMessage;
  firstMessagePart = string.sub(message, 1, 50);
  nextMessagePart = string.sub(message, 51);
  jsonMessage = Json.stringify(EasyRecruitingProxy.Utils.Message.createMessage(firstMessagePart, sender));
  encodedMessage = EasyRecruitingProxy.Constants.MSG_PREFIX..jsonMessage;

  for index, value in pairs(ERPSettings.officers) do
    SendChatMessage(encodedMessage, "WHISPER", "Common", value);
  end;

  if (string.len(nextMessagePart) > 0 ) then
    EasyRecruitingProxy.Utils.Message.proxyToOfficerFromUser(nextMessagePart, sender);
  end
end

function EasyRecruitingProxy.Utils.Message.routeWshipers(self, message, sender, language, channelString, target, flags, arg7, channelNumber, channelName, arg8)
  if( EasyRecruitingProxy.Utils.Table.indexOf(ERPSettings.officers, sender) >= 1) then
    DEFAULT_CHAT_FRAME:AddMessage("I am proxy message from officers - proxy to user");
    local parsedMessage = EasyRecruitingProxy.Utils.Message.parseMessage(message);

    if ( parsedMessage ) then
      if ( parsedMessage.type == "action" ) then
        -- do action

        return true;
      end

      if ( parsedMessage.type == "note" ) then
        -- do somethign

        return true;
      end

      EasyRecruitingProxy.Utils.Message.proxyToUserFromOfficer(parsedMessage);
    end
  else
    EasyRecruitingProxy.Utils.Message.proxyToOfficerFromUser(message, sender);
    DEFAULT_CHAT_FRAME:AddMessage("I am proxy message from user - proxy to officers");
  end
end

--__ER__{"msg": "aaaaaaaaaaaaa", "to": "Zeemonk-Silvermoon"}
--__ER__{"msg": "aaaaaaaaaaaaa", "sender": "nefeli-Silvermoon"}
--12345678910111213141516171819202122232425262728293031323334353637383934041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798991001011021031041051061071081091101111121131141151161171181191201211221231241251261271281913013113213313413513613713819140141142143144145146147148149150


