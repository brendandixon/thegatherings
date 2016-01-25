class FauxModel
  include ActiveSupport
  include ActiveModel::AttributeMethods
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  extend ActiveModel::Callbacks

  class_attribute :attributes
  self.attributes = []

  attribute_method_prefix 'read_'
  attribute_method_prefix 'write_'

  attr_accessor :persisted, :saved

  define_model_callbacks :save
  
  class<<self
    def define_attributes(*attrs)
      attrs.each do |attr|
        attr = attr.to_sym
        self.attributes = (self.attributes || []) << attr
        self.send(:attr_accessor, attr)
        define_attribute_method attr
      end
    end

    def define_tags(*attrs)
      define_attributes(*attrs.map{|attr| "#{attr}_list".to_sym})
    end
  end

  def initialize(values = {})
    @persisted = false
    @saved = {}
    values.each {|k,v| self.write_attribute(k, v)}
  end

  def attributes
    self.class.attributes.inject({}) {|h, attr| h[attr.to_s] = read_attribute(attr); h }
  end

  def read_attribute(attr)
    self.instance_variable_get("@#{attr}".to_sym)
  end

  def write_attribute(attr, v)
    self.instance_variable_set("@#{attr}".to_sym, v)
  end

  def new_record?
    !@persisted
  end

  def persisted?
    @persisted
  end

  def save
    run_callbacks :save do
      @saved = {}
      self.class.attributes.each do |attr|
        @saved[attr] = read_attribute(attr)
      end if self.class.attributes.present?
      @persisted = true
    end
  end
end
