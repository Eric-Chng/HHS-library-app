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
		$user =$_POST[transaction_id];
		// This is a multi-line SQL statement that does a variety of options to process the return of a book. Checkout history is stored to allow for recommendation algorithms to learn about a user's preferences.
		$sql = "UPDATE `Books` SET `bookcount` = bookcount+1 WHERE `Books`.`isbn` = {$int};
		UPDATE `CheckedOut` SET `isOut` = '0' WHERE `CheckedOut`.`transaction_id` = {$user};";
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