# frozen_string_literal: true

require 'xinatra'

RSpec.describe Xinatra::TrieRouter do
  describe 'route matching' do
    it 'matches a route' do
      router = Xinatra::TrieRouter.new
      router.define('GET', '/hello', -> () { 'Hello' })

      matched = router.match('GET', '/hello')
      expect(matched.call).to eq('Hello')
    end

    it 'returns nil if no route is matched' do
      router = Xinatra::TrieRouter.new
      router.define('GET', '/hello', -> () { 'Hello' })

      matched = router.match('GET', '/nonexistent')
      expect(matched).to eq(nil)
    end
  end
end
