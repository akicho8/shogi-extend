module AliceBobCarol
  extend ActiveSupport::Concern

  included do
    let(:__window_instance_a) { Capybara.open_new_window }
    let(:__window_instance_b) { Capybara.open_new_window }
    let(:__window_instance_c) { Capybara.open_new_window }
  end

  def window_a(&block)
    if block
      Capybara.within_window(__window_instance_a, &block)
    else
      Capybara.switch_to_window(__window_instance_a)
    end
  end

  def window_b(&block)
    if block
      Capybara.within_window(__window_instance_b, &block)
    else
      Capybara.switch_to_window(__window_instance_b)
    end
  end

  def window_c(&block)
    if block
      Capybara.within_window(__window_instance_c, &block)
    else
      Capybara.switch_to_window(__window_instance_c)
    end
  end
end
