# encoding: UTF-8
require 'test_helper'

class WikipediaQueryTest < Test::Unit::TestCase
  class << self
    include ActiveSupport::Testing::Declarative
  end
  
  def setup
    @metallica_id = 18787
    @coldplay_id = 80103
    @pink_id = 215566
    @ledzep_id = 17909
    #page deleted due to irrelevance
    @two_much_id = 11043140
  end
  
  test "abstracts load correctly" do
    assert Wikipedia::Page.from_id(@metallica_id)[:abstract] =~ /Metallica/
    assert Wikipedia::Page.from_id(@coldplay_id)[:abstract] =~ /Coldplay/
    assert Wikipedia::Page.from_id(@pink_id)[:abstract] =~ /Pink/
    assert Wikipedia::Page.from_id(@ledzep_id)[:abstract] =~ /Led Zeppelin/
    assert Wikipedia::Page.from_id(@two_much_id) == {}
  end
end