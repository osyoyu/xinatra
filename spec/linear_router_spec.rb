# frozen_string_literal: true

require 'xinatra'

RSpec.describe Xinatra::LinearRouter do
  describe 'route matching' do
    it 'matches a route' do
      router = Xinatra::LinearRouter.new
      router.define('GET', '/hello', -> () { 'Hello' })

      matched = router.match('GET', '/hello')
      expect(matched.call).to eq('Hello')
    end

    it 'returns nil if no route is matched' do
      router = Xinatra::LinearRouter.new
      router.define('GET', '/hello', -> () { 'Hello' })

      matched = router.match('GET', '/nonexistent')
      expect(matched).to eq(nil)
    end
  end
end
