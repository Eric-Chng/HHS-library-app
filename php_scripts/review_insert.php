<?php
 
// Create connection
$con=mysqli_connect("www.the-library-database.com","thelibs8_dbadmin","eric-david","thelibs8_MADlibrary");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL1: " . mysqli_connect_errno();
}

if ($_POST[password] == "1234")
{
	echo "Verification Failed: Incorrect Password";
} else {
	if (!isset($_POST[userid])) {
		echo "No id passed in";
	} 
	else {
		$int =$_POST[userid];
	    $inttwo=$_POST[isbn];
		$rating=$_POST[rating];
		$text = "";
		//Verifies if any text info was submitted
		if (isset($_POST[text])) {
			$text = $_POST[text];
		}
		// This SQL statement creates a review with the data passed in from the POST statement
		$sql = "INSERT INTO `Reviews` (`id`, `user_id`, `isbn`, `rating`, `text`) VALUES (NULL, {$int}, {$inttwo}, {$rating}, '{$text}');";
		 
		// Check if there are results
		if ($result = mysqli_query($con, $sql))
		{
		    echo "script success";
		}
		else {
		    echo "script failure";
		}
	}
}
 
// Close connections
mysqli_close($con);
?>