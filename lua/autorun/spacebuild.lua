--
-- Created by IntelliJ IDEA.
-- User: Stijn
-- Date: 20/05/2016
-- Time: 19:56
-- To change this template use File | Settings | File Templates.
--

AddCSLuaFile()

local requiredGmodVersion = 160424
local version = 1
local runTests = true
if VERSION < requiredGmodVersion then
    error("SB Loader: Your gmod is out of date: found version ", VERSION, "required ", requiredGmodVersion)
end

require("Json")
require("log")
require("sbnet")

SPACEBUILD = {}
local SB = SPACEBUILD

local function loadLuaFiles(path, method, info)
    MsgN("Processing folder "..path)
    local Files, _, File = file.Find(path.."/*.lua" , "LUA"), nil, nil
    for _, File in ipairs(Files) do
        Msg(info.." "..File.."...")
        local ErrorCheck, PCallError = pcall(method, path.."/"..File)
        if(not ErrorCheck) then
            MsgN(PCallError)
        else
            MsgN("Done")
        end
    end
end

loadLuaFiles("spacebuild/classes", include, "Loading")
loadLuaFiles("spacebuild/shared", include, "Loading")

if SERVER then
    loadLuaFiles("spacebuild/server", include, "Loading")

    -- We do modules manually to not the ones from other modules!
    AddCSLuaFile("includes/modules/Json.lua")
    AddCSLuaFile("includes/modules/log.lua")
    AddCSLuaFile("includes/modules/luaunit.lua")
    AddCSLuaFile("includes/modules/sbnet.lua")
    -- end modules

    loadLuaFiles("spacebuild/classes", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/classes/sb", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/classes/ui", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/classes/ls", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/classes/rd", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/classes/wire", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/client", AddCSLuaFile, "Sending")
    loadLuaFiles("spacebuild/shared", AddCSLuaFile, "Sending")

end

if CLIENT then
    loadLuaFiles("spacebuild/client", include, "Loading")
end

if runTests then
    require("luaunit")

end

