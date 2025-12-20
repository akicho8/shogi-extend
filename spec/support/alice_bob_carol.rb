module AliceBobCarol
  extend ActiveSupport::Concern

  included do
    let(:__window_instance_a) { Capybara.open_new_window }
    let(:__window_instance_b) { Capybara.open_new_window }
    let(:__window_instance_c) { Capybara.open_new_window }
    let(:__window_instance_d) { Capybara.open_new_window }
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

  # FIXME: 4つめのタブを開こうとすると固まる問題あり。原因不明。RAILS_MAX_THREADS を 20 にしても変わらず。
  def window_d(&block)
    if block
      Capybara.within_window(__window_instance_d, &block)
    else
      Capybara.switch_to_window(__window_instance_d)
    end
  end
end
