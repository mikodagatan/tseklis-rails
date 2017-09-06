class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_hr?
    @hr_officer = Role.find(1)
    self.nil? ? self.present? : self.role_id == @hr_officer.id
  end

  def is_employee?
    @employee = Role.find(2)
    self.nil? ? self.present? : self.role_id == @employee.id
  end

end
