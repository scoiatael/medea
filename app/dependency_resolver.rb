# frozen_string_literal: true

require 'dry/effects'

module DependencyResolver
  extend Dry::Effects::Handler.Resolve

  def self.around(&block)
    provide(::Medea::Container, &block)
  end

  def self.testing(&block)
    provide(::Medea::Container, overridable: true, &block)
  end
end
