class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
has_many :employments
has_many :users, through: :employments
has_one	 :address, as: :addressable

has_one  :company_leave_setting
has_many :leave_types

end
