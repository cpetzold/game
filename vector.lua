require 'class'

Vector = class()

function Vector:init(x, y)
  self.x = x
  self.y = y
end

function Vector:toString()
  return '(' .. self.x .. ', ' .. self.y .. ')'
end

