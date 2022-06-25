module Api
	module V1
		class ReservationsController < ApplicationController

			def index
				reservations = Reservation.order('start_date DESC');

				render json: {status:'success', data:reservations}, status: :ok
			end

			def show
				reservation = Reservation.find(params[:id])
				render json: {status:'success', data:reservation}, status: :ok
			end

			def create
				# RESERVATION DETAILS
				
				if params[:reservation].has_key?(:guest_details)
					params["reservation_code"] = params[:reservation].delete(:code)
					params["guests"]		   = params[:reservation].delete(:number_of_guests)
					params["adults"]		   = params[:reservation][:guest_details].delete(:number_of_adults)
					params["children"]		   = params[:reservation][:guest_details].delete(:number_of_children)
					params["infants"]          = params[:reservation][:guest_details].delete(:number_of_infants)
					params["payout_price"]	   = params[:reservation].delete(:expected_payout_amount)
					params["security_price"]   = params[:reservation].delete(:listing_security_price_accurate)
					params["currency"] 		   = params[:reservation].delete(:host_currency)
					params["status"]		   = params[:reservation].delete(:status_type)
					params["total_price"]      = params[:reservation].delete(:total_paid_amount_accurate)
					params["start_date"]	   = params[:reservation].delete(:start_date)
					params["end_date"]         = params[:reservation].delete(:end_date)
					params["nights"]		   = params[:reservation].delete(:nights)

					puts "hey #{params}"
				end

				reservation = Reservation.new(reservation_params)
				@errors = []

				if reservation.save
					guest = Guest.new

					if params.has_key?(:guest)
						guest.first_name = params[:guest][:first_name]
						guest.last_name  = params[:guest][:last_name]
						guest.phone 	 = params[:guest][:phone]
						guest.email 	 = params[:guest][:email]

					elsif params[:reservation].has_key?(:guest_details)
						guest.first_name = params[:reservation][:guest_first_name]
						guest.last_name  = params[:reservation][:guest_last_name]
						guest.phone 	 = params[:reservation][:guest_phone_numbers]
						guest.email 	 = params[:reservation][:guest_email]
					end

					if guest.save
						render json: {status: 'created', data:reservation, include:guest}, status: :created
					else
						@errors << guest.errors.full_messages.to_sentence
					end
				else
					@errors << reservation.errors.full_messages.to_sentence

					render json: {status: "error - #{@errors.to_s}"}, status: :unprocessable_entity
				end
			end

			def update
				reservation = Reservation.find(params[:id])
		        passed_params = reservation_params.as_json

		        if reservation && reservation.update_attributes(passed_params) 
		            render json: {status:'success', data:reservation}, status: :ok
		        else
		            render json: {:error => (reservation.errors.full_messages)}, :status => "404"
		        end
		    end


			private
				def reservation_params
					params.permit(:reservation_code, :start_date, :end_date, :guests, :nights, :adults, :children, :infants,
						:status, :currency, :payout_price, :security_price, :total_price, :guest_details)
				end
		end
	end
end