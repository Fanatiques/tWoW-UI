# /equip and /equipoh

`/equip` puts an item with the given name or id into the main hand slot.

`/equipoh` puts an item with the given name or id into the off hand slot.

## Examples

```lua
/equip Elementium Reinforced Bulwark
```

Will equip the Elementium Reinforced Bulwark if it can be found in the inventory.

---

```lua
/equipoh [equipped:Shields] Iblis, Blade of the Fallen Seraph
```

Will equip Iblis, Blade of the Fallen Seraph if you currently have a shield equipped.

---

```lua
/equip 19862
```

Will equip item id 19862, Aegis of the Blood God.
