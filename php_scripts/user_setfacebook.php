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
		$inttwo=$_POST[facebookid];
		// This SQL statement updates a user's facebook id for facebook social media integration
		$sql = "UPDATE `Members` SET `facebookid` = {$inttwo} WHERE `Members`.`user_id` = {$int};";
		 
		// Check if there are results
		if ($result = mysqli_query($con, $sql))
		{
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