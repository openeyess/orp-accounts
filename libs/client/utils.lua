local screen = {guiGetScreenSize()}
local resW, resH = 1920, 1080
local sx, sy = screen[1]/resW, screen[2]/resH

local vectors = {
  slots = {},
  arrows = {},
  buttons = {}
}
local caches = {}

settings = {
  slots = 5,
  slotsInScreen = {1, 2, 3}
}

function aToR(X, Y, sX, sY)
  local xd = X/resW or X
  local yd = Y/resH or Y
  local xsd = sX/resW or sX
  local ysd = sY/resH or sY
  return xd * screen[1], yd * screen[2], xsd * screen[1], ysd * screen[2]
end

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, color, scale, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    local scale = screen[2]/1100
    return _dxDrawText (text, x, y, (x + w), (y + h), color, scale, ...)
end

function isCursorOnElement(x, y, w, h)
  local x, y, w, h = sx * x, sy * y, sx * w, sy * h

  if (not isCursorShowing()) then
      return false
  end
  local mx, my = getCursorPosition()
  local fullx, fully = guiGetScreenSize()
  local cursorx, cursory = mx*fullx, my*fully
  if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
      return true
  else
      return false
  end
end

function createVector(width, height, rawData)
  local svgElm = svgCreate(width, height, rawData)
  local svgXML = svgGetDocumentXML(svgElm)
  local rect = xmlFindChild(svgXML, 'rect', 0) or nil
  local path = xmlFindChild(svgXML, 'path', 0) or nil

  return {
    svg = svgElm,
    xml = svgXML,
    rect = rect,
    path = path
  }
end

function createSlotsBackground()
  local raw = [[
    <svg width="385" height="564" fill="none">
      <rect width="377" height="556" x="4" y="4" stroke="#222" stroke-width="8" rx="54"/>
    </svg>
  ]]
  local svg = createVector(377, 556, raw)

  local attributes = {
    type = 'slot-background',
    svgDetails = svg,
    width = 377,
    height = 556
  }

  vectors.slots = attributes
end

function createNextSlot()
  local raw = [[
    <svg width="42" height="74" fill="none" viewBox="0 0 42 74">
      <path fill="#222" d="M36 32a5 5 0 0 0 0 10V32Zm4.535 8.535a5 5 0 0 0 0-7.07L8.715 1.645a5 5 0 0 0-7.07 7.07L29.929 37 1.645 65.284a5 5 0 1 0 7.07 7.071l31.82-31.82ZM36 42h1V32h-1v10Z"/>
    </svg>
  ]]
  local svg = createVector(42, 74, raw)

  local attributes = {
    type = 'arrow',
    svgDetails = svg,
    width = 42,
    height = 74,
  }

  vectors.arrows = attributes
end

function createAddButton()
  local raw = [[
    <svg width="108" height="108" fill="none" >
      <path fill="#222" d="M83.333 51.333H56.667V24.667A2.667 2.667 0 0 0 54 22a2.667 2.667 0 0 0-2.667 2.667v26.666H24.667A2.667 2.667 0 0 0 22 54a2.667 2.667 0 0 0 2.667 2.667h26.666v26.666a2.667 2.667 0 0 0 5.334 0V56.667h26.666a2.667 2.667 0 0 0 0-5.334Z"/>
      <circle cx="54" cy="54" r="51" stroke="#222" stroke-width="6"/>
    </svg>
  ]]
  local svg = createVector(108, 108, raw)

  local attributes = {
    type = 'slot-create-button',
    svgDetails = svg,
    width = 108,
    height = 108,
  }

  vectors.buttons = attributes
end

function drawAddButton(x, y)
  if (not vectors.buttons) then return end
  
  dxSetBlendMode('add')
  dxDrawImage(x, y, vectors.buttons.width, vectors.buttons.height, vectors.buttons.svgDetails.svg, 0, 0, 0)
  dxSetBlendMode('blend')
end

function drawNextSlot()
  if (not vectors.arrows) then return end
  
  dxSetBlendMode('add')
  dxDrawImage(1791, 503, vectors.arrows.width, vectors.arrows.height, vectors.arrows.svgDetails.svg, 0, 0, 0)
  dxSetBlendMode('blend')
end

function drawSlotsBackground()
  if (not vectors.slots) then return end

  for i, v in ipairs(settings.slotsInScreen) do
    dxSetBlendMode('add')
    dxDrawImage(217 + 559*(i-1), 266, vectors.slots.width, vectors.slots.height, vectors.slots.svgDetails.svg, 0, 0, 0)
    dxSetBlendMode('blend')
  end
end

function changeSlots()
  settings.slotsInScreen[1] = (settings.slotsInScreen[1] + 1 > settings.slots) and 1 or settings.slotsInScreen[1] + 1
  settings.slotsInScreen[2] = (settings.slotsInScreen[2] + 1 > settings.slots) and 1 or settings.slotsInScreen[2] + 1
  settings.slotsInScreen[3] = (settings.slotsInScreen[3] + 1 > settings.slots) and 1 or settings.slotsInScreen[3] + 1
end