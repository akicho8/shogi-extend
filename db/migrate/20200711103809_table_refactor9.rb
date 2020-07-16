class TableRefactor9 < ActiveRecord::Migration[6.0]
  def up
    Actb::SourceAbout.reset_column_information
    Actb::Question.reset_column_information

    Actb::SourceAbout.setup
    Actb::Question.find_each do |e|
      if e.source_author == "作者不詳"
        e.source_about_key = "unknown"
      else
        e.source_about_key = "ascertained"
      end
      e.save!(touch: false)
      p ["#{__FILE__}:#{__LINE__}", __method__, e.id]
    end
  end
end
