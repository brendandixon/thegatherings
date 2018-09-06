class CategoryMatch

  attr_reader :category, :desired, :aligned, :misaligned

  class<<self

    def match_for(category, desired, actual)
      aligned =
      misaligned =
      i =
      j = 0
      category.tags.in_order.each do |tag|
        if tag == desired[i] && tag == actual[j]
          aligned += 1
          i += 1
          j += 1
        elsif tag == desired[i]
          i += 1
        elsif tag == actual[j]
          misaligned += 1
          j += 1
        end
      end
      CategoryMatch.new(category, desired.length, aligned, misaligned)
    end

  end

  def as_json(*args, **options)
    super.except('category').tap do |c|
      c['single'] = @category.single
      c['plural'] = @category.plural
      c['singleton'] = @category.singleton
      c['total'] = @category.tags.length
    end
  end

  protected

    def initialize(category, desired, aligned, misaligned)
      @category = category
      @desired = desired
      @aligned = aligned
      @misaligned = misaligned
    end

end
