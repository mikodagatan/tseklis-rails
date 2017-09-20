class Profile < ApplicationRecord
  belongs_to :user

  validates_presence_of :first_name
  validates_presence_of :last_name

  def self.text_search(query)
    if query.present?
      where("name @@ :q", q: query)
    else
      scoped
    end
  end

  include PgSearch

  pg_search_scope :search_for, against: %i(first_name last_name)
  multisearchable against: %i(first_name last_name)

end
