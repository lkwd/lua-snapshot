local snapshot = require( "snapshotter.libsnapshotter" )
local utils = require( "snapshotter.utils" )

local M = {
    snaps = {}
}

function M:snap()
    local date = os.date("*t")
    local time = string.format( "%d-%d-%d %d:%d:%d", date.year, 
        date.month, date.day, date.hour, date.min, date.sec )

    self.snaps[ #self.snaps + 1 ] = { snap = snapshot(), time = time }
end

local function deep_copy( orig )
    if type( orig ) ~= 'table' then return orig end
    local copy = {}
    for k, v in next, orig do 
        copy[deep_copy( k )] = deep_copy( v ) 
    end
    setmetatable( copy, deep_copy( getmetatable( orig ) ) )
    return copy
end

function M:diff( dir )

    if #self.snaps < 2 then
        error( "need at least two snaps for a diff" )
    end

    local output = ""
    for i = 2, #self.snaps do
        local from = self.snaps[ i - 1 ]
        local to = self.snaps[ i ]
        output = output .. from.time .. " - " .. to.time .. 
            "\n==========================================\n\n" ..
            utils.dump( utils.diff( deep_copy( from.snap ), 
                deep_copy( to.snap ), true ) ) .. "\n\n"
    end
    
    local file = io.open( ( dir or "." ) .. "/snapshot_" .. 
        os.time( os.date( "!*t" ) ) .. ".txt", "w" )
    file:write( output )
    file:close()
end

function M:clear()
    self.snaps = {}
end

return M
