# frozen_string_literal: true

require 'sinatra/base'

class SinatraApp < Sinatra::Base
  get '/' do
    'hello'
  end
end
