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
		@notes['nearest dining'] = 'nearest dining'
		@notes['nearest athletics'] = 'nearest athletics'
		@notes['nearest parking'] = 'nearest parking'
  	end

 	def search
		respond_to do |format|
			@result = []
			@text_d = ""
			if params[:start] != nil && params[:end] != nil && params[:end] != ""
				start_id = 0
				end_id = 0
				if params[:start] != ""
					start_id = (Building.where(name: params[:start]))[0].id.to_i
				else
					lat_lng = cookies[:lat_lng].split("|")
					start_id = WelcomeHelper.nearest_building_id(lat_lng)
					@result.push(lat_lng)
				end
				if params[:end].starts_with? 'nearest'
					if params[:end] == 'nearest dining'
						nodetype = 2
					elsif params[:end] == 'nearest athletics'
						nodetype = 3
					else
						nodetype = 4
					end
					destination_list = Node.where(nodetype: nodetype).pluck(:id)
					print "!!!!!!!!!!!!!!", destination_list
					distMin = Float::INFINITY
					destination_list.each do |d_id|
						path_temp, strs_temp, dist = WelcomeHelper.find_route(start_id, d_id)
						print "&&&&&&&&&&&&&&&", dist
						if dist < distMin
							distMin = dist
							end_id = d_id
						end
					end
				else
					end_id = (Building.where(name: params[:end]))[0].id.to_i
				end
				@result, session[:text_d], distance = WelcomeHelper.find_route(start_id, end_id)
				print @result
			end
			format.js {}
		end
	end

	def send_email
		respond_to do |format|
			UserMailer.directions_email(User.current_user, params[:email], session[:text_d]).deliver
			format.html { render :nothing => true }
		end
	end

	#def select_home
		#building_id = params[:select_home]
		#node = Node.find(building_id)
		#node.latitude, node.longitude
	#end

end
