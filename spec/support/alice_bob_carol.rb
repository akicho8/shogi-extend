module AliceBobCarol
  extend ActiveSupport::Concern

  included do
    let(:alice_window) { Capybara.open_new_window }
    let(:bob_window)   { Capybara.open_new_window }
    let(:carol_window) { Capybara.open_new_window }
  end

  def a_block(&block)
    if block
      Capybara.within_window(alice_window, &block)
    else
      Capybara.switch_to_window(alice_window)
    end
  end

  def b_block(&block)
    if block
      Capybara.within_window(bob_window, &block)
    else
      Capybara.switch_to_window(bob_window)
    end
  end

  def c_block(&block)
    if block
      Capybara.within_window(carol_window, &block)
    else
      Capybara.switch_to_window(carol_window)
    end
  end
end
