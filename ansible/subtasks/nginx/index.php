<?php
 
  $name = $_GET['name'];
  // do some validation here to ensure id is safe
 
  $link = mysql_connect("localhost", "root", "1234");
  mysql_select_db("testdb1");
  $sql = "SELECT path FROM t1 WHERE name=$name";
  $result = mysql_query("$sql");
  $row = mysql_fetch_assoc($result);
  mysql_close($link);
 
  header("Content-type: image/jpeg");
  echo base64_decode($row['data']);
?>
