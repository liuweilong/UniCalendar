<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Form</title>
	<meta name="generator" content="TextMate http://macromates.com/">
	<meta name="author" content="Liu Weilong">
	<!-- Date: 2014-01-26 -->
</head>
<body>
	<?php

	$host = "localhost"; //Your database host server
	$db = "apprevol_calendar"; //Your database name
	$user = "apprevol_cal"; //Your database user
	$pass = "LWL19930415q"; //Your password
	
	$connection = mysql_connect($host, $user, $pass);
	
	//Check to see if we can connect to the server
	if(!$connection)
	{
		die("Database server connection failed.");	
	}
	else
	{
		//Attempt to select the database
		$dbconnect = mysql_select_db($db, $connection);
		
		//Check to see if we could select the database
		if(!$dbconnect)
		{
			die("Unable to connect to the specified database!");
		} 
		else
		{
			$query = "SELECT * FROM unicalendar";
			$resultset = mysql_query($query, $connection);
			
			$records = array();
			
			//Loop through all our records and add them to our array
			while($r = mysql_fetch_assoc($resultset))
			{
				$records[] = $r;		
			}
			
			//Output the data as JSON
			echo json_encode($records);
		}		
	}
	?>
	<pre>
		<?php  
		$title = $_POST["title"];
		$discription = $_POST["discription"];
		$startdate = $_POST["startdate"];
		$enddate = $_POST["enddate"];
		$allday = (int)$_POST["allday"];

		$query = "INSERT INTO unicalendar(title, discription, startDate, endDate, allday)
					VALUE (\"{$title}\", \"{$discription}\", \"{$startdate}\", \"{$enddate}\", {$allday});";
		echo $query;
		mysql_query($query, $connection);
		?>
	</pre>
</body>
</html>
