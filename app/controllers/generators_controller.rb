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
	def download
    	send_file 'app/assets/data/database_connect.php', :type=>"application/php"
  	end
	def form
		@input_code = params[:input_code]
		@database_name = params[:database_name]
		@table_name = params[:table_name]
		@database_attr = params[:database_attr]
		@cond = params[:cond]
		@query_type=params[:query_type]
		input_array = Array.new
		@output_array = Array.new
		@input_code.to_s.try(:split, "\n").each do |i|
			each_element = i.try(:split, /[<>\s]/)
			input_array.push each_element
		end
		input = @input_code.to_s.length > 1
		name = ''
		input_array.each do |each_element|
			name = each_element.to_s .eql? ["", "/form"].to_s
		end
		if !name
			@output_array.push "Please paste a valid code"
		elsif input && @query_type.to_s.length > 2
			@output_array.push "<?php"
			@output_array.push "\tinclude(database_connect.php);"
		elsif @query_type.to_s.length < 2 || !input
			@output_array.push "Please paste a code and must select any query type."			
		end


		counter = 0
		value_of_attribute = Array.new

		if (@query_type .eql? "Insert") && input
			@output_array.push "\tif ( isset( $_POST['submit'] ) ){"
			@output_array, counter, value_of_attribute, radiocounter = get_attributes(counter, value_of_attribute, input_array)
			sql_input = input_query(counter, value_of_attribute, radiocounter, @database_name, @table_name, @database_attr)
			@output_array.push sql_input.to_s
			if input
				@output_array.push "\t\tmysqli_query($dbconnect, $sql);"
				@output_array.push "\t}"
				@output_array.push "?>"
			end
		elsif @query_type .eql? 'Update' && input
			@output_array.push "\tif ( isset( $_POST['update'] ) ){"
			@output_array, counter, value_of_attribute, radiocounter = get_attributes(counter, value_of_attribute, input_array)
			sql_update = update_query(counter, value_of_attribute, radiocounter, @database_name, @table_name, @database_attr, @cond)
			@output_array.push sql_update.to_s
			if input
				@output_array.push "\t\tmysqli_query($dbconnect, $sql);"
				@output_array.push "\t}"
				@output_array.push "?>"
			end
		elsif (@query_type. eql? "Delete") && input
			@output_array.push "\tif ( isset( $_POST['delete'] ) ){"
			sql_delete = delete_query(@database_name, @table_name, @cond)
			@output_array.push sql_delete.to_s
			if input
				@output_array.push "\t\tmysqli_query($dbconnect, $sql);"
				@output_array.push "\t}"
				@output_array.push "?>"
			end
		elsif @query_type.eql? 'Complete-CRUD' && input
			@output_array.push "\t if (isset($_POST['submit'])){"
			@output_array, counter, value_of_attribute, radiocounter =  get_attributes(counter, value_of_attribute, input_array)
			sql_input = input_query(counter, value_of_attribute, radiocounter, @database_name, @table_name, @database_attr)
			@output_array.push sql_input.to_s
			sql_update = update_query(counter, value_of_attribute, radiocounter, @database_name, @table_name, @database_attr, @cond)
			@output_array.push sql_update.to_s
			sql_delete = delete_query(@database_name, @table_name, @cond)
			@output_array.push sql_delete.to_s
			if input
				sql_select = select_query(@database_name, @table_name, @database_attr, @cond)
				@output_array.push sql_select
				@output_array.push "\t\tmysqli_query($dbconnect, $sql);"
				@output_array.push "\t\twhile($row = mysqli_fetch_array($result)){"
				if @database_attr.to_s.length > 0
					attributes = select_attributes(@database_attr).to_s + ";" 	
					@output_array.push attributes
				else
					@output_array.push "\t\techo $row['attribute_1'].$row['attribute_2']...$row['attribute_n'];"
				end
				@output_array.push "\t}"
				@output_array.push "?>"
			end
		else
			if input
				sql_select = select_query(@database_name, @table_name, @database_attr, @cond)
				@output_array.push sql_select
				@output_array.push "\tmysqli_query($dbconnect, $sql);"
				@output_array.push "\twhile($row = mysqli_fetch_array($result)){"
				if @database_attr.to_s.length > 0
					attributes = select_attributes(@database_attr).to_s + ";" 	
					@output_array.push attributes
				else
					@output_array.push "\t\techo $row['attribute_1'].$row['attribute_2']...$row['attribute_n'];"
				end
				@output_array.push "\t}"
				@output_array.push "?>"
			end
		end
		respond_to do |format|
		 	format.html
		 	format.js	
		end		
	end
end
