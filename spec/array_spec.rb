require 'rspec'
require 'rswift'

describe Array do

  before do
    @sut = %w(foo bar foobar)
  end

  after do
    @sut = nil
  end

  describe 'all combination' do

    before do
      @all_combinations = @sut.all_combinations
    end

    it 'should return array of all combinations' do
      expected_combinations = [[], ["foo"], ["bar"], ["foobar"], ["foo", "bar"], ["foo", "foobar"], ["bar", "foobar"], ["foo", "bar", "foobar"]]
      expect(@all_combinations).to eq(expected_combinations)
    end
  end
end
