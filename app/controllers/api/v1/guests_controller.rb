module Api
	module V1
		class GuestsController < ApplicationController

			def index
				guests = Guest.order('start_date DESC');

				render json: {status:'success', data:guests}, status: :ok
			end

			def show
				guest = Guest.find(params[:id])
				render json: {status:'success', data:guest}, status: :ok
			end

			def create
				guest = Guest.new(guest_params)
					
				if guest.save
					render json: {status: 'created', data:guest}, status: :created
				else
					render json: {status: "error - #{guest.errors.full_messages.to_sentence}"}, status: :unprocessable_entity
				end
			end

			def update
				guest = guest.find(params[:id])
		        passed_params = guest_params.as_json

		        if guest && guest.update_attributes(passed_params) 
		            render json: {status:'success', data:guest}, status: :ok
		        else
		            render json: {:error => (guest.errors.full_messages)}, :status => "404"
		        end
		    end

			private
				def guest_params
					params.permit(:first_name, :last_name, :phone, :email)
				end
		end
	end
end