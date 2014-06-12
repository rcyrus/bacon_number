require 'tree'
require 'thread/pool'

require_relative 'wikipedia'

class Bacon

  def initialize(e, start_topic, opts ={})
    @pool  = Thread.pool(70)
    @end_topic  = e
    @bacon_tree = Tree::TreeNode.new("ROOT", start_topic)
  end

  def bud_leaves
    ret = nil
    puts "building tree"

    leaves = @bacon_tree.each_leaf

    tasks  = []
    leaves.each { |leaf|
      # puts leaf.content
      tasks << @pool.process {

        leaf_topics = Wikipedia.linked_topics_for(leaf.content)
        leaf_topics.each { |topic|
          next if topic.include? ":"
          leaf << Tree::TreeNode.new(topic, topic)
          if topic == @end_topic
            ret = [leaf.children.last].concat leaf.children.last.parentage
            # self.search
            # ret = '1'
            terminate!
            break
          end

        }
      }

    }

    @pool.wait tasks
    ret
  end

  def search
    puts "searching"
    beginning_time = Time.now
    @bacon_tree.breadth_each { |node|
      if node.content == @end_topic
        str = "#{node.content} -> "
        node.parentage.each { |node|
          str << "#{node.content}"
          str << " -> " unless node.name == 'ROOT'
        }
        end_time = Time.now
        puts str
        puts "Time elapsed #{(end_time - beginning_time)*1000} milliseconds"
        break
      end
    }
  end

end