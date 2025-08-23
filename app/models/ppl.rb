module Ppl
  def self.table_name_prefix
    name.underscore.gsub("/", "_") + "_"
  end

  # Ppl.setup(reset: true)
  def self.setup(options = {})
    if options[:reset]
      destroy_all
    end
    Result.setup(options)
    Rank.setup(options)
    Season.setup(options)
  end

  def self.destroy_all
    [
      Season,
      User,
      Mentor,
    ].each(&:destroy_all)
  end

  def self.reset_all
    destroy_all
    setup
  end

  def self.setup_for_workbench
    destroy_all
    Result.setup
    Rank.setup
  end

  class SpiderKlassNotFound < StandardError
  end
end
