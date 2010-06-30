module Freebase
  class Artist
    class << self
      def find_by_name(name)
        resource = Ken.session.mqlread(
            { :id => nil,
              :name => name,
              :type => '/music/artist',
              :limit => 1
            }
          )
        self.new(resource['id']) if resource.present? && resource['name'].present?
      end
    end

    attr_reader :resource
    
    def initialize(guid)
      resource = Ken.get(guid)
      @resource = resource
      @attributes = resource.attributes
    end
    
    def guid
      @resource.guid
    end
    
    def name
      CGI.unescapeHTML(@resource.name)
    end
    
    def is_band?
      @resource.view('/music/musical_group').present?
    end
    
    def is_person?
      return false unless @resource.view('/people/person')
      @resource.view('/people/person').attributes.present?
    end
    
    def wikipedia_page_id
      return {} unless @resource.attribute('/common/topic/article')
      page = {}
      wikipedia_page = @resource.attribute('/common/topic/article').values[0].attribute('/common/document/source_uri').values[0]
      wikipedia_page.scan(/\d+$/).first.to_i
    end
    
    def place_of_origin
      return nil unless @resource.attribute('/music/artist/origin')
      @resource.attribute('/music/artist/origin').values[0].name
    end
    
    def members
      return [] unless @resource.view('/music/musical_group')
      memberships = @resource.attribute('/music/musical_group/member').values
      memberships.map{ |m| m.attribute('/music/group_membership/member').values[0].name}
    end
    
    def official_pages
      return [] unless @resource.attribute('/music/artist/home_page')
      pages = @resource.attribute('/music/artist/home_page').values
      values = []
      pages.each do |page|
        values << {:name => page.name, :url => page.attribute('/common/webpage/uri').values[0]}
      end
      values
    end
    
    def active_start
      return nil unless @resource.attribute('/music/artist/active_start')
      @resource.attribute('/music/artist/active_start').values[0]
    end
    
    def active_end
      return nil unless @resource.attribute('/music/artist/active_end')
      @resource.attribute('/music/artist/active_end').values[0]
    end
    
    def genres
      return [] unless @resource.attribute('/music/artist/genre')
      @resource.attribute('/music/artist/genre').values.map(&:name)
    end
    
    def similar_artists
      a = @resource.attribute('/music/artist/similar_artist')
      b = @resource.attribute('/music/artist/artist_similar')
      values = []
      values += a.values if a
      values += b.values if b
      values.map(&:name)
    end
    
    def date_born
      return nil unless @resource.attribute('/people/person/date_of_birth')
      @resource.attribute('/people/person/date_of_birth').values[0]
    end
    
    def place_of_birth
      return nil unless @resource.attribute('/people/person/place_of_birth')
      @resource.attribute('/people/person/place_of_birth').values[0].name
    end
    
    def labels
      return [] unless @resource.attribute('/music/artist/label')
      @resource.attribute('/music/artist/label').values.map(&:name)
    end
  end
end