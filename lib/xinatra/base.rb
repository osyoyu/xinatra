# frozen_string_literal: true

require 'rack'

require_relative 'linear_router'

module Xinatra
  class Base
    @@router = LinearRouter.new
    @@error_handler = nil

    class << self
      def get(path, &block)
        method_name = build_ruby_method_name("GET", path)
        define_method(method_name, &block)
        @@router.define("GET", path, method_name)
      end

      def post(path, &block)
        method_name = build_ruby_method_name("POST", path)
        define_method(method_name, &block)
        @@router.define("POST", path, method_name)
      end

      def put(path, &block)
        method_name = build_ruby_method_name("PUT", path)
        define_method(method_name, &block)
        @@router.define("PUT", path, method_name)
      end

      def patch(path, &block)
        method_name = build_ruby_method_name("PATCH", path)
        define_method(method_name, &block)
        @@router.define("PATCH", path, method_name)
      end

      def delete(path, &block)
        method_name = build_ruby_method_name("DELETE", path)
        define_method(method_name, &block)
        @@router.define("DELETE", path, method_name)
      end

      def options(path, &block)
        method_name = build_ruby_method_name("OPTIONS", path)
        define_method(method_name, &block)
        @@router.define("OPTIONS", path, method_name)
      end

      def before(&block)
        define_method(:__before, &block)
      end

      def after(&block)
        define_method(:__after, &block)
      end

      def set(a = nil, b = nil, c = nil, d = nil)
        # no-op
      end

      def enable(a = nil, b = nil, c = nil, d = nil)
        # no-op
      end

      def disable(a = nil, b = nil, c = nil, d = nil)
        # no-op
      end

      def error(klass = nil, &block)
        @@error_handler = block
      end

      # for testing
      def reset
        @@router = LinearRouter.new
        define_method(:__before, -> {})
        define_method(:__after, -> {})
      end

      private

      def build_ruby_method_name(http_method, path)
        "__handle___#{http_method.downcase}___#{path.gsub('/', '__')}"
      end
    end

    def initialize
      @router = @@router
      @error_handler = @@error_handler
      @error_handled = false
      @error_ret = nil
    end

    def call(env)
      @request = ::Rack::Request.new(env)
      @status = nil

      __before
      if handler_method_name = @router.match(env['REQUEST_METHOD'], env['PATH_INFO'])
        retstr = self.send(handler_method_name)

        if @error_ret
          return [@status || 500, { 'Content-Type' => 'application/json' },  @error_ret]
        else
          ret = [@status || 200, { 'Content-Type' => 'application/json' }, [retstr]]
        end
      else
        ret = [@status || 404, { 'Content-Type' => 'application/json' }, ['']]
      end
      __after
      ret
    end

    def request
      @request
    end

    def status(code)
      @status = code
    end

    def error
      @error_ret = self.instance_eval(&@error_handler)
      @error_handled = true
    end

    def __before
      # no-op; could be overridden via `before` DSL
    end

    def __after
      # no-op; could be overridden via `after` DSL
    end
  end
end
