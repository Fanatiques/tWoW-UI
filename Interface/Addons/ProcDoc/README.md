# ProcDoc

**ProcDoc** is a lightweight World of Warcraft (Turtle WoW / Vanilla) addon that shows pulsing visuals whenever your character gains an instant-cast or free-cast buff—like Clearcasting, Shadow Trance, Overpower, etc. It automatically detects procs and displays on-screen alerts in a fun and noticeable way.

---

## Key Features

1. **Visual Alerts for Procs**  
   Displays large, pulsing textures around or above your character whenever a supported proc is active.

2. **Multiple Buff Support**  
   Supports many instant/free-cast buff procs (e.g. Shadow Trance, Clearcasting, Overpower), each with unique textures and placement.

3. **No Manual Setup Needed**  
   Simply install and go—proc detection is automatic. An in-game options panel (via `/procdoc`) lets you test custom visuals and tweak appearance settings.

---

## Installation

1. **Open Up Turtle-WoW Launcher** and click on the  **`ADDONS`** tab at the top of the window.
![Click Addons](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Install1.png)
2.  **At the bottom of the window,** press `+ Add new addon`. A new screen will appear that says `Enter a URL to install the addon from.`
![Click Add](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Install2.png)
3. **In the text box,** enter in the web address `https://github.com/wsmaxcy/ProcDoc`. If done correctly, a github repository will appear and you will see a beautiful face appear in the window.
![Add Repo](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Install3.png)
4. **Press Install** and you're good to go! Enjoy your proc animations!

---

## How to Use

1. **Log In**: Enter the game with any class that has procs (Warrior, Mage, Priest, etc.).
2. **Trigger a Proc**: Cast spells or fight until you get an “instant cast” buff (e.g. Clearcasting).
3. **See the Alert**: Pulsing textures appear in the chosen style (**SIDES** or **TOP**).
4. **Buff Ends**: The alert automatically disappears when the buff expires.

**Done!** You can also open the addon’s panel with **`/procdoc`** to test procs, modify transparency, or adjust offsets.

---

## Configuration

- **Min/Max Transparency**: Controls how faint or bright the pulsing effect can get.
- **Min/Max Size**: Changes how small or large the images become during pulsing.
- **Pulse Speed**: Adjusts how quickly the images fade in/out.
- **Offsets**: Shifts the alerts vertically (top) or horizontally (sides).
- **Sound Alerts**: Comes with a sound alert that will trigger when any proc is activated. Can be muted in the menu. This is tied to the `Master` volume, so if you would like to change the volume of the alert, use that slider.
You can experiment with these in the **`/procdoc`** panel. Changes are saved automatically.

![Configuration](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Config.png)

---

## Supported Procs

ProcDoc supports a variety of procs and alerts when key abilities or buffs become available for each class. Below is a list of currently supported procs:

### **Warlock**
![Warlock](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warlock.png)
- **Shadow Trance**


### **Mage**
![Mage](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Mage.png)
- **Clearcasting**
- **Netherwind Focus**
- **Temporal Convergence**
- **Flash Freeze**
- **Arcane Surge**
- **Arcane Rupture**


### **Warrior**
![Warrior](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Warrior.png)
- **Enrage**
- **Overpower**
- **Execute**
- **Revenge**
- **Counterattack**


### **Druid**
![Druid](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Druid.png)
- **Clearcasting**
- **Nature’s Grace**
- **Tiger's Fury**
- **Astral Boon**
- **Natural Boon**
- **Arcane Eclipse**
- **Nature Eclipse**


### **Rogue**
![Rogue](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Rogue.png)

- **Remorseless**
- **Riposte**
- **Surprise Attack**


### **Shaman**
![Shaman](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Shaman.png)

- **Clearcasting**
- **Nature's Swiftness**
- **Stormstrike**
- **Flurry**


### **Priest**
![Priest](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Priest.png)
- **Resurgence**
- **Enlightened**
- **Searing Light**


### **Hunter**
![Hunter](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Hunter.png)
- **Quick Shots**
- **Counterattack**
- **Mongoose Bite**


### **Paladin**
![Paladin](https://github.com/wsmaxcy/ProcDoc/blob/main/img/Paladin.png)
- **Hammer of Wrath**


### Additional Notes
- The list includes both classic procs and custom procs unique to Turtle WoW.
- New procs and alerts can easily be added by modifying the configuration in the `PROC_DATA` and `ACTION_PROCS` tables in the code. That, or hit me up and I can add it to the main addon!


---

## License

Feel free to use, modify, or share **ProcDoc**. A mention or credit is welcome but not required. Enjoy your new proccing visuals!
