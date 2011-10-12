#!/opt/local/bin/lua
-- vim: set tw=78 ts=4 et syn=lua fdm=marker :
-- ------------------------------------------------------------------------ --
-- quick PPM output (still readable)

-- binary output?
local binary = true

module("PPM", package.seeall)

-- ------------------------------------------------------------------------ --
-- general helpers

-- identity function
function id(x) return x end

-- no-op
function nop() end

-- map for array keys & values, discards result
function mapsT(fk,fv,t)
    fk = fk or nop
    fv = fv or nop
    for k,v in ipairs(t) do fk(k); fv(v) end
end

-- convert to bytes
function nToBytes(n,nbytes)
    if nbytes < 1 then return "" end
    local d, m = math.floor(n / 256), n % 256
    return nToBytes(d, nbytes-1)..string.char(m)
end

-- pad text representation to width
function nToWidth(n,width)
    return string.format("%"..width.."d", n)
end

-- output status message (somewhat useful for huge images)
local stat_out = nop -- function(...) io.write("\r",...) ; io.flush() end

function set_msgout(f) stat_out = f end

function status(max)
    max = "/"..tostring(max)
    return function(x)
        stat_out(tostring(x),max)
    end
end

-- ------------------------------------------------------------------------ --
-- config

local numfmt   = binary and nToBytes or nToWidth
local numsep   = binary and ""       or " "
local pixelsep = binary and ""       or "\t"
local linesep  = binary and ""       or "\n"

-- ------------------------------------------------------------------------ --
-- PPM helpers

function _ppmMapDim(stats,f,sep,t,h,...)
    local args = {...}      -- need to save across function boundary
    mapsT(stats,  function(x) f(x,h,unpack(args)); h:write(sep) end,  t)
end

-- pad number to create readable PPM
function _ppmDeNum(n,h,col)    h:write(numfmt(n,col)) end
-- convert rgb triplet
function _ppmDeTrip(t,h,col)   _ppmMapDim(nil,         _ppmDeNum, numsep,  t,  h,col) end
-- write one line of the image
function _ppmDeLine(tt,h,col)  _ppmMapDim(nil,         _ppmDeTrip,pixelsep,tt, h,col) end
-- iterate over lines of the image
function _ppmDeFile(ttt,h,col) _ppmMapDim(status(#ttt),_ppmDeLine,linesep, ttt,h,col) end

-- ------------------------------------------------------------------------ --
-- PPM export

function _ppmHeader(x,y,depth,h)
    h:write(
        binary and "P6\n" or "P3\n",
        x, " ", y, "\n",
        depth, "\n"
    )
end

function ppmWriteFile(ttt,depth,filename)
    local col = binary and math.ceil(math.log(depth+1)/math.log(2)/8) or #(tostring(depth))
    local h = io.open(filename,"w")
    if not h then return nil, "File open failed" end
    _ppmHeader(#(ttt[1]), #ttt, depth, h)
    _ppmDeFile(ttt, h, col)
    stat_out "\n"
    h:close()
end

