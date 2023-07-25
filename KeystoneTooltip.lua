KeystoneTooltip = LibStub("AceAddon-3.0"):NewAddon("KeystoneTooltip", "AceConsole-3.0", "AceEvent-3.0");

local L = LibStub("AceLocale-3.0"):GetLocale("KeystoneTooltip", true)

local line_added = false
local font_color = "|cffffffff"
local dungeon_reward_string = L["Dungeon Reward: "]
local vault_reward_string = L["Vault Reward: "]

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "ADDON_LOADED") then
        local addon = ...
    end
end)


local function OnTooltipSetItem(tooltip, ...)
    name, link = GameTooltip:GetItem()

    if (link == nil) then return end

    for itemLink in link:gmatch("|%x+|Hkeystone:.-|h.-|h|r") do
        local itemString = string.match(itemLink, "keystone[%-?%d:]+")
        local mlvl = select(4, strsplit(":", itemString))

        local ilvl = MythicLootItemLevel(mlvl)
        local wlvl = MythicWeeklyLootItemLevel(mlvl)

        if not line_added then
            tooltip:AddLine(font_color .. dungeon_reward_string .. ilvl .. "|r")
            tooltip:AddLine(font_color .. vault_reward_string .. wlvl .. "|r")
            line_added = true
        end
    end
end


local function OnTooltipCleared(tooltip, ...) line_added = false end


local function SetHyperlink_Hook(self, hyperlink, text, button)
    local itemString = string.match(hyperlink, "keystone[%-?%d:]+")
    if itemString == nil or itemString == "" then return end
    if strsplit(":", itemString) == "keystone" then
        local mlvl = select(4, strsplit(":", hyperlink))
        local ilvl = MythicLootItemLevel(mlvl)
        local wlvl = MythicWeeklyLootItemLevel(mlvl)		
        ItemRefTooltip:AddLine(font_color .. dungeon_reward_string .. ilvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. vault_reward_string .. wlvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:Show()
    end
end


GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)


function MythicLootItemLevel(mlvl)
    if (mlvl == "2") then
        return "402"
    elseif (mlvl == "3") then
        return "405"
    elseif (mlvl == "4") then
        return "405"
    elseif (mlvl == "5") then
        return "408"
    elseif (mlvl == "6") then
        return "408"
    elseif (mlvl == "7") then
        return "411"
    elseif (mlvl == "8") then
        return "411"
    elseif (mlvl == "9") then
        return "415"
    elseif (mlvl == "10") then
        return "415"
    elseif (mlvl == "11") then
        return "418"
    elseif (mlvl == "12") then
        return "418"
    elseif (mlvl == "13") then
        return "421"
    elseif (mlvl == "14") then
        return "421"
    elseif (mlvl == "15") then
        return "424"
    elseif (mlvl == "16") then
        return "424"
    elseif (mlvl == "17") then
        return "428"
    elseif (mlvl == "18") then
        return "428"
    elseif (mlvl == "19") then
        return "431"
    elseif (mlvl >= "20") then
        return "431"
    else
        return ""
    end
end


function MythicWeeklyLootItemLevel(mlvl)
    if (mlvl == "2") then
        return "415"
    elseif (mlvl == "3") then
        return "418"
    elseif (mlvl == "4") then
        return "421"
    elseif (mlvl == "5") then
        return "421"
    elseif (mlvl == "6") then
        return "424"
    elseif (mlvl == "7") then
        return "424"
    elseif (mlvl == "8") then
        return "428"
    elseif (mlvl == "9") then
        return "428"
    elseif (mlvl == "10") then
        return "431"
    elseif (mlvl == "11") then
        return "431"
    elseif (mlvl == "12") then
        return "434"
    elseif (mlvl == "13") then
        return "434"
    elseif (mlvl == "14") then
        return "437"
    elseif (mlvl == "15") then
        return "437"
    elseif (mlvl == "16") then
        return "441"
    elseif (mlvl == "17") then
        return "441"
    elseif (mlvl == "18") then
        return "444"
    elseif (mlvl == "19") then
        return "444"
    elseif (mlvl >= "20") then
        return "447"
    else
        return ""
    end
end
