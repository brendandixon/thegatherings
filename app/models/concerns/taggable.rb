module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    if self < ApplicationRecord
      scope :tagged_with, lambda{|tags| joins(:taggings).where(taggings: {tag_id: tags})}
      scope :tagged_with_set, lambda{|tag_set| tagged_with(tag_set.tags)}
    end
  end

  def add_tags!(*tags)
    tags = normalize_tags(*tags)
    return if tags.empty?

    if self.new_record?
      tags.each {|tag| self.taggings.build(tag: tag)}
    else
      self.class.transaction do
        tags.each {|tag| self.taggings.create!(tag: tag)}
      end
    end

  end
  alias :add_tag! :add_tags!

  def remove_tags!(*tags)
    return self.taggings.clear if tags.empty?

    tags = normalize_tags(*tags)
    return if tags.empty?

    taggings = self.taggings.for_tags(tags).all
    self.taggings.delete(taggings) if taggings.present?

  end
  alias :remove_tag! :remove_tags!

  def set_tags!(*tags, **options)
    tags = normalize_tags(*tags)
    return if tags.empty?

    if options[:tag_set].present?
      tag_set = options[:tag_set]
      tag_set = TagSet.for_community(self.community).with_name(tag_set).first if tag_set.is_a?(String) || tag_set.is_a?(Symbol)
      return unless tag_set.is_a?(TagSet) && tag_set.community == self.community
      taggings = self.taggings.from_set(tag_set)
    else
      taggings = self.taggings
    end

    self.class.transaction do
      taggings.each {|tagging| tagging.delete unless tags.include?(tagging.tag)}
      tags.each {|tag| self.taggings.create(tag: tag) unless self.tags.exists?(tag.id)}
    end
  end

  def has_tags?(*tags)
    return self.is_tagged? if tags.empty?

    tags = normalize_tags(*tags).map{|tag| tag.id}
    return false if tags.empty?
 
    tags.all?{|tag| self.tags.exists?(tag)}
  end
  alias :has_tag? :has_tags?

  def is_tagged?
    !self.taggings.empty?
  end

  def tag_sets
    self.community.present? ? self.community.tag_sets.to_a : []
  end

  def tags_from_set(tag_set)
    return [] unless self.community.present?
    return [] unless tag_set.is_a?(TagSet)

    self.tags.from_set(tag_set)
  end

  protected

    def normalize_tags(*tags)
      tags = tags.flatten.map do |tag|
                if tag.is_a?(Tag)
                  tag
                elsif tag.is_a?(String) && tag =~ /\A\d+\z/
                  Tag.find(tag.to_i) rescue nil
                elsif tag.is_a?(Integer)
                  Tag.find(tag) rescue nil
                else
                  nil
                end
              end

      tags.compact
    end

end
