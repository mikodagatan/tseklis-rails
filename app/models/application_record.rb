class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_hr?
    @hr_officer = Role.find(1)
    self.present? ? self.role_id == @hr_officer.id : false
  end

  def is_employee?
    @employee = Role.find(2)
    self.present? ? self.role_id == @employee.id : false
  end

  def is_manager?
    @manager = Role.find(3)
    self.present? ? self.role_id == @manager.id : false
  end
end
