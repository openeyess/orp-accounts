local characters = false
local test = true 
addEventHandler('onClientResourceStart', resourceRoot,
function()
  createSlotsBackground()
  createNextSlot()
  createAddButton()
end
)

addEvent('drawAccounts', true)
addEventHandler('drawAccounts', root, function(characters)
  characters = characters
  showCursor(true)
  if test then
      addEventHandler('onClientRender', root, function()
      dxDrawImage(0, 0, 1920, 1080, 'assets/images/ui/background.png')
      drawSlotsBackground()
      drawNextSlot()
      for i, v in ipairs(settings.slotsInScreen) do
        if characters and characters[v] then
          dxDrawImage(181+(549*(i-1)), 210, 441, 604, 'assets/images/ui/char'..characters[v].character_image..'.png')
        else
          drawAddButton(354+(559*(i-1)), 492)
        end
      end
    end)
  end
end)

addEventHandler('onClientClick', root, function(button, state)
  if test and button == 'left' and state == 'down' then
    if isCursorOnElement(1791, 503, 42, 74) then 
      changeSlots()
    end
  end
end)