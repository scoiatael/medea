# frozen_string_literal: true

require 'dry/system/rails'

Dry::System::Rails.container do
  # you can set it to whatever you want and add as many dirs you want
  config.auto_register << 'lib'
end
