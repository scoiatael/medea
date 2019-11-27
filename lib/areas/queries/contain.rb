# frozen_string_literal: true

module Areas
  module Queries
    class Contain
      class UnsupportedType < StandardError; end

      def call(areas, point)
        areas.any? { |a| contains?(a.geometry, point) }
      end

      private

      def contains?(geometry, point)
        ghash = RGeo::GeoJSON.encode(geometry)
        gtype = ghash['type']
        raise UnsupportedType, "Only Polygon geometries are supported, got type #{gtype}" unless gtype == 'Polygon'

        phash = RGeo::GeoJSON.encode(point)
        ptype = phash['type']
        raise UnsupportedType, "Only Point types are supported, got type #{ptype}" unless ptype == 'Point'

        polygon_contains?(ghash['coordinates'].first, phash['coordinates'])
      end

      def polygon_contains?(coordinates, point)
        coordinates += [coordinates[0]] unless coordinates[-1] == coordinates[0]

        # For point to be inside, horizontal ray from point to right must cross odd number of vertices
        vertices(coordinates).filter(&ray_horizontally_crosses(point)).count.odd?
      end

      def ray_horizontally_crosses(point)
        lambda do |(from, to)|
          # Ensure from, to vector is "upwards"
          from, to = from.last > to.last ? [to, from] : [from, to]
          # Then ray crosses iff horizontal bounds overlap point AND point is to the left of from, to vector
          overlapping(point, [from, to]) && cross(vec(from, to), vec(from, point)).positive?
        end
      end

      def overlapping((_, py), ((_, sy), (_, ey)))
        (sy <= py && py <= ey)
      end

      def vertices(coords)
        coords[0...-1].zip(coords[1..])
      end

      def vec((ax, ay), (bx, by))
        [(bx - ax), (by - ay)]
      end

      def cross((ax, ay), (bx, by))
        ax * by - ay * bx
      end
    end
  end
end
