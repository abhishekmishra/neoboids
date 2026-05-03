local nl = require('lib.neoluv')
local Class = require('lib.neoluv.middleclass')

local AABB = Class('AABB')

--- Axis-aligned bounding box with half dimension and center
function AABB:initialize(x, y, hw, hh)
    self.x = x or 0
    self.y = y or 0
    self.hw = hw or 10
    self.hh = hh or self.hw
end

function AABB:containsPoint(x, y)
    if x >= self.x - self.hw and x <= self.x + self.hw and
        y >= self.y - self.hh and y <= self.y + self.hh then
        return true
    end
    return false
end

function AABB:intersectsAABB(other)
    return ((self.x - self.hw) <= (other.x + other.hw))
        and ((self.x + self.hw) >= (other.x - other.hw))
        and ((self.y - self.hh) <= (other.y + other.hh))
        and ((self.y + self.hh) >= (other.y - other.hh))
end

local QuadTree = Class('QuadTree')

function QuadTree:initialize(boundary, capacity, depth, maxDepth)
    if boundary and not boundary.class then
        boundary = AABB(unpack(boundary))
    end
    self.boundary = boundary
    self.capacity = capacity or 4
    self.depth = depth or 0
    self.maxDepth = maxDepth or 10
    self.points = {}

    -- children
    self.nw = nil
    self.ne = nil
    self.se = nil
    self.sw = nil
end

-- Insert a point into the QuadTree
function QuadTree:insert(p)
    -- Ignore objects that do not belong in this quad tree
    if (not self.boundary:containsPoint(p.x, p.y)) then
        return false -- object cannot be added
    end

    -- If this is a leaf with space, add the object here.
    if (#self.points < self.capacity and self.nw == nil) then
        table.insert(self.points, p)
        return true
    end

    -- Keep overflow points at the deepest leaf instead of subdividing forever.
    if self.depth >= self.maxDepth then
        table.insert(self.points, p)
        return true
    end

    -- Otherwise, subdivide and then add the point to whichever node will accept it
    if (self.nw == nil) then
        self:subdivide()
    end

    if (self.nw:insert(p)) then return true end
    if (self.ne:insert(p)) then return true end
    if (self.se:insert(p)) then return true end
    if (self.sw:insert(p)) then return true end

    -- Otherwise, the point cannot be inserted for some unknown reason (this should never happen)
    return false
end

function QuadTree:subdivide()
    -- quarter dimensions
    local qh = self.boundary.hh / 2
    local qw = self.boundary.hw / 2
    local x = self.boundary.x
    local y = self.boundary.y
    local childDepth = self.depth + 1
    self.nw = QuadTree(AABB(x - qw, y - qh, qw, qh), self.capacity, childDepth, self.maxDepth)
    self.ne = QuadTree(AABB(x + qw, y - qh, qw, qh), self.capacity, childDepth, self.maxDepth)
    self.se = QuadTree(AABB(x + qw, y + qh, qw, qh), self.capacity, childDepth, self.maxDepth)
    self.sw = QuadTree(AABB(x - qw, y + qh, qw, qh), self.capacity, childDepth, self.maxDepth)

    local points = self.points
    self.points = {}

    for _, p in ipairs(points) do
        self:insert(p)
    end
end

-- Find all points that appear within a range
function QuadTree:queryRange(range)
    if range and not range.class then
        range = AABB(unpack(range))
    end
    -- Prepare an array of results
    local pointsInRange = {}

    -- Automatically abort if the range does not intersect this quad
    if (not self.boundary:intersectsAABB(range)) then
        return pointsInRange -- empty list
    end
    -- Check objects at this quad level
    for k, p in ipairs(self.points) do
        if (range:containsPoint(p.x, p.y)) then
            table.insert(pointsInRange, p)
        end
    end

    -- Terminate here, if there are no children
    if (self.nw == nil) then
        return pointsInRange
    end
    -- Otherwise, add the points from the children
    for _, p in ipairs(self.nw:queryRange(range)) do
        table.insert(pointsInRange, p)
    end
    for _, p in ipairs(self.ne:queryRange(range)) do
        table.insert(pointsInRange, p)
    end
    for _, p in ipairs(self.se:queryRange(range)) do
        table.insert(pointsInRange, p)
    end
    for _, p in ipairs(self.sw:queryRange(range)) do
        table.insert(pointsInRange, p)
    end

    return pointsInRange
end

function QuadTree:draw()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle('line', self.boundary.x - self.boundary.hw, self.boundary.y - self.boundary.hh,
        2 * self.boundary.hw, 2 * self.boundary.hh)
    if self.nw ~= nil then
        self.nw:draw()
        self.ne:draw()
        self.se:draw()
        self.sw:draw()
    end
end

return QuadTree
