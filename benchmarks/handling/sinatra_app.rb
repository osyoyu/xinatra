# frozen_string_literal: true

require 'sinatra/base'

class SinatraApp < Sinatra::Base
  before do
    # nop
  end

  after do
    # nop
  end

  get '/' do
    'hello'
  end
end
