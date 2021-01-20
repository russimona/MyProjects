<html>
<head>
	 <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
	 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>

	 <style>
body {
  background-image: url('5.1.jpg');
  background-repeat: no-repeat;
  background-attachment: fixed;
  background-size: 100% 100%;
}
</style>

</head>
<body>


<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
    <a class="navbar-brand" href="meniu_principal.html">Zboruri</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="5_1.php"><div class="d-grid gap-2">
													<button type="button" class="btn btn-outline-dark">5.1</button>
													</div></a>
        </li>
		
		  <li class="nav-item">
          <a class="nav-link active" aria-current="page" >
																	<div class="btn-group" role="group" aria-label="Basic outlined example">
																	<form action = "5_1.html">
																	<button type="submit" class="btn btn-outline-dark">BACK</button>
																	</form>
																	<form action = "meniu_principal.html" >
																	<button type="submit" class="btn btn-outline-dark">HOME</button>
																	</form>
																	</div></a>
        </li>
		
		</li>
		
		
		
      </ul>
    </div>
  </div>
</nav>

<p class="aligncenter">
    <img src="img3.gif" alt="centered image"  style = " display: block; margin-left: auto;  margin-right: auto; " />
</p>

<?php
	
		
	$clasa_efectiva=$_POST['clasa_efectiva'];
	$clasa_efectiva= trim($clasa_efectiva);
	
		if (!$clasa_efectiva)
	{
			echo 'Nu ati introdus criteriul de cautare. Va rog sa incercati din nou.';
			exit;
	}
	///incercam conexiunea la baza de date
	require_once('PEAR.php');
	$user = 'student';
	$pass = 'student123';
	$host = 'localhost';
	$db_name = 'zboruri';
	
	$dsn = new mysqli( $host, $user, $pass, $db_name);
	
	///verificam daca am reusit conexiunea la baza de date
	if ($dsn->connect_error)
	{
		die('Eroare la conectare:'. $dsn->connect_error);
	}

	
	
	
	

	///apelam interogarea
	/*
	$query = 'SELECT nume
			  FROM clienti NATURAL JOIN Bilete
			  WHERE clasa=\'Business\' AND valoare<=ALL(SELECT valoare FROM bilete WHERE clasa=\'Business\')';
	$result = mysqli_query($dsn,$query);
	
	if (!$result)
	{
		die('Interogare gresita :'.mysqli_error($dsn));
	}
	
	///afisam tabelul
	echo ' <Table style = "width:60%">
	<tr>
		<th>Nume</th>
	</tr>'; 

	$randuri = mysqli_num_rows($result);
	
	for ($i=0; $i < $randuri; $i++)
	{
		echo '<tr>';
	    $row = mysqli_fetch_assoc($result);
		echo '<td align="center">'.htmlspecialchars(stripslashes($row['nume'])).'</td>';
	}
	*/
	if ( $clasa_efectiva != 'Business' and $clasa_efectiva != 'Economic' ){
	echo ' <div class = "container" >  <div class="alert alert-primary text-center" role="alert"> Clasa efectiva nu exista. Va rugam sa introduceti una dintre clasele existente!  </div> </div>';  

	exit;
	}

	$query = "call Proc5_1('".$clasa_efectiva."')";
	
	//$empty= 0;
    //$stmt = $dsn->prepare ("call Proc5_1()");
    //$stmt->bind_Param("i",$empty);
    //$stmt -> execute();
    //$result = $stmt->get_result();
   
   $result = mysqli_query($dsn, $query);
   
    $row = mysqli_fetch_array($result);
    // verifică dacă rezultatul este în regulă
    if (!$result)
    { 
     	die('Interogare gresita :'.mysqli_error($dsn));
    }
    echo 
		' <div class = "container" >  <div class="alert alert-primary text-center" role="alert"> Numele clientului care are valoarea cea mai mica intre biletele din clasa ceruta este :  '.htmlspecialchars(stripslashes($row[0])).'</div> </div>'; 
	
	
	///deconectarea de la baza de date
	mysqli_close($dsn);
?>
</body>
</html>