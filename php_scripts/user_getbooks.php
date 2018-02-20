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
		$user =$_POST[userid];
		// This SQL statement returns all the checkouts currently held by a certain user
		$sql = "SELECT * FROM `CheckedOut` WHERE user_id={$user} AND isOut!=0;";
		// Run prepared statement
		if ($result = mysqli_query($con, $sql))
		{
			// If so, then create a results array and a temporary one
			// to hold the data
			$resultArray = array();
			$tempArray = array();
		 
			// Loop through each row in the result set
			while($row = $result->fetch_object())
			{
				// Add each row into our results array
				$tempArray = $row;
			    array_push($resultArray, $tempArray);
			}
		 
			// Finally, encode the array to JSON and output the results
			echo json_encode($resultArray);
		}
	}
}
 
// Close connections
mysqli_close($con);
?>