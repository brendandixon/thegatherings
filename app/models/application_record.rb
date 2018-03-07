class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  REGEX_TERM = /\A[[:word:]]{3,255}\z/i
  REGEX_WORD = /\A(?:[[:word:]]{2,2}|(?:[[:word:]][[[:word:]]\-\'[[:blank:]]]{0,253}[[:word:]]))\z/i
  REGEX_PHRASE = /\A([[:word:]]|[[:punct:]])[[[:word:]][[:blank:]][[:punct:]]]{2,253}([[:word:]]|[[:punct:]])\z/i
end
