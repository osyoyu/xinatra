# frozen_string_literal: true

require 'xinatra'
require 'rack'

def build_rack_request(method, path)
  Rack::Request.new({'REQUEST_METHOD' => method, 'PATH_INFO' => path})
end

RSpec.describe Xinatra::Base do
  before { class App < Xinatra::Base; end }
  after { App.reset; Object.send(:remove_const, :App) }

  it 'returns a 200' do
    App.class_eval do
      get '/hello' do
        'Hello, world!'
      end
    end

    req = App.new.call(build_rack_request('GET', '/hello').env)
    expect(req[0]).to eq(200)
    expect(req[2]).to eq(['Hello, world!'])
  end

  it 'returns a 404 when requested a non-existent path' do
    req = App.new.call(build_rack_request('GET', '/hello').env)
    expect(req[0]).to eq(404)
  end
end
