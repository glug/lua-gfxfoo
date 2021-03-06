#!/usr/bin/lua
-- vim: set tw=78 ts=4 et syn=lua fdm=marker :
-- ------------------------------------------------------------------------ --

-- XXX settings
width  = 100
height = 100
depth  = 255
frames =  25
basename = "anim"

-- ------------------------------------------------------------------------ --
-- initial fixed code

local numberwidth = #tostring(frames)

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
newImage = function()
    local img = {}
    for y = 1, height do
        local t = {}
        for x = 1, width do
            t[x] = setmetatable({0,0,0}, _metaPixel)
        end
        img[y] = t
    end
    return img
end

img = newImage()

-- ------------------------------------------------------------------------ --
-- image generation

for frame = 1, frames do
    local time = (frame-1)/(frames-1)
    local ltime = (frame-1)/frames

-- ------------------------------------------------------------------------ --
    -- XXX insert here XXX

    --[[
    local need_reset = true
    time = 2*math.pi*ltime
    local y = math.ceil((height/2.1)*(1+math.sin(time)+(2.1/height)))
    local x = math.ceil((width /2.1)*(1+math.cos(time)+(2.1/width)))
    img[y][x] = {depth, depth, depth}
    --]]

    ---[[
    local need_reset = false
    time = depth*time
    if not setup then
        setup = true
        for y=1,height do
            local line = img[y]
            for x=1,width do
                line[x].r = ((x-1)/(width -1))*depth
                line[x].g = ((y-1)/(height-1))*depth
            end
        end
    end
    for y = 1, height do
        local line = img[y]
        for x = 1, width do
            line[x].b = time
        end
    end
    --]]

-- ------------------------------------------------------------------------ --
    -- image writing
    local fname = os.tmpname(basename)
    PPM.ppmWriteFile(img,depth,fname)
    os.execute(string.format("pnmtopng < %s > %s%0"..numberwidth.."d.png",fname,basename,frame))
    if need_reset then
        img = newImage()
        collectgarbage()
    end
end


-- ------------------------------------------------------------------------ --
-- image writing

