local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("pfUI-fonts%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\BalooBhaina.ttf:BalooBhaina")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Bungee.ttf:Bungee")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\CaesarDressing.ttf:CaesarDressing")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\CoveredByYourGrace.ttf:CoveredByYourGrace")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\JotiOne.ttf:JotiOne")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\LondrinaSolid.ttf:LondrinaSolid")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\NovaFlat.ttf:NovaFlat")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Roboto.ttf:Roboto")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\SedgwickAveDisplay.ttf:SedgwickAveDisplay")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\ShareBold.ttf:ShareBold")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Share.ttf:Share")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Sniglet.ttf:Sniglet")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\SquadaOne.ttf:SquadaOne")
