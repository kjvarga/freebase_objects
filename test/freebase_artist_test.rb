# encoding: UTF-8
require 'test_helper'

class FreebaseQueryTest < Test::Unit::TestCase
  class << self
    include ActiveSupport::Testing::Declarative
  end
  
  def setup
  end
  
  test "metallica" do
    @metallica = Freebase::Artist.new('/en/metallica')
    assert @metallica.name == 'Metallica'
    assert @metallica.is_band?
    assert !@metallica.is_person?
    assert @metallica.wikipedia_page_id == 18787
    assert @metallica.place_of_origin.present?
    assert @metallica.members.size == 8
    assert @metallica.active_start.present?
    assert @metallica.active_end.blank?
    assert @metallica.official_pages.present?
    assert @metallica.genres.present?
    assert @metallica.similar_artists.blank?
    assert @metallica.labels.present?
  end

  test "coldplay" do
    @coldplay = Freebase::Artist.new('/en/coldplay')
    assert @coldplay.name == 'Coldplay'
    assert @coldplay.is_band?
    assert !@coldplay.is_person?
    assert @coldplay.wikipedia_page_id == 80103
    assert @coldplay.place_of_origin.present?
    assert @coldplay.members.size == 4
    assert @coldplay.active_start.present?
    assert @coldplay.active_end.blank?
    assert @coldplay.official_pages.present?
    assert @coldplay.genres.present?
    assert @coldplay.similar_artists.present?
    assert @coldplay.labels.present?
  end
    
  test "pink" do
    @pink = Freebase::Artist.new('/en/pink_1979')
    assert @pink.name == 'Pink'
    assert @pink.is_person?
    assert !@pink.is_band?
    assert @pink.wikipedia_page_id == 215566
    assert @pink.date_born.is_a?(String)
    assert @pink.place_of_birth.present?
    assert @pink.place_of_origin.present?
    assert @pink.members == nil
    assert @pink.active_start.is_a?(String)
    assert @pink.active_end.blank?
    assert @pink.official_pages.present?
    assert @pink.genres.size > 0
    assert @pink.similar_artists.blank?
    assert @pink.labels.size > 0
  end
  
  test "Led Zeppelin" do
    @ledzep = Freebase::Artist.new('/en/led_zeppelin')
    assert @ledzep.name == 'Led Zeppelin'
    assert @ledzep.is_band?
    assert !@ledzep.is_person?
    assert @ledzep.wikipedia_page_id == 17909
    assert @ledzep.place_of_origin.present?
    assert @ledzep.members.size == 4
    assert @ledzep.active_start.present?
    assert @ledzep.active_end.present?
    assert @ledzep.official_pages.present?
    assert @ledzep.genres.size > 0
    assert @ledzep.similar_artists.size > 0
    assert @ledzep.labels.size > 0
  end

  test "Christina Aguilera, Lil' Kim, Mýa & P!nk" do
    @combo = Freebase::Artist.new('/en/christina_aguilera_lil_kim_mya_p_nk')
    assert @combo.name == "Christina Aguilera, Lil' Kim, Mýa & P!nk"
    assert @combo.members.size == 4
    assert @combo.similar_artists.blank?
    assert @combo.labels == nil
  end

  test "Boo-Yaa T.R.I.B.E." do
    @booya = Freebase::Artist.new('/en/boo-yaa_tribe')
    assert @booya.name == "Boo-Yaa T.R.I.B.E."
    assert @booya.similar_artists.size > 0
    @highnmighty = Freebase::Artist.new('/guid/9202a8c04000641f800000000054b14c')
    assert @highnmighty.name == "High and Mighty"
    assert @highnmighty.similar_artists.size > 0
  end

  test "2-Much" do
    # not found in wikipedia
    @much = Freebase::Artist.new('#9202a8c04000641f80000000047de0a9')
    assert @much.wikipedia_page_id == 11043140
  end

  test "Unknown" do
    assert_raise(Ken::ResourceNotFound){ Freebase::Artist.new('/sadf/sadf') }
  end
end
