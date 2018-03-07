# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        unsigned, not null, primary key
#  tag_set_id :bigint(8)        not null
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'CommunityAuthorizer'

  FORM_FIELDS = [:tag_set_id, :name]

  belongs_to :tag_set
  has_one :community, through: :tag_set

  has_many :taggings, dependent: :destroy

  validates :tag_set, belonging: {models: [TagSet]}

  validates_presence_of :name
  validates_format_of :name, with: REGEX_WORD
  validates_uniqueness_of :name, scope: :tag_set

  scope :from_set, lambda{|tag_set| where(tag_set: tag_set)}
  scope :with_name, lambda{|name| where(name: name)}

  def to_s
    self.name
  end

end
