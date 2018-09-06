class ApplicationRecord < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  self.abstract_class = true

  REGEX_TERM = /\A[[:word:]]{3,255}\z/i
  REGEX_WORD = /\A(?:[[:word:]]{2,2}|(?:[[:word:]][[[:word:]]\-\'[[:blank:]]]{0,253}[[:word:]]))\z/i
  REGEX_PHRASE = /\A([[:word:]]|[[:punct:]])[[[:word:]][[:blank:]][[:punct:]]]{1,253}([[:word:]]|[[:punct:]])\z/i

  JSON_EXCLUDES = ['created_at', 'updated_at']

  scope :in_order, lambda{ order_by }
  scope :order_by, lambda{|field = 'id', direction = 'ASC'| order("#{field} #{direction}")}

  end
