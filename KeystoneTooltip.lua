local line_added = false
local font_color = "|cffffffff"
local dungeon_reward_string = "Dungeon Reward: "
local vault_reward_string = "Vault Reward: "
local dungeon_rewards = { 441, 444, 444, 447, 447, 450, 450, 454, 454, 457, 457, 460, 460, 463, 463, 467, 467, 470, 470 }
local dungeon_reward_track = { "Veteran 1/8", "Veteran 2/8", "Veteran 2/8", "Veteran 3/8", "Veteran 3/8", "Veteran 4/8", "Veteran 4/8", "Champion 1/8", "Champion 1/8", "Champion 2/8", "Champion 2/8", "Champion 3/8", "Champion 3/8", "Champion 4/8", "Champion 4/8", "Hero 1/6", "Hero 1/6", "Hero 2/6", "Hero 2/6" }
local vault_rewards = { 454, 457, 460, 460, 463, 463, 467, 467, 470, 470, 473, 473, 473, 476, 476, 476, 480, 480, 483 }
local vault_reward_track = { "Champion 1/8", "Champion 2/8", "Champion 3/8", "Champion 3/8", "Champion 4/8", "Champion 4/8", "Hero 1/6", "Hero 1/6", "Hero 2/6", "Hero 2/6", "Hero 3/6", "Hero 3/6", "Hero 3/6", "Hero 4/6", "Hero 4/6", "Hero 4/6", "Myth 1/4", "Myth 1/4", "Myth 2/4" }


SLASH_KEYSTONETOOLTIP1 = "/kt"

SlashCmdList["KEYSTONETOOLTIP"] = function(msg)
    print(dungeon_reward_string .. GetDungeonReward(tonumber(msg)) .. " " .. dungeon_reward_track)
    print(vault_reward_string .. GetVaultReward(tonumber(msg)) .. " " .. vault_reward_track)
end


local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "ADDON_LOADED") then
        local addon = ...
    end
end)


local function GetItemString(parent_string)
    return string.match(parent_string, "keystone[%-?%d:]+")
end


local function GetKeyLevel(parent_string)
    return tonumber(select(4, strsplit(":", parent_string)))
end


local function OnTooltipSetItem(tooltip, ...)
    name, link = GameTooltip:GetItem()

    if (link == nil) then return end

    for item_link in link:gmatch("|%x+|Hkeystone:.-|h.-|h|r") do
        local item_string = GetItemString(item_link)
        local mlvl = GetKeyLevel(item_string)
        local ilvl = GetDungeonReward(mlvl)
        local dtrack = GetDungeonRewardTrack(mlvl)
        local wlvl = GetVaultReward(mlvl)
        local vtrack = GetVaultRewardTrack(mlvl)

        if not line_added then
            tooltip:AddLine(font_color .. dungeon_reward_string .. ilvl .. "|r")
            tooltip:AddLine(font_color .. dungeon_reward_string .. dtrack .. "|r")
            tooltip:AddLine(font_color .. vault_reward_string .. wlvl .. "|r")
            tooltip:AddLine(font_color .. vault_reward_string .. vtrack .. "|r")
            line_added = true
        end
    end
end


local function OnTooltipCleared(tooltip, ...) line_added = false end


local function SetHyperlink_Hook(self, hyperlink, text, button)
    local item_string = GetItemString(hyperlink)
    if item_string == nil or item_string == "" then return end
    if strsplit(":", item_string) == "keystone" then
        local mlvl = GetKeyLevel(hyperlink)
        local ilvl = GetDungeonReward(mlvl)
        local dtrack = GetDungeonRewardTrack(mlvl)
        local wlvl = GetVaultReward(mlvl)
        local vtrack = GetVaultRewardTrack(mlvl)
        ItemRefTooltip:AddLine(font_color .. dungeon_reward_string .. ilvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. dungeon_reward_string .. dtrack .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. vault_reward_string .. wlvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. vault_reward_string .. vtrack .. "|r", 1, 1, 1, true)
        ItemRefTooltip:Show()
    end
end


function GetDungeonReward(mlvl)
    if mlvl == nil or mlvl < 2 then
        return "Unknown Key Level"
    else
        if mlvl > 20 then
            return tostring(dungeon_rewards[#dungeon_rewards])
        else
            return tostring(dungeon_rewards[mlvl-1])
        end
    end
end


function GetDungeonRewardTrack(mlvl)
    if mlvl == nil or mlvl < 2 then
        return "Unknown Key Level"
    else
        if mlvl > 20 then
            return dungeon_reward_track[#dungeon_reward_track]
        else
            return dungeon_reward_track[mlvl-1]
        end
    end
end


function GetVaultReward(mlvl)
    if mlvl == nil or mlvl < 2 then
        return "Unknown Key Level"
    else
        if mlvl > 20 then
            return tostring(vault_rewards[#vault_rewards])
        else
            return tostring(vault_rewards[mlvl-1])
        end
    end
end


function GetVaultRewardTrack(mlvl)
    if mlvl == nil or mlvl < 2 then
        return "Unknown Key Level"
    else
        if mlvl > 20 then
            return vault_reward_track[#vault_reward_track])
        else
            return vault_reward_track[mlvl-1])
        end
    end
end


GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
