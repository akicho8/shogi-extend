class Fix45 < ActiveRecord::Migration[6.0]
  def up
    # ActiveRecord::Base.logger = nil; ActiveRecord::Base.transaction { ActsAsTaggableOn::Tag.find_by(name: "相振り飛車")&.destroy! }
  end
end
