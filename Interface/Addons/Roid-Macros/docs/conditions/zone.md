# zone / nozone

Checks if you are in the given zone or not. Can be inverted by adding `no` in
front of `zone`.  

## Examples:

```lua
/cast [zone:Orgrimmar] Resurrection; Flash Heal
```

Will cast Resurrection if you're in Orgrimmar. If you are not it will cast Flash Heal instead.  

---

```lua
/cast [nozone:The_Barrens/Undercity] Resurrection; Flash Heal
```

The same but only if you're not in The Barrens or Undercity.  