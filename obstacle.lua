Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:create(points)
    local obstacle = {}
    setmetatable(obstacle, Obstacle)
    obstacle.points = points
    obstacle.isVisible = false
    return obstacle
end

function Obstacle:getSegments()
    local segments = {}
    for i=2, #self.points do
        p1 = self.points[i-1]
        p2 = self.points[i]
        table.insert(segments, {p1, p2})
    end
    return segments
end

function Obstacle:draw()
    local r, g, b, a = love.graphics.getColor()

    if self.isVisible then
        love.graphics.setColor(0, 0, 1)
    else
        love.graphics.setColor(1, 1, 1)
    end

    local originalLineWidth = love.graphics.getLineWidth()
    local newLineWidth = 4
    love.graphics.setLineWidth(newLineWidth)

    for i = 2, #self.points do
        local p1 = self.points[i-1]
        local p2 = self.points[i]
        love.graphics.line(p1[1], p1[2], p2[1], p2[2])
    end

    love.graphics.setLineWidth(originalLineWidth)
    love.graphics.setColor(r, g, b, a)
end


function Obstacle:setVisible()

    self.isVisible = true
end

function Obstacle:resetVisible()

    self.isVisible = false
end