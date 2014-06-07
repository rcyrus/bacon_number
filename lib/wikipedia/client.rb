require 'open-uri'
require 'json'

module Wikipedia
  class Client
    def get_links_for(title)
      opts = {
          :action  => "query",
          :prop    => 'links',
          :pllimit => '10', #link limit
          :titles  => title
      }

      d = JSON::load(URI.parse(url_for(opts)).read)
      d['query']['pages'].values[0]['links']
    end

    def url_for(params)
      url = 'http://en.wikipedia.org/w/api.php?&format=json'
      params.inject(url){|furl, kv|
        value = URI.encode(kv[1]).gsub('&', '%26')
        furl << "&#{kv[0]}=#{value}"
      }
    end

  end
end
