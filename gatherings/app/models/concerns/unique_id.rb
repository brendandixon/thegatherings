module UniqueID
  extend ActiveSupport::Concern

  UUID_PATTERN = /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/

  included do
    self.primary_key = 'id'
    before_validation :set_id, on: :create
    validates :id, format: {with: UUID_PATTERN}, length: {is: 36}, presence: true, uniqueness: true
  end

  def set_id
    self.id = SecureRandom.uuid if self.id.blank? && self.new_record?
  end

  module ClassMethods

  end

end
