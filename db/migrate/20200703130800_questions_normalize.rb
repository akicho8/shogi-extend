class QuestionsNormalize < ActiveRecord::Migration[6.0]
  def up
    DbCop.foreign_key_checks_disable do
      Actb::Question.find_each do |record|
        [
          :title,
          :description,
          :hint_desc,
          :other_author,
          :source_media_name,
        ].each do |e|
          record.send("#{e}=", ApplicationRecord.hankaku_format(record.send(e)))
          record.save!(validate: false, touch: false)
        end
      end
    end
  end
end
