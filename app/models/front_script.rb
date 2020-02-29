module FrontScript
  extend self

  def keys
    @keys ||= admin_scripts_keys.sort.uniq
  end

  def bundle_classes
    @bundle_classes ||= keys.collect { |e| find(e) }
  end

  def find(key)
    "#{name}/#{key}".classify.constantize
  end

  private

  def admin_scripts_keys
    Pathname(__dir__).glob("#{name.underscore}/[^_]*_script.rb").collect { |e| e.basename(".rb").to_s }
  end
end
