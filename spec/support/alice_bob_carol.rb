module AliceBobCarol
  extend ActiveSupport::Concern

  included do
    before do
      @alice_window = Capybara.open_new_window
      @bob_window   = Capybara.open_new_window
      @carol_window = Capybara.open_new_window
    end

    after do
      [
        @alice_window,
        @bob_window,
        @carol_window,
      ].each(&:close)
    end
  end

  def a_block(&block)
    if block
      Capybara.within_window(@alice_window, &block)
    else
      Capybara.switch_to_window(@alice_window)
    end
  end

  def b_block(&block)
    if block
      Capybara.within_window(@bob_window, &block)
    else
      Capybara.switch_to_window(@bob_window)
    end
  end

  def c_block(&block)
    if block
      Capybara.within_window(@carol_window, &block)
    else
      Capybara.switch_to_window(@carol_window)
    end
  end
end
