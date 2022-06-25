class Guest < ApplicationRecord

	validates_uniqueness_of :email
	validates_presence_of 	:first_name, :last_name, :phone, :email
	
end
