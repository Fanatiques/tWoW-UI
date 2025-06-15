# SmartHealer
*for World of Warcraft 1.12.1 (Vanilla)*

Autoscales heals in macros (/heal <spell_name>) and click heals for pfUI, Clique and ClassicMouseover.

Scaling is done using HealComm-1.0 library (part of the package) or [TheoryCraft](https://wow.curseforge.com/projects/project-1644) (if present).  
Addon checks missing HPs of target (or player if self cast), compares it with calculated healing done and selects the lowest rank needed to fully heal the target. If TheoryCraft is installed, addon also checks if you have enough mana to cast spell of selected rank. If you do not, it will try to use highest possible rank for which you have enough mana.

## Commands:
- `/heal <spell_name>[, overheal_multiplier]`  
  Used in macros to cast optimal rank of heal.  
  Overheal multiplier is optional and should be separated from spell name by comma "," or semicolon ";". It will override dafault overheal multiplier. See the next command.  

- `/sh_overheal <multiplier>`  
  Sets new default overheal multiplier. When selecting spell rank, calculated heal must be higher then missing HP * multiplier. Valid multiplier is number or percentage (1.15 or 115%).   
  If used without argument, prints current overheal multiplier.  

*NOTE:*  
Spell name shouldn't contain rank. If there is a rank, heal won't be scaled. It means that `/heal Healing Wave` will use rank as needed, but `/heal Healing Wave(Rank 3)` will always cast rank 3.  
The same goes for supported addons. Do not specify rank in click actions (in case of Clique, spell must be set to "Max").  

## Installation
1. Download **[Latest Version](https://github.com/melbaa/SmartHealer/archive/refs/heads/master.zip)**
2. Unpack the Zip file
3. Rename the folder "SmartHealer-master" to "SmartHealer"
4. Copy "SmartHealer" into \<WoW-directory\>\Interface\AddOns
5. Restart WoW

### Credits:
Garkin's repo https://gitlab.com/AMGarkin/SmartHealer  
Original idea of this addon is based on Ogrisch's [LazySpell](https://github.com/satan666/LazySpell).
