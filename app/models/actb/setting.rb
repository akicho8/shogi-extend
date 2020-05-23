module Actb
  class Setting < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"

    before_validation do
      self.rule_key ||= RuleInfo.fetch(:rule_key1).key
    end

    with_options presence: true do
      validates :rule_key
    end

    with_options allow_blank: true do
      validates :rule_key, inclusion: RuleInfo.keys.collect(&:to_s)
    end

    def rule_info
      RuleInfo.fetch(rule_key)
    end
  end
end
