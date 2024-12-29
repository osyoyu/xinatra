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

  describe 'HTTP methods' do
    it 'responds to GET' do
      App.class_eval do
        get '/hello' do
          'Hello, world!'
        end
      end

      req = App.new.call(build_rack_request('GET', '/hello').env)
      expect(req[0]).to eq(200)
      expect(req[2]).to eq(['Hello, world!'])
    end

    it 'responds to POST' do
      App.class_eval do
        post '/hello' do
          'Hello, world!'
        end
      end

      req = App.new.call(build_rack_request('POST', '/hello').env)
      expect(req[0]).to eq(200)
      expect(req[2]).to eq(['Hello, world!'])
    end

    it 'responds to PUT' do
      App.class_eval do
        put '/hello' do
          'Hello, world!'
        end
      end

      req = App.new.call(build_rack_request('PUT', '/hello').env)
      expect(req[0]).to eq(200)
      expect(req[2]).to eq(['Hello, world!'])
    end

    it 'responds to PATCH' do
      App.class_eval do
        patch '/hello' do
          'Hello, world!'
        end
      end

      req = App.new.call(build_rack_request('PATCH', '/hello').env)
      expect(req[0]).to eq(200)
      expect(req[2]).to eq(['Hello, world!'])
    end

    it 'responds to DELETE' do
      App.class_eval do
        delete '/hello' do
          'Hello, world!'
        end
      end

      req = App.new.call(build_rack_request('DELETE', '/hello').env)
      expect(req[0]).to eq(200)
      expect(req[2]).to eq(['Hello, world!'])
    end

    it 'responds to OPTIONS' do
      App.class_eval do
        options '/hello' do
          'Hello, world!'
        end
      end

      req = App.new.call(build_rack_request('OPTIONS', '/hello').env)
      expect(req[0]).to eq(200)
      expect(req[2]).to eq(['Hello, world!'])
    end
  end
end
