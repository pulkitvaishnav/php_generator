<?php
		
		$dbserver = "<Database_server_name>";
		$dbname = "<Database_name>";
		$username = "<Database_username>";
		$password = "<Database_password>";
		$error = "Can't connect";
		$dbconnect = mysqli_connect($dbserver, $username, $password, $dbname) or die('Connection error');
?>