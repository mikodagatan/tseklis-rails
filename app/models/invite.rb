class Invite < ActiveRecord::Base
  belongs_to :company
  belongs_to :sender, :class_name => 'User', foreign_key: :sender_id
  belongs_to :recipient, :class_name => 'User', foreign_key: :recipient_id, required: false

  before_save :check_user_existence
  before_create :generate_token
  # validates :email, uniqueness: true

  def generate_token
   self.token = Digest::SHA1.hexdigest([self.company_id, Time.now, rand].join)
  end

   def check_user_existence
      recipient = User.find_by_email(email)
     if recipient
        self.recipient_id = recipient.id
     end
   end
end
