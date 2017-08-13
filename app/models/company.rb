class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
has_many :employments
has_many :users, through: :employments
has_one	 :addresses, as: :addressable
end
