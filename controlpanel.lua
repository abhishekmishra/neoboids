----- ControlPanel ------
local nl = require('lib.neoluv')
local Class = require('lib.neoluv.middleclass')

-- A Control Panel Class which extends Layout
local ControlPanel = Class('ControlPanel', nl.ColumnLayout)

function ControlPanel:initialize(w, h)
    nl.ColumnLayout.initialize(self, {
        size = { w = w, h = h },
        margin = 5,
        border = 1,
        padding = 2
    }, {
        bgColor = PALETTE.dark,
        borderColor = PALETTE.darkest
    })
    local itemH = 20

    -- sliders
    self.alignmentSlider = nil
    self.cohesionSlider = nil
    self.separationSlider = nil

    -- slider labels
    local alignmentLabel
    local cohesionLabel
    local separationLabel

    -- fps text display
    self.fpsText = nil

    ----------- Alignment Slider ------------
    -- create and add alignment slider label
    alignmentLabel = nl.Text(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            text = 'Alignment:',
            bgColor = PALETTE.mid,
            align = 'center'
        }
    )
    self:addChild(alignmentLabel)

    -- create and add alignment slider
    self.alignmentSlider = nl.Slider(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            minValue = 0,
            maxValue = 1.5,
            currentValue = 0.5,
            bgColor = PALETTE.mid
        }
    )

    self.alignmentSlider:addChangeHandler(function(value)
        -- trim value to 2 decimal places
        value = math.floor(value * 100) / 100
        alignmentLabel:setText('Alignment: ' .. value)
    end)

    self:addChild(self.alignmentSlider)

    -- set initial Alignment value
    alignmentLabel:setText('Alignment: ' .. self.alignmentSlider.currentValue)

    -- add empty panel
    self:separator(20)

    ----------- Cohesion Slider ------------

    -- create and add cohesion slider label
    cohesionLabel = nl.Text(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            text = 'Cohesion:',
            bgColor = PALETTE.mid,
            align = 'center'
        }
    )

    self:addChild(cohesionLabel)

    self.cohesionSlider = nl.Slider(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            minValue = 0,
            maxValue = 1,
            currentValue = 0.1,
            bgColor = PALETTE.mid
        }
    )

    self.cohesionSlider:addChangeHandler(function(value)
        -- trim value to 2 decimal places
        value = math.floor(value * 100) / 100
        cohesionLabel:setText('Cohesion: ' .. value)
    end)

    self:addChild(self.cohesionSlider)
    -- set initial Cohesion
    cohesionLabel:setText('Cohesion: ' .. self.cohesionSlider.currentValue)

    -- separator
    self:separator(20)

    ----------- Separation Slider ------------

    separationLabel = nl.Text(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            text = 'Separation:',
            bgColor = PALETTE.mid,
            align = 'center'
        }
    )

    self:addChild(separationLabel)

    self.separationSlider = nl.Slider(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            minValue = 0,
            maxValue = 1,
            currentValue = 0.4,
            bgColor = PALETTE.mid
        }
    )

    self.separationSlider:addChangeHandler(function(value)
        -- trim value to 2 decimal places
        value = math.floor(value * 100) / 100
        separationLabel:setText('Separation: ' .. value)
    end)

    self:addChild(self.separationSlider)
    -- set initial Separation
    separationLabel:setText('Separation: ' .. self.separationSlider.currentValue)

    -- separator
    -- total height for 3 sliders, 3 labels, and 2 separators, each itemH
    -- in height. Add one more itemH for the fps text display.
    local totalHeight = itemH * (3 + 3 + 2 + 1);
    self:separator(self:getCanvasRect():getHeight() - totalHeight)

    self.fpsText = nl.Text(
        {
            size = { w = self:getCanvasRect():getWidth(), h = 20 }
        },
        {
            text = 'FPS: 0',
            bgColor = PALETTE.mid,
            fgColor = PALETTE.light,
            align = 'center'
        }
    )
    self:addChild(self.fpsText)
end

--- Create and add a separator to the control panel, with the
-- specified height.
-- @param height The height of the separator
function ControlPanel:separator(height)
    local emptyPanel = nl.Panel(
        nl.Rect(0, 0, self:getCanvasRect():getWidth(), height),
        {
            bgColor = PALETTE.mid
        }
    )
    self:addChild(emptyPanel)
end

return ControlPanel
