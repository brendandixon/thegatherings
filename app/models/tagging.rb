# == Schema Information
#
# Table name: taggings
#
#  id            :bigint(8)        unsigned, not null, primary key
#  tag_id        :bigint(8)        not null
#  taggable_id   :bigint(8)        unsigned, not null
#  taggable_type :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Tagging < ApplicationRecord
  include Authority::Abilities

  FORM_FIELDS = [:tag_id, :taggable_id, :taggable_type]
  JSON_EXCLUDES = JSON_EXCLUDES + %w(tag_id taggable_id taggable_type)

  belongs_to :tag
  has_one :category, through: :tag
  belongs_to :taggable, polymorphic: true, inverse_of: :taggings

  validates :tag, belonging: {models: [Tag]}
  validates :taggable, belonging: {models: [Gathering, Preference]}

  validates_uniqueness_of :tag, scope: :taggable

  validate :community_owns_tag
  validate :singleton_tag

  scope :for_taggable, lambda{|taggable| where(taggable: taggable)}
  scope :for_tags, lambda{|tags| where(tag: tags)}
  scope :from_set, lambda{|category| joins(:tag).where(tags: { category: category })}

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |p|
      p['tag'] = self.tag.as_json
    end
  end

  def to_s
    self.tag.to_s
  end

  protected

    def community_owns_tag
      return if self.errors.has_key?(:taggable) || self.errors.has_key?(:tag)
      return if self.taggable.community == self.tag.community
      self.errors.add(:taggable, "Community #{self.taggable.community} does not own the #{self.tag.category} set of tags")
    end

    def singleton_tag
      return if self.category.blank? || !self.category.singleton?
      return unless Tagging.from_set(self.category).for_taggable(self.taggable).exists?
      self.errors.add(:tag, "Only one tag from #{self.category.plural} may be applied at a time")
    end

end
