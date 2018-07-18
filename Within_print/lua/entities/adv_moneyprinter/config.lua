--Config.lua--
--Don't even think about touching this top stuff. You'll just break something.--
Config = {}
Config.Level = {}
Config.LevelRank = {}
function AddLevelColor(R,G,B)
	Config.Level[#Config.Level + 1] = Vector(R,G,B)
end
function AddRankMaxLevel(usergroup, level)
	Config.LevelRank[usergroup] = level
end
--Okay, you can touch the stuff below--

// The name of all moneyprinters
Config.MoneyPrinterName = "Money Printer"
// How much the printer prints at level 1
Config.DefaultPrintAmount = 40
// The max amount of heat the printer can take at level 1 (note: It is displayed in percentage on the printer. It is a percentage of this number)
Config.DefaultHeatAmount = 40
// How much money the printer can hold at level 1
Config.DefaultMaxStorage = 700	
// How much battery life the printer has at level 1			
Config.DefaultMaxPower = 500
// How much it costs to upgrade the battery at level 1				
Config.BatteryUpgrade = 300
// The maximum level of the printer | Requires Config.LevelCap = true, otherwise it is infinite					
Config.MaxLevel = 10
// The amount of XP you gain per print at level 1										
Config.XPBoost = 4							

--ULX only
//Which ranks have the levelup button displayed on their printer menu.
Config.CanLevelRanks = {"owner", "co-owner", "superadmin", "coder"}

//Does the printer require power to run?
Config.RequiresPower = false
//Do the ranks specified in Config.CanLevelRanks have the ability to level printers?
Config.SuperAdminsCanLevel = true
//Is there a level cap as defined in Config.MaxLevel?
Config.LevelCap = false
//Is the level of the printers capped based on rank?
Config.CapRanks = true

--[[
The ranks to cap.
	AddRankMaxLevel(rank to cap, level to cap)
	Example:
		AddRankMaxLevel("moderator", 50)
		This will cap moderator printers to level 50.
]]--
AddRankMaxLevel("user", 5)
AddRankMaxLevel("coder", 7)
AddRankMaxLevel("owner", 15)

AddLevelColor(0,145,200)
AddLevelColor(255,0,0)
AddLevelColor(100,100,0)
AddLevelColor(0,0,255)
AddLevelColor(255,258,0)
AddLevelColor(70,0,145)
AddLevelColor(70,0,0)
AddLevelColor(0,70,0)
AddLevelColor(0,0,70)
AddLevelColor(50,50,50)