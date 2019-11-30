# frozen_string_literal: true

require_relative '../dependency_resolver'

class DependencyResolverMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    DependencyResolver.around { @app.call(env) }
  end
end
