class DigitTagDeleteAll < ActiveRecord::Migration[5.2]
  def change
    p ActsAsTaggableOn::Tag.count
    s = (0..9).collect { |e| "%#{e}%" }
    a = ActsAsTaggableOn::Tag.where(ActsAsTaggableOn::Tag.arel_table[:name].matches_any(s))
    p a.count
    a.each do |e|
      p e
      if e.name.match?(/\A[\d\/\-]+\z/)
        e.taggings.find_each(&:destroy); nil
        print "D"
      else
        print "."
      end
    end
    p ActsAsTaggableOn::Tag.count
  end
end
