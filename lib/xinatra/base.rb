# frozen_string_literal: true

module Xinatra
  class Base
    @@routes = {}

    class << self
      def get(path, &block)
        @@routes[path] = block
      end
    end

    def initialize
      @routes = @@routes
    end

    def call(env)
      if env['REQUEST_METHOD'] == 'GET' && handler = @routes[env['PATH_INFO']]
        retstr = handler.call
        [200, { 'Content-Type' => 'text/plain' }, [retstr]]
      else
        [404, { 'Content-Type' => 'text/plain' }, ['']]
      end
    end
  end
end
