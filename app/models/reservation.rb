class Reservation < ApplicationRecord

	validates_uniqueness_of :reservation_code
	validates_presence_of   :reservation_code

end