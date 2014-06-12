require_relative '../spec_helper'

describe Wikipedia do
  it 'return a list of links for topic' do
    VCR.use_cassette('beer') do
      x = Wikipedia.articles_for('Beer')
      x.must_be_instance_of Array
    end
  end

  it 'returns nil for an unkown topic' do
    topic = 'derpherptydo'
    VCR.use_cassette(topic) do
      Wikipedia.articles_for(topic).must_be_nil
    end
  end
end

