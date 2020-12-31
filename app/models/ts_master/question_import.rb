module TsMaster
  class QuestionImport
    attr_accessor :model
    attr_accessor :params

    def initialize(model, params = {})
      @model = model
      @params = {
        :max        => default_max,
        :mate       => [3, 5, 7, 9, 11],
        :reset      => Rails.env.development? || Rails.env.test?,
        :block_size => (Rails.env.development? || Rails.env.test?) ? 2 : 5000,
      }.merge(params)
    end

    def all_import
      Array(params[:mate]).each do |mate|
        one_import(mate)
      end
    end

    private

    def one_import(mate)
      if params[:reset]
        model.mate_eq(mate).delete_all
      end
      lines = source_file(mate).readlines(chomp: true)
      if params[:max]
        lines = lines.take(params[:max])
      end
      all_count = lines.count
      position = 0
      lines.each_slice(params[:block_size]) do |lines|
        attributes_list = lines.collect.with_index { |sfen, i|
          { sfen: sfen, mate: mate, position: position + i }
        }
        model.insert_all!(attributes_list)
        position += attributes_list.count
        p [mate, position, all_count] unless Rails.env.test?
      end
    end

    def default_max
      case
      when Rails.env.production?
        nil
      when Rails.env.staging?
        500
      else
        100
      end
    end

    def source_file(mate)
      Rails.root.join("mate3_5_7_9_11/mate#{mate}.txt")
    end
  end
end
