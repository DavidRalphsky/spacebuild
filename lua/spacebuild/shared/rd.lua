--
-- Created by IntelliJ IDEA.
-- User: Stijn
-- Date: 21/05/2016
-- Time: 23:51
-- To change this template use File | Settings | File Templates.
--

local SB = SPACEBUILD
local class = SB.class
local device_table = {}
local missing_devices = {}
local resourceRegistry = class.new("rd/ResourceRegistry", class)

resourceRegistry:registerResourceInfo(1, "energy", "Energy", { "ENERGY" })
resourceRegistry:registerResourceInfo(2, "oxygen", "Oxygen", { "GAS" })
resourceRegistry:registerResourceInfo(3, "water", "Water", { "LIQUID", "COOLANT" })
resourceRegistry:registerResourceInfo(4, "hydrogen", "Hydrogen", { "GAS", "FLAMABLE" })
resourceRegistry:registerResourceInfo(5, "nitrogen", "Nitrogen", { "GAS", "COOLANT" })
resourceRegistry:registerResourceInfo(6, "co2", "Carbon Dioxide", { "GAS" })

SB.RDTYPES = {
    STORAGE = 1,
    GENERATOR = 2,
    NETWORK = 3
}

function SB:getResourceRegistry()
    return resourceRegistry
end

function SB:registerDevice(ent, rdtype)
    local entid, obj = ent:EntIndex(), nil
    if rdtype == self.RDTYPES.STORAGE or rdtype == self.RDTYPES.GENERATOR then
        obj = class.new("ResourceEntity", entid, resourceRegistry, class)
    elseif rdtype == self.RDTYPES.NETWORK then
        obj = class.new("ResourceNetwork", entid, resourceRegistry, class)
    else
        error("type is not supported")
    end
    ent.rdobject = obj
    ent._synctimestamp = CurTime() --Time stamp on registration, for use with timers.
    device_table[entid] = obj

    if not ent.rdobject then
        MsgN("Something went wrong registering the device")
    end
    -- TODO move this to client!!
    if CLIENT and missing_devices[entid] then
        missing_devices[entid] = nil
        net.Start("SBRU")
        net.writeShort(entid)
        net.SendToServer()
    end
    hook.Call("onDeviceAdded", GAMEMODE, ent)
end

function SB:removeDevice(ent)
    local entid = ent:EntIndex()
    device_table[entid] = nil
    if ent.rdobject ~= nil then
        ent.rdobject:unlink()
    end
    ent.rdobject = nil
    hook.Call("onDeviceRemoved", GAMEMODE, ent)
end

function SB:getDeviceInfo(entid)
    return device_table[entid]
end


