# frozen_string_literal: true

module Xinatra
  class Base
    def call(env)
      if env['REQUEST_METHOD'] == 'GET' && env['PATH_INFO'] == '/'
        [200, { 'Content-Type' => 'text/plain' }, ['hello']]
      else
        [404, { 'Content-Type' => 'text/plain' }, ['']]
      end
    end
  end
end
