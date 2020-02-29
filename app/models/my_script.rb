module MyScript
  extend self


  def keys
    my_scripts_keys.sort.uniq
  end

  def bundle_classes
    @bundle_classes ||= keys.collect { |e| script_constantize(e) }
  end

  private

  def script_constantize(key)
    "#{name}/#{key}".classify.constantize
  end

  def my_scripts_keys
    [ViewSupport::Engine.root, Rails.root].collect {|root|
      Pathname.glob("#{root}/app/models/#{name.underscore}/[^_]*_script.rb").collect {|f| f.basename(".rb").to_s }
    }.flatten
  end
end
