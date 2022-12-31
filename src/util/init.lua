---@class point
---@field x number
---@field y number
local point = {}
function point:new(x, y)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    return o
end

---@param v vector
---@return point
function point:add(v)
    return point:new(self.x + v.dx, self.y + v.dy)
end

---@param v vector
---@return point
function point:subtract(v)
    return point:new(self.x - v.dx, self.y - v.dy)
end

---@class vector
---@field dx number
---@field dy number
---@field length number
local vector = {}

---@param dx number
---@param dy number
---@return vector
function vector:new(dx, dy)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.dx = dx
    o.dy = dy
    o.length = math.sqrt(vector.dot(o, o))
    return o
end

---@param p point
---@param q point
---@return vector
function vector:from_points(p, q)
    return vector:new(q.x - p.x, q.y - p.y)
end

---@param q vector
---@return number
function vector:dot(q)
    return (self.dx * q.dx) + (self.dy * q.dy)
end

---@param q vector
---@return number
function vector:cross(q)
    return (self.dx * q.dy) - (self.dy * q.dx)
end

---@return vector?
function vector:normalized()
    if self.length ~= 0 then
        return vector:new(self.dx / self.length, self.dy / self.length)
    end

    return self
end

---@param q vector
---@return vector
function vector:add(q)
    return vector:new(self.dx + q.dx, self.dy + q.dy)
end


---@param q vector
---@return vector
function vector:subtract(q)
    return vector:new(self.dx - q.dx, self.dy - q.dy)
end

---@param scalar number
---@return vector
function vector:multiply(scalar)
    return vector:new(self.dx * scalar, self.dy * scalar)
end

return {vector = vector, point = point}