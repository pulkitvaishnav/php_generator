#############################################################################
####### This method takes input from user and split it into array ###########
#############################################################################
def input_code
	print "Enter your bootstrap code: "
 	$/ = "</form>" 						# Works as EOF
	user_input = STDIN.gets
	user_input = user_input.split("\n") # String convert into array
	input_array = Array.new
	user_input.each do |i|
		each_element = i.split(/[<>\s]/) # Split array by <, > and space
		input_array.push each_element
	end
	return input_array
	
end
######################################################
####### This method generate INSERT query  ###########
######################################################
def insert_query(value_of_attribute, counter)
	intial_query = "\t\tINSERT INTO `<database_name>`.`<table_name>`"
	no_of_attribute = "("
	for i in 0..counter-1
		if i < counter-1
			no_of_attribute= no_of_attribute + "`attribute_#{i+1}`, "	
		else
			no_of_attribute= no_of_attribute + "`attribute_#{i+1}`"
		end
		
	end
	no_of_attribute = no_of_attribute + ") "
	values_for_attributes = "VALUES("
	len= value_of_attribute.length
	for i in 0..len - 1
		if i < len - 1
			values_for_attributes = values_for_attributes + "'$#{value_of_attribute[i]}', "
		else
			values_for_attributes = values_for_attributes + "'$#{value_of_attribute[i]}'"
		end
	end
	values_for_attributes = values_for_attributes + ");"
	sql = intial_query + no_of_attribute + values_for_attributes
	puts sql
end
#########################################################################
####### This method generate PHP code from the Bootstrap code ###########
#########################################################################
def generate_php_code(input_array)
	input_array.each do |each_element|
		if each_element.include?('button')
			#if each_element.include?('type="submit"')
				puts "<?php \n\tinclude(database_connect.php);"
				puts "\tif(isset($_POST['submit'])){"
			#end
		end
	end
	counter = 0
	value_of_attribute = Array.new
	input_array.each do |each_element|
		name = each_element.select{|type| type.match(/name=.*/)}
		if name
			#$input = $_POST['input'];
			if name.length >= 1
				name = name.to_s
				name = name.slice(6 .. -2)
				value_of_attribute.push name
				puts "\t\t$#{name} = $_POST['#{name}'];"
				counter = counter + 1
			end
		end
	end
	insert_query(value_of_attribute, counter)
	puts "\t\tmysqli_query($dbconnect, $sql);"
	puts "\t}"
	puts "?>"
end

###############################
####### Main Method ###########
###############################

	input = input_code()
	generate_php_code(input)

	
			
	
