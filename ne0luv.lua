--[[
  ne0luv - Some love2d utilities

  date: 25/03/2024
  author: Abhishek Mishra
]]
local ne0luv = {}

local Class = require('middleclass')

--- vector.lua - A simple vector class. Similar to the Vector implementation in
-- the p5.js library.
--
-- see: https://p5js.org/reference/#/p5.Vector
-- see: https://love2d.org/wiki/Vectors
--
-- date: 23/03/2024
-- author: Abhishek Mishra
-- license: MIT, see LICENSE for more details.
--- Vector class
local Vector = Class('Vector')

--- constructor
--@param x the x component of the vector
--@param y the y component of the vector
--@param z the z component of the vector
function Vector:initialize(x, y, z)
    self:set(x or 0, y or 0, z or 0)
end

--- set the x, y, z components of the vector
--@param x the x component of the vector
--@param y the y component of the vector
--@param z the z component of the vector
function Vector:set(x, y, z)
    self.x = x
    self.y = y
    self.z = z
end

--- tostring operator overloading
function Vector:__tostring()
    return 'Vector(' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. ')'
end

--- copy the vector
function Vector:copy()
    return Vector(self.x, self.y, self.z)
end

--- add a vector to this vector using the lua operator overloading
--@param v the vector to add
function Vector:__add(v)
    return Vector(self.x + v.x, self.y + v.y, self.z + v.z)
end

--- subtract a vector from this vector using the lua operator overloading
--@param v the vector to subtract
function Vector:__sub(v)
    return Vector(self.x - v.x, self.y - v.y, self.z - v.z)
end

--- multiply this vector by a scalar using the lua operator overloading
--@param s the scalar to multiply
function Vector:__mul(s)
    return Vector(self.x * s, self.y * s, self.z * s)
end

--- divide this vector by a scalar using the lua operator overloading
--@param s the scalar to divide
function Vector:__div(s)
    return Vector(self.x / s, self.y / s, self.z / s)
end

--- get the magnitude of the vector
function Vector:mag()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

-- set the magnitude of the vector
--@param m the magnitude to set
function Vector:setMag(m)
    self:normalize()
    -- multiply by the magnitude
    self:set(self.x * m, self.y * m, self.z * m)
end

--- get the magnitude of the vector squared
function Vector:magSq()
    return self.x * self.x + self.y * self.y + self.z * self.z
end

--- get the heading of the vector
function Vector:heading()
    return math.atan(self.y, self.x)
end

--- limit the magnitude of the vector, returns a new vector without modifying
-- the original
--@param max the maximum magnitude
--@return the limited vector (a new vector)
function Vector:limit(max)
    local limited = self:copy()
    if limited:magSq() > max * max then
        limited:normalize()
        limited = limited * max
    end
    return limited
end

--- dot product of this vector with another vector
--@param v the other vector
function Vector:dot(v)
    return self.x * v.x + self.y * v.y + self.z * v.z
end

--- cross product of this vector with another vector
--@param v the other vector
function Vector:cross(v)
    return Vector(
        self.y * v.z - self.z * v.y,
        self.z * v.x - self.x * v.z,
        self.x * v.y - self.y * v.x
    )
end

--- distance between this vector and another vector
--@param v the other vector
function Vector:dist(v)
    return (self - v):mag()
end

--- normalize the vector
function Vector:normalize()
    local m = self:mag()
    if m > 0 then
        self:set(self.x / m, self.y / m, self.z / m)
    end
end

--- equals operator overloading
--@param v the other vector
function Vector:__eq(v)
    return self.x == v.x and self.y == v.y and self.z == v.z
end

--- vector not equals operator overloading
--@param v the other vector
function Vector:__ne(v)
    return not (self == v)
end

--- vector unary minus operator overloading
function Vector:__unm()
    return Vector(-self.x, -self.y, -self.z)
end

--- vector unary plus operator overloading
function Vector:__uplus()
    return self:copy()
end

--- vector less than operator overloading
--@param v the other vector
function Vector:__lt(v)
    return self:magSq() < v:magSq()
end

--- vector less than or equal to operator overloading
--@param v the other vector
function Vector:__le(v)
    return self:magSq() <= v:magSq()
end

--- vector greater than operator overloading
--@param v the other vector
function Vector:__gt(v)
    return self:magSq() > v:magSq()
end

--- vector greater than or equal to operator overloading
--@param v the other vector
function Vector:__ge(v)
    return self:magSq() >= v:magSq()
end

--- create a random 2D vector
--@return a random 2D vector
function Vector.random2D()
    local angle = math.random() * math.pi * 2
    return Vector(math.cos(angle), math.sin(angle))
end

--- create a random 3D vector
--@return a random 3D vector
function Vector.random3D()
    local angle = math.random() * math.pi * 2
    local vz = math.random() * 2 - 1
    local vx = math.sqrt(1 - vz * vz) * math.cos(angle)
    local vy = math.sqrt(1 - vz * vz) * math.sin(angle)
    return Vector(vx, vy, vz)
end

local Rect = Class('Rect')

function Rect:initialize(x, y, w, h)
    self.pos = Vector(x, y)
    self.dim = Vector(w, h)
end

function Rect:contains(x, y)
    return (x >= self.pos.x and x <= self.pos.x + self.dim.x
        and y >= self.pos.y and y <= self.pos.y + self.dim.y)
end

function Rect:getWidth()
    return self.dim.x
end

function Rect:getHeight()
    return self.dim.y
end

function Rect:getX()
    return self.pos.x
end

function Rect:getY()
    return self.pos.y
end

function Rect:setX(x)
    self.pos.x = x
end

function Rect:setY(y)
    self.pos.y = y
end

function Rect:setWidth(w)
    self.dim.x = w
end

function Rect:setHeight(h)
    self.dim.y = h
end


-- Default values for the panel
local PANEL_DEFAULT_WIDTH = 100
local PANEL_DEFAULT_HEIGHT = 100

-- Define the Panel class
local Panel = Class('Panel')

--- Constructor for the Panel class
--@param dim the dimensions of the panel
function Panel:initialize(rect)
    self.rect = rect or Rect(0, 0, PANEL_DEFAULT_WIDTH, PANEL_DEFAULT_HEIGHT)
    self.parent = nil
end

function Panel:setParent(parent)
    self.parent = parent
end

function Panel:getParent()
    return self.parent
end

-- Lifecycle methods
function Panel:show()
    -- Code to show the panel
end

function Panel:hide()
    -- Code to hide the panel
end

function Panel:update(dt)
    -- Code to update the panel
end

--- set the position of the panel and then draw using internal _draw method
-- Subclasses should override the _draw method
function Panel:draw()
    love.graphics.push()
    self:_draw()
    love.graphics.pop()
end

function Panel:_draw()
    -- Code to draw the panel
end

function Panel:keypressed(key)
    -- Code to handle key press
end

function Panel:mousepressed(x, y, button, istouch, presses)
    if self.rect:contains(x, y) then
        self:_mousepressed(x, y, button, istouch, presses)
    end
end

function Panel:_mousepressed(x, y, button, istouch, presses)
end

function Panel:mousereleased(x, y, button, istouch, presses)
    if self.rect:contains(x, y) then
        self:_mousereleased(x, y, button, istouch, presses)
    end
end

function Panel:_mousereleased(x, y, button, istouch, presses)
end

function Panel:mousemoved(x, y, dx, dy, istouch)
    if self.rect:contains(x, y) then
        self:_mousemoved(x, y, dx, dy, istouch)
    else
        self:_mouseout()
    end
end

function Panel:_mousemoved(x, y, dx, dy, istouch)
end

function Panel:_mouseout()
end

function Panel:getWidth()
    return self.rect:getWidth()
end

function Panel:getHeight()
    return self.rect:getHeight()
end

function Panel:getX()
    return self.rect:getX()
end

function Panel:getY()
    return self.rect:getY()
end

function Panel:setX(x)
    self.rect:setX(x)
end

function Panel:setY(y)
    self.rect:setY(y)
end
--- text.lua - A panel class that displays a single line of text
--
-- date: 17/02/2024
-- author: Abhishek Mishra

-- Define the Text class that extends the Panel class
local Text = Class('Text', Panel)

-- Constructor for the Text class
function Text:initialize(rect, config)
    Panel.initialize(self, rect)
    self.config = config or {}
    self.fgColor = self.config.fgColor or { 1, 1, 1, 1 } -- Default text color is white
    self.font = self.config.font or love.graphics.newFont(14) -- Default font size is 14
    self.displayText = self.config.text or "" -- Default text is an empty string
    self.align = self.config.align or "left" -- Default alignment is left
    self._text = love.graphics.newText(self.font, self.displayText) -- Create the love2d text object
end

-- Method to set the text
function Text:setText(text)
    self.displayText = text
    self._text:set(text) -- Update the love2d text object
end

-- Set the text alignment
function Text:setAlignment(align)
    self.align = align
end

-- Override the draw method
function Text:_draw()
    love.graphics.setColor(self.fgColor)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.displayText, self:getX(), self:getY(), self:getWidth(), self.align)
end
--- button.lua - A simple button class
--
-- date: 17/02/2024
-- author: Abhishek Mishra

--- Button class
local Button = Class('Button', Panel)

--- a counter to keep track of the number of buttons created
Button.static.idCounter = 0

--- constructor
--@param displayText the text to display on the button
--@param onActivate the function to call when the button is activated
function Button:initialize(dim, displayText, onActivate, colors)
    Panel.initialize(self, dim)
    Button.idCounter = Button.idCounter + 1
    self.id = 'Button' .. Button.idCounter
    self.displayText = displayText
    self.onActivate = onActivate or function() end
    self.text = love.graphics.newText(love.graphics.getFont(), self.displayText)
    self.colors = colors or {
        bg = { 0.5, 0.5, 0.5, 1 },
        fg = { 1, 1, 1, 1 },
        bgSelect = { 0.7, 0.7, 0.7, 1 },
        fgSelect = { 0, 0, 0, 1 }
    }
end

function Button:toggleSelect()
    self.select = not self.select
end

function Button:isSelected()
    return self.select
end

function Button:setSelected(selected)
    if selected == nil then
        selected = true
    end
    self.select = selected
end

--- run the onActivate function
function Button:activate()
    self.onActivate()
end

--- draw the button
function Button:_draw()
    local bgColor, fgColor
    love.graphics.push()
    if self:isSelected() then
        bgColor = self.colors.bgSelect
        fgColor = self.colors.fgSelect
    else
        bgColor = self.colors.bg
        fgColor = self.colors.fg
    end
    love.graphics.setColor(bgColor)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(fgColor)
    love.graphics.draw(self.text, self.x + 10, self.y + 10)
    love.graphics.pop()
end

function Button:_mouseout()
    self:setSelected(false)
end

function Button:_mousemoved(x, y, dx, dy, istouch)
    if self:contains(x, y) then
        self:setSelected(true)
    else
        self:setSelected(false)
    end
end

function Button:_mousepressed(x, y, button, istouch, presses)
    if self:contains(x, y) then
        self:activate()
    end
end

-- contains - check if the button contains the point x, y
function Button:contains(x, y)
    return x >= 0 and x <= self.width and
        y >= 0 and y <= self.height
end
-- Define the Slider class that extends the Panel class
local Slider = Class('Slider', Panel)

-- Constructor for the Slider class
function Slider:initialize(rect, config)
    Panel.initialize(self, rect)
    self.config = config or {}
    self.minValue = self.config.minValue or 0                     -- Default minValue is 0
    self.maxValue = self.config.maxValue or 100                   -- Default maxValue is 100
    self.currentValue = self.config.currentValue or self.minValue -- Default currentValue is minValue
    self.handleWidth = 10                             -- Width of the handle
    self.handleHeight = self:getHeight()                    -- Height of the handle
    self.handleX = self:calculateHandlePosition()     -- X position of the handle
    self.changeHandler = {}
end

-- Method to calculate the handle position based on the current value
function Slider:calculateHandlePosition()
    local range = self.maxValue - self.minValue
    local fraction = (self.currentValue - self.minValue) / range
    return self:getX() + fraction * (self:getWidth() - self.handleWidth)
end

-- Method to update the current value based on the handle position
function Slider:updateCurrentValue()
    local range = self.maxValue - self.minValue
    local fraction = (self.handleX - self:getX()) / (self:getWidth() - self.handleWidth)
    self.currentValue = self.minValue + fraction * range
    -- self.currentValue = math.floor(self.currentValue + 0.5)
    self:fireChangeHandlers()
end

function Slider:addChangeHandler(handler)
    table.insert(self.changeHandler, handler)
end

function Slider:fireChangeHandlers()
    for _, handler in ipairs(self.changeHandler) do
        handler(self.currentValue)
    end
end

-- remove handler
function Slider:removeChangeHandler(handler)
    for i, h in ipairs(self.changeHandler) do
        if h == handler then
            table.remove(self.changeHandler, i)
            break
        end
    end
end

-- Override the draw method
function Slider:_draw()
    love.graphics.push()

    if self.dragging then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    else
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
    end

    -- Draw the line
    love.graphics.line(self:getX(), self:getY() + self:getHeight() / 2, self:getX() + self:getWidth(), self:getY() + self:getHeight() / 2)

    -- Draw the handle
    love.graphics.rectangle('fill', self.handleX, self:getY(), self.handleWidth, self.handleHeight)

    love.graphics.pop()
end

-- Override the mousepressed method
function Slider:_mousepressed(x, y, button)
    -- print("Slider:mousepressed [" .. x .. ", " .. y .. "]")
    if button == 1 and x >= self.handleX
        and x <= self.handleX + self.handleWidth
        and y >= self:getY() and y <= self:getY() + self.handleHeight then
        self.dragging = true
    else
        self.handleX = x
        self.dragging = false
        self:updateCurrentValue()
    end
end

-- Override the mousemoved method
function Slider:_mousemoved(x, y, dx, dy)
    -- print("Slider:mousemoved")
    if self.dragging then
        self.handleX = self.handleX + dx
        self.handleX = math.max(self:getX(),
            math.min(self:getX() + self:getWidth() - self.handleWidth, self.handleX))
        self:updateCurrentValue()
    end
end

-- Override the mousereleased method
function Slider:_mousereleased(x, y, button)
    -- print("Slider:mousereleased")
    if button == 1 then
        self.dragging = false
    end
end

--- Override the setX method to update the handle position when
-- the x position of the slider is changed
function Slider:setX(x)
    self.rect:setX(x)
    self.handleX = self:calculateHandlePosition()
end

-- function Slider:setY(y)
--     self.rect:setY(y)
-- end

-- Define the Layout class that extends the Panel class
local Layout = Class('Layout', Panel)

-- Constructor for the Layout class
function Layout:initialize(rect, config)
    Panel.initialize(self, rect)
    self.config = config or {}
    -- Default layout is row
    self.layout = self.config.layout or 'row'
    -- Default fill color is black
    self.bgColor = self.config.bgColor or { 0, 0, 0, 1 }
    -- Initialize an empty table for child components
    self.children = {}
end

-- Method to add a child component
function Layout:addChild(c)
    table.insert(self.children, c)

    -- Set the parent of the child to this layout
    c:setParent(self)

    -- set the position of the child based on layout, and the size of the children

    -- if layout is row
    if self.layout == 'row' then
        local startPos = 0
        for _, child in ipairs(self.children) do
            child:setX(startPos)
            startPos = startPos + child:getWidth()
        end
    else -- layout is column
        local startPos = 0
        for _, child in ipairs(self.children) do
            child:setY(startPos)
            startPos = startPos + child:getHeight()
        end
    end

end

function Layout:setX(x)
    -- set the x position of the layout
    local prevX = self:getX()
    self.rect:setX(x)
    local diff = x - prevX
    -- update the x position of all the children
    -- if layout is row
    if self.layout == 'row' then
        -- adjust the x position of all the children
        for _, child in ipairs(self.children) do
            child:setX(child:getX() + diff)
        end
    end
    if self.layout == 'column' then
        -- adjust the x position of all the children
        for _, child in ipairs(self.children) do
            child:setX(self:getX())
        end
    end
end

function Layout:setY(y)
    -- set the y position of the layout
    local prevY = self:getY()
    self.rect:setY(y)
    local diff = y - prevY
    -- update the y position of all the children
    -- if layout is row
    if self.layout == 'row' then
        -- adjust the y position of all the children
        for _, child in ipairs(self.children) do
            child:setY(self:getY())
        end
    end
    if self.layout == 'column' then
        -- adjust the y position of all the children
        for _, child in ipairs(self.children) do
            child:setY(child:getY() + diff)
        end
    end
end

-- Get children
function Layout:getChildren()
    return self.children
end

-- Method to set the background color for the panel
function Layout:setBGColor(color)
    self.bgColor = color
end

-- show method
function Layout:show()
    -- Iterate over child components and show them
    local startPos = 0
    for _, child in ipairs(self.children) do
        child:show()
    end
end

-- hide method
function Layout:hide()
    -- Iterate over child components and hide them
    for _, child in ipairs(self.children) do
        child:hide()
    end
end

-- Override the _draw method
function Layout:_draw()
    -- Draw the background
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle('fill', self:getX(), self:getY(), self:getWidth(), self:getHeight())
    -- Iterate over child components and draw them
    for _, child in ipairs(self.children) do
        child:draw()
    end
end

-- Override the update method
function Layout:update(dt)
    -- Iterate over child components and update them
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

-- Override the keypressed method
function Layout:keypressed(key)
    -- Iterate over child components and pass the keypress event
    for _, child in ipairs(self.children) do
        child:keypressed(key)
    end
end

-- Override the mousepressed method
function Layout:_mousepressed(x, y, button, istouch, presses)
    -- print("Layout:_mousepressed [" .. x .. ", " .. y .. "]")
    -- Iterate over child components and pass the mousepress event
    for _, child in ipairs(self.children) do
        child:mousepressed(x, y, button, istouch, presses)
    end
end

-- Override the mousereleased method
function Layout:_mousereleased(x, y, button, istouch, presses)
    -- Iterate over child components and pass the mouserelease event
    for _, child in ipairs(self.children) do
        child:mousereleased(x, y, button, istouch, presses)
    end
end

-- Override the mousemoved method
function Layout:_mousemoved(x, y, dx, dy, istouch)
    -- print("Layout:_mousemoved [" .. x .. ", " .. y .. "]")
    -- Iterate over child components and pass the mousemove event
    for _, child in ipairs(self.children) do
        child:mousemoved(x, y, dx, dy, istouch)
    end
end

ne0luv["Vector"] = Vector
ne0luv["Rect"] = Rect
ne0luv["Panel"] = Panel
ne0luv["Text"] = Text
ne0luv["Button"] = Button
ne0luv["Slider"] = Slider
ne0luv["Layout"] = Layout

return ne0luv
