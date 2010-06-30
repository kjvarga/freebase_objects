require 'test_helper'

class FreebaseResourceTest < Test::Unit::TestCase
  class << self
    include ActiveSupport::Testing::Declarative
  end
  
  def setup
  end
  
  test "good" do
    @metallica = Freebase::Resource.new('/en/metallica')
    assert @metallica.exists?
  end
  
  test "unknown" do
    @unknown = Freebase::Resource.new('/sadfsad/asdfdasf')
    assert !@unknown.exists?
  end

  test "not found" do
    @not_found = Freebase::Resource.new('/guid/9202a8c04000641f8000000003674e41')
    assert !@not_found.exists?
  end
end
