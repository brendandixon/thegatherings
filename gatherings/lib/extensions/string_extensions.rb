module StringExtensions
  extend ActiveSupport::Concern

  def despace
    self.dup.despace!
  end

  def despace!
    self.gsub!(/\s/,'')
  end

end

String.send(:include, StringExtensions)
