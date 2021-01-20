<html>
<head>
	 <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
	 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>

	 <style>
body {
  background-image: url('3.2.jpg');
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
          <a class="nav-link active" aria-current="page" href="3_2.php"><div class="d-grid gap-2">
													<button type="button" class="btn btn-outline-dark">3.2</button>
													</div></a>
        </li>
		
		  <li class="nav-item">
          <a class="nav-link active" aria-current="page" >
																	<div class="btn-group" role="group" aria-label="Basic outlined example">
																	<form action = "3_2.html">
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



<?php
		
	$locuri=$_POST['locuri'];
	$locuri= trim($locuri);

		if (!$locuri)
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
	
	$dsn= new mysqli( $host, $user, $pass, $db_name);
	
	///verificam daca am reusit conexiunea la baza de date
	if ($dsn->connect_error)
	{
		die('Eroare la conectare:'. $dsn->connect_error);
	}
	
	///apelam interogarea
	$query = 'SELECT aparat_zbor, nr_locuri FROM Zboruri WHERE nr_locuri>'.$locuri.' ORDER BY nr_locuri';
	$result = mysqli_query($dsn,$query);
	
	if (!$result)
	{
		die('Interogare gresita :'.mysqli_error($dsn));
	}
	
	///afisam tabelul
	echo '  <Table style = " margin-left: auto;  margin-right: auto;  width:60%"   class="table table-primary table-striped table-hover text-center "   >
	<tr>
		<th>APARAT ZBOR</th>
		<th>NUMAR LOCURI</th>

	</tr>'; 

	$randuri = mysqli_num_rows($result);
	
	for ($i=0; $i < $randuri; $i++)
	{
		echo '<tr>';
	    $row = mysqli_fetch_assoc($result);
		echo '<td align="center">'.htmlspecialchars(stripslashes($row['aparat_zbor'])).'</td>';
		echo '<td align="center">'.stripslashes($row['nr_locuri']).'</td>';
	
		echo '</tr>';
	}
	///deconectarea de la baza de date
	mysqli_close($dsn);
?>

<p class="aligncenter">
    <img src="img3.gif" alt="centered image"  style = " display: block; margin-left: auto;  margin-right: auto; " />
</p>
</body>
</html>