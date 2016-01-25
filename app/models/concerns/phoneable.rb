module Phoneable
  extend ActiveSupport::Concern

  PATTERNS = [
    #  xxxxxxxxxx
    /\s*([1-9]\d{2})([1-9]\d{2})(\d{4})\s*/,
  
    # xxx xxxxxxx
    # xxx xxx xxxx
    /\s*([1-9]\d{2})\s+([1-9]\d{2})\s*(\d{4})\s*/,
  
    # xxx.xxx.xxxx
    # xxx-xxx-xxxx
    # xxx.xxx-xxxx
    # xxx-xxx.xxxx
    /\s*([1-9]\d{2})[\.\-]([1-9]\d{2})[\.\-](\d{4})\s*/,

    # xxx xxx.xxxx
    # xxx xxx-xxxx
    /\s*([1-9]\d{2})\s+([1-9]\d{2})[\.\-](\d{4})\s*/,

    # xxx.xxx xxxx
    # xxx-xxx xxxx
    # xxx.xxxxxxx
    # xxx-xxxxxxx
    /\s*([1-9]\d{2})[\.\-]([1-9]\d{2})\s*(\d{4})\s*/,
    
    # (xxx)xxx-xxxx
    # (xxx)xxx.xxxx
    # (xxx) xxx-xxxx
    # (xxx) xxx.xxxx
    /\s*\(([1-9]\d{2})\)\s*([1-9]\d{2})[\.\-](\d{4})\s*/,
    
    # (xxx)xxxxxxx
    # (xxx)xxx xxxx 
    # (xxx) xxx xxxx
    /\s*\(([1-9]\d{2})\)\s*([1-9]\d{2})\s*(\d{4})\s*/
  ]

  included do
    before_validation :normalize_phone
    validates :phone, phone: true
  end

  protected
  
    def normalize_phone
      if self.phone.present?
        p = self.phone.to_s
        self.phone = "#{$1}.#{$2}.#{$3}" if PATTERNS.any?{|pattern| p =~ pattern}
      end
    end

end
