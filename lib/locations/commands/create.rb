# frozen_string_literal: true

module Locations
  module Commands
    class Create
      class ExistingRecordNameMismatch < StandardError; end
      class IDNotUUID < StandardError; end

      def call(id:, name:)
        # UUID regex src: https://github.com/assaf/uuid/blob/0b22c7d/lib/uuid.rb#L202
        raise IDNotUUID, "#{id} is not in UUID format" unless id =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i

        created = false
        location = Location.find_or_create_by(id: id) do |creating|
          created = true
          creating.name = name
        end
        LocationGeocodingJob.perform_later(location) if created
        raise ExistingRecordNameMismatch, "existing record with id #{id} has name #{name}" unless location.name == name

        [created, location]
      end
    end
  end
end
