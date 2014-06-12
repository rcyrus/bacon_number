require 'thor'

require_relative 'lib/bacon'

class BaconNumber < Thor
  option :for, type: :string
  option :max_depth, type: :numeric, default: 3

  desc "for", "get a bacon number for a wikipedia TOPIC"
  long_desc <<-LONGDESC
    `bacon_number for TOPIC` will print the shortest path of Wikipedia
    topics it can find from 'for' to Kevin Bacon

    > $ bacon_number.rb for "Bacon"
  LONGDESC

  def for(start_topic)
    end_topic   = 'Kevin Bacon'
    b = Bacon.new(end_topic, start_topic)

    options[:max_depth].times do
      ret = b.bud_leaves
      next if ret.nil?

      str = ''
      ret.reverse.each { |node|
        str << "#{node.content}"
        str << " -> " unless node.content == end_topic
      }
      puts "BACON NUMBER IS: #{ret.length - 1}"
      puts "Found Path: #{str}"

      break
    end
  end
end

BaconNumber.start(ARGV)