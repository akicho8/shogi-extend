class ApplicationController < ActionController::Base
  def submitted?(name)
    [name, "#{name}.x", "#{name}.y"].any? {|e| params.key?(e) }
  end

  helper_method :submitted?

  private

  def h
    @h ||= view_context
  end

  delegate :tag, :link_to, :icon_tag, to: :h
end
