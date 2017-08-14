class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

has_one :profile
has_one :address, as: :addressable

accepts_nested_attributes_for :profile, reject_if: :all_blank

end
