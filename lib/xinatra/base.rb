# frozen_string_literal: true

require_relative 'linear_router'

module Xinatra
  class Base
    @@router = LinearRouter.new
    @@before_actions = []
    @@after_actions = []

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
        name = "before_#{@@before_actions.size}"
        define_method(name, &block)
        @@before_actions << name
      end

      def after(&block)
        name = "after_#{@@after_actions.size}"
        define_method(name, &block)
        @@after_actions << name
      end

      # for testing
      def reset
        @@router = LinearRouter.new
        @@before_actions = []
        @@after_actions = []
      end
    end

    def initialize
      @router = @@router
      @before_actions = @@before_actions
      @after_actions = @@after_actions
    end

    def call(env)
      @before_actions.each { |action| self.send(action) }
      if handler = @router.match(env['REQUEST_METHOD'], env['PATH_INFO'])
        retstr = handler.call
        ret = [200, { 'Content-Type' => 'text/plain' }, [retstr]]
      else
        ret = [404, { 'Content-Type' => 'text/plain' }, ['']]
      end
      @after_actions.each { |action| self.send(action) }
      ret
    end
  end
end
