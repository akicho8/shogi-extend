# rails r ShareBoard.setup
module ShareBoard
  module Root
    def table_name_prefix
      name.underscore.gsub("/", "_") + "_"
    end

    def setup(options = {})
      if options[:force]
        destroy_all
      end

      [
        Room,
        User,
        Battle,
        Judge,
        Location,
        MessageScope,
        Room,
      ].each do |e|
        e.setup(options)
      end
    end

    def models
      [
        Battle,
        User,
        Roomship,
        Room,
        Membership,
        MessageScope,
        ChatMessage,
      ]
    end

    def destroy_all
      models.each do |e|
        e.destroy_all
        ApplicationRecord.connection.truncate(e.table_name)
      end
    end

    def info
      models.collect { |e|
        { model: e.name, count: e.count, "最終ID" => e.order(:id).last&.id }
      }
    end
  end
end
