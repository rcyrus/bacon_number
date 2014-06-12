require 'tree'
require 'thread/pool'

require_relative 'wikipedia/client'

class Bacon

  attr_accessor :wiki_client

  def initialize(end_topic, opts = {})
    @max_depth   = opts[:max_depth] || 3
    @pool        = Thread.pool(opts[:max_threads] || 10)
    @wiki_client = Wikipedia::Client.new({pllimit: opts[:pllimit] || 10})
    @bacon_tree  = Tree::TreeNode.new("ROOT", end_topic)
  end

  def number_for(goal)
    self.ret_message(self.bacon_it(goal))
  end

  protected

  def bacon_it(goal)
    if @bacon_tree.root.content == goal
      return {number: 0 , path: "#{@bacon_tree.root.content} -> #{goal}"}
    end

    @max_depth.times do
      ret = self.bud_leaves(goal)
      next if ret.nil?

      str = ret.inject('') { |str, node|
        str << "#{node.content}"
        str << " -> " unless node.name == 'ROOT'
        str
      }
      return {number: ret.length - 1 , path: str}
    end

    {number: -1 , path: 'No path found for given depth.'}
  end

  def bud_leaves(goal)
    ret = nil
    puts "building tree"

    leaves = @bacon_tree.each_leaf

    tasks = []
    leaves.each { |leaf|
      tasks << @pool.process {

        leaf_topics = @wiki_client.links_for(leaf.content)
        leaf_topics.each { |topic|
          next if topic.include? ":"
          leaf << Tree::TreeNode.new(topic, topic)
          if topic == goal
            ret = [leaf.children.last].concat leaf.children.last.parentage
            terminate!
            break
          end

        }
      }

    }

    @pool.wait tasks
    ret
  end

  def ret_message(data)
    number = data[:number] >= 0 ? data[:number] : '∞'
    ["BACON NUMBER IS: #{number}", "Found Path: #{data[:path]}"]
  end

end