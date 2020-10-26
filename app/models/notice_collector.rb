class NoticeCollector
  class << self
    def single(*args)
      new.tap do |e|
        e.add(*args)
      end
    end
  end

  attr_accessor :infos

  def initialize
    @infos = []
  end

  def add(type, message, options = {})
    if !Rails.env.development? && options[:development_only]
      return
    end

    infos << { type: type, message: message, title: nil, method: :toast, **options }
  end

  def as_json(*)
    {
      :has_error => has_error?,
      :infos     => infos,
    }
  end

  private

  def has_error?
    infos.any? { |e| [:warning, :danger].include?(e[:type].to_sym) }
  end
end
