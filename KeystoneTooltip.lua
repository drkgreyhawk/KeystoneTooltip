local line_added = false
local font_color = "|cffffffff"
local dungeon_reward_string = "Dungeon Reward: "
local vault_reward_string = "Vault Reward: "
local dungeon_rewards = { 402, 405, 405, 408, 408, 411, 411, 415, 415, 418, 418, 421, 421, 424, 424, 428, 428, 431, 431 }
local vault_rewards = { 415, 418, 421, 421, 424, 424, 428, 428, 431, 431, 434, 434, 437, 437, 441, 441, 444, 444, 447 }


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
        local wlvl = GetVaultReward(mlvl)

        if not line_added then
            tooltip:AddLine(font_color .. dungeon_reward_string .. ilvl .. "|r")
            tooltip:AddLine(font_color .. vault_reward_string .. wlvl .. "|r")
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
        local wlvl = GetVaultReward(mlvl)		
        ItemRefTooltip:AddLine(font_color .. dungeon_reward_string .. ilvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:AddLine(font_color .. vault_reward_string .. wlvl .. "|r", 1, 1, 1, true)
        ItemRefTooltip:Show()
    end
end


function GetDungeonReward(mlvl)
    if mlvl > 20 then
        return tostring(dungeon_rewards[#dungeon_rewards])
    else
        return tostring(dungeon_rewards[mlvl-1])
    end
end


function GetVaultReward(mlvl)
    if mlvl > 20 then
        return tostring(vault_rewards[#vault_rewards])
    else
        return tostring(vault_rewards[mlvl-1])
    end
end


GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)