class ModelGroup
  def self.[](*args)
    new(*args)
  end

  def initialize(*models)
    @models = models
  end

  def destroy_all
    @models.reverse.destroy_all
  end

  def count
    @models.collect(&:count)
  end

  def diff
    before = Vector[*count]
    yield
    after = Vector[*count]
    (Vector[*after] - Vector[*before]).to_a
  end

  def display
    @models.each do |e|
      tp e
    end
  end
end
