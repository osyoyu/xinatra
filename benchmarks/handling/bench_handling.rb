# frozen_string_literal: true

require 'benchmark/ips'

require_relative './xinatra_app'
require_relative './sinatra_app'
require_relative './roda_app'

xinatra = XinatraApp.new
roda = RodaApp.freeze.app
sinatra = SinatraApp.new

Benchmark.ips do |x|
  x.config(warmup: 0, time: 2)

  x.report('xinatra') {
    reqenv = Rack::Request.new({'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET'}).env
    xinatra.call(reqenv)
  }

  x.report('sinatra') {
    reqenv = Rack::Request.new({'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET'}).env
    sinatra.call(reqenv)
  }

  x.report('roda') {
    reqenv = Rack::Request.new({'PATH_INFO' => '/', 'REQUEST_METHOD' => 'GET'}).env
    roda.call(reqenv)
  }

  x.compare!
end
