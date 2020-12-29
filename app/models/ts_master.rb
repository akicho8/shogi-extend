module TsMaster
  extend self

  def table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  def setup(options = {})
    if options[:force]
      destroy_all
    end

    [
      Stock,
      Rule,
      TimeRecord,
    ].each do |e|
      e.setup(options)
    end

    # User.find_each(&:create_various_folders_if_blank)
    # User.find_each(&:create_TsMaster_setting_if_blank)
    # User.find_each(&:create_TsMaster_season_xrecord_if_blank)
    # User.find_each(&:create_TsMaster_main_xrecord_if_blank)
    #
    # if Rails.env.development? || Rails.env.test?
    #   TsMaster::BaseChannel.redis_clear
    # end
    #
    # if Rails.env.staging? || Rails.env.production? || options[:import_all] || ENV["INSIDE_DB_SEEDS_TASK"]
    #   unless TsMaster::Question.exists?
    #     TsMaster::Question.import_all
    #   end
    # end
  end

  def models
    [
      TimeRecord,
      Rule,
    ]
  end

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
end
