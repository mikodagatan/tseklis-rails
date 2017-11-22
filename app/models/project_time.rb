class ProjectTime < ApplicationRecord
  belongs_to :onboarding, required: false
  belongs_to :project
  has_one :employment, through: :onboarding
  # has_one :project, through: :onboarding
  has_one :user, through: :employment
  has_one :company, through: :project
  has_one :department, through: :project
  has_one :client, through: :project

  validates_presence_of :project_id, :onboarding_id, required: false

  validate :duration_input

  scope :for_client, -> (client) {
     joins(project: :client)
     .where("projects.client_id = ?", client.id)
     .references(:clients)
  }

  scope :for_date, -> (start_date, end_date) {
      where("project_times.date between ? and ?", start_date.to_date.strftime("%Y/%m/%d"), end_date.to_date.strftime("%Y/%m/%d"))
    }

  scope :this_month, -> {
      where("project_times.date between ? and ?", Time.zone.now.at_beginning_of_month,
      Time.zone.now.at_end_of_month)
  }

  def duration_input
    if duration <= 0
      errors.add(:duration, "duration bad")
    end
  end
end
