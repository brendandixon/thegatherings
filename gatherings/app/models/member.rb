class Member < ActiveRecord::Base
  devise :confirmable,
    :database_authenticatable,
    :lockable,
    :registerable,
    :recoverable,
    :rememberable,
    :timeoutable,
    :trackable,
    :validatable,
    :omniauthable, :omniauth_providers => [:developer]
end
