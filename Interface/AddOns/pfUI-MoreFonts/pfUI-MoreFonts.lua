local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("pfUI-MoreFonts%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Acme-Regular.ttf:Acme")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\AlegreyaSansSC-Bold.ttf:AlegreyaSansSC")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Bangers-Regular.ttf:Bangers")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\BarlowCondensed-Medium.ttf:BarlowCondensed")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\BigNoodleTitlingOblique.ttf:BigNoodleTitlingOblique")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\FjallaOne-Regular.ttf:FjallaOne")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\FTY.ttf:FTY")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Kingthings Foundation.ttf:Kingthings")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\PathwayGothicOne-Regular.ttf:PathwayGothicOne")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\RoadRage-Regular.ttf:RoadRage")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\US101:US101")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\ToxiUI.ttf:ToxiUI")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Montserrat-Black.ttf:Montserrat-Black")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Montserrat-Bold.ttf:Montserrat-Bold")
table.insert(pfUI.gui.dropdowns.fonts, addonpath .. "\\fonts\\Montserrat-Medium.ttf:Montserrat-Medium")


