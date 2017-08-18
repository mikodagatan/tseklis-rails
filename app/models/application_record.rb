class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_admin?(employment = nil)
  		self.role_id == @administrator.id
  end

  def is_hr?
  	self.role_id == @hr_officer.id
  end

  def is_employee?
  	self.role_id == @employee.id 
  end

  def show_error_message
  	if self.errors.any?
  		self.errors.full_messages.each do |message| 
  			message
  		end
  	end
  end

end
