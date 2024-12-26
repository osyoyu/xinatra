# frozen_string_literal: true

require 'roda'

class RodaApp < Roda
  route do |r|
    r.root do
      'hello'
    end
  end
end
