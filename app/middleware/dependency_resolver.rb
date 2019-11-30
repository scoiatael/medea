# frozen_string_literal: true

require_relative '../dependency_resolver'

class DependencyResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    DependencyResolver.provide { @app.call(env) }
  end
end
