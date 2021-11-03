class Xnotice
  class << self
    def add(*args)
      new.tap do |e|
        e.add(*args)
      end
    end
  end

  attr_accessor :infos

  def initialize
    @infos = []
  end

  def add(message, options = {})
    options = {
      message: message,
      method: :toast,
    }.merge(options)

    if !Rails.env.development? && options[:development_only]
      return
    end

    infos << options
  end

  def as_json(*)
    {
      :has_error_p => has_error?,
      :infos       => infos,
    }
  end

  private

  def has_error?
    infos.any? { |e| [:warning, :danger].include?(e[:type].to_sym) }
  end
end
