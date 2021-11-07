module Swars
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
        # ActiveRecord
        Grade,
      ].each do |e|
        e.setup(options)
      end
    end

    def models
      [
        Battle,
        Membership,
        MembershipExtra,
        Grade,
        User,
      ]
    end

    # 実行順序重要
    def destroy_all
      models.each do |e|
        e.destroy_all
      end
    end

    def info
      models.collect { |e|
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
          :model  => model.name,
          :before => before[i],
          :after  => after[i],
          :diff   => diff[i],
        }
      end

      if options[:change_only]
        records = records.reject { |e| e[:diff].zero? }
      end

      records.sort_by { |e| e[:diff] }
    end
  end
end
