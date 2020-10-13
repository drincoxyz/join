-- https://github.com/drincoxyz/join

-- serverside module
if !SERVER then return end
-- reload disabled
 if istable(join) then return end

module("join", package.seeall)

-- team cooldowns
local cooldown = {}
-- player next join times
local nextjoin = {}
-- player previous teams
local prevteam = {}

-- updates the next join for a player based on their previous team
-- player must've joined a team at least once
-- uses real-world timing
-- doesn't work on bots
function Update(pl)
	-- bots aren't included
	if pl:IsBot() then return false end
	-- set next join based on previous team
	return Set(pl, GetCooldown(prevteam[pl:SteamID()]))
end
-- sets the next join for a player relative to the current time
-- uses real-world timing
-- doesn't work on bots
function Set(pl, time)
	-- bots aren't included
	if pl:IsBot() then return false end
	-- time must be more than 0 seconds
	time = tonumber(time) || 0
	if time < 0 then return false end
	
	local id = pl:SteamID()

	-- set next join
	nextjoin[id] = RealTime() + time
	-- automatically clear next join
	hook.Add("Think", "join_"..id, function()
		-- still waiting to clear next join
		if RealTime() < nextjoin[id] then return end
		-- clear next join
		nextjoin[id] = nil
		hook.Remove("Think", "join_"..id)
	end)

	-- success
	return true
end
-- returns the next join for a player
-- uses real-world timing
-- always returns 0 for bots
function Get(pl)
	-- bots aren't included
	if pl:IsBot() then return 0 end
	-- return next join
	return nextjoin[pl:SteamID()] || 0
end

-- returns whether a player is ready to join another team
function Check(pl)
	return Get(pl) <= 0
end

-- sets the join cooldown of a team
function SetCooldown(id, time)
	cooldown[id] = math.max(0, tonumber(time) || cooldown[id])
end
-- returns the join cooldown of a team
function GetCooldown(id)
	return cooldown[id] || 0
end

-- team change event
hook.Add("PlayerChangedTeam", "joinlib", function(pl, old, new)
	local id = pl:SteamID()
	-- update previous team
	prevteam[id] = old
end)
