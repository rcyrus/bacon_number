require_relative 'wikipedia/client'

module Wikipedia
  def self.articles_for(title)
    client.get_links_for(title)
  end

  private

  def self.client
    @client ||= Wikipedia::Client.new
  end
end