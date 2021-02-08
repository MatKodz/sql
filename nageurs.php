
<?php

require("connect.php");


$requeteOptions = "SELECT DISTINCT (CONCAT(perf_distance, ' ', perf_style)) AS epreuve FROM nageur_performance";



if ( isset($_GET['nagechoisie']) && $_GET['nagechoisie']) {
  $requete_preparee = "SELECT id_perf, CONCAT(profile_nom,' ', profile_prenom) AS nom_prenom, CONCAT(perf_distance,' ', perf_style) AS epreuve, perf_temps, perf_bassin, perf_date, perf_lieu, club_nom FROM nageur_performance
  INNER JOIN nageur_profile
  ON nageur_profile.id_profile = nageur_performance.fk_id_profile
  INNER JOIN nageur_club
  ON nageur_club.id_club = nageur_performance.fk_id_club
  WHERE CONCAT(perf_distance,' ', perf_style) = ?
  ORDER BY perf_date ";
  $sth = $conn->prepare($requete_preparee);
  $sth->bindValue(1,$_GET['nagechoisie'], PDO::PARAM_STR);
  $sth->execute();
  $data = $sth->fetchAll();
}

else {
  $requete = "SELECT id_perf, CONCAT(profile_nom,' ', profile_prenom) AS nom_prenom, CONCAT(perf_distance,' ', perf_style) AS epreuve, perf_temps, perf_bassin, perf_date, perf_lieu, club_nom FROM nageur_performance
  INNER JOIN nageur_profile
  ON nageur_profile.id_profile = nageur_performance.fk_id_profile
  INNER JOIN nageur_club
  ON nageur_club.id_club = nageur_performance.fk_id_club
  ORDER BY perf_date DESC LIMIT 10
  ";

  $jeu = $conn->query($requete);
  $data = $jeu->fetchAll();
}

?>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Performances natation française</title>
    <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
    <style media="screen">
      body {
        background-color: #fafafa;
        padding: 0;
        margin: 0;
        font-family: 'Lato', sans-serif;
      }
      header {
        background: linear-gradient(to top left,#fafafa, #fff);
        color: white;
        padding: 4vh 2%;
        border-bottom:  3px #003da0 solid;

      }

      header .inner {
        max-width: 990px;
        margin: 0 auto;
      }

      header a {
      background: -webkit-linear-gradient(bottom left, #003da0, #c5ceff);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      text-transform: uppercase;
      font-weight: 700;
      font-size: 4em;
      }


      main {
        max-width: 990px;
        margin: 0 auto;
      }

      .display-perf {
        background-color: white;
        padding: 2%;
      }

      .performance, .heading-perf {
        display: flex;
        padding: 10px;
      }

      .performance p, .performance, .heading-perf p {
        font-size: 14px;
        flex: 1 1;
        padding: 5px;
      }

      .performance p:nth-of-type(3), .heading-perf p:nth-of-type(3){
        flex: 0 0 90px;
      }

      .performance p:nth-of-type(4), .heading-perf p:nth-of-type(4){
        flex: 0 0 70px;
      }

      .performance p:nth-of-type(5), .heading-perf p:nth-of-type(5){
        flex: 0 0 100px;
      }

      .performance p:last-of-type{
        font-size: 12px;
        color: grey;
      }

      .performance p:nth-of-type(3){
        color: grey;
        font-family: serif;
      }

      .performance:nth-of-type(odd) {
        background-color: #d8e7ff;
        border-bottom: 1px dotted #003da0;
      }

      div.heading-perf {
        background-color: #eeeeee;
        border-color: grey;
        font-size: 80%;
      }

      .genre {
        display: none;
      }


      .genre + label {
        display: inline-block;
        padding: 10px;
        color: grey;
        border: 2px solid grey;
      }

      .genre:checked + label{
        color: white;
        background-color: grey;
      }

      form {
        padding: 2% 0;
        margin: 2% 0;
        border-bottom: 1px solid #aaa;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      header a {
        color: white;
      }

      h3 span {
        color: #003da0;
        font-size: 150%;
      }

      p.fail {
        padding: 7px;
        color: orange;
        border: #f90 1px solid;
        background-color: #fffcf1;
      }


    </style>
  </head>
  <body>
    <header>
      <div class="inner">
        <a href="./">Performance sportive</a>
      </div>
    </header>
    <main>
      <section class="display-perf">
        <form action="" method="get">
          Style
        <select name="nagechoisie">
          <option value="0">Choisir une nage</option>
          <?php
          foreach ($conn->query($requeteOptions) as $Nomepreuve) {
            ?>
            <option value="<?= $Nomepreuve['epreuve']?>"><?= $Nomepreuve['epreuve']?></option>
            <?php

          }
          ?>
        </select>
        | Sexe
        <input type="radio" name="sexe" value="F" id="femme" class="genre" ><label for="femme">Femme</label>
        <input type="radio" name="sexe" value="H" id="homme" class="genre" ><label for="homme">Homme</label>
        OU tapez trois lettres<input type="search" name="chercher">
        <input type="submit" name="valider" value="Afficher les nageurs">
        </form>
        <div class="heading-perf">
        <p>Nageur</p>
        <p>Epreuve</p>
        <p>Temps</p>
        <p>Bassin</p>
        <p>Date</p>
        <p>Lieu</p>
        <p>Club </p>
        </div>
        <?php
        foreach ($data as $performance) {
          ?>
          <div class="performance" id="perf_<?= $performance['id_perf']?>">
          <p>
            <?php echo $performance['nom_prenom'];?>
          </p>
          <p>
            <?php echo $performance['epreuve'];?>
          </p>
          <p>
            <?php echo $performance['perf_temps'];?>
          </p>
          <p>
            <?php echo $performance['perf_bassin'];?>
          </p>
          <p>
            <?php echo $performance['perf_date'];?>
          </p>
          <p>
            <?php echo $performance['perf_lieu'];?>
          </p>
          <p>
            <?php echo $performance['club_nom'];?>
          </p>
          </div>
          <?php
        }
         ?>

      </section>
    </main>
  </body>
</html>
