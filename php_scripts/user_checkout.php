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
		$due= strtotime("1 week");
		// This is a multi-line SQL statement that reduces the count of books available at the library and creates a checkout value.
		$sql = "UPDATE `Books` SET `bookcount` = 'bookcount-1' WHERE `Books`.`isbn` = {$int}; 
		INSERT INTO `CheckedOut` (`transaction_id`, `isbn`, `user_id`, `start`, `isOut`, `due`) VALUES (NULL, '{$int}', '1', NULL, '{$user}', '{$due}');";
		// Run prepared statement
		$success = mysqli_multi_query($con, $sql);
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