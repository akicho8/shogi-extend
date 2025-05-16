# -*- compile-command: "rails r 'ModelStat.new.call'" -*-

# |--------------------------------------|
# | 例                                   |
# |--------------------------------------|
# | rails model_stat TARGET=quick_script |
# |--------------------------------------|

class ModelStat
  def initialize(options = {})
    @options = options
  end

  def call
    tp({
        "全体" => target_files.size,
        "o"    => o_count,
        "x"    => x_count,
      })
    tp target_files.collect { |e|
      {
        "テスト" => e.spec_path.exist? ? "" : "×",
        "モデル" => e.path,
        "SPEC"   => e.spec_path,
      }
    }
  end

  private

  def o_count
    @o_count ||= target_files.size - x_count
  end

  def x_count
    @x_count ||= target_files.count { |e| !e.spec_path.exist? }
  end

  def root_dir
    Rails.root.expand_path.join("app/models")
  end

  def all_files
    @all_files ||= root_dir.glob("**/*.rb").collect { |e| SourceFile.new(self, e) }
  end

  def target_files
    @target_files ||= all_files.find_all do |e|
      e.path.to_s.include?(@options[:target].to_s)
    end
  end

  class SourceFile
    attr_accessor :base
    attr_accessor :path

    def initialize(base, path)
      @base = base
      @path = path
    end

    def spec_path
      str = path.to_s.sub("/app/", "/spec/")
      Pathname(str).sub_ext("_spec.rb")
    end
  end
end
