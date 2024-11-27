# インターフェイスはこの2つだけ
#
# |----------+-------------------------------------------|
# | 内容     | コード                                    |
# |----------+-------------------------------------------|
# | 書き込み | PermanentVariable["A"].write({foo: 1})    |
# | 読み出し | PermanentVariable["A"].read # => {foo: 1} |
# |----------+-------------------------------------------|
#
class PermanentVariable < ApplicationRecord
  scope :key_only, -> key { where(key: key) }

  class << self
    def [](key)
      if record = find_by(key: key)
        if v = record.value
          if v.kind_of?(Hash)
            v = v.deep_symbolize_keys
          end
        end
        v
      end
    end

    def []=(key, value)
      record = find_or_initialize_by(key: key)
      record.update!(value: value)
    end
  end

  before_validation do
    self.value ||= {}
  end

  with_options presence: true do
    validates :key
  end

  after_create_commit do
    AppLog.important(subject: "[#{key}]", body: value.to_t(truncate: nil))
  end
end
