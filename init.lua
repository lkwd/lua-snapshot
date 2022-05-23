local snapshot = require( "snapshotter.libsnapshotter" )
local utils = require( "snapshotter.utils" )

local M = {
    start_snap = nil
}

local function time()
    local date = os.date("*t")
    return string.format( "%d-%d-%d %d:%d:%d", date.year, 
        date.month, date.day, date.hour, date.min, date.sec )
end

function M:start()
    collectgarbage()
    jit.off()
    jit.flush()
    self.start_snap = { snap = snapshot(), time = time() }
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

function M:stop( dir )

    local top_n = 30
    local from = self.start_snap 
    local to = { snap = snapshot(), time = time() }

    local top_tables = utils.tablecount_topN( top_n, deep_copy( to.snap ), true )
    local top_refcount = utils.refcount_topN( top_n, deep_copy( to.snap ), true )

    local output = from.time .. " - " .. to.time ..
        "\n=====================\nBiggest Tables \n=======================\n\n" .. utils.dump( top_tables ) .. 
        "\n=====================\nBiggest RefCount\n======================\n " .. utils.dump( top_refcount ) ..
        "\n=====================\nDiff\n======================\n " .. utils.dump( utils.diff( from.snap, to.snap, true ) ) 
    
    local file = io.open( ( dir or "." ) .. "/snapshot_" .. 
        os.time( os.date( "!*t" ) ) .. ".txt", "w" )
    file:write( output )
    file:close()

    jit.on()
    self.start_snap = nil
    collectgarbage()
end

return M
