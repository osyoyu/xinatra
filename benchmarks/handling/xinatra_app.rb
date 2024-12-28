# frozen_string_literal: true

require 'xinatra/base'

class XinatraApp < Xinatra::Base
  get '/' do
    'hello'
  end
end
