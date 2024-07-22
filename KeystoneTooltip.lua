local line_added = false
local font_color = "|cffffffff"
local dungeon_reward_string = "Dungeon Reward: "
local vault_reward_string = "Vault Reward: "
local dungeon_item_level_table = { 597, 597, 600, 603, 606, 610, 610, 613 }
local dungeon_upgrade_track_table = { "Champion 1", "Champion 1", "Champion 2", "Champion 3", "Champion 4", "Hero 1", "Hero 1", "Hero 2"}
local vault_item_reward_table = { 606, 610, 610, 613, 613, 616, 619, 619, 623 }
local vault_upgrade_track_table = { "Champion 4", "Hero 1", "Hero 1", "Hero 2", "Hero 2", "Hero 3", "Hero 4", "Hero 4", "Myth 1" }


SLASH_KEYSTONETOOLTIP1 = "/kt"

SlashCmdList["KEYSTONETOOLTIP"] = function(msg)
    print(dungeon_reward_string .. GetDungeonReward(tonumber(msg)) .. ", " .. GetDungeonRewardTrack(tonumber(msg)))
    print(vault_reward_string .. GetVaultReward(tonumber(msg)) .. ", " .. GetVaultRewardTrack(tonumber(msg)))
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
        local key_level = GetKeyLevel(item_string)
        local dungeon_item_level = GetDungeonReward(key_level)
        local dungeon_upgrade_track = GetDungeonRewardTrack(key_level)
        local vault_item_level = GetVaultReward(key_level)
        local vault_upgrade_track = GetVaultRewardTrack(key_level)

        if not line_added then
            tooltip:AddLine(font_color .. dungeon_reward_string .. dungeon_item_level .. ", " .. dungeon_upgrade_track .. "|r")
            tooltip:AddLine(font_color .. vault_reward_string .. vault_item_level .. ", " .. vault_upgrade_track .. "|r")
            line_added = true
        end
    end
end


local function OnTooltipCleared(tooltip, ...) line_added = false end


local function SetHyperlink_Hook(self, hyperlink, text, button)
    local item_string = GetItemString(hyperlink)
    if item_string == nil or item_string == "" then return end
    if strsplit(":", item_string) == "keystone" then
        local key_level = GetKeyLevel(hyperlink)
        local dungeon_item_level = GetDungeonReward(key_level)
        local dungeon_upgrade_track = GetDungeonRewardTrack(key_level)
        local vault_item_level = GetVaultReward(key_level)
        local vault_upgrade_track = GetVaultRewardTrack(key_level)
        ItemRefTooltip:AddLine(font_color .. dungeon_reward_string .. dungeon_item_level .. ", " .. dungeon_upgrade_track .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. vault_reward_string .. vault_item_level .. ", " .. vault_upgrade_track .. "|r", 1, 1, 1, true)
        ItemRefTooltip:Show()
    end
end


function GetDungeonReward(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 9 then
            -- return the last element in the table
            return tostring(dungeon_item_level_table[#dungeon_item_level_table])
        else
            -- return the element at the index of key_level-1
            return tostring(dungeon_item_level_table[key_level-1])
        end
    end
end


function GetDungeonRewardTrack(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 9 then
            -- return the last element in the table
            return dungeon_upgrade_track_table[#dungeon_upgrade_track_table]
        else
            -- return the element at the index of key_level-1
            return dungeon_upgrade_track_table[key_level-1]
        end
    end
end


function GetVaultReward(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 10 then
            -- return the last element in the table
            return tostring(vault_item_reward_table[#vault_item_reward_table])
        else
            -- return the element at the index of key_level-1
            return tostring(vault_item_reward_table[key_level-1])
        end
    end
end


function GetVaultRewardTrack(key_level)
    if key_level == nil or key_level < 2 then
        -- Key value outside of normal range, return err
        return "Unknown Key Level"
    else
        if key_level > 10 then
            -- return the last element in the table
            return vault_upgrade_track_table[#vault_upgrade_track_table]
        else
            -- return the element at the index of key_level-1
            return vault_upgrade_track_table[key_level-1]
        end
    end
end


GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
