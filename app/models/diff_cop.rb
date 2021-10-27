class DiffCop
  def initialize(text_old, text_new)
    @text_old = text_old
    @text_new = text_new
  end

  def to_s
    str = []
    diffs.each do |e|
      if e.old_element == e.new_element
      else
        str << "- #{e.old_element}" if e.old_element
        str << "+ #{e.new_element}" if e.new_element
      end
    end
    str.collect { |e| e + "\n" }.join
  end

  def diffs
    Diff::LCS.sdiff(normalize(@text_old), normalize(@text_new))
  end

  def same_line_count
    diffs.count { |e| e.action == "=" }
  end

  def diff_line_count
    diffs.count { |e| e.action == "!" }
  end

  private

  def normalize(object)
    if object.respond_to?(:lines)
      lines = object.lines
    else
      lines = object
    end
    lines.collect(&:rstrip)
  end
end
