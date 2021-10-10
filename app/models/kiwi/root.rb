module Kiwi
  module Root
    def table_name_prefix
      name.underscore.gsub("/", "_") + "_"
    end

    def setup(options = {})
      if options[:force]
        destroy_all
      end

      [
        # Static
        Folder,
        # ActiveRecord
        BananaMessage,
        Banana,
        Lemon,
      ].each do |e|
        e.setup(options)
      end

      # if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
      #   unless Article.exists?
      #     Article.import_all
      #   end
      # end
    end

    def models
      [
        BananaMessage,
        Banana,
        Lemon,
        Folder,
      ]
    end

    # 実行順序重要
    def destroy_all
      models.each do |e|
        e.destroy_all
      end
    end

    def info
      [User, *models].collect { |e|
        { model: e.name, count: e.count, "最終ID" => e.order(:id).last&.id }
      }
    end

    # rails r 'user = User.create!; tp Kiwi.count_diff { user.destroy! }'
    def count_diff(options = {})
      list = [User, *models]
      before = Vector[*list.collect(&:count)]
      yield
      after = Vector[*list.collect(&:count)]
      diff = after - before

      records = list.collect.with_index do |model, i|
        {
          model: model.name,
          before: before[i],
          after: after[i],
          diff: diff[i],
        }
      end

      if options[:change_only]
        records = records.reject { |e| e[:diff].zero? }
      end

      records.sort_by { |e| e[:diff] }
    end
  end
end
