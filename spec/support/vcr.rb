VCR.configure do |c|
  c.cassette_library_dir = '../../spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.around_http_request do |request|
    topic = CGI::parse(request.uri)['titles'].first
    VCR.use_cassette(topic.gsub(' ', '_'), :record => :none, &request)
  end
end