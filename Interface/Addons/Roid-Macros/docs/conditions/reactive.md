# reactive / noreactive

Checks if a given reactive ability is useable. Can be inverted by adding `no` in
front of `reactive`.  
This requires a bare (non-macro'd) version of the reactive ability to be present in an actionbar slot somewhere, it does not have to be visible.  

## Examples:

```lua
/cast [reactive:Revenge] Revenge;Sunder Armor
```

Will cast Revenge if it's possible and Sunder Armor otherwise.  
