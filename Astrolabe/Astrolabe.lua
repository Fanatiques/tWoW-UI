--[[
Name: Astrolabe
Revision: $Rev: 17 $
$Date: 2006-11-26 09:36:31 +0100 (So, 26 Nov 2006) $
Author(s): Esamynn (jcarrothers@gmail.com)
Inspired By: Gatherer by Norganna
             MapLibrary by Kristofer Karlsson (krka@kth.se)
Website: http://esamynn.wowinterface.com/
Documentation:
SVN:
Description:
	This is a library for the World of Warcraft UI system to place
	icons accurately on both the Minimap and the Worldmaps accurately
	and maintain the accuracy of those positions.

License:

Copyright (C) 2006  James Carrothers

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
]]

local LIBRARY_VERSION_MAJOR = "Astrolabe-0.2"
local LIBRARY_VERSION_MINOR = "$Revision: 20 $"

if not AceLibrary then error(LIBRARY_VERSION_MAJOR .. " requires AceLibrary.") end
if not AceLibrary:IsNewVersion(LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR) then return end

local Astrolabe = {};

-- define local variables for Data Tables (defined at the end of this file)
-- changed to global since TomTom needs it
--local WorldMapSize, MinimapSize;
WorldMapSize, MinimapSize = {}, {}
local initSizes

--------------------------------------------------------------------------------------------------------------
-- Working Tables and Config Constants
--------------------------------------------------------------------------------------------------------------

Astrolabe.LastPlayerPosition = {};
Astrolabe.MinimapIcons = {};


Astrolabe.MinimapUpdateTime = 0.1;
Astrolabe.UpdateTimer = 0;
Astrolabe.ForceNextUpdate = false;
Astrolabe.minimapOutside = false;
local twoPi = math.pi * 2;


--------------------------------------------------------------------------------------------------------------
-- General Utility Functions
--------------------------------------------------------------------------------------------------------------

local function getContPosition( zoneData, z, x, y )
	--Fixes nil error
	if z < 0 then
		z = 1;
	end
	if ( z ~= 0 ) then
		zoneData = zoneData[z];
		x = x * zoneData.width + zoneData.xOffset;
		y = y * zoneData.height + zoneData.yOffset;
	else
		x = x * zoneData.width;
		y = y * zoneData.height;
	end
	return x, y;
end

function Astrolabe:ComputeDistance( c1, z1, x1, y1, c2, z2, x2, y2 )
	z1 = z1 or 0;
	z2 = z2 or 0;

	local dist, xDelta, yDelta;
	if ( c1 == c2 and z1 == z2 ) then
		-- points in the same zone
		local zoneData = WorldMapSize[c1];
		if ( z1 ~= 0 ) then
			zoneData = zoneData[z1];
		end
		if zoneData == nil then
			return 0, 0, 0; -- temporary fix, todo: log this
		end
		xDelta = (x2 - x1) * zoneData.width;
		yDelta = (y2 - y1) * zoneData.height;
	elseif ( c1 == c2 and c1 < 3) then
		-- points on the same continent
		local zoneData = WorldMapSize[c1];
		if zoneData == nil then
			return 0, 0, 0; -- temporary fix, todo: log this
		end
		x1, y1 = getContPosition(zoneData, z1, x1, y1);
		x2, y2 = getContPosition(zoneData, z2, x2, y2);
		xDelta = (x2 - x1);
		yDelta = (y2 - y1);
	elseif ( c1 and c2 and c1 < 3 and c2 < 3) then
		local cont1 = WorldMapSize[c1];
		local cont2 = WorldMapSize[c2];
		if cont1 == nil or cont2 == nil then
			return 0, 0, 0; -- temporary fix, todo: log this
		end
		if ( cont1.parentContinent == cont2.parentContinent ) then
			if ( c1 ~= cont1.parentContinent ) then
				x1, y1 = getContPosition(cont1, z1, x1, y1);
				x1 = x1 + cont1.xOffset;
				y1 = y1 + cont1.yOffset;
			end
			if ( c2 ~= cont2.parentContinent ) then
				x2, y2 = getContPosition(cont2, z2, x2, y2);
				x2 = x2 + cont2.xOffset;
				y2 = y2 + cont2.yOffset;
			end

			xDelta = x2 - x1;
			yDelta = y2 - y1;
		end

	end
	if ( xDelta and yDelta ) then
		dist = sqrt(xDelta*xDelta + yDelta*yDelta);
	end
	return dist, xDelta, yDelta;
end

function Astrolabe:TranslateWorldMapPosition( C, Z, xPos, yPos, nC, nZ )
	Z = Z or 0;
	nZ = nZ or 0;
	if ( nC < 0 ) then
		return;
	end

	--Fixes nil error.
	if(C < 0) then
		C=2;
	end
	if(nC < 0) then
		nC = 2;
	end

	local zoneData;
	if ( C == nC and Z == nZ ) then
		return xPos, yPos;
	elseif ( C == nC and C < 3) then
		-- points on the same continent
		zoneData = WorldMapSize[C];
		xPos, yPos = getContPosition(zoneData, Z, xPos, yPos);
		if ( nZ ~= 0 and zoneData[nZ] ~= nil) then
			zoneData = zoneData[nZ];
			xPos = xPos - zoneData.xOffset;
			yPos = yPos - zoneData.yOffset;
		end
	elseif ( C and nC) and (C < 3 and nC < 3) and ( WorldMapSize[C].parentContinent == WorldMapSize[nC].parentContinent )  then
		-- different continents, same world
		zoneData = WorldMapSize[C];
		local parentContinent = zoneData.parentContinent;
		xPos, yPos = getContPosition(zoneData, Z, xPos, yPos);
		if ( C ~= parentContinent ) then
			-- translate up to world map if we aren't there already
			xPos = xPos + zoneData.xOffset;
			yPos = yPos + zoneData.yOffset;
			zoneData = WorldMapSize[parentContinent];
		end
		if ( nC ~= parentContinent ) then
			--translate down to the new continent
			zoneData = WorldMapSize[nC];
			xPos = xPos - zoneData.xOffset;
			yPos = yPos - zoneData.yOffset;
			if ( nZ ~= 0 and zoneData[nZ] ~= nil) then
				zoneData = zoneData[nZ];
				xPos = xPos - zoneData.xOffset;
				yPos = yPos - zoneData.yOffset;
			end
		end

	else
		return;
	end

	return (xPos / zoneData.width), (yPos / zoneData.height);
end

Astrolabe_LastX = 0;
Astrolabe_LastY = 0;
Astrolabe_LastZ = 0;
Astrolabe_LastC = 0;
-- Alphaest - remade the method so the data doesn't jump with the changing of the map view
function Astrolabe:GetCurrentPlayerPosition()
	local x, y = GetPlayerMapPosition("player")
	if (x <= 0 and y <= 0) then
		-- we're off the map, in another zone, check if map is closed
		if WorldMapFrame:IsVisible() == nil then
			-- focus the invisible map to current zone and retrieve location
			SetMapToCurrentZone()
			x, y = GetPlayerMapPosition("player")
			if (x <= 0 and y <= 0) then
				-- we're off a zone, in some wild place. Set the view to continent view
				SetMapZoom(GetCurrentMapContinent())
				x, y = GetPlayerMapPosition("player")
				if (x <= 0 and y <= 0) then
					-- we are in an instance or otherwise off the continent map
					return
				end
			end
		else
			-- map is open, we've got no way of getting info about the player
			-- this is especially problematic if the player is crossing zone borders while map is open
			return Astrolabe_LastC, Astrolabe_LastZ, Astrolabe_LastX, Astrolabe_LastY
		end
	end
	local C, Z = GetCurrentMapContinent(), GetCurrentMapZone()
	local pC, pZ = C, Z
	if pZ == 0 then
		-- map is open on continent view. Assume player is still in old zone
		pZ = Astrolabe_LastZ
	end
	if pC == 0 then
		-- map is open on world view. Assume player is still on old continent. This can safely be assumed since the UI is redrawn on continent change
		pC = Astrolabe_LastC
	end
	if not WorldMapSize[pC] then
		pC, pZ = 0, 0
	end
	if pC > 0 and not WorldMapSize[pC][pZ] then
		pZ = 0
	end
	local nX, nY = self:TranslateWorldMapPosition(C, Z, x, y, pC, pZ)
	Astrolabe_LastX = nX
	Astrolabe_LastY = nY
	Astrolabe_LastC = pC
	Astrolabe_LastZ = pZ
	return Astrolabe_LastC, Astrolabe_LastZ, Astrolabe_LastX, Astrolabe_LastY;
end

--------------------------------------------------------------------------------------------------------------
-- Working Table Cache System
--------------------------------------------------------------------------------------------------------------

local tableCache = {};
tableCache["__mode"] = "v";
setmetatable(tableCache, tableCache);

local function GetWorkingTable( icon )
	if ( tableCache[icon] ) then
		return tableCache[icon];
	else
		local T = {};
		tableCache[icon] = T;
		return T;
	end
end


--------------------------------------------------------------------------------------------------------------
-- Minimap Icon Placement
--------------------------------------------------------------------------------------------------------------

function Astrolabe:PlaceIconOnMinimap( icon, continent, zone, xPos, yPos )
	-- check argument types
	--DEFAULT_CHAT_FRAME:AddMessage("PlaceIcon" .. continent .. " " .. zone .. " " .. xPos .. " " .. yPos);
	self:argCheck(icon, 2, "table");
	self:assert(icon.SetPoint and icon.ClearAllPoints, "Usage Message");
	self:argCheck(continent, 3, "number");
	self:argCheck(zone, 4, "number", "nil");
	self:argCheck(xPos, 5, "number");
	self:argCheck(yPos, 6, "number");
	--DEFAULT_CHAT_FRAME:AddMessage("ARGCHECK passed");

	local lC, lZ, lx, ly = self.LastPlayerPosition[1], self.LastPlayerPosition[2], self.LastPlayerPosition[3], self.LastPlayerPosition[4];
	--DEFAULT_CHAT_FRAME:AddMessage("lC " .. lC .. " " .. lZ .. " " .. lx .. " " .. ly);
	if (not lC) or (not lZ) or (not lx) or (not ly) then
	  self.LastPlayerPosition[1] = nil;
	  self.LastPlayerPosition[2] = nil;
	  self.LastPlayerPosition[3] = nil;
	  self.LastPlayerPosition[4] = nil;
	  table.setn(self.LastPlayerPosition,0);
	  self.LastPlayerPosition[1], self.LastPlayerPosition[2], self.LastPlayerPosition[3], self.LastPlayerPosition[4] = Astrolabe:GetCurrentPlayerPosition();
	  lC, lZ, lx, ly = self.LastPlayerPosition[1], self.LastPlayerPosition[2], self.LastPlayerPosition[3], self.LastPlayerPosition[4];
	end
	local dist, xDist, yDist = self:ComputeDistance(lC, lZ, lx, ly, continent, zone, xPos, yPos);
	if not ( dist ) then
	 --DEFAULT_CHAT_FRAME:AddMessage("BADDIST");
		--icon's position has no meaningful position relative to the player's current location
		return -1;
	end
	local iconData = self.MinimapIcons[icon];
	if not ( iconData ) then
		iconData = GetWorkingTable(icon);
		self.MinimapIcons[icon] = iconData;
	end
	iconData.continent = continent;
	iconData.zone = zone;
	iconData.xPos = xPos;
	iconData.yPos = yPos;
	iconData.dist = dist;
	iconData.xDist = xDist;
	iconData.yDist = yDist;

	--show the new icon and force a placement update on the next screen draw
	icon:Show()
	self.UpdateTimer = 0;
	Astrolabe.ForceNextUpdate = true;

	return 0;
end

function Astrolabe:RemoveIconFromMinimap( icon )
	if not ( self.MinimapIcons[icon] ) then
		return 1;
	end
	self.MinimapIcons[icon] = nil;
	icon:Hide();
	return 0;
end

function Astrolabe:RemoveAllMinimapIcons()
	local minimapIcons = self.MinimapIcons
	for k, v in pairs(minimapIcons) do
		minimapIcons[k] = nil;
		k:Hide();
	end
end

function Astrolabe:isMinimapInCity()
	local tempzoom = 0;
	self.minimapOutside = true;
	if (GetCVar("minimapZoom") == GetCVar("minimapInsideZoom")) then
		if (GetCVar("minimapInsideZoom")+0 >= 3) then 
			Minimap:SetZoom(Minimap:GetZoom() - 1);
			tempzoom = 1;
		else
			Minimap:SetZoom(Minimap:GetZoom() + 1);
			tempzoom = -1;
		end
	end
	if (GetCVar("minimapInsideZoom")+0 == Minimap:GetZoom()) then self.minimapOutside = false; end
	Minimap:SetZoom(Minimap:GetZoom() + tempzoom);
end


local function placeIconOnMinimap( minimap, minimapZoom, mapWidth, mapHeight, icon, dist, xDist, yDist )
	local mapDiameter;
	if ( Astrolabe.minimapOutside ) then 
		mapDiameter = MinimapSize.outdoor[minimapZoom];
	else
		mapDiameter = MinimapSize.indoor[minimapZoom];
	end
	local mapRadius = mapDiameter / 2;
	local xScale = mapDiameter / mapWidth;
	local yScale = mapDiameter / mapHeight;
	local iconDiameter = ((icon:GetWidth() / 2) -3) * xScale; -- LaYt +3
	icon:ClearAllPoints();
	local signx,signy =1,1;
	-- Adding square map support by LaYt
	if (Squeenix or (simpleMinimap_Skins and simpleMinimap_Skins:GetShape() == "square")) then 
		if (xDist<0) then signx=-1; end
		if (yDist<0) then signy=-1; end
		if (math.abs(xDist) > (mapWidth/2*xScale)) then 
			xDist = (mapWidth/2*xScale - iconDiameter/2)*signx; 
		end
		if (math.abs(yDist) > (mapHeight/2*yScale)) then 
			yDist = (mapHeight/2*yScale - iconDiameter/2)*signy; 
		end
	elseif ( (dist + iconDiameter) > mapRadius ) then  
		-- position along the outside of the Minimap
		local factor = (mapRadius - iconDiameter) / dist;
		xDist = xDist * factor;
		yDist = yDist * factor;
	end
	--DEFAULT_CHAT_FRAME:AddMessage("MINIMAP " .. xDist .. " " .. xScale .. " " .. yDist .. " " .. yScale);
	icon:SetPoint("CENTER", minimap, "CENTER", xDist/xScale, -yDist/yScale);
end

local lastZoom;
function Astrolabe:UpdateMinimapIconPositions()
  --DEFAULT_CHAT_FRAME:AddMessage("UPDATEMINI");
	local C, Z, x, y = self:GetCurrentPlayerPosition();
	if not ( C and Z and x and y ) then
	 -- DEFAULT_CHAT_FRAME:AddMessagE("NotCNotZNotxNoty");
		self.processingFrame:Hide();
	end
	local Minimap = Minimap;
	local lastPosition = self.LastPlayerPosition;
	local lC, lZ, lx, ly = lastPosition[1], lastPosition[2], lastPosition[3], lastPosition[4];
	local currentZoom = Minimap:GetZoom();
	local zoomChanged = lastZoom ~= Minimap:GetZoom()
	lastZoom = currentZoom;
	if zoomChanged then
		Astrolabe.MinimapUpdateTime = (6 - Minimap:GetZoom()) * 0.05
	end

	if ( (lC == C and lZ == Z and lx == x and ly == y)) then--Added or WorldMapFrame:IsVisible() to fix the jumping around minimap icons when the map is opened -- Removed it not needed?
		-- player has not moved since the last update
		--DEFAULT_CHAT_FRAME:AddMessage("NoMove");
		if (zoomChanged or self.ForceNextUpdate ) then
			local mapWidth = Minimap:GetWidth();
			local mapHeight = Minimap:GetHeight();
			for icon, data in pairs(self.MinimapIcons) do
				placeIconOnMinimap(Minimap, currentZoom, mapWidth, mapHeight, icon, data.dist, data.xDist, data.yDist);
			end
			self.ForceNextUpdate = false;
		end
		--DEFAULT_CHAT_FRAME:AddMessage("IF");
	else
	 --DEFAULT_CHAT_FRAME:AddMessage("Move");
		local dist, xDelta, yDelta = self:ComputeDistance(lC, lZ, lx, ly, C, Z, x, y);
		if not dist or not xDelta or not yDelta then return; end
		local mapWidth = Minimap:GetWidth();
		local mapHeight = Minimap:GetHeight();
		for icon, data in pairs(self.MinimapIcons) do-- DEFAULT_CHAT_FRAME:AddMessage("MMI");
			local xDist = data.xDist - xDelta;
			local yDist = data.yDist - yDelta;
			local dist = sqrt(xDist*xDist + yDist*yDist);

			placeIconOnMinimap(Minimap, currentZoom, mapWidth, mapHeight, icon, dist, xDist, yDist);

			data.dist = dist;
			data.xDist = xDist;
			data.yDist = yDist;
		end

		--DEFAULT_CHAT_FRAME:AddMessage("ELSE");

		lastPosition[1] = C;
		lastPosition[2] = Z;
		lastPosition[3] = x;
		lastPosition[4] = y;
		--self.LastPlayerPosition = lastPosition;--It did not set before? Wonder why...
	end
end

function Astrolabe:CalculateMinimapIconPositions()
	local C, Z, x, y = self:GetCurrentPlayerPosition();
	if not ( C and Z and x and y ) then
		self.processingFrame:Hide();
	end

	local currentZoom = Minimap:GetZoom();
	lastZoom = currentZoom;
	local Minimap = Minimap;
	local mapWidth = Minimap:GetWidth();
	local mapHeight = Minimap:GetHeight();
	for icon, data in pairs(self.MinimapIcons) do
		local dist, xDist, yDist = self:ComputeDistance(C, Z, x, y, data.continent, data.zone, data.xPos, data.yPos);
		placeIconOnMinimap(Minimap, currentZoom, mapWidth, mapHeight, icon, dist, xDist, yDist);

		data.dist = dist;
		data.xDist = xDist;
		data.yDist = yDist;
	end

	local lastPosition = self.LastPlayerPosition;
	lastPosition[1] = C;
	lastPosition[2] = Z;
	lastPosition[3] = x;
	lastPosition[4] = y;
	--self.LastPlayerPosition = lastPosition;--It did not set before? Wonder why...
end

function Astrolabe:GetDistanceToIcon( icon )
	local data = Astrolabe.MinimapIcons[icon];
	if ( data ) then
		return data.dist, data.xDist, data.yDist;
	end
end

function Astrolabe:GetDirectionToIcon( icon )
	local data = Astrolabe.MinimapIcons[icon];
	if ( data ) then
		local dir = atan2(data.xDist, -(data.yDist))
		if ( dir > 0 ) then
			return twoPi - dir;
		else
			return -dir;
		end
	end
end

--------------------------------------------------------------------------------------------------------------
-- World Map Icon Placement
--------------------------------------------------------------------------------------------------------------

function Astrolabe:PlaceIconOnWorldMap( worldMapFrame, icon, continent, zone, xPos, yPos )
	-- check argument types
	self:argCheck(worldMapFrame, 2, "table");
	self:assert(worldMapFrame.GetWidth and worldMapFrame.GetHeight, "Usage Message");
	self:argCheck(icon, 3, "table");
	self:assert(icon.SetPoint and icon.ClearAllPoints, "Usage Message");
	self:argCheck(continent, 4, "number");
	self:argCheck(zone, 5, "number", "nil");
	self:argCheck(xPos, 6, "number");
	self:argCheck(yPos, 7, "number");

	local C, Z = GetCurrentMapContinent(), GetCurrentMapZone();
	local nX, nY = self:TranslateWorldMapPosition(continent, zone, xPos, yPos, C, Z);
	if ( nX and nY and (0 < nX and nX <= 1) and (0 < nY and nY <= 1) ) then
		icon:ClearAllPoints();
		icon:SetPoint("CENTER", worldMapFrame, "TOPLEFT", nX * worldMapFrame:GetWidth(), -nY * worldMapFrame:GetHeight());
	end
	return nX, nY;
end


--------------------------------------------------------------------------------------------------------------
-- Handler Scripts
--------------------------------------------------------------------------------------------------------------
function Astrolabe:OnEvent( frame, event )
	if ( event == "MINIMAP_UPDATE_ZOOM" ) then
		Astrolabe:isMinimapInCity()
		-- re-calculate all Minimap Icon positions
		if ( frame:IsVisible() ) then
			self:CalculateMinimapIconPositions();
		end
	elseif ( event == "PLAYER_LEAVING_WORLD" ) then
		frame:Hide();
		self:RemoveAllMinimapIcons(); --dump all minimap icons
	elseif (event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA") then
		Astrolabe:isMinimapInCity()
		frame:Show();
	end
end

function Astrolabe:OnUpdate( frame, elapsed )
	local updateTimer = self.UpdateTimer - elapsed;
	if ( updateTimer > 0 ) then
		self.UpdateTimer = updateTimer;
		return;
	end
	self.UpdateTimer = self.MinimapUpdateTime;
	self:UpdateMinimapIconPositions();
end

function Astrolabe:OnShow( frame )
	self:CalculateMinimapIconPositions();
end


--------------------------------------------------------------------------------------------------------------
-- Library Registration
--------------------------------------------------------------------------------------------------------------

local function activate( self, oldLib, oldDeactivate )
	Astrolabe = self;
	local frame = self.processingFrame;
	if not ( frame ) then
		frame = CreateFrame("Frame");
		self.processingFrame = frame;
	end
	frame:SetParent("Minimap");
	frame:Hide();
	frame:UnregisterAllEvents();
	frame:RegisterEvent("MINIMAP_UPDATE_ZOOM");
	frame:RegisterEvent("PLAYER_LEAVING_WORLD");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	frame:SetScript("OnEvent", function()
			self:OnEvent(this, event);
		end
	);
	frame:SetScript("OnUpdate",
		function( frame, elapsed )
			-- elapsed doesn't work in Lua created frames, however it is equal to the time passed between each frame. So calulcate from FPS ;)
			self:OnUpdate(frame, 1/GetFramerate());
		end
	);
	frame:SetScript("OnShow",
		function( frame )
			self:OnShow(frame);
		end
	);
	if not ( self.ContinentList ) then
		local _
		self.ContinentList, _, _ = { GetMapContinents() };
		for C in pairs(self.ContinentList) do
			local zones = { GetMapZones(C) };
			self.ContinentList[C] = zones;
			for Z, N in ipairs(zones) do
				SetMapZoom(C, Z);
				zones[Z] = { mapFile = GetMapInfo(), mapName = N}
			end
		end
		for C = 3, 40 do
        local zones = { GetMapZones(C) };
				self.ContinentList[C] = zones;
        for Z, N in ipairs(zones) do
					SetMapZoom(C, Z);
					zones[Z] = { mapFile = GetMapInfo(), mapName = N}
				end
    end
	end
	initSizes()
	frame:Show();
end

--------------------------------------------------------------------------------------------------------------
-- Data
--------------------------------------------------------------------------------------------------------------

-- diameter of the Minimap in game yards at
-- the various possible zoom levels
MinimapSize = {
	indoor = {
		[0] = 300, -- scale
		[1] = 240, -- 1.25
		[2] = 180, -- 5/3
		[3] = 120, -- 2.5
		[4] = 80,  -- 3.75
		[5] = 50,  -- 6
	},
	outdoor = {
		[0] = 466 + 2/3, -- scale
		[1] = 400,       -- 7/6
		[2] = 333 + 1/3, -- 1.4
		[3] = 266 + 2/6, -- 1.75
		[4] = 200,       -- 7/3
		[5] = 133 + 1/3, -- 3.5
	},
}

-- distances across and offsets of the world maps
-- in game yards
-- from classic client data, except for values commented on
local initDone = false
function initSizes()
	if initDone then return end
	initDone = true
	WorldMapSize = {
		-- World Map of Azeroth
		[0] = {
			parentContinent = 0,
			height = 29687.90575403711, -- as in Questie
			width = 44531.82907938571, -- as in Questie
		},
		-- Kalimdor
		[1] = {
			parentContinent = 0,
			height = 24533.2001953125,
			width = 36799.810546875,
			xOffset = -8310.0, -- as in Questie
			yOffset = 1815.0, -- as in Questie
			zoneData =  {
				AhnQirajEntrance = {
					yOffset = 20805.10052815721,
					height = 2946.049805,
					xOffset = 13133.93164381626,
					width = 4139.019928,
				},
				Moonglade = {
					yOffset = 4308.230373499235,
					height = 1539.589844,
					xOffset = 18447.85126019727,
					width = 2308.330078,
				},
				Barrens = {
					width = 10133.33984,
					xOffset = 14443.68003621553,
					height = 6756.25,
					yOffset = 11187.40044517085,
				},
				Winterspring = {
					yOffset = 4266.568983370459,
					height = 4733.330078,
					xOffset = 17383.27043686745,
					width = 7099.999909,
				},
				Icepoint = {
					yOffset = -704.7070264816284,
					height = 1075,
					xOffset = -916.6494112014771,
					width = 1608,
				},
				Ogrimmar = {
					width = 1402.609863,
					xOffset = 20747.20146032612,
					height = 935.419922,
					yOffset = 10526.01945561005,
				},
				Hyjal = {
					yOffset = 6269.689287272782,
					height = 2142,
					xOffset = 16150.92869607518,
					width = 3206,
				},
				Darkshore = {
					yOffset = 4466.573394413073,
					height = 4366.660156,
					xOffset = 14124.93301322865,
					width = 6550,
				},
				Desolace = {
					yOffset = 12347.81785121689,
					height = 2997.910065,
					xOffset = 12833.26823111993,
					width = 4495.830078,
				},
				GMIsland = {
					height = 541,
					width = 828,
				},
				MaraudonEntrance = {
					yOffset = 13895.89904078562,
					height = 550,
					xOffset = 13858.59982908645,
					width = 824,
				},
				Tanaris = {
					width = 6900,
					xOffset = 17285.34934453101,
					height = 4600,
					yOffset = 18674.900390625,
				},
				ThunderBluff = {
					yOffset = 13649.90096196075,
					height = 695.829956,
					xOffset = 16549.93296999144,
					width = 1043.75,
				},
				Durotar = {
					yOffset = 10991.56986759917,
					height = 3525,
					xOffset = 19029.10077151016,
					width = 5287.5,
				},
				Silithus = {
					yOffset = 18758.23285001491,
					height = 2322.919922,
					xOffset = 14529.10166638078,
					width = 3483.330017,
				},
				TelAbim = {
					yOffset = 19983.89995714609,
					height = 2187,
					xOffset = 22245.59972146468,
					width = 3227,
				},
				StonetalonMountains = {
					yOffset = 9883.233800947906,
					height = 3256.249909,
					xOffset = 13820.76862040341,
					width = 4883.330078,
				},
				Darnassis = {
					width = 1058.330078,
					xOffset = 14128.24105601921,
					height = 705.730468,
					yOffset = 2561.578194220845,
				},
				BlackstoneIsland = {
					width = 2472,
					xOffset = 23340.59975367633,
					height = 1665,
					yOffset = 12000.8998829521,
				},
				ThousandNeedles = {
					yOffset = 16766.57008374465,
					height = 2933.330078,
					xOffset = 17499.93036367079,
					width = 4400.000091,
				},
				Ashenvale = {
					yOffset = 8126.983858289012,
					height = 3843.749939,
					xOffset = 15366.5965059437,
					width = 5766.669922,
				},
				Teldrassil = {
					width = 5091.660034000001,
					xOffset = 13252.02016447844,
					height = 3393.75,
					yOffset = 968.6494826403359,
				},
				Mulgore = {
					yOffset = 13072.81703024922,
					height = 3424.999909,
					xOffset = 15018.68289964989,
					width = 5137.500122,
				},
				Felwood = {
					yOffset = 5666.569877125914,
					height = 3833.330078,
					xOffset = 15424.92971944267,
					width = 5750.000122,
				},
				CavernsOfTime = {
					yOffset = 20822.990294469,
					height = 888.089844,
					xOffset = 20762.45175980817,
					width = 1348.239746,
				},
				WailingCavernsEntrance = {
					width = 572.779907,
					xOffset = 18967.47108651929,
					height = 381.849975,
					yOffset = 13288.53967756627,
				},
				Feralas = {
					yOffset = 15166.56727492637,
					height = 4633.330078,
					xOffset = 11624.93304645902,
					width = 6949.999878,
				},
				UngoroCrater = {
					yOffset = 18766.56911267953,
					height = 2466.660156,
					xOffset = 16533.2662182722,
					width = 3699.999939,
				},
				Dustwallow = {
					width = 5250,
					xOffset = 18041.5995700472,
					height = 3500.000122,
					yOffset = 14833.23352603454,
				},
				Aszhara = {
					yOffset = 7458.229517519206,
					height = 3381.249878,
					xOffset = 20343.68127434695,
					width = 5070.839844,
				},
				AmaniAlor = {
					width = 1513,
					xOffset = 13954.60081035236,
					height = 1003,
					yOffset = 9362.900076787424,
				},
			},
		},
		-- Eastern Kingdoms
		[2] = {
			parentContinent = 0,
			height = 23466.60009765625,
			width = 35199.900390625,
			xOffset = 16625.0, -- guessed
			yOffset = 2470.0, -- guessed
			zoneData = {
				LochModan = {
					yOffset = 11954.10012304344,
					height = 1839.580078,
					xOffset = 17993.74967672627,
					width = 2758.330078,
				},
				BurningSteppes = {
					yOffset = 14497.84977022409,
					height = 1952.080078,
					xOffset = 16266.66940538385,
					width = 2929.160065,
				},
				GnomereganEntrance = {
					width = 571.1900030000001,
					xOffset = 14972.35867388772,
					height = 379.140137,
					yOffset = 12272.91978343362,
				},
				Hinterlands = {
					yOffset = 5999.930155532402,
					height = 2566.670044,
					xOffset = 17574.99862139614,
					width = 3850,
				},
				Westfall = {
					width = 3499.999909,
					xOffset = 12983.32970314683,
					height = 2333.330078,
					yOffset = 16866.59997760904,
				},
				Badlands = {
					yOffset = 13356.18016799525,
					height = 1658.339844,
					xOffset = 18079.16962992761,
					width = 2487.5,
				},
				Undercity = {
					yOffset = 5588.651919369713,
					height = 640.1099850000001,
					xOffset = 15126.81056548411,
					width = 959.370002,
				},
				Arathi = {
					yOffset = 7599.929798740743,
					height = 2400.000076,
					xOffset = 16866.66943452937,
					width = 3599.999939,
				},
				Tirisfal = {
					yOffset = 3629.099788801752,
					height = 3012.5,
					xOffset = 12966.66954215969,
					width = 4518.750122,
				},
				SwampOfSorrows = {
					yOffset = 17087.42977086731,
					height = 1529.169922,
					xOffset = 18222.91817589162,
					width = 2293.75,
				},
				Alterac = {
					yOffset = 5966.599192090737,
					height = 1866.670013,
					xOffset = 15216.66926913595,
					width = 2800.000061,
				},
				SearingGorge = {
					yOffset = 13566.60042351385,
					height = 1487.5,
					xOffset = 16322.91828832413,
					width = 2231.249909,
				},
				Hilsbrad = {
					yOffset = 7066.599243354643,
					height = 2133.329956,
					xOffset = 14933.32870252766,
					width = 3200.000122,
				},
				Duskwood = {
					yOffset = 17183.27039742278,
					height = 1800,
					xOffset = 15166.66824279203,
					width = 2700.000061,
				},
				Gillijim = {
					yOffset = 19995.30927119885,
					height = 2047.009766,
					xOffset = 11563.77891415499,
					width = 3092.10022,
				},
				AlahThalas = {
					width = 1468,
					xOffset = 18168.99791844504,
					height = 976,
					yOffset = 2559.60064630233,
				},
				ScarletEnclave = {
					height = 2108,
					width = 3159,
				},
				BlastedLands = {
					yOffset = 18033.2698063524,
					height = 2233.330078,
					xOffset = 17241.66825043826,
					width = 3349.999878,
				},
				Ironforge = {
					width = 790.629944,
					xOffset = 16713.58884526778,
					height = 527.609864,
					yOffset = 12035.84070705678,
				},
				Lapidis = {
					yOffset = 18510.08055003897,
					height = 1915.939453,
					xOffset = 11066.66949320913,
					width = 2901.450073,
				},
				UldamanEntrance = {
					yOffset = 13420.00940292701,
					height = 376.09961,
					xOffset = 18747.14837411694,
					width = 563.310059,
				},
				Wetlands = {
					width = 4135.420013,
					xOffset = 16389.57916618149,
					height = 2756.25,
					yOffset = 9614.520306918188,
				},
				WesternPlaguelands = {
					yOffset = 4099.929220898957,
					height = 2866.669922,
					xOffset = 15583.3290218687,
					width = 4300.000091,
				},
				Silverpine = {
					yOffset = 5799.930212901396,
					height = 2800,
					xOffset = 12549.99901819119,
					width = 4200,
				},
				Elwynn = {
					width = 3470.840088,
					xOffset = 14464.57813347087,
					height = 2314.589844,
					yOffset = 15406.18052031593,
				},
				ThalassianHighlands = {
					width = 3082,
					xOffset = 17004.99985098059,
					height = 2061,
					yOffset = 2514.599757153039,
				},
				Gilneas = {
					yOffset = 7825.600370727596,
					height = 2442,
					xOffset = 12746.99856660113,
					width = 3666,
				},
				EasternPlaguelands = {
					yOffset = 3666.599452794188,
					height = 2581.25,
					xOffset = 18185.41907567977,
					width = 3870.830078,
				},
				ScarletMonasteryEntrance = {
					yOffset = 4519.229692855992,
					height = 135.040039,
					xOffset = 16659.95914987431,
					width = 203.659973,
				},
				Stormwind = {
					width = 1737.500044,
					xOffset = 14277.07937469156,
					height = 1158.339844,
					yOffset = 15462.43058020257,
				},
				BlackrockMountain = {
					yOffset = 14794.41961357115,
					height = 468.680176,
					xOffset = 16760.93936339493,
					width = 711.559998,
				},
				DeadwindPass = {
					yOffset = 17333.27023066827,
					height = 1666.660156,
					xOffset = 16833.32974010742,
					width = 2500.000061,
				},
				DeadminesEntrance = {
					width = 449.890015,
					xOffset = 14206.81846012042,
					height = 299.919922,
					yOffset = 18521.54025717683,
				},
				Redridge = {
					yOffset = 16041.59964642502,
					height = 1447.919922,
					xOffset = 17570.82713775882,
					width = 2170.839966,
				},
				Stranglethorn = {
					yOffset = 18635.34948081806,
					height = 4254.169922,
					xOffset = 13779.16838504921,
					width = 6381.25,
				},
				DunMorogh = {
					width = 4924.999878,
					xOffset = 14197.91821285553,
					height = 3283.339844,
					yOffset = 11343.67957693626,
				},
			},
		},
		[3] = {
			zoneData = {
				WinterVeilVale = {
					height = 977,
					width = 1432,
				},
			},
		},
		[4] = {
			zoneData = {
				Ragefire = {
					height = 492.570011,
					width = 738.8599850000001,
				},
			},
		},
		[5] = {
			zoneData = {
				ZulFarrak = {
					height = 922.910034,
					width = 1383.330002,
				},
			},
		},
		[6] = {
			zoneData = {
				TheTempleOfAtalHakkar = {
					height = 463.350022,
					width = 695.0300140000001,
				},
			},
		},
		[7] = {
			zoneData = {
				BlackFathomDeeps = {
					height = 806.420013,
					width = 1221.870026,
				},
			},
		},
		[8] = {
			zoneData = {
				TheStockade = {
					height = 252.100004,
					width = 378.150009,
				},
			},
		},
		[9] = {
			zoneData = {
				Gnomeregan = {
					height = 513.110001,
					width = 769.669983,
				},
			},
		},
		[10] = {
			zoneData = {
				Uldaman = {
					height = 595.779999,
					width = 893.669998,
				},
			},
		},
		[11] = {
			zoneData = {
				MoltenCore = {
					height = 843.200074,
					width = 1264.800064,
				},
			},
		},
		[12] = {
			zoneData = {
				ZulGurub = {
					height = 1414.580078,
					width = 2120.830078,
				},
			},
		},
		[13] = {
			zoneData = {
				DireMaul = {
					height = 850,
					width = 1275,
				},
			},
		},
		[14] = {
			zoneData = {
				BlackrockDepths = {
					height = 938.0400550000001,
					width = 1407.059998,
				},
			},
		},
		[15] = {
			zoneData = {
				RuinsofAhnQiraj = {
					height = 1675,
					width = 2512.499939,
				},
			},
		},
		[16] = {
			zoneData = {
				OnyxiasLair = {
					height = 322.080002,
					width = 483.110008,
				},
			},
		},
		[17] = {
			zoneData = {
				BlackrockSpire = {
					height = 591.229981,
					width = 886.84,
				},
			},
		},
		[18] = {
			zoneData = {
				WailingCaverns = {
					height = 785,
					width = 1170,
				},
			},
		},
		[19] = {
			zoneData = {
				Maraudon = {
					height = 1410.890015,
					width = 2112.090058,
				},
			},
		},
		[20] = {
			zoneData = {
				BlackwingLair = {
					height = 332.949707,
					width = 499.430054,
				},
			},
		},
		[21] = {
			zoneData = {
				TheDeadmines = {
					height = 434.970009,
					width = 656.590027,
				},
			},
		},
		[22] = {
			zoneData = {
				RazorfenDowns = {
					height = 472.699951,
					width = 709.049926,
				},
			},
		},
		[23] = {
			zoneData = {
				RazorfenKraul = {
					height = 490.959839,
					width = 736.4499510000001,
				},
			},
		},
		[24] = {
			zoneData = {
				ScarletMonastery2f = {
					height = 213.459991,
					width = 320.189987,
				},
				ScarletMonastery3f = {
					height = 408.459961,
					width = 612.689983,
				},
				ScarletMonastery4f = {
					height = 468.870056,
					width = 703.3000489999999,
				},
				ScarletMonastery = {
					height = 413.320069,
					width = 619.979981,
				},
			},
		},
		[25] = {
			zoneData = {
				Scholomance = {
					height = 213.37001,
					width = 320.050003,
				},
			},
		},
		[26] = {
			zoneData = {
				ShadowfangKeep = {
					height = 254,
					width = 381,
				},
			},
		},
		[27] = {
			zoneData = {
				Stratholme = {
					height = 789.859863,
					width = 1185.349854,
				},
			},
		},
		[28] = {
			zoneData = {
				AhnQiraj2f = {
					height = 1851.69043,
					width = 2777.540115,
				},
				AhnQiraj = {
					height = 651.700195,
					width = 977.559937,
				},
			},
		},
		[29] = {
			zoneData = {
				Karazhan = {
					height = 399,
					width = 598,
				},
			},
		},
		[30] = {
			zoneData = {
				DeeprunTram = {
					height = 208,
					width = 312,
				},
				DeeprunTram2f = {
					height = 208,
					width = 309,
				},
			},
		},
		[31] = {
			zoneData = {
				BlackMorass2f = {
					height = 726.610107,
					width = 1085.859864,
				},
				BlackMorass = {
					height = 845.47998,
					width = 1271.990235,
				},
			},
		},
		[32] = {
			zoneData = {
				GilneasCity = {
					height = 837.440063,
					width = 1250.180053,
				},
			},
		},
		[33] = {
			zoneData = {
				Naxxramas2f = {
					height = 439.670166,
					width = 652.100098,
				},
				Naxxramas = {
					height = 1318.419922,
					width = 1991.689941,
				},
			},
		},
		[34] = {
			zoneData = {
				CrescentGrove = {
					height = 1751.159973,
					width = 2643.209961,
				},
			},
		},
		[35] = {
			zoneData = {
				HateforgeQuarry = {
					height = 510.330567,
					width = 752.119873,
				},
			},
		},
		[36] = {
			zoneData = {
				KarazhanCrypt = {
					height = 391.969726,
					width = 546.75,
				},
			},
		},
		[37] = {
			zoneData = {
				StormwindVault = {
					height = 234.740005,
					width = 354.499996,
				},
			},
		},
		[38] = {
			zoneData = {
				EmeraldSanctum = {
					height = 853.719971,
					width = 1273.100098,
				},
			},
		},
		[39] = {
			zoneData = {
				Moomoo = {
					height = 671.7890619999999,
					width = 1007.680664,
				},
			},
		},
		[40] = {
			zoneData = {
				UpperKarazhan = {
					height = 549,
					width = 823,
				},
				UpperKarazhan2f = {
					height = 1868,
					width = 2800,
				},
			},
		},
	}
	
	local zeroData = { xOffset = 0, height = 0, yOffset = 0, width = 0 };
	for continent, zones in pairs(Astrolabe.ContinentList) do
		local mapData = WorldMapSize[continent];
		if not mapData then ChatFrame1:AddMessage("Astrolabe is missing data for continent "..continent.."."); end
		for index, zData in pairs(zones) do
			if not ( mapData.zoneData[zData.mapFile] ) then
				--WE HAVE A PROBLEM!!!
				-- Disabled because TBC zones were removed
				--ChatFrame1:AddMessage("Astrolabe is missing data for "..select(index, GetMapZones(continent))..".");
				mapData.zoneData[zData.mapFile] = zeroData;
			end
			mapData[index] = mapData.zoneData[zData.mapFile];
			mapData[index].mapName = zData.mapName
			mapData.zoneData[zData.mapFile] = nil;
		end
	end
end

AceLibrary:Register(Astrolabe, LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR, activate)
local _G = getfenv()
_G["Astrolabe"] = AceLibrary("Astrolabe-0.2")