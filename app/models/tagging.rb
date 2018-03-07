# == Schema Information
#
# Table name: taggings
#
#  id            :bigint(8)        unsigned, not null, primary key
#  tag_id        :bigint(8)
#  taggable_id   :bigint(8)        unsigned, not null
#  taggable_type :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Tagging < ApplicationRecord
  include Authority::Abilities

  FORM_FIELDS = [:tag_id, :taggable_id, :taggable_type]

  belongs_to :tag
  belongs_to :taggable, polymorphic: true, inverse_of: :taggings

  validates :tag, belonging: {models: [Tag]}
  validates :taggable, belonging: {models: [Gathering, Preference]}

  validates_uniqueness_of :tag, scope: :taggable

  validate :community_owns_tag

  scope :for_taggable, lambda{|taggable| where(taggable: taggable)}
  scope :for_tags, lambda{|tags| where(tag: tags)}
  scope :from_set, lambda{|tag_set| joins(:tag).where(tags: { tag_set: tag_set })}

  def to_s
    self.tag.to_s
  end

  protected

    def community_owns_tag
      return if self.errors.has_key?(:taggable) || self.errors.has_key?(:tag)
      return if self.taggable.community == self.tag.community
      self.errors.add(:taggable, "Community #{self.taggable.community} does not own the #{self.tag.tag_set} set of tags")
    end

end
