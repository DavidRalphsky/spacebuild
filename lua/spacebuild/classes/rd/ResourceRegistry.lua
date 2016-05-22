local pairs = pairs
local table = table
-- Class specific
local C = CLASS


function C:isA(className)
    return className == "ResourceRegistry"
end

function C:init(classLoader)
    if not classLoader then error("Resource requires a reference to the classLoader!") end
    self.classLoader = classLoader
    self.resources_names_table = {}
    self.resources_ids_table = {}
end

function C:registerResourceInfo(id, name, displayName, attributes)
    local resourceinfo = self.classLoader.new("rd/ResourceInfo", id, name, displayName, attributes)
    self.resources_names_table[name] = resourceinfo
    self.resources_ids_table[id] = resourceinfo
end

function C:getResourceInfoFromID(id)
    return self.resources_ids_table[id]
end

function C:getResourceInfoFromName(name)
    return self.resources_names_table[name]
end

local coolant_resources
function C:getRegisteredCoolants()
    if self.coolant_resources == nil then
        self.coolant_resources = {}
        for k, v in pairs(self.resources_names_table) do
            if v:hasAttribute("COOLANT") then
                table.insert(self.coolant_resources, v:getName())
            end
        end
    end
    return self.coolant_resources
end


