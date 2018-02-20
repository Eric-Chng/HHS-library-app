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
	if (!isset($_POST[id])) {
		echo "No id passed in";
	} 
	else {
		$int =$_POST[id];
		// This SQL statement sets a hold to be ready when a hold is available for pickup
		$sql = "UPDATE `Holds` SET `ready` = '1' WHERE `Holds`.`hold_id` = {$int};";
		 
		// Check if there are results
		$success = mysqli_query($con, $sql);
		if ($success) {
		    echo "script success";
		}
		else {
		    echo "script failed";
		}
	}
}
 
// Close connections
mysqli_close($con);
?>