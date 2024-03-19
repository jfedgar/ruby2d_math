module ExtendedShapes
  class Grid
    attr_reader :rows, :cols, :color, :window, :box_height, :box_width

    def initialize(rows, cols, color, ruby2d_window = Window)
      @rows = rows
      @cols = cols
      @color = color
      @window = ruby2d_window
      @box_height = window.height / rows
      @box_width = window.width / cols
      draw
    end

    def draw
      draw_rows
      draw_cols
    end

    def draw_rows
      rows.times do |row|
        height = row * box_height
        Line.new(
          x1: 0, y1: height,
          x2: Window.width, y2: height,
          width: 1,
          color: color,
          z: 0
        )
      end
    end

    def draw_cols
      cols.times do |col|
        width = col * box_width
        Line.new(
          x1: width, y1: 0,
          x2: width, y2: Window.height,
          width: 1,
          color: "lime",
          z: 0
        )
      end
    end
  end

  class Arrow
    attr_reader :origin, :finish, :color, :line_width, :z, :arrowhead_length,
                :dx, :dy

    def initialize(origin, finish, color, line_width, z, arrowhead_length = 10)
      @origin = origin
      @finish = finish
      @color = color
      @line_width = line_width
      @z = z
      @arrowhead_length = arrowhead_length
      draw
    end

    def draw
      calculate_directions
      draw_shaft
      draw_arrowhead
    end

    private

    # calculates the direction in x and y
    def draw_shaft
      # Draw the arrow's shaft
      Line.new(
        x1: origin[0], y1: origin[1],
        x2: finish[0], y2: finish[1],
        width: line_width,
        color: color,
        z: z
      )
    end

    def draw_arrowhead
      left_x = finish[0] + arrowhead_length * (-dx - dy)
      left_y = finish[1] + arrowhead_length * (-dy + dx)
      right_x = finish[0] + arrowhead_length * (-dx + dy)
      right_y = finish[1] + arrowhead_length * (-dy - dx)

      # the first point is the tip of the triangle, pushed line_width in the direction of the arrow
      Triangle.new(
        x1: finish[0] + (line_width * dx), y1: finish[1] + (line_width * dy),
        x2: left_x, y2: left_y,
        x3: right_x, y3: right_y,
        color: "red",
        z: z
      )
    end

    # Calculate direction of the line
    def calculate_directions
      @dx = finish[0] - origin[0]
      @dy = finish[1] - origin[1]

      # # Normalize direction vector
      # after normalization, dx^2 + dy^2 = 1 (always)
      # [dx, dy] is a unit vector (same direction as original vectorl but with length 1)
      # Normalization ensures that the arrowhead is always the same length, regardles
      #   of the length of the original vector
      # Normalization of a vector into a unit vector involves dividing each component
      # of the vector by the magnitude (length) of the vector
      # Normalization is often used when you want the direction of a vector, but not the magnitude

      @dx /= shaft_length
      @dy /= shaft_length
    end

    def shaft_length
      @shaft_length ||= Math.sqrt(dx**2 + dy**2)
    end
  end

  class RotatableRectangle
    attr_reader :x, :y, :width, :height, :color, :line_width, :z, :degrees

    def initialize(x, y, width, height, color, line_width, z, degrees)
      @x = x
      @y = y
      @width = width
      @height = height
      @color = color
      @line_width = line_width
      @z = z
      @degrees = degrees
      draw
    end

    def draw
      # Draw lines between the corners
      rotated_corners.each_cons(2) do |(x1, y1), (x2, y2)|
        Line.new(
          x1: x1, y1: y1,
          x2: x2, y2: y2,
          width: line_width,
          color: color,
          z: z
        )
      end
    end

    def rotated_corners
      corners.map do |cx, cy|
        rotation_equation(cx, cy)
      end
    end

    # derived from the standard trig rotation equation to rotate a point around the origin:
    # x' = x * cos(θ) - y * sin(θ)
    # y' = x * sin(θ) + y * cos(θ)
    def rotation_equation(corner_x, corner_y)
      radians = degrees_to_radians(degrees)
      [
        x + (corner_x * Math.cos(radians) - corner_y * Math.sin(radians)),
        y + (corner_x * Math.sin(radians) + corner_y * Math.cos(radians))
      ]
    end

    def corners
      # Calculate the half-width and half-height
      hw = width / 2.0
      hh = height / 2.0

      hwl = line_width / 2.0

      # First calculate the corners  (as an offset of the center) of the rectangle in
      # a non-rotated form.
      # We also add line_width / 2 to the endpoint of each line
      # This is to account for the fact that the line is drawn to and from single point
      # This point is always the center point of the start of the next line.
      # when the line_width is greater than 1 it would otherwise leave
      # a gap at the end of exactly one half the line_width.
      [
        [-hw, -hh], # Top left (start point of line)
        [hw + hwl, -hh], # Top right (end point of line)
        [hw, -hh], # Top right (start point of line)
        [hw, hh + hwl], # Bottom right (end point of line)
        [hw, hh], # Bottom right (start point of line)
        [-hw - hwl, hh], # Bottom left (end point of line)
        [-hw, hh], # Bottom left (start point of line)
        [-hw, -hh - hwl] # Top left (end point, close the loop to the beginning)
      ]
    end

    private

    # Converts degrees to radians
    def degrees_to_radians(degrees)
      degrees * Math::PI / 180.0
    end
  end
end
