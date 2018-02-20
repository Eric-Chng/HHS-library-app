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
	if (!isset($_POST[isbn])) {
		echo "No id passed in";
	} 
	else {
		$int =$_POST[isbn];
		$user =$_POST[user];
		// This SQL statement creates a hold with the values passed in from the POST statement
		$sql = "INSERT INTO `Holds` (`hold_id`, `user_id`, `isbn`, `timestart`, `ready`) VALUES (NULL, '{$user}', '{$int}', CURRENT_TIMESTAMP, '0');";
		// Run prepared statement
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