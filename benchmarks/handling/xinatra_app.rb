# frozen_string_literal: true

require 'xinatra/base'

class XinatraApp < Xinatra::Base
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
