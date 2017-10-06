# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

['HR Officer', 'Employee'].each do |n|
  Role.find_or_create_by(
    name: n
  )
end

20.times do

  company = Company.create!(
    name: Faker::Company.unique.name
  )

  company.build_address(
    first_line: Faker::Address.street_address,
    second_line: Faker::Address.community,
    city_town: Faker::Address.city,
    province: Faker::Address.state,
    country: Faker::Address.country,
    zip_code: Faker::Address.zip_code.to_i
  ).save!

  company.build_company_leave_setting(
    leave_month_expiration: Faker::Number.between(6,24),
    leave_month_start: Faker::Number.between(0,12),
    prorate_accrual: true
  ).save!

  leave_type_ids = []

  ['Unpaid','Sick','Vacation','Maternity'].each do |leave_type|
    leave = company.leave_types.build(
      name: leave_type,
      amount: (leave_type == 'Non-paid') ?
        365 :
        Faker::Number.between(10,20)
    )
    leave.save!
    leave_type_ids << leave.id
  end

  2.times do
    hr = User.create!(
      email: Faker::Internet.unique.email,
      password: 'mol123'
    )

    hr.build_profile(
      first_name: Faker::Name.unique.first_name,
      last_name: Faker::Name.unique.last_name
    ).save!

    hr.employments.build(
      start_date: Faker::Date.backward(365*20),
      salary: (Faker::Number.between(15000,2000000)/1000).ceil * 1000,
      acceptance: Faker::Boolean.boolean(0.95),
      company_id: company.id,
      # acceptor_id: acceptor,
      role_id: 1
    ).save!

    8.times do
      employee = User.create!(
        email: Faker::Internet.unique.email,
        password: 'mol123'
      )

      employee.build_profile(
        first_name: Faker::Name.unique.first_name,
        last_name: Faker::Name.unique.last_name
      ).save!

      employments = employee.employments.build(
        start_date: Faker::Date.backward(365*20),
        salary: (Faker::Number.between(15000,2000000)/1000).ceil * 1000,
        acceptance: Faker::Boolean.boolean(0.95),
        company_id: company.id,
        acceptor_id: hr.id,
        role_id: 2
      ).save!

      # 3.times do
      #   start_d = Faker::Date.backward((employments.start_date -
      #     company.company_leave_settings.leave_month_start).days)
      #   end_d = Faker::Date((start_d - Date.today).days)
      #   start_t = Faker::Time.backward(1, :all)
      #   employments.leave_requests.build(
      #     start_date: start_d
      #     end_date: end_d
      #     start_time: start_t
      #     end_time: start_t + (Faker::Number.between(1,8)).hours
      #     allow_weekend_holiday_leave: false
      #     acceptance: true
      #     acceptor_id: hr.id,
      #     leave_type_id: leave_type_ids[Faker::Number.between(1,4)]
      #   ).save!
      #
      #   (start_d - end_d).times do
      #
      #   end
      # end
    end
  end
end

# 50.times do
#   User.create!(
#     email: Faker::Internet.unique.email
#     password: 'mol123'
#   )
#   Profile.create!(
#     first_name: Faker::Name.unique.first_name
#     last_name: Faker::Name.unique.last_name
#     user_id: User.last.id
#   )
#   Employment.create!(
#     start_date: Faker::Date.backward(365*20)
#     salary: (Faker::Number.between(15000,2000000)/1000).ceil * 1000
#     acceptance: Faker::Boolean.boolean(0.95)
#     acceptor_id: Faker::Number.between(1, 20)
#     company_id: Faker::Number.between(1, 20)
#     user_id: User.last.id
#     role_id: ()
#   )
# end

# def create_user(role = nil, company = nil, acceptor = nil)
#   user = User.create!(
#     email: Faker::Internet.unique.email,
#     password: 'mol123'
#   )
#
#   user.build_profile(
#     first_name: Faker::Name.unique.first_name,
#     last_name: Faker::Name.unique.last_name
#   ).save!
#
#   user.employments.build(
#     start_date: Faker::Date.backward(365*20),
#     salary: (Faker::Number.between(15000,2000000)/1000).ceil * 1000,
#     acceptance: Faker::Boolean.boolean(0.95),
#     company_id: company,
#     acceptor_id: acceptor,
#     role_id: role
#   ).save!
#
#   return user
# end
