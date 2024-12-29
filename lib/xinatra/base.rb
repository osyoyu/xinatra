# frozen_string_literal: true

require_relative 'linear_router'

module Xinatra
  class Base
    @@router = LinearRouter.new
    @@before_actions = []

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
        @@before_actions << block
      end

      # for testing
      def reset
        @@router = LinearRouter.new
        @@before_actions = []
      end
    end

    def initialize
      @router = @@router
      @before_actions = @@before_actions
    end

    def call(env)
      @before_actions.each { |action| self.instance_eval(&action) }

      if handler = @router.match(env['REQUEST_METHOD'], env['PATH_INFO'])
        retstr = handler.call
        [200, { 'Content-Type' => 'text/plain' }, [retstr]]
      else
        [404, { 'Content-Type' => 'text/plain' }, ['']]
      end
    end
  end
end
