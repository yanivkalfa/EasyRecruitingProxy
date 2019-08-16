EasyRecruitingProxy.Utils.General = {};

function EasyRecruitingProxy.Utils.General.getFullPlayerName()
  local playerName, realm = UnitFullName("player");
  local fullName = playerName;
  if ( realm ) then
    fullName = fullName .. "-".. realm;
  end
	return fullName, realm;
end

local function filterPrefixedMessages(msg)
	return string.find(msg, EasyRecruitingProxy.Constants.MSG_PREFIX);
end

local function hookChatFrame(frame)
	if (not frame) then
		return
	end

	local original = frame.AddMessage;
	if (original) then
		frame.AddMessage = function(t, msg, ...)
			if ( filterPrefixedMessages(msg) ) then
				return
			end
			original(t, msg, ...);
		end
	else
		Utils.log("Tried to hook non-chat frame");
	end
end

function EasyRecruitingProxy.Utils.General.hidePrefixedMessages()
	local frames = { ChatFrame1, ChatFrame2, ChatFrame3, ChatFrame4, ChatFrame5, ChatFrame6, ChatFrame7 };

	for index,frame in pairs(frames) do
		hookChatFrame(frame);
	end;
end

function EasyRecruitingProxy.Utils.General.log(msg, channel)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
	return;
end

function EasyRecruitingProxy.Utils.General.implode(delimiter, list)
  local len = table.getn(list);
  if len == 0 then
    return ""
  end
  
  local string = list[1]
  for i = 2, len do
    string = string .. delimiter .. list[i]
  end
  return string
end

function EasyRecruitingProxy.Utils.General.explode(delimiter, text)
  local list = {}; local pos = 1
  if string.find("", delimiter, 1) then
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end