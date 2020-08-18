module UserCpuBrainMod
  extend ActiveSupport::Concern

  def cpu_brain_info
    CpuBrainInfo.fetch(cpu_brain_key || :level1)
  end
end
