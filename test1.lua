#!/usr/bin/lua
-- vim: set tw=78 ts=4 et syn=lua fdm=marker :
-- ------------------------------------------------------------------------ --

-- XXX settings
width  = 100
height = 100
depth  = 255
filename = "test1.pnm"

-- ------------------------------------------------------------------------ --
-- initial fixed code

require "PPM"

math.randomseed(os.time())

-- add mnemonic keys
_metaPixel = {
    __index = function(t,k)
        if     k == "r" then k = 1
        elseif k == "g" then k = 2
        elseif k == "b" then k = 3
        end
        return rawget(t,k)
    end,
    __newindex = function(t,k,v)
        if     k == "r" then k = 1
        elseif k == "g" then k = 2
        elseif k == "b" then k = 3
        end
        return rawset(t,k,v)
    end,
}

-- allocate image
img = {}
for y = 1, height do
    local t = {}
    for x = 1, width do
        t[x] = setmetatable({0,0,0}, _metaPixel)
    end
    img[y] = t
end

-- ------------------------------------------------------------------------ --
-- XXX image generation

-- XXX insert here XXX

--[[
for i = 1,math.min(width,height) do
    img[i][i].r = depth
    img[height-i+1][i].g = depth
    img[math.random(1,height)][math.random(1,width)].b = depth
end
--]]

---[[
local maxdist = math.sqrt((width^2)+(height^2))
for y = 1, height do
    for x = 1, width do
        local pixel = img[y][x]
        pixel.r = math.floor((x/width)*depth)
        pixel.g = math.floor((y/height)*depth)
        local dist = math.sqrt((x^2)+(y^2))
        pixel.b = math.floor((1 - dist/maxdist)*depth)
    end
end
--]]

--[[
local x = 1
for y = 1, height do
    local dir = (-1)^math.random(0,1)
    for _ = 1, 5 do
        img[y][x].r = depth
        x = x + dir
        if x > width then
            x = 1
        elseif x < 1 then
            x = width
        end
    end
end
--]]

-- ------------------------------------------------------------------------ --
-- image writing
PPM.ppmWriteFile(img,depth,filename)

