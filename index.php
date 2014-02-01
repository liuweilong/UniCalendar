<?php
class RedeemAPI {
	private $connection;
	private $hostname = 'localhost';
	private $username = 'apprevol_cal';
	private $password = 'LWL19930415q';
	private $database = 'apprevol_calendar';
	

	// function __construct() {
	// 	$this->connection = mysqli_connect($this->hostname, $this->username, $this->password, $this->database);	
	// 	if(mysqli_connect_errno()) {
	// 		die("Database connection failed: " . 
	// 			mysqli_connect_error() . 
	// 			" (" . mysqli_connect_errno() . ")"
	// 			);
	// 	}
	// }

	// function __destruct() {
	// 	if ($this->connection != null) {
	// 		$this->connection->close();
	// 	}
	// }

	function redeem() {
		$mysqli = new mysqli($this->hostname, $this->username, $this->password, $this->database);
		$query = 'SELECT id, code, unlock_code, uses_remaining FROM rw_promo_code';
		$result = $mysqli->query($query) or die($mysqli->error);
		$data = array();

		while ( $row = $result->fetch_assoc() ){
			$data[] = json_encode($row);
		}
		echo json_encode( $data );
		// $result = mysqli_query($this->connection, $query);
		// //Test if there is a query error
		// if (!$result) {
		// 	die("Database query failed.");
		// }
		// $json = array();
		// while ($row = mysqli_fetch_assoc($result)) {
		// 	$id = $row["id"];
		// 	$code = $row["code"];
		// 	$unlock_code = $row["unlock_code"];
		// 	$uses_remaining = $row["uses_remaining"];
		// 	$json[] = '{ id: '.$id.', code :'.$code.', unlock_code : '.$unlock_code.', uses_remaining : '.$uses_remaining.'}';
		// }
		// echo json_encode($json);
		// mysqli_free_result($result);
	}

}

$api = new RedeemAPI;
$api->redeem();
?>