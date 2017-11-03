class Company < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	has_many :employments
	has_many :users, through: :employments
	has_many :leave_requests, through: :employments
	has_many :leave_amounts, through: :leave_requests
	has_many :holidays
	has_many :departments
	has_many :projects, through: :categories
	has_many :projects, through: :employments
	has_many :project_times, through: :projects
	has_one	 :address

	has_one  :company_leave_setting
	has_many :leave_types, dependent: :destroy

	has_many :invites

	accepts_nested_attributes_for :employments,
		:address,
		:leave_types,
		:company_leave_setting,
		:holidays,
		allow_destroy: true


	validates :name, presence: true, uniqueness: true

	attr_accessor :segmented_monthly_leaves

	def self.search(search)
	  if search
	    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
	  else
	  end
	end

	def segmented_leaves(date_used)
		leave = []
		self.leave_types.each do |p|
		 	value = self.leave_amounts
		 		.where(date: date_used)
		 		.where(leave_request_id: self.leave_requests.ids)
		 		.where("leave_requests.acceptance = true")
		 		.where("leave_requests.leave_type_id = ?", p.id)
		 		.sum(:amount)
		 	name = p.name
			leave << {name => value}
		end
		return leave
	end

	def total_leaves(date_used)
		self.leave_amounts.where(date: date_used).sum(:amount)
	end

	def number_of_users
		self.users.size
	end

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

end
