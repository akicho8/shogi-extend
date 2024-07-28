# -*- compile-command: "rails r 'QuickScript::ModelStat.new.call'" -*-

module QuickScript
  class ModelStat < ::ModelStat
    def initialize(...)
      super
      @options[:target] = "quick_script"
    end
  end
end
