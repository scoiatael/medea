# frozen_string_literal: true

module Areas
  module Queries
    class Contain
      def call(areas, point)
        areas.any? { |a| a.geometry.contains?(point) }
      end
    end
  end
end
