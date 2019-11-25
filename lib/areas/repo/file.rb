# frozen_string_literal: true

require 'rgeo/geo_json'

module Areas
  module Repo
    class File
      AREAS = "#{::Rails.root}/db/areas.json"

      def all
        RGeo::GeoJSON.decode(::File.read(AREAS))
      end
    end
  end
end
