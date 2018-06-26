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
    return if tags.blank?

    if self.new_record?
      tags.each {|tag| self.taggings.build(tag: tag) unless self.tags.exists?(tag.id) }
    else
      self.class.transaction do
        tags.each {|tag| self.taggings.create!(tag: tag) unless self.tags.exists?(tag.id) }
      end
    end

  end
  alias :add_tag! :add_tags!

  def add_tags(*tags)
    self.add_tags!(*tags)
    return true
  rescue Exception => e
    return false
  end
  alias :add_tag :add_tags

  def remove_tags!(*tags)
    tags = normalize_tags(*tags)
    return if tags.blank?

    taggings = self.taggings.for_tags(tags).all
    self.taggings.delete(taggings) if taggings.present?

  end
  alias :remove_tag! :remove_tags!

  def remove_tags(*tags)
    self.remove_tags!(*tags)
    return true
  rescue Exception => e
    return false
  end
  alias :remove_tag :remove_tags

  def set_tags!(*tags)
    self.taggings.clear if tags.blank?

    tags = normalize_tags(*tags)
    return if tags.blank?

    taggings = self.taggings.to_a
    if self.new_record?
      self.taggings.clear
      tags.each {|tag| self.taggings.build(tag: tag)}
    else
      self.class.transaction do
        taggings.each {|tagging| tagging.delete unless tags.include?(tagging.tag)}
        tags.each {|tag| self.taggings.create!(tag: tag) unless self.tags.exists?(tag.id)}
      end
    end
  end
  alias :set_tag! :set_tags!

  def set_tags(*tags)
    self.set_tags!(*tags)
    return true
  rescue Exception => e
    return false
  end
  alias :set_tag :set_tags

  def has_tags?(*tags, **possible_tags)
    return self.is_tagged? if tags.blank?

    tags = normalize_tags(*tags, possible_tags).map{|tag| tag.id}
    return false if tags.blank?
 
    tags.all?{|tag| self.tags.exists?(tag)}
  end
  alias :has_tag? :has_tags?

  def is_tagged?
    !self.taggings.blank?
  end

  def tag_sets
    self.community.present? ? self.community.tag_sets.to_a : []
  end

  def tags_from_set(tag_set)
    return [] unless self.community.present?

    tag_set = normalize_tag_set(tag_set)
    return [] unless tag_set.is_a?(TagSet)

    tag_set.tags.to_a
  end

  protected

    def normalize_tag_set(tag_set)
      tag_set = self.tag_sets.find{|ts| ts.id == tag_set} if tag_set.is_a?(Integer)
      tag_set = self.tag_sets.find{|ts| ts.name == tag_set.to_s} if tag_set.is_a?(String) || tag_set.is_a?(Symbol)
      tag_set.is_a?(TagSet) && tag_set.community == self.community ? tag_set : nil
    end

    def normalize_tags(*tags)
      possible_tags = tags.extract_options!
      tags = tags.map{|t| t.is_a?(Tag) && t.community == self.community ? t : nil}.compact
      return [] if tags.blank? && possible_tags.blank?

      tags += possible_tags.map do |tag_set, tags|
                tag_set = normalize_tag_set(tag_set)
                next unless tag_set.is_a?(TagSet)
                tag_set.normalize_tags(*tags)
              end

      tags.flatten!
      tags.compact
    end

  end
