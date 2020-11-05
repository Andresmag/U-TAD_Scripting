-- Clase Vector
Vector = {}
-- Constructor
function Vector:new(x, y)
    local vector = { x=x, y=y }
    setmetatable(vector, self)
    self.__index = self
    return vector
end

-- Add
function Vector.__add(vector, other_vector)
    return Vector:new(vector.x + other_vector.x, vector.y + other_vector.y)
end

-- Sub
function Vector.__sub(vector, other_vector)
    return Vector:new(vector.x - other_vector.x, vector.y - other_vector.y)
end

-- Div
function Vector.__div(vector, value)
    return Vector:new(vector.x/value, vector.y/value)
end

-- Mul
function Vector.__mul(vector, value)
    return Vector:new(vector.x * value, vector.y * value)
end

-- Dot
function Vector:dot(other_vector)
    return self.x * other_vector.x + self.y * other_vector.y
end

-- Length
function Vector:length()
    return math.sqrt(self.x^2 + self.y^2)
end

-- Norm
function Vector:norm()
    local length = self:length()
    if length ~= 0 then
        self = self / length
    end
    return self
end

-- To String
function Vector:__tostring()
    return "x = "..self.x..", y = "..self.y
end
-- Fin Clase Vector


vector1 = Vector:new(3, 5)
vector2 = Vector:new(1, 2)

print(vector1)
print(vector2)

vector3 = vector1 + vector2
print("Vector1 + vector2: "..vector3:__tostring())

vector4 = vector1 - vector2
print("Vector1 - vector2: "..vector4:__tostring())

vector5 = vector1:dot(vector2)
print("Dot product v1 and v2 = "..vector5)

vector1_length = vector1:length()
print("Vector 1 length = "..vector1_length)

vector1_norm = vector1:norm()
print("Vector1 norm: "..vector1_norm:__tostring())

vector6 = vector1 * 2
print("Vector1 * 2: "..vector6:__tostring())

-- Stop
io.read()
