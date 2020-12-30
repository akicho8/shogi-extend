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
      Rule,
      TimeRecord,
    ].each do |e|
      e.setup(options)
    end

    if Rails.env.development? || Rails.env.test?
      Question.setup(options)
    end
  end

  def models
    [
      Question,
      Rule,
      TimeRecord,
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
