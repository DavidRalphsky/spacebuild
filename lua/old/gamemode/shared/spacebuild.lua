--[[
Copyright (C) 2012-2013 Spacebuild Development Team

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ]]

local GM = GM
local class = GM.class
local int = GM.internal

require("sbnet")
local net = sbnet

local space


local function init()
	space = class.new("SpaceEnvironment")
end
hook.Add("Initialize", "spacebuild_init_shared", init)



-- SB
int.environments = {}
int.mod_tables = {}
int.mod_tables.color = {}
int.mod_tables.bloom = {}

local obj

function GM:addEnvironment(environment)
	int.environments[environment:getID()] = environment
	hook.Call("onEnvironmentAdded", GM, environment)
end

function GM:onEnvironmentAdded(environment)
end

function GM:removeEnvironment(environment)
	int.environments[environment:getID()] = nil
	hook.Call("onEnvironmentRemoved", GM, environment)
end

function GM:onEnvironmentRemoved(environment)
end


function GM:removeEnvironmentFromEntity(ent)
	int.environments[ent:EntIndex()] = nil
end


function GM:getEnvironment(id)
	if id == -1 then
		return self:getSpace()
	end
	return int.environments[id]
end

function GM:onSBMap()
	return table.Count(int.environments) > 0
end

function GM:getSpace()
	return space
end

function GM:addEnvironmentColor(env_color)
	int.mod_tables.color[env_color:getID()] = env_color
end

function GM:getEnvironmentColor(id)
	return int.mod_tables.color[id]
end

function GM:addEnvironmentBloom(env_bloom)
	int.mod_tables.bloom[env_bloom:getID()] = env_bloom
end

function GM:getEnvironmentBloom(id)
	return int.mod_tables.bloom[id]
end

function GM:isValidRDEntity(ent)
	return ent.rdobject ~= nil
end

function GM:canLink(ent1, ent2)
	return self:isValidRDEntity(ent1) and self:isValidRDEntity(ent2) and ent1.rdobject:canLink(ent2.rdobject)
end

-- Basic resources


--[[
	Register hooks
]]

function GM:OnToolCreated(toolname, tool)
	if toolname == "sb4_generators" then
		local generators = {
			{
				Name = "Test Solar Panel",
				Model = "models/props_phx/life_support/panel_medium.mdl",
				EntityClass = "resource_generator_energy",
				EntityDescription = "Solar panel used for testing"
			},
			{
				Name = "Test Oxygen generator",
				Model = "models/hunter/blocks/cube1x1x1.mdl",
				EntityClass = "resource_generator_oxygen",
				EntityDescription = "Oxygen generator used for testing"
			},
			{
				Name = "Test Water Pump",
				Model = "models/props_phx/life_support/gen_water.mdl",
				EntityClass = "resource_generator_water",
				EntityDescription = "Water pump used for testing"
			}
		}
		tool:AddRDEntities(generators, "Generators")

		local storages = {
			{
				Name = "Test Energy Storage",
				Model = "models/ce_ls3additional/resource_cache/resource_cache_small.mdl",
				EntityClass = "resource_storage_energy",
				EntityDescription = "Test energy storage device"
			},
			{
				Name = "Test Oxygen generator",
				Model = "models/ce_ls3additional/resource_cache/resource_cache_small.mdl",
				EntityClass = "resource_storage_oxygen",
				EntityDescription = "Test oxygen storage device"
			},
			{
				Name = "Test Water Storage",
				Model = "models/ce_ls3additional/resource_cache/resource_cache_small.mdl",
				EntityClass = "resource_storage_water",
				EntityDescription = "Test water storage device"
			},
			{
				Name = "Test Blackhole Storage",
				Model = "models/ce_ls3additional/resource_cache/resource_cache_small.mdl",
				EntityClass = "resource_storage_blackhole",
				EntityDescription = "Test energy/oxygen/water storage device"
			}
		}
		tool:AddRDEntities(storages, "Storage")

		local networks = {}
		tool:AddRDEntities(networks, "Resource Nodes")

		local ls_devices = {}
		tool:AddRDEntities(ls_devices, "Life Support")
	end
end




