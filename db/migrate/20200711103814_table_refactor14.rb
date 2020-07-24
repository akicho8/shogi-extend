class TableRefactor14 < ActiveRecord::Migration[6.0]
  def up
    change_column :actb_questions, :good_rate, :float, null: true
    Actb::Question.reset_column_information
    Actb::Question.find_each do |e|
      e.good_rate_update
      tp [e.title, e.good_rate.inspect]
    end

    change_column :actb_ox_records, :o_rate, :float, null: true
    Actb::OxRecord.reset_column_information
    Actb::OxRecord.find_each do |e|
      e.o_rate_set
      e.save!(validate: false, touch: false)
      p [e.id, e.o_rate]
    end
  end
end
