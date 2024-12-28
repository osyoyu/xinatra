# frozen_string_literal: true

module Xinatra
  class LinearRouter
    Route = Data.define(:method, :path, :handler)

    def initialize
      @routes = []
    end

    # @param method [String]
    # @param pattern [String]
    # @param handler [Proc]
    def define(method, pattern, handler)
      @routes << Route.new(method, pattern, handler)
    end

    # @param method [String]
    # @param path [String]
    # @return [Proc, nil] The registered handler for the given method and path
    def match(method, path)
      # Iterate over all registered routes
      @routes.each do |route|
        if route.method == method && route.path == path
          return route.handler
        end
      end
      nil
    end
  end
end

