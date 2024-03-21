# Vector(graph, x, y, tail_x = 0, tail_y = 0, color, line_width = 2, z = 1)
# GraphLine(graph, x1, y1, x2, y2, color, line_width = 2, z = 1) # this will be the line defined by these two vectors goes into infinity
# Screenshot(path = nil)
module Geometry
  include ExtendedShapes
  class Graph
    attr_reader :rows, :cols, :type, :origin, :color, :line_width, :z, :box_height, :box_width

    def initialize(rows, cols, type = :lines, origin = :bottom_left, line_color = "black", line_width = 1, z = 0,
                   window = Window)
      unless %i[bottom_left top_left top_right bottom_right center].include? origin
        raise "Invalid origin. Must be one of :bottom_left, :top_left, :top_right, :bottom_right, :center."
      end

      raise "Invalid type. Must be one of :lines, :dots." unless %i[lines dots].include? type

      @rows = rows
      @cols = cols
      @type = type
      @origin = origin
      @line_color = color
      @line_width = line_width
      @z = z
      @box_height = window.height / rows
      puts window.height
      puts rows
      @box_width = window.width / cols
      draw
    end

    def draw
      if type == :lines
        draw_lines
      else
        draw_dots
      end
      draw_origin
    end

    def draw_origin
      Circle.new(
        x: origin_coordinates[0],
        y: origin_coordinates[1],
        radius: 5,
        sectors: 32,
        color: "red",
        z: z
      )
    end

    def draw_lines
      # add 2 to account for edges
      (rows + 2).times do |row|
        y = row * box_height
        Line.new(
          x1: 0, y1: y,
          x2: Window.width, y2: y,
          width: line_width,
          color: @line_color,
          z: z
        )
      end
      (cols + 2).times do |col|
        x = col * box_width
        Line.new(
          x1: x, y1: 0,
          x2: x, y2: Window.height,
          width: line_width,
          color: @line_color,
          z: z
        )
      end
    end

    def draw_dots
      (rows + 2).times do |row|
        (cols + 2).times do |col|
          x = col * box_width
          y = row * box_height
          Square.new(
            x: x,
            y: y,
            size: 5,
            color: @line_color,
            z: z
          )
        end
      end
    end

    def origin_coordinates
      @origin_coordinates ||= calculate_origin_coordinates
    end

    private

    def calculate_origin_coordinates
      case origin
      when :bottom_left
        [0, window.height]
      when :top_left
        [0, 0]
      when :top_right
        [window.width, 0]
      when :bottom_right
        [window.width, window.height]
      when :center
        half_rows = (rows / 2.0).ceil
        half_cols = (cols / 2.0).ceil
        [half_cols * box_width, half_rows * box_height]
      end
    end
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
