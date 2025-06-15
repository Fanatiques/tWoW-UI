# casting / nocasting

This [SuperWoW] condition will only fire when a target is casting a spell. Can be inverted by adding `no` in front of `casting`  

## Examples

```lua
/cast [casting @target] Pummel
```

You will Pummel only when your target is casting any spell.  

```lua
/cast [casting:Polymorph @target] Counterspell
```

You will Pummel only when your target is casting Polymorph.  

```lua
/cast [casting nocasting:Fireball @target] Intercept
```

You will Intercept when your target is casting any spell, except Fireball.  
