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
snapshotter:snap()
snapshotter:snap()
snapshotter:diff( "path/to/dir" )
snapshotter:snap()
snapshotter:diff( "path/to/dir" )
snapshotter:clear()
```

Diff will output a file to the given path else . if no path provided.

The file will contain diffs of snap_n to snap_n+1 with the following format:

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
