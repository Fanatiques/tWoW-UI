local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("pfUI-CustomMedia%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-A.tga:pfUI-A")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-B.tga:pfUI-B")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-C.tga:pfUI-C")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-D.tga:pfUI-D")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-E.tga:pfUI-E")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-F.tga:pfUI-F")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-G.tga:pfUI-G")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-H.tga:pfUI-H")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-I.tga:pfUI-I")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-J.tga:pfUI-J")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-K.tga:pfUI-K")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-L.tga:pfUI-L")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-M.tga:pfUI-M")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-N.tga:pfUI-N")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-O.tga:pfUI-O")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-P.tga:pfUI-P")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-Q.tga:pfUI-Q")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-R.tga:pfUI-R")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-S.tga:pfUI-S")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-T.tga:pfUI-T")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-U.tga:pfUI-U")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-V.tga:pfUI-V")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-W.tga:pfUI-W")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-X.tga:pfUI-X")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-Y.tga:pfUI-Y")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-Y.tga:Blinkii")
table.insert(pfUI.gui.dropdowns.uf_bartexture, addonpath .. "\\bars\\pfUI-Y.tga:ToxiUI-clean")