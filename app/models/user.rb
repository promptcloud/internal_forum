class User < ApplicationRecord
  validates :display_name, presence: true, uniqueness: true
  before_validation :uniq_display_name!, on: :create
  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@promptcloud\.com\z/, message: "must be a promptcloud.com account" }

  def display_name=(value)
    super(value ? value.strip : nil)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :ldap_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  def authenticatable_salt
    Digest::SHA1.hexdigest(email)[0,29]
  end

  private

  # Makes the display_name unique by appending a number to it if necessary.
  # "Gleb" => Gleb 1"
  def uniq_display_name!
    self.display_name = display_name ? display_name : email.split('@').first.downcase
    if display_name.present?
      new_display_name = display_name
      i = 0
      while User.exists?(display_name: new_display_name)
        new_display_name = "#{display_name} #{i += 1}"
      end
      self.display_name = new_display_name
    end
  end
end
