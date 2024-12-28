# frozen_string_literal: true

require 'benchmark/ips'
require 'json'

require 'xinatra'
require_relative './mustermann_router'

puts "=== 3 routes ==="

routes = [
  { method: 'GET', path: '/foo' },
  { method: 'GET', path: '/foo/bar' },
  { method: 'GET', path: '/baz' },
]

trie = Xinatra::TrieRouter.new
routes.each do |route|
  trie.define(route[:method], route[:path], -> () { 'hello' })
end

linear = Xinatra::LinearRouter.new
routes.each do |route|
  linear.define(route[:method], route[:path], -> () { 'hello' })
end

mustermann = MustermannRouter.new
routes.each do |route|
  mustermann.define(route[:method], route[:path], -> () { 'hello' })
end

Benchmark.ips do |x|
  x.config(warmup: 0, time: 2)

  x.report('trie') {
    trie.match("GET", "/hoge")
  }

  x.report('linear') {
    linear.match("GET", "/hoge")
  }

  x.report('mustermann') {
    mustermann.match("GET", "/hoge")
  }

  x.compare!
end

# ======================================================================

puts "=== 228 routes (lobste.rs) ==="

lobsters_routes = File.read(File.expand_path('../lobsters_routes.jsonl', __FILE__)).split("\n").map { |line| JSON.parse(line, symbolize_names: true) }

trie = Xinatra::TrieRouter.new
lobsters_routes.each do |route|
  trie.define(route[:method], route[:path], -> () { 'hello' })
end

linear = Xinatra::LinearRouter.new
lobsters_routes.each do |route|
  linear.define(route[:method], route[:path], -> () { 'hello' })
end

mustermann = MustermannRouter.new
lobsters_routes.each do |route|
  mustermann.define(route[:method], route[:path], -> () { 'hello'})
end

Benchmark.ips do |x|
  x.config(warmup: 0, time: 2)

  x.report('trie') {
    trie.match("GET", "/hoge")
  }

  x.report('linear') {
    linear.match("GET", "/hoge")
  }

  x.report('mustermann') {
    mustermann.match("GET", "/hoge")
  }

  x.compare!
end
