module Freebase
  class Genre
    def initialize(guid)
      @guid = guid
    end
    
    def has_artists?
      test = Ken.session.mqlread(
          {:id => @guid,
            :'/music/genre/artists' => [{
              :id => nil,
              :limit => 1
            }]
          }
        )
      test['/music/genre/artists'].present? rescue false
    end

    def subgenres
      test = Ken.session.mqlread(
          {:id => @guid,
            :'/music/genre/subgenre' => [{
              :id => nil,
              :name => nil,
              :limit => 99999
            }]
          }
        )
      test['/music/genre/subgenre'].present? rescue return []
      test['/music/genre/subgenre'].map{|h| h['name'] }
    end

    def parent_genres
      test = Ken.session.mqlread(
          {:id => @guid,
            :'/music/genre/parent_genre' => [{
              :id => nil,
              :name => nil,
              :limit => 99999
            }]
          }
        )
      test['/music/genre/parent_genre'].present? rescue return []
      test['/music/genre/parent_genre'].map{|h| h['name'] }
    end
  end
end