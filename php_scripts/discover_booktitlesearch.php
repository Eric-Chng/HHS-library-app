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
	if (!isset($_POST[textquery])) {
		echo "No query passed in";
	} 
	else {
		$int =$_POST[textquery];
		// This SQL statement selects ALL from the table 'Books' where text matches with a natural language SQL search
		$sql = "SELECT * FROM Books
        WHERE MATCH (name)
        AGAINST ('{$int}' IN NATURAL LANGUAGE MODE);";
		 
		// Check if there are results
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