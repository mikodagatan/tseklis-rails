class CreateCompanyLeaveSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :company_leave_settings do |t|
    		t.integer			:company_id

    		t.integer			:leave_month_expiration
    		t.integer			:leave_month_start

    		t.boolean			:prorate_accrual
        t.boolean     :include_weekends, default: true

    		t.timestamps
    end
  end
end
