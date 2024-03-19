# frozen_string_literal: true

require "ruby2d"
require_relative "ruby2d_math/version"
require_relative "ruby2d_math/extended_shapes"
require_relative "ruby2d_math/geometry"

module Ruby2dMath
  class Error < StandardError; end
end

# set title: 'Test extended shapes'

include ExtendedShapes
include Geometry
