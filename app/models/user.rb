# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  jti                    :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("customer"), not null
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Tokenizable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable, 
         :devise,
         :validatable,
         :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self

  enum role: %i[customer admin]

  validates :email, presence: true
  validates :email, length: { maximum: 255 }
  validates :email, format: { with: Regex::Email::VALIDATE }

  after_initialize :setup_new_user, if: :new_record?

  has_many :triggers
  has_and_belongs_to_many :sportsbooks


  # Send mail through activejob
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private 

  def setup_new_user
    self.role ||= :customer
    self.sportsbooks << Sportsbook.find_by_name('BetOnline')
    self.sportsbooks << Sportsbook.find_by_name('Bookmaker')
  end

end
