require 'thor'

require_relative 'lib/bacon'

class BaconNumber < Thor
  option :for, type: :string
  option :end_topic, type: :string, default: 'Kevin Bacon'
  option :max_depth, type: :numeric, default: 3
  option :max_threads, type: :numeric, default: 70
  option :max_links, type: :numeric, default: 500

  desc "for", "get a bacon number for a wikipedia TOPIC"
  long_desc <<-LONGDESC
    `bacon_number for TOPIC` will print the shortest path of Wikipedia
    topics it can find from 'for' to Kevin Bacon

    > $ bacon_number.rb for "Bacon"
  LONGDESC

  def for(goal)
    b = Bacon.new(options[:end_topic], {pllimit: options[:max_links], max_threads: options[:max_threads], max_depth: options[:max_depth]})

    message = b.number_for(goal)
    puts message
  end

end

BaconNumber.start(ARGV)