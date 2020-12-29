KeystoneLoot = LibStub("AceAddon-3.0"):NewAddon("KeystoneLoot", "AceConsole-3.0", "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("KeystoneLoot", true)

local lineAdded = false

local numScreen = ""

local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");

frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "ADDON_LOADED") then
        local addon = ...
    end
end)

-- Tooltip functions

local function OnTooltipSetItem(tooltip, ...)
    name, link = GameTooltip:GetItem()

    -- The player is using the Auction House, return!
    if (link == nil) then return end

    for itemLink in link:gmatch("|%x+|Hkeystone:.-|h.-|h|r") do
        local itemString = string.match(itemLink, "keystone[%-?%d:]+")
        local mlvl = select(4, strsplit(":", itemString))
        local ilvl = MythicLootItemLevel(mlvl)
        local wlvl = MythicWeeklyLootItemLevel(mlvl)
        local icolor = "|cff00ccff"

        if not lineAdded then
            tooltip:AddLine("|cffffffff" .. L["Dungeon Reward: "] .. icolor .. ilvl .. "|r")
            tooltip:AddLine("|cffffffff" .. L["Weekly Reward: "] .. icolor .. wlvl .. "|r")
            lineAdded = true
        end
    end
end

local function OnTooltipCleared(tooltip, ...) lineAdded = false end

-- ITEM REF Tooltip
local function SetHyperlink_Hook(self, hyperlink, text, button)
    local itemString = string.match(hyperlink, "keystone[%-?%d:]+")
    if itemString == nil or itemString == "" then return end
    if strsplit(":", itemString) == "keystone" then
        local mlvl = select(4, strsplit(":", hyperlink))
        local ilvl = MythicLootItemLevel(mlvl)
        local wlvl = MythicWeeklyLootItemLevel(mlvl)
        local icolor = "|cff00ccff"

        ItemRefTooltip:AddLine("|cffffffff" .. L["Dungeon Reward: "] .. icolor .. ilvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine("|cffffffff" .. L["Weekly Reward: "] .. icolor .. wlvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:Show()
    end
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)


-- Dungeon Item Levels
function MythicLootItemLevel(mlvl)
    if (mlvl == "2") then
        return "187"
    elseif (mlvl == "3") then
        return "190"
    elseif (mlvl == "4" or mlvl == "5") then
        return "194"
    elseif (mlvl == "6") then
        return "197"
    elseif (mlvl == "7" or mlvl == "8" or mlvl == "9") then
        return "200"
    elseif (mlvl == "10" or mlvl == "11") then
        return "203"
    elseif (mlvl == "12" or mlvl == "13" or mlvl == "14") then
        return "207"
    elseif (mlvl >= "15") then
        return "210"
    else
        return ""
    end
end

-- Weekly Reward Item Levels
function MythicWeeklyLootItemLevel(mlvl)
    if (mlvl == "2") then
        return "200"
    elseif (mlvl == "3") then
        return "203"
    elseif (mlvl == "4") then
        return "207"
    elseif (mlvl == "5" or mlvl == "6") then
        return "210"
    elseif (mlvl == "7") then
        return "213"
    elseif (mlvl == "8" or mlvl == "9") then
        return "216"
    elseif (mlvl == "10" or mlvl == "11") then
        return "220"
    elseif (mlvl == "12" or mlvl == "13") then
        return "223"
    elseif (mlvl >= "14") then
        return "226"
    else
        return ""
    end
end
