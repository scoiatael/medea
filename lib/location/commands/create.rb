# frozen_string_literal: true

class Location
  module Commands
    class Create
      class ExistingRecordNameMismatch < StandardError; end

      def call(id:, name:)
        created = false
        location = Location.find_or_create_by(id: id) do |creating|
          created = true
          creating.name = name
        end
        raise ExistingRecordNameMismatch, "existing record with id #{id} has name #{name}" unless location.name == name

        [created, location]
      end
    end
  end
end
