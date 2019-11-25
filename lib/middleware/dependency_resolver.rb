# frozen_string_literal: true

require 'dry/effects'

class DependencyResolverMiddleware
  include Dry::Effects::Handler.Resolve

  def initialize(app)
    @app = app
  end

  def call(env)
    provide(::Medea::Container) { @app.call(env) }
  end

  def testing(&block)
    provide(::Medea::Container, overridable: true, &block)
  end
end
