module Acns2
  class Profile < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"

    before_validation do
      self.rating ||= EloRating.rating_default
      self.rating_max ||= EloRating.rating_default
      self.rating_last_diff ||= 0

      if v = changes_to_save[:rating]
        ov, nv = v
        if ov && nv
          self.rating_last_diff = nv - ov
        end
      end

      if rating_max < rating
        self.rating_max = rating
      end

      self.rensho_count ||= 0
      self.renpai_count ||= 0
      self.rensho_max ||= 0
      self.renpai_max ||= 0

      if rensho_max < rensho_count
        self.rensho_max = rensho_count
      end

      if renpai_max < renpai_count
        self.renpai_max = renpai_count
      end
    end
  end
end
