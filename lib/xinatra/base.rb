# frozen_string_literal: true

require_relative 'linear_router'

module Xinatra
  class Base
    @@router = LinearRouter.new

    class << self
      def get(path, &block)
        @@router.define("GET", path, block)
      end

      def post(path, &block)
        @@router.define("POST", path, block)
      end

      def put(path, &block)
        @@router.define("PUT", path, block)
      end

      def patch(path, &block)
        @@router.define("PATCH", path, block)
      end

      def delete(path, &block)
        @@router.define("DELETE", path, block)
      end

      def options(path, &block)
        @@router.define("OPTIONS", path, block)
      end

      def before(&block)
        define_method(:__before, &block)
      end

      def after(&block)
        define_method(:__after, &block)
      end

      # for testing
      def reset
        @@router = LinearRouter.new
        define_method(:__before, -> {})
        define_method(:__after, -> {})
      end
    end

    def initialize
      @router = @@router
    end

    def call(env)
      __before
      if handler = @router.match(env['REQUEST_METHOD'], env['PATH_INFO'])
        retstr = handler.call
        ret = [200, { 'Content-Type' => 'text/plain' }, [retstr]]
      else
        ret = [404, { 'Content-Type' => 'text/plain' }, ['']]
      end
      __after
      ret
    end

    def __before
      # no-op; could be overridden via `before` DSL
    end

    def __after
      # no-op; could be overridden via `after` DSL
    end
  end
end
