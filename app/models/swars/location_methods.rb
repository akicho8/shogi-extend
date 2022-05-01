module Swars
  concern :LocationMethods do
    included do
      belongs_to :location
      scope :location_eq,     -> v { where(    location_key: LocationInfo.keys_from(v)) }
      scope :location_not_eq, -> v { where.not(location_key: LocationInfo.keys_from(v)) }
      scope :location_ex, proc  { |v; s, g|
        s = all
        g = xquery_parse(v)
        if g[true]
          s = s.location_eq(g[true])
        end
        if g[false]
          s = s.location_not_eq(g[false])
        end
        s
      }

      with_options presence: true do
        validates :location_key
      end

      with_options allow_blank: true do
        validates :location_key, inclusion: LocationInfo.keys.collect(&:to_s)
        if Rails.env.development? || Rails.env.test?
          validates :location_key, uniqueness: { scope: :battle_id, case_sensitive: true }
        end
      end
    end

    def location_key=(v)
      super
      self.location = Location.lookup(v)
    end

    def location_info
      LocationInfo[location_key]
    end
  end
end
