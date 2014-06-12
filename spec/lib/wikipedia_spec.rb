require_relative '../spec_helper'

describe Wikipedia do
  before {
    @client = Wikipedia::Client.new
  }
  it 'return a list of links for topic' do
    VCR.use_cassette('beer') do
      x = @client.links_for('Beer')
      x.must_be_instance_of Array
    end
  end

  it 'returns nil for an unkown topic' do
    topic = 'derpherptydo'
    VCR.use_cassette(topic) do
      @client.links_for(topic).must_be_empty
    end
  end
end

