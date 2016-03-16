class Country < ActiveRecord::Base
	has_many :phone_numbers
	has_many :profiles

  def self.default_country
    Country.find_by(name: GlobalConstants::DEFAULT_COUNTRY)
  end

end

