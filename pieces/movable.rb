module Movable
  def add_direction(pos, direction)
    r, f = pos
    dr, df = direction
    [r + dr, f + df]
  end
end
