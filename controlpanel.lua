----- ControlPanel ------
local nl = require('lib.neoluv')
local Class = require('lib.neoluv.middleclass')

-- A Control Panel Class which extends Layout
local ControlPanel = Class('ControlPanel', nl.ColumnLayout)

ControlPanel.static.LABEL_HEIGHT = 24
ControlPanel.static.SLIDER_HEIGHT = 20
ControlPanel.static.SEPARATOR_HEIGHT = 20

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
    alignmentLabel = nl.Text(self:getLabelConfig('Alignment:'))
    self:addChild(alignmentLabel)

    -- create and add alignment slider
    self.alignmentSlider = nl.Slider(
        self:getSliderConfig(0.5, 1.5)
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
    self:separator(ControlPanel.SEPARATOR_HEIGHT)

    ----------- Cohesion Slider ------------

    -- create and add cohesion slider label
    cohesionLabel = nl.Text(self:getLabelConfig('Cohesion:'))
    self:addChild(cohesionLabel)

    self.cohesionSlider = nl.Slider(
        self:getSliderConfig(0.1, 1)
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
    self:separator(ControlPanel.SEPARATOR_HEIGHT)

    ----------- Separation Slider ------------
    separationLabel = nl.Text(self:getLabelConfig('Separation:'))
    self:addChild(separationLabel)

    self.separationSlider = nl.Slider(
        self:getSliderConfig(0.4, 1)
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
    local totalHeight = 3 * ControlPanel.SLIDER_HEIGHT + 3 * ControlPanel.LABEL_HEIGHT +
        2 * ControlPanel.SEPARATOR_HEIGHT + 1 * ControlPanel.LABEL_HEIGHT;
    self:separator(self:getCanvasRect():getHeight() - totalHeight)

    self.fpsText = nl.Text(
        {
            size = { w = self:getCanvasRect():getWidth(), h = ControlPanel.LABEL_HEIGHT },
            padding = 1
        },
        {
            text = 'FPS: 0',
            bgColor = PALETTE.mid,
            fgColor = PALETTE.lightest,
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

function ControlPanel:getLabelConfig(label)
    return {
            size = { w = self:getCanvasRect():getWidth(), h = ControlPanel.LABEL_HEIGHT },
            padding = 1
        },
        {
            text = label,
            bgColor = PALETTE.mid,
            fgColor = PALETTE.lightest,
            align = 'center'
        }
end

function ControlPanel:getSliderConfig(val, max)
    return {
            size = { w = self:getCanvasRect():getWidth(), h = ControlPanel.SLIDER_HEIGHT }
        },
        {
            minValue = 0,
            maxValue = max or 1.5,
            currentValue = val or 0.5,
            bgColor = PALETTE.mid,
            fgColor = PALETTE.light,
            handleColor = PALETTE.lighter,
            activeColor = PALETTE.lightest
        }
end

return ControlPanel
