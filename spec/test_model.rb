class TestModelBase
  include ActiveSupport
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Dirty
  include ActiveModel::Validations::Callbacks

  extend ActiveModel::Callbacks

  class_attribute :attribute_names

  attr_accessor :saved

  define_model_callbacks :save
  
  class<<self
    def define_attribute(attr, type=:string)
      self.attribute_names = (self.attribute_names || []) + [attr.to_s]
      self.send(:attribute, attr, type)
      self.send(:attr_accessor, attr)
      define_attribute_method attr
    end
  end

  def initialize(attributes={})
    super(attributes)
    @saved = nil
  end

  def attributes
    self.class.attribute_names.inject({}) {|h, attr| h[attr] = send(attr.to_sym); h }
  end

  def new_record?
    !persisted?
  end

  def persisted?
    !@saved.nil?
  end

  def save
    run_callbacks :save do
      @saved = attributes.dup
      changes_applied
    end
  end

  def rollback!
    @saved.each {|attr, v| send("#{attr}=", v) }
    @saved = nil
    restore_attributes
  end
end
