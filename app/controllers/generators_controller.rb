class GeneratorsController < ApplicationController
	include ApplicationHelper
	def index
		
	end
	def create
	end
	def show
	end
	def new
		
	end
	def form
		@name = params[:name]
		@database_name = params[:database_name]
		@table_name = params[:table_name]
		@database_attr = params[:database_attr]
		input_array = Array.new
		@output_array = Array.new
		@name.to_s.try(:split, "\n").each do |i|
			each_element = i.try(:split, /[<>\s]/)
			input_array.push each_element
		end
		input_array.each do |each_element|
			@output_array.push "<?php"
			@output_array.push "\tinclude(database_connect.php);"	
			if each_element.select{|type| type.match(/button=.*/)}
				@output_array.push "\tif(isset($_POST['submit'])){"
				break;
			end
		end
		counter = 0
		value_of_attribute = Array.new		
		@output_array, counter, value_of_attribute, radiocounter = get_attributes(counter, value_of_attribute, input_array)
		sql = input_query(counter, value_of_attribute, radiocounter, @database_name, @table_name, @database_attr)
		
		if @name.to_s.length > 0
			@output_array.push sql.to_s
			@output_array.push "\t\tmysqli_query($dbconnect, $sql);"
			@output_array.push "\t}"
			@output_array.push "?>"
		end
	end
end
