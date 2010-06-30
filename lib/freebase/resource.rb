module Freebase
  class Resource
    class << self
      def exists?(guid)
        resource = Ken.session.mqlread(
            {:id => guid,
              :name => nil,
              :limit => 1
            }
          )
        resource.present? && resource['name'].present?
      end
    end
  end
end