# Graph(rows, cols, origin, color, line_width = 1, z = 0)
# Vector(graph, x, y, origin_x = 0, origin_y = 0, color, line_width = 2, z = 1)
# GraphLine(graph, x1, y1, x2, y2, color, line_width = 2, z = 1) # this will be the line defined by these two vectors goes into infinity
# Screenshot(path = nil)

module Geometry
  class Graph
  end

  class Vector
  end

  class GraphLine
  end

  # rubocop:disable Naming/MethodName
  def self.Screenshot(path = nil)
    Window.screenshot(path)
  end
  # rubocop:enable Naming/MethodName
end
