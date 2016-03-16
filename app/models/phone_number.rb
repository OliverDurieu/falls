class PhoneNumber < ActiveRecord::Base
	belongs_to :user
	belongs_to :country

  # validates :body, uniqueness: true
  validates :body,:presence => true,
                 :numericality => true,
                 :length => { :minimum => 7, :maximum => 15 }

	def get_country
		self.country_id.present? ? self.country : Country.default_country
	end

  def public?
    self.public_status != 1
  end

end
