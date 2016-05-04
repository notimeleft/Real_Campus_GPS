require './lib/map.rb'

class WelcomeController < ApplicationController

  	def index
		@result = []
		@text_d = ""
    	name_list = Building.order(:name).pluck(:id, :name)
    	@notes = {}
    	name_list.sort_by{|id, name| name}.each do |id, name|
      		@notes[name] = name
		end
  	end

 	def search
		respond_to do |format|
			@result = []
			@text_d = ""
			if params[:start] != nil && params[:end] != nil && params[:end] != ""
				if params[:start] != ""
					start_id = (Building.where(name: params[:start]))[0].id.to_i
				else
					lat_lng = cookies[:lat_lng].split("|")
					start_id = WelcomeHelper.nearest_building_id(lat_lng)
					@result.push(lat_lng)
				end
				end_id = (Building.where(name: params[:end]))[0].id.to_i
				@result, session[:text_d] = WelcomeHelper.find_route(start_id, end_id)
			end
			format.js {}
		end
	end

	def send_email
		respond_to do |format|
			email_address = params[:email]
			UserMailer.directions_email(User.current_user, email_address, session[:text_d]).deliver
			format.html { render :nothing => true }
		end
	end

	#def select_home
		#building_id = params[:select_home]
		#node = Node.find(building_id)
		#node.latitude, node.longitude
	#end

end
