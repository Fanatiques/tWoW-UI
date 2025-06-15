# cooldown / nocooldown

This condition will only fire when the given name of a spell or item is
off/on cooldown.

## Parameters

The name of the spell. White spaces must be replaced with an underscore `_`.

## Examples

```lua
/cast [nocooldown:Spell_Lock] Spell Lock
```

Your Felhunter will cast Spell Lock when it is off cooldown.

```lua
/cast [cooldown:Bloodthirst>2] Sunder Armor
```

Cast Sunder Armor if Bloodthirst cooldown is greater than 2 seconds.
