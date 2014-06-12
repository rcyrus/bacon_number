require 'open-uri'
require 'json'

module Wikipedia
  class Client

    def initialize(opts = {pllimit: 10})
      @options = opts
    end

    def links_for(title)
      opts = {
          :action  => "query",
          :prop    => 'links',
          :titles  => title
      }.merge(@options)

      d = JSON::load(URI.parse(url_for(opts)).read)
      links = d['query']['pages'].values[0]['links']

      return [] if links.nil?
      links.map {|l| l['title'] unless l.nil?}
    end

    def url_for(params)
      url = 'http://en.wikipedia.org/w/api.php?&format=json'
      params.inject(url){|furl, kv|
        value = URI.encode(kv[1].to_s).gsub('&', '%26')
        furl << "&#{kv[0]}=#{value}"
      }
    end

  end
end
