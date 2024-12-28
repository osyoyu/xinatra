# frozen_string_literal: true

require 'mustermann'

# A linear router built on top of Mustermann (https://github.com/sinatra/mustermann).
# The API should be similar to Xinatra::LinearRouter.
class MustermannRouter
  Route = Data.define(:method, :path, :handler)

  def initialize
    @routes = []
  end

  def define(method, path, handler)
    @routes << Route.new(method:, path: Mustermann.new(path), handler: handler)
  end

  def match(method, path)
    @routes.each do |route|
      if route.method == method && route.path === path
        return route.handler
      end
    end
    nil
  end
end

if __FILE__ == $0
  r = MustermannRouter.new
  r.define("GET", "/hoge", -> () { "hoge" })
  r.define("GET", "/hoge/fuga", -> () { "fuga" })
  r.define("GET", "/piyo", -> () { "hoge" })

  p r.match("GET", "/hoge")
  p r.match("GET", "/hoge/fuga")
  p r.match("GET", "/piyo")
  p r.match("GET", "/hoge/fuga/piyo")

  # Expected Output:
  # (proc)
  # (proc)
  # (proc)
  # nil
end
