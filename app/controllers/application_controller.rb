class ApplicationController < ActionController::Base
  def submitted?(name)
    [name, "#{name}.x", "#{name}.y"].any? {|e| params.key?(e) }
  end

  helper_method :submitted?
end
