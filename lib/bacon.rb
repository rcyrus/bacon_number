require 'tree'
require 'thread/pool'

require_relative 'wikipedia/client'

class Bacon

  def initialize(e, start_topic, opts = {})
    @max_depth   = opts[:max_depth] || 3
    @pool        = Thread.pool(opts[:max_threads] || 10)
    @wiki_client = Wikipedia::Client.new({pllimit: opts[:pllimit] || 10})
    @end_topic   = e
    @bacon_tree  = Tree::TreeNode.new("ROOT", start_topic)
  end

  def bud_leaves
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

  def bacon_it
    if @bacon_tree.root.content == @end_topic
      return ret_message(0, "#{@bacon_tree.root.content} -> #{@end_topic}")
    end

    @max_depth.times do
      ret = self.bud_leaves
      next if ret.nil?

      str = ret.reverse.inject('') { |str, node|
        str << "#{node.content}"
        str << " -> " unless node.content == @end_topic
        str
      }
      return ret_message(ret.length - 1 , str)
    end

    ret_message('∞', 'No path found for given depth.')
  end



  private

  def ret_message(bacon_number, path)
    ["BACON NUMBER IS: #{bacon_number}", "Found Path: #{path}"]
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