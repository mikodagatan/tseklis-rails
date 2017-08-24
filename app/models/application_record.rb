class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_admin?(employment=nil)
		employment.nil? ? employment.present? : employment.role_id == @administrator.id
  end

  def is_hr?(employment=nil)
    employment.nil? ? employment.present? : employment.role_id == @administrator.id
  end

  def is_employee?(employment=nil)
    employment.nil? ? employment.present? : employment.role_id == @administrator.id
  end

end
