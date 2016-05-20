
require("luaunit")
local lu = luaunit

TestGlobal = {}
function TestGlobal:testSBVar()
    lu.assertNotNil(SPACEBUILD);
end

function TestGlobal:testVersion()
    lu.assertEquals(SPACEBUILD.version, 20160520)
end