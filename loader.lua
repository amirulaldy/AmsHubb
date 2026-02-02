-- FishItHub Loader
-- Entry point for executor

local url = "https://raw.githubusercontent.com/amirulaldy/AmsHubb/main/src/Main.lua"

local success, err = pcall(function()
	loadstring(game:HttpGet(url))()
end)

if not success then
	warn("AmsHubb failed to load:", err)
end
