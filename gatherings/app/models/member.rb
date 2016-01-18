# == Schema Information
#
# Table name: members
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)
#  postal_code            :string(25)
#  country                :string(2)
#  time_zone              :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#

class Member < ActiveRecord::Base
  include Addressed
  include AgeGroups
  include Genders
  include LifeStages
  include Phoneable
  include Relationships

  has_address_of :country, :postal_code

  has_many :community_members
  has_many :communities, through: :community_members
  
  has_many :campus_members
  has_many :campuses, through: :campus_members
  
  has_many :gathering_members
  has_many :gatherings, through: :gathering_members
  has_many :attendance_records
  has_many :membership_requests

  before_validation :ensure_password
  before_validation :ensure_time_zone

  validates_presence_of :first_name, :last_name, :email
  validates :email, email: true

  devise :database_authenticatable,
    :lockable,
    :registerable,
    :recoverable,
    :rememberable,
    :timeoutable,
    :trackable
    # :confirmable,
    # :validatable,
    # :omniauthable, :omniauth_providers => [:developer]

  protected

    def ensure_password
      unless self.password.present? || self.password_confirmation.present?
        self.password =
        self.password_confirmation = Rails.env.production? ? Devise.friendly_token : "pa$$w0rd"
      end if self.new_record?
    end

    def ensure_time_zone
      self.time_zone = TheGatherings::Application.default_time_zone if self.time_zone.blank?
    end

end
