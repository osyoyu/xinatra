# frozen_string_literal: true

Pattern = Data.define(:type, :pattern)

module Xinatra
  class TrieRouter
    class Node
      attr_accessor :segment, :handler, :children

      def initialize(segment)
        @segment = segment
        @handler = nil
        @children = {}
      end
    end

    def initialize
      @root = Node.new('/')
    end

    # @param method [String]
    # @param pattern [String]
    # @param handler [Proc]
    def define(method, pattern, handler)
      segments = split_to_segments(pattern)
      current_node = @root
      segments.each do |segment|
        if child = current_node.children[segment]
          current_node = child
        else
          new_node = Node.new(segment)
          current_node.children[segment] = new_node
          current_node = new_node
        end
      end

      # Assign the handler to the last node
      current_node.handler = handler
    end

    # @param method [String]
    # @param path [String]
    # @return [Proc, nil] The registered handler for the given method and path
    def match(method, path)
      segments = split_to_segments(path)
      current_node = @root
      segments.each do |segment|
        if child = current_node.children[segment]
          current_node = child
        else
          return nil
        end
      end
      current_node.handler
    end

    private

    def split_to_segments(path)
      segments = path.split('/', 3)
      if segments[0] == ''
        segments.shift
      end
      segments
    end
  end
end

