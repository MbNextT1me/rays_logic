Ray = {}
Ray.__index = Ray

function Ray:create(origin)
    local ray = {}

    setmetatable(ray, Ray)

    ray.origin = origin
    ray.to = origin

    ray.intersections = {}
    ray.closest = nil
    
    return ray
end

function Ray:castTo(to, obstacles)

    self.to = to

    local intersects = {}
    local closest = {}

    self.closest = nil

    local nearestObstacle = nil

    for i=1, #obstacles do

        local segments = obstacles[i]:getSegments()
        for j=1, #segments do

            local intersect = self:intersection(segments[j])
            if (intersect ~= nil) then

                table.insert(intersects, intersect)
                if (self.closest  == nil) then

                    self.closest = intersect
                    if nearestObstacle == nil then
                        nearestObstacle = obstacles[i]
                    end

                else
                    if (intersect.t1 < self.closest.t1) then
                        self.closest = intersect
                        nearestObstacle = obstacles[i]
                    end
                end
            end
        end
    end
    self.intersections = intersects
    if nearestObstacle ~= nil then 

        nearestObstacle:setVisible()
    end
end

function Ray:draw()

    r, g, b, a = love.graphics.getColor()

    love.graphics.setColor(0 / 255, 0 / 255, 255 / 255, 1)

    love.graphics.line(self.origin[1], self.origin[2], self.to[1], self.to[2])

    love.graphics.setColor(r, g, b, a)

    if (self.closest ~= nil) then 
        
        love.graphics.line(self.origin[1], self.origin[2], self.closest.x, self.closest.y)
    end
end

function Ray:intersection(segment)

    local rpx = self.origin[1]
    local rpy = self.origin[2]
    local rdx = self.to[1] - rpx
    local rdy = self.to[2] - rpy

    local spx = segment[1][1]
    local spy = segment[1][2]
    local sdx = segment[2][1] - spx
    local sdy = segment[2][2] - spy

    local rmag = math.sqrt(rdx * rdx + rdy * rdy)
    local smag = math.sqrt(sdx * sdx + sdy * sdy)

    if ((rdx / rmag == sdx/smag) and (rdy / rmag == sdy / smag)) then
        return nil
    end

    local t2 = (rdx * (spy - rpy) + rdy * (rpx - spx)) / (sdx * rdy - sdy * rdx)
    local t1 = (spx + sdx * t2 - rpx) / rdx

    if (t1 < 0) then
        return nil
    end
    if (t2 < 0 or t2 > 1) then
        return nil
    end

    local x = rpx + rdx * t1
    local y = rpy + rdy * t1

    return {x = x, y = y, t1 = t1}
end