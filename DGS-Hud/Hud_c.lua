-- Usefull Functions 
function formatNumber(number) 
	while true do      
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if k==0 then      
			break   
		end  
	end  
	return number
end

function Hex2RGB(sHexString)
	if String.Length(sHexString) ~= 6 then
		return 0,0,0
	else
		red = String.Left(sHexString,2)
		green = String.Mid(sHexString,3,2)
		blue = String.Right(sHexString,2)
		red = tonumber(red, 16).."";
		green = tonumber(green, 16).."";
		blue = tonumber(blue, 16).."";
		return red, green, blue
	end
end

-- Hud 

loadstring(exports.dgs:dgsImportFunction())()
loadstring(exports.dgs:dgsImportOOPClass(true))()

local Components = {
    "ammo",
    "armour",
    "health",
    "clock",
    "money",
    "breath",
    "wanted",
    "weapon"
}

addEventHandler("onClientResourceStart",resourceRoot,function ()
    for i,C in ipairs(Components) do setPlayerHudComponentVisible(C,false) end
end)
addEventHandler("onClientResourceStop",resourceRoot,function ()
    for i,C in ipairs(Components) do setPlayerHudComponentVisible(C,true) end
end)
dgsSetRenderSetting("postGUI",false)

local MainRectAngle = dgsCreateRoundRect(0.2,true,tocolor(0,0,0,125))
local MainImage = dgsImage(0.69,0.05,0.3,0.3,MainRectAngle,true)

local SkinRectAngle = dgsCreateRoundRect(0.2,true,tocolor(255,255,255,255),dxCreateTexture("Files/Skins/0.png"))
local SkinImage = MainImage:dgsImage(0.05,0.1,0.2,0.3,SkinRectAngle,true)

local thePlayer = getLocalPlayer()

local PlayerMoney = MainImage:dgsLabel(0.3,0.11,0.0,0.0,"$"..tostring(formatNumber(thePlayer:getMoney())),true)

local time = getRealTime()

local Time = MainImage:dgsLabel(0.69,0.11,0,0,time.hour..":"..time.minute..":"..time.second,true)
local Date = MainImage:dgsLabel(0.43,0.0,0,0,(time.year + 1900)..":"..(time.month+1)..":"..time.monthday,true)

PlayerMoney.textColor = tocolor(getColorFromString("#709aff"))
local Font = dgsCreateFont("Font.ttf",16)
PlayerMoney.font = Font

Time.textColor = tocolor(getColorFromString("#ff00ff"))
Time.font = Font

Date.textColor = tocolor(getColorFromString("#fff000"))
Date.font = Font

local Wanteds = {}

for i = 1 , 6 do 
    Wanteds[i] = MainImage:dgsImage(0.20 + (i ~= 0 and i*0.1 or 0 ),0.28,0.08,0.15,"Files/Star.png",true)
    Wanteds[i].color = tocolor(0,255,0,255)
end


local PlayerHealthRectAngle = dgsCreateRoundRect(0.1,true,tocolor(255,255,255,tonumber((thePlayer:getHealth()/100)*255)),dxCreateTexture("Files/Heart.png"))
local PlayerHealthImage = MainImage:dgsImage(0.3 + 0.13,0.40 + 0.1,0.15,0.25,PlayerHealthRectAngle,true)

local PlayerArmorRectAngle = dgsCreateRoundRect(0.1,true,tocolor(255,255,255,tonumber((thePlayer:getArmor()/100)*255)),dxCreateTexture("Files/Armor.png"))
local PlayerArmorImage = MainImage:dgsImage(0.5 + 0.13,0.40 + 0.1,0.15,0.25,PlayerArmorRectAngle,true)

local PlayerBreathRectAngle = dgsCreateRoundRect(0.1,true,tocolor(255,255,255,tonumber((thePlayer:getOxygenLevel()/1000)*255)),dxCreateTexture("Files/Breath.png"))
local PlayerBreathImage = MainImage:dgsImage(0.7 + 0.13,0.40 + 0.1,0.15,0.25,PlayerBreathRectAngle,true)

local WeaponImage = MainImage:dgsImage(-0.26,0.45,0.7,0.7,"Files/Weapons/"..(thePlayer:getWeapon())..".png",true)
local WeaponAmmo = MainImage:dgsLabel(0.450,0.80,0,0,(tonumber(thePlayer:getTotalAmmo()) ~= 0 and (tonumber(thePlayer:getAmmoInClip()) ~= 0 and thePlayer:getTotalAmmo().."/"..thePlayer:getAmmoInClip() or thePlayer:getTotalAmmo()) or ""),true)
WeaponAmmo.font = Font
WeaponAmmo.textColor = tocolor(255,125,125)

addEventHandler("onClientRender",root,function()
	for i = 1 , 6 do 
		if i <= thePlayer:getWantedLevel() then 
			Wanteds[i].color = tocolor(255,0,0,255)
		else
			Wanteds[i].color = tocolor(0,255,0,255)
		end
	end
    PlayerMoney.text = "$"..thePlayer:getMoney()
    dgsRoundRectSetColor(PlayerHealthRectAngle,tocolor(255,255,255,(tonumber((thePlayer:getHealth()/100)*255)) <= 5 and 5 or tonumber((thePlayer:getHealth()/100)*255)))
    dgsRoundRectSetColor(PlayerArmorRectAngle,tocolor(255,255,255,(tonumber((thePlayer:getArmor()/100)*255)) <= 50 and 50 or tonumber((thePlayer:getArmor()/100)*255)))
    dgsRoundRectSetColor(PlayerBreathRectAngle,tocolor(255,255,255,tonumber((thePlayer:getOxygenLevel()/1000)*255)))
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
    local seconds = time.second
    local monthday = time.monthday
	local month = time.month
	local year = time.year
    if (hours >= 0 and hours < 10) then
        hours = "0"..time.hour
    end
    if (minutes >= 0 and minutes < 10) then
        minutes = "0"..time.minute
    end
    if (seconds >= 0 and seconds < 10) then
        seconds = "0"..time.second
    end
    local formattedDate = string.format("%04d-%02d-%02d", year + 1900, month + 1, monthday)
    
    Time.text = hours..":"..minutes..":"..seconds
    Date.text = formattedDate
    if fileExists(":DGS-Hud/Files/Weapons/"..(thePlayer:getWeapon())..".png") then 
        WeaponImage.image = ":DGS-Hud/Files/Weapons/"..(thePlayer:getWeapon())..".png"
    else WeaponImage.image = ":DGS-Hud/Files/Weapons/0.png" end
    if fileExists("Files/Skins/"..thePlayer:getModel()..".png") then 
        dgsRoundRectSetTexture(SkinRectAngle,dxCreateTexture("Files/Skins/"..thePlayer:getModel()..".png"))
    else    dgsRoundRectSetTexture(SkinRectAngle,dxCreateTexture("Files/Skins/0.png")) end
    WeaponAmmo.text = (tonumber(thePlayer:getTotalAmmo()) ~= 0 and (tonumber(thePlayer:getAmmoInClip()) ~= 0 and thePlayer:getAmmoInClip().."/"..(thePlayer:getTotalAmmo() - thePlayer:getAmmoInClip()) or thePlayer:getTotalAmmo()) or "")
end)