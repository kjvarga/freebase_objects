# encoding: UTF-8
require 'test_helper'

class FreebaseGenreTest < Test::Unit::TestCase
  class << self
    include ActiveSupport::Testing::Declarative
  end
  
  def setup
  end
  
  test "pop music" do
    @pop = Freebase::Genre.new('#9202a8c04000641f8000000000078115')
    assert @pop.has_artists?
    assert @pop.subgenres.size > 0
    assert @pop.parent_genres.size == 0
  end
  
  test "rock music" do
    @rock = Freebase::Genre.new('#9202a8c04000641f8000000000032ba7')
    assert @rock.has_artists?
    assert @rock.subgenres.size > 0
    assert @rock.parent_genres.size > 0
  end

  test "Indie rock" do
    @indie = Freebase::Genre.new('/en/indie_rock')
    assert @indie.has_artists?
    assert @indie.subgenres.size > 0
    assert @indie.parent_genres.size > 0
  end
  
  test "Slack-key guitar" do
    @slack = Freebase::Genre.new('#9202a8c04000641f80000000002b467b')
    assert !@slack.has_artists?
    assert @slack.subgenres.size == 0
    assert @slack.parent_genres.size == 0
  end

  test "unknown" do
    @unknown = Freebase::Genre.new('/asdf/21341234')
    assert !@unknown.has_artists?
    assert @unknown.subgenres.size == 0
    assert @unknown.parent_genres.size == 0
  end
end
