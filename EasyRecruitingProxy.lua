EasyRecruitingProxy = CreateFrame("Frame", "ERPMainContainerFrame", UIParent);
EasyRecruitingProxy.addonName = "EasyRecruitingProxy";
EasyRecruitingProxy.Constants = {};
EasyRecruitingProxy.initiated = nil;
EasyRecruitingProxy.Utils = {};

ERPSettings = ERPSettings or {
  channelsToSpam = {
    "Trade - City"
  },
  officers = {},
  minimap = {
    hide = false,
  },
};

function EasyRecruitingProxy:toggleOptions()
  if ( ERPMainFrame:IsShown() ) then
    ERPMainFrame:Hide();
  else
    ERPMainFrame:Show();
  end
end

function EasyRecruitingProxy:OnEvent(event, ...)
  local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;

  if ( event == "PLAYER_ENTERING_WORLD") then
    EasyRecruitingProxy:init();
  end

  if ( event == "CHAT_MSG_WHISPER") then
    EasyRecruitingProxy.Utils.Message.routeWshipers(self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13);
  end
end

function EasyRecruitingProxy:init()
  if ( not self.initiated ) then
    local easyRecruitingProxyLDB, icon;
    self.Utils.General.hidePrefixedMessages();
    --if LibStub("LibDataBroker-1.1", true) then
      easyRecruitingProxyLDB = LibStub("LibDataBroker-1.1"):NewDataObject(EasyRecruitingProxy.addonName, {
        type = "data source",
        icon = "Interface\\AddOns\\EasyRecruitingProxy\\Icons\\BattlenetWorking0",
        OnClick = EasyRecruitingProxy.toggleOptions,
      });
    --end

    --if LibStub("LibDBIcon-1.0", true) then
      icon = LibStub("LibDBIcon-1.0");
      icon:Register(EasyRecruitingProxy.addonName, easyRecruitingProxyLDB, ERPSettings.minimap);
    --end
    EasyRecruitingProxy.initiated = true;
  end
end

function EasyRecruitingProxy:bindEvents()
  self:RegisterEvent("CHAT_MSG_WHISPER");
  self:RegisterEvent("PLAYER_ENTERING_WORLD");
  self:SetScript("OnEvent", self.OnEvent);
end

function EasyRecruitingProxy:RegisterSlashCommands()
  SLASH_ERP1 = "/ERP";
  SLASH_ERP2 = "/EasyRecruitingProxy";
  SlashCmdList["ERP"] = function(msg)
    EasyRecruitingProxy:toggleOptions()
  end
end

EasyRecruitingProxy:RegisterSlashCommands();
EasyRecruitingProxy:bindEvents();
