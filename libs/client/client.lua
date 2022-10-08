local musics = {
  'https://server1.mtabrasil.com.br/youtube/play?id=HvC96EaQDmU'
}

local characters = false
local renderDrawAccount = false
local renderCreateAccount = false

local animations = {
  characterImage = {
    duration = 500,
    tick = 0,
    now = 0,
    animation = true
  },
  changingSlot = false
}

local fonts = {
  ['Montserrat-Bold'] = dxCreateFont('assets/fonts/Montserrat-Bold.ttf', 36)
}

addEventHandler('onClientResourceStart', resourceRoot,
function()
  createSlotsBackground()
  createNextSlot()
  createAddButton()
end
)

addEvent('drawAccountsEvent', true)
addEventHandler('drawAccountsEvent', root, function(chars)
  characters = chars
  --iprint(#characters)
  if not renderDrawAccount then
    renderDrawAccount = true
    showCursor(true)
    showChat(false)
    animations.characterImage.tick = getTickCount()
    addEventHandler('onClientRender', root, drawAccounts)
    local musicplaying = math.random(1, #musics)
    music = playSound(musics[musicplaying], true)
    setSoundVolume(music, 0.05)
  end
end)

function drawAccounts()
  if renderDrawAccount then
    animations.characterImage.now = getTickCount()
    dxDrawImage(0, 0, 1920, 1080, 'assets/images/ui/background.png')
    drawSlotsBackground()
    drawNextSlot()
    for i, v in ipairs(settings.slotsInScreen) do
      if characters and characters[v] then
        dxDrawText(characters[v].name..' '..characters[v].lastname, 217+(559*(i-1)), 140, 369, 26, tocolor(219, 219, 219, interpolateBetween(not animations.characterImage.animation and 255 or 0, 0, 0, not animations.characterImage.animation and 0 or 255, 0, 0, (animations.characterImage.now-animations.characterImage.tick)/animations.characterImage.duration, 'OutQuad')), 1, fonts['Montserrat-Bold'], 'center', 'center')
        dxDrawImage(181+(549*(i-1)), 210, 441, 604, 'assets/images/ui/char'..characters[v].character_image..'.png', 0, 0, 0, tocolor(255, 255, 255, interpolateBetween(not animations.characterImage.animation and 255 or 0, 0, 0, not animations.characterImage.animation and 0 or 255, 0, 0, (animations.characterImage.now-animations.characterImage.tick)/animations.characterImage.duration, 'OutQuad')))
        dxDrawText(characters[v].id..'', 213+(562*(i-1)), 914, 377, 26, tocolor(219, 219, 219, interpolateBetween(not animations.characterImage.animation and 255 or 0, 0, 0, not animations.characterImage.animation and 0 or 255, 0, 0, (animations.characterImage.now-animations.characterImage.tick)/animations.characterImage.duration, 'OutQuad')), 1, fonts['Montserrat-Bold'], 'center', 'center')
      else
        drawAddButton(354+(559*(i-1)), 492)
      end
    end
  end
end

addEvent('drawCreateAccount', true)
addEventHandler('drawCreateAccount', root, function()
  if not renderCreateAccount then
    renderDrawAccount = false
    renderCreateAccount = true
    addEventHandler('onClientRender', root, drawCreateAccount)
  end
end
)

function drawCreateAccount()
  if renderCreateAccount then

  end
end

addEventHandler('onClientClick', root, function(button, state)
  if renderDrawAccount and button == 'left' and state == 'down' then
    if isCursorOnElement(1791, 503, 42, 74) then
      if changingSlot == true then return end
      animations.characterImage.tick = getTickCount()
      animations.characterImage.animation = false
      changingSlot = true
      setTimer(function()
        animations.characterImage.tick = getTickCount()
        changingSlot = false
        animations.characterImage.animation = true
        changeSlots()
      end, animations.characterImage.duration, 1)
    end

    if isCursorOnElement(217, 266, 369, 548) then
      if settings.slotsInScreen[1] <= #characters then
        -- entrar conta
        return
      end
      -- menu criar conta
    end

    if isCursorOnElement(776, 266, 369, 548) then
      if settings.slotsInScreen[2] <= #characters then
        -- entrar conta
        return
      end
      -- menu criar conta
    end

    if isCursorOnElement(1326, 266, 369, 548) then
      if settings.slotsInScreen[3] <= #characters then
        -- entrar conta
        return
      end
      -- menu criar conta
    end
  end
end)