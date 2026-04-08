module SharedMethods
  def shortcut_send(...)
    Capybara.current_session.active_element.send_keys(...)
  end
end
