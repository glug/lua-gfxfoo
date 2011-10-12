#!/opt/local/bin/lua
-- vim: set tw=78 ts=4 et syn=lua fdm=marker :
-- ------------------------------------------------------------------------ --

-- XXX settings
w = 100
h = 100
d = 255
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
for y = 1, h do
    local t = {}
    for x = 1, w do
        t[x] = setmetatable({0,0,0}, _metaPixel)
    end
    img[y] = t
end

-- ------------------------------------------------------------------------ --
-- XXX image generation

-- XXX insert here XXX

--[[
for i = 1,math.min(w,h) do
    img[i][i].r = d
    img[h-i+1][i].g = d
    img[math.random(1,h)][math.random(1,w)].b = d
end
--]]

---[[
local maxdist = math.sqrt((w^2)+(h^2))
for y = 1, h do
    for x = 1, w do
        local pixel = img[y][x]
        pixel.r = math.floor((x/w)*d)
        pixel.g = math.floor((y/h)*d)
        local dist = math.sqrt((x^2)+(y^2))
        pixel.b = math.floor((1 - dist/maxdist)*d)
    end
end
--]]

--[[
local x = 1
for y = 1, h do
    local dir = (-1)^math.random(0,1)
    for _ = 1, 5 do
        img[y][x].r = d
        x = x + dir
        if x > w then
            x = 1
        elseif x < 1 then
            x = w
        end
    end
end
--]]

-- ------------------------------------------------------------------------ --
-- image writing
PPM.ppmWriteFile(img,d,filename)

