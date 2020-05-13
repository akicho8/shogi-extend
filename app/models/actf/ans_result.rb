module Actf
  class AnsResult < ApplicationRecord
    class << self
      def setup(options = {})
        ::Actf::AnsResultInfo.each do |e|
          find_or_create_by!(key: e.key)
        end
      end

      def fetch(key)
        find_by!(key: key)
      end
    end

    def static_info
      AnsResultInfo.fetch(key)
    end
  end
end
