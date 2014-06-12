require_relative 'wikipedia/client'

module Wikipedia
  def self.linked_topics_for(title)
    client.links_for(title)
  end

  private

  def self.client
    @client ||= Wikipedia::Client.new
  end
end