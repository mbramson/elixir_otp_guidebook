# Cache

A very simple GenServer-based Cache.

Note: This is not meant to be performant in any way, this was to demonstrate
the GenServer aspects of this program. The underlying data structure is Map.

## Usage

Start the cache just like you would any other GenServer module.
```
Cache.start_link
{:ok, #PID<0.108.0>}
```

To write to the cache, invoke the `write/2` function.
```
Cache.write("cat", "dog")
:ok
```

To read from the cache, invoke the `read/1` function.
```
Cache.read("cat")
"dog"
Cache.read("key_that_doesnt_exist")
{:error, :no_value}
```

To get the total number of keys in the cache invoke the `key_count/0`
function.
```
Cache.key_count
1
```

To clear the cache, invoke the `delete/1` function to delete a specific
key or the `clear/0` function to delete all keys. These both work fine if
the key doesn't exist or the cache is empty.
```
Cache.delete("key_that_doesnt_exist")
:ok
Cache.delete("cat")
:ok
Cache.clear
:ok
```

To stop the process, invoke the `stop/0` function.
```
Cache.stop
terminating cache for reason: :normal
:ok
cache terminated with 1 keys
```

