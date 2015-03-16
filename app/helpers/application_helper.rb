module ApplicationHelper
	def input_query(counter, value_of_attribute, radiocounter, database_name, table_name, database_attr)
			if database_name.to_s.length > 0 && table_name.to_s.length > 0
				intial_query = "INSERT INTO `#{database_name}`.`#{table_name}`"
			elsif table_name.to_s.length > 0 && database_name.to_s.length < 1 
				intial_query = "INSERT INTO `<database_name>`.`#{table_name}`"
			elsif table_name.to_s.length < 1 && database_name.to_s.length > 0
				intial_query = "INSERT INTO `#{database_name}`.`<table_name>`"
			else
				intial_query = "INSERT INTO `<database_name>`.`<table_name>`"
			end
			no_of_attribute = "("
			no_of_attribute = attributes_name(database_name, table_name, database_attr, counter, radiocounter, no_of_attribute)
			no_of_attribute = no_of_attribute + ") "
			values_for_attributes = "VALUES("
			len = value_of_attribute.length
			for i in 0..len - 1
				if i < len - 1
					values_for_attributes = values_for_attributes + "'$#{value_of_attribute[i]}', "
				else
					values_for_attributes = values_for_attributes + "'$#{value_of_attribute[i]}'"
				end
			end
			#no_of_attribute = attributes_name(database_name, table_name, database_attr, counter, no_of_attribute)
			values_for_attributes = values_for_attributes + ");"
			return sql = "\t\t$sql = " + intial_query + no_of_attribute + values_for_attributes
			
	end
	def get_attributes(counter, value_of_attribute, input_array)
		radiocounter = 0
		input_array.each do |each_element|
			name = each_element.select{|type| type.match(/name=.*/)}
			if name.length >= 1
				name = name.to_s.slice(9 .. -5)
				if each_element.select{|type| type.match(/name=radio.*/)}
					radiocounter = radiocounter + 1
				end
				if !(name .eql? "submit") && !(name.match(/\w*button\b/))
					value_of_attribute.push name
					@output_array.push "\t\t$#{name} = $_POST['#{name}'];"	
					counter = counter + 1
				else
				 	break
			 	end
			end
		end
		return @output_array, counter, value_of_attribute, radiocounter
	end
	def attributes_name(database_name, table_name, database_attr, counter, radiocounter, no_of_attribute)
	 	if database_attr.to_s.length > 0
	 		database_attr.to_s.try(:split, ",").each_with_index do |element, index|

	 			if index < counter-1 	
	 				no_of_attribute = no_of_attribute + "`#{element}`, "
	 			else
	 				no_of_attribute = no_of_attribute + "`#{element}`"
	 			end

	 		end
	 	else
	 		for i in 0..counter-1
	 			if i < counter-1
	 				no_of_attribute= no_of_attribute + "`attribute_#{i+1}`, "	
	 			else
	 				no_of_attribute= no_of_attribute + "`attribute_#{i+1}`"
	 			end
				
	 		end
	 	end
	 	return no_of_attribute
	end
	def update_query(counter, value_of_attribute, radiocounter, database_name, table_name, database_attr, cond)
		#UPDATE  `xyz`.`APPLE_PRODUCT` SET  `model` =  'i-pad' WHERE  `APPLE_PRODUCT`.`s_no` =1;
		no_of_attribute = ""
		if database_name.to_s.length > 0
				intial_query = "UPDATE `#{database_name}`.`#{table_name}` SET "
		else
				intial_query = "UPDATE `<database_name>`.`<table_name>` SET "
		end
		if database_attr.to_s.length > 0
			database_attr.to_s.try(:split, ", ").zip(value_of_attribute.to_a).each_with_index do |element, index|
				if index < counter-1
					no_of_attribute = no_of_attribute + "`#{element[0]}` = '#{element[1]}', "
				else
					no_of_attribute = no_of_attribute + "`#{element[0]}`= #{element[1]}"
				end

		 	end
		else
			value_of_attribute.each_with_index do |values_for_attributes, index|
				if index<counter-1
					no_of_attribute = no_of_attribute + "`attribute_#{index}` = '#{values_for_attributes}', "
				else
					no_of_attribute = no_of_attribute + "`attribute_#{index}` = '#{values_for_attributes}'"
				end
			end
		end
		condition = where_cond(cond)
		
		return sql = "\t\t$sql = " + intial_query + no_of_attribute + condition.to_s
	end
	
	def delete_query(database_name, table_name, cond)
		no_of_attribute = ""
		if database_name.to_s.length > 0 && table_name.to_s.length > 0
			intial_query = "DELETE `#{database_name}`.`#{table_name}` FROM "
		elsif table_name.to_s.length > 0 && database_name.to_s.length < 1 
			intial_query = "DELETE `<database_name>`.`#{table_name}`"
		elsif table_name.to_s.length < 1 && database_name.to_s.length > 0
			intial_query = "DELETE `#{database_name}`.`<table_name>`"				
		else
			intial_query = "DELETE `<database_name>`.`<table_name>` FROM "
		end
		where = where_cond(cond)
		return "\t\t$sql = " + intial_query + where 

	
	end
	def select_query(database_name, table_name, database_attr, cond)
		if database_attr.to_s.length > 0
			intial_query ="\t$sql = SELECT " + database_attr + " FROM " +"table_name" + where_cond(cond).to_s		
		else
			intial_query ="\t$sql =  SELECT " + " * " + " FROM " +"table_name" + where_cond(cond).to_s
		end
		
	end
	def select_attributes(database_attr)
		element = "\techo "
		database_attr.to_s.try(:split, ", ").each do |element|
			element = element + "$row['#{element}'] ."
		end
		element = element.to_s.slice(-1)
		return element
	end
	def where_cond(cond)
		if cond.to_s.length > 0
			return " WHERE #{cond};"
		else
			return " WHERE <condition>;"
		end
	end
	def execute_query(input)
		if input
			@output_array.push "\t\tmysqli_query($dbconnect, $sql);"
			@output_array.push "\t}"
			@output_array.push "?>"
		end
	end
end

