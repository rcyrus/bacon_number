require_relative '../spec_helper'

describe Bacon do
  before {
    @bacon = Bacon.new('Kevin Bacon', {max_threads: 1, pllimit: 500, max_depth: 3})
  }

  it 'returns a score and path for found goal' do
      hsh = @bacon.send(:bacon_it, 'Apollo Lunar Module')

      hsh.must_be_kind_of Hash
      hsh[:number].must_equal 2
      hsh[:path].must_equal "Apollo Lunar Module -> Apollo 13 (film) -> Kevin Bacon"
  end

  it 'returns 0 score for matching start and goal' do
    hsh = @bacon.send(:bacon_it, 'Kevin Bacon')

    hsh[:number].must_equal 0
    hsh[:path].must_equal "Kevin Bacon -> Kevin Bacon"
  end

  it 'returns -1 score if no path found' do
    @bacon.wiki_client = Wikipedia::Client.new({max_depth: 1})
    hsh = @bacon.send(:bacon_it, 'DerpHerptyDun')

    hsh[:number].must_equal -1
  end
end