lua-snapshot
============

Generates a diff between two snapshots of the lua state to detect memory leaks.


Build
=====

luarocks make rockspecs/lua-snapshot-lkwd-1.rockspec

Usage
=====

```
local snapshotter = require( "snapshotter" )
snapshotter:start()
snapshotter:stop( "path/to/dir" )
```

Stop will output a file to the given path else . if no path provided.

The file will contain:

Biggest Tables -> the tables with the most entries at the time of stopping.
Biggest Refcount -> the memory with the highest refcount at the time of stopping.
Diff -> the diff between a snapshots taken at start and at end

Example format:

```
address+id [address]
       +type [table/function/userdata/thread]
       +tablecount [table's count]
       +source [function/thread defined location,e.g: short_src:linedefined]
       +refcount [refrence count]
       +reflist+1 refpath
               +2 refpath
               ...
refpath: is a shortest reference path,seperate by '.'
_M : main thread
_G : global table
```
