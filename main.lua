--- main.lua: Flocking Simulation in LÖVE using boids. Based on a video by
-- Daniel Shiffman on the Coding Train youtube channel.
--
-- date: 23/3/2024
-- author: Abhishek Mishra

require('common')
local Boid = require('boid')
local nl = require('lib.neoluv')
local ControlPanel = require('controlpanel')
local QuadTree = require('quadtree')

local cw, ch
local top
local boidPanel
local controlPanel
local cpWidth = 180


------- Main Program -------

-- random seed
math.randomseed(os.time())

local boids
local qtree

local function initBoids()
    boids = {}
    for i = 1, 100 do
        local b = Boid(boidPanel)
        table.insert(boids, b)
    end
end

local function rebuildQuadTree()
    local w, h = cw - cpWidth, ch
    local tree = QuadTree({ w / 2, h / 2, w / 2, h / 2 })

    for _, boid in ipairs(boids) do
        tree:insert({
            x = boid.position.x,
            y = boid.position.y,
            boid = boid
        })
    end

    return tree
end

local function nearbyBoids(boid)
    local w, h = cw - cpWidth, ch
    local neighbourPoints = qtree:queryRange({
        boid.position.x,
        boid.position.y,
        w / 10,
        h / 10
    })
    local neighbourBoids = {}

    for _, p in ipairs(neighbourPoints) do
        table.insert(neighbourBoids, p.boid)
    end

    return neighbourBoids
end

--- love.load: Called once at the start of the simulation
function love.load()
    cw, ch = love.graphics.getWidth(), love.graphics.getHeight()
    top = nl.RowLayout(
        { size = { w = cw, h = ch } },
        {
            bgColor = PALETTE.darkest,
        }
    )

    boidPanel = nl.RowLayout(
        { size = { w = cw - cpWidth, h = ch } },
        {
            bgColor = PALETTE.darkest,
        }
    )
    top:addChild(boidPanel)

    controlPanel = ControlPanel(cpWidth, ch)

    top:addChild(controlPanel)

    top:show()

    initBoids()
end

--- love.update: Called every frame, updates the simulation
function love.update(dt)
    top:update(dt)

    qtree = rebuildQuadTree()

    for _, boid in ipairs(boids) do
        boid:flock(
            nearbyBoids(boid),
            controlPanel.alignmentSlider,
            controlPanel.cohesionSlider,
            controlPanel.separationSlider
        )
    end

    for _, boid in ipairs(boids) do
        boid:update(dt)
        boid:edges()
    end
end

--- love.draw: Called every frame, draws the simulation
function love.draw()
    --update fps
    controlPanel.fpsText:setText('FPS: ' .. love.timer.getFPS())

    top:draw()

    for _, boid in ipairs(boids) do
        boid:show()
    end

    -- qtree:draw()
end

-- escape to exit
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--- love.mousepressed: Called when a mouse button is pressed
function love.mousepressed(x, y, button, istouch, presses)
    top:mousepressed(x, y, button, istouch, presses)
end

--- love.mousereleased: Called when a mouse button is released
function love.mousereleased(x, y, button, istouch, presses)
    top:mousereleased(x, y, button, istouch, presses)
end

--- love.mousemoved: Called when the mouse is moved
function love.mousemoved(x, y, dx, dy, istouch)
    top:mousemoved(x, y, dx, dy, istouch)
end
