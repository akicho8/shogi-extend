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
        :block_size => (Rails.env.development? || Rails.env.test?) ? 1 : 5000,
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
      position = 0
      File.open(source_file(mate)) do |f|
        f.each_slice(params[:block_size]) do |lines|
          attributes_list = lines.collect.with_index { |sfen, i|
            { sfen: sfen.strip, mate: mate, position: position + i }
          }
          model.insert_all!(attributes_list)
          position += attributes_list.count
          p [mate, position] unless Rails.env.test?
          if params[:max] && position >= params[:max]
            break
          end
        end
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
