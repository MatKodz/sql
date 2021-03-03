/* CORRECTIONS TP droits utilisateur 03/03/2021 */

-- avec les droits d'administrateur, droit de sélection
CREATE USER 'nemo'@'localhost' IDENTIFIED BY 'nemo';
GRANT SELECT ON exercice.nageur_performance  TO 'nemo'@'localhost' ;
GRANT SELECT ON exercice.nageur_profile  TO 'nemo'@'localhost' ;
GRANT SELECT ON exercice.nageur_club TO 'nemo'@'localhost' ;
FLUSH PRIVILEGES;

-- test avec les droits de nemo (impossible à réaliser)
INSERT INTO `nageur_performance` (`id_perf`, `perf_distance`, `perf_style`, `perf_bassin`, `perf_temps`, `perf_niveau`, `perf_lieu`, `perf_date`, `fk_id_club`, `fk_id_profile`) VALUES (NULL, '50', 'Nage libre', '25m', '00:01:00.000', 'reg', 'Montpel', '2021-03-01', '10', '11');

-- avec les droits d'administrateur, droit de création
GRANT INSERT ON exercice.nageur_performance TO 'nemo'@'localhost'

-- avec les droits d'administrateur, révocation des droits
REVOKE INSERT ON exercice.nageur_performance FROM 'nemo'@'localhost'

-- avec les droits d'administrateur, suppression de l'utilisateur
DROP USER 'nemo'@'localhost';

/* CORRECTIONS evaluation individuelle 03/03/2021 */

-- Question 1 : transaction rollback --
START TRANSACTION;
INSERT INTO nageur_performance VALUES
  (NULL,100,'Brasse','25m','50_b',"00:00:38.18","REG","Montpellier",CURDATE(),37,32),
 (NULL,100,'Brasse','25m','100_p',"00:01:08.53","REG","Montpellier",CURDATE(),37,32),
 (NULL,100,'Brasse','25m','100_b',"00:01:30.28","REG","Montpellier",CURDATE(),37,32);
 SELECT * FROM nageur_performance LIMIT 10;
ROLLBACK;

-- Question 2, création d'une procédure pour supprimer un profile_
DELIMITER $$
CREATE PROCEDURE delete_profile(IN profileid INT)
BEGIN
  DECLARE EXIT HANDLER FOR 1451 SELECT "Impossible de supprimer le nageur" as MSG;
  DELETE FROM nageur_profile WHERE id_profile = profileid;
END $$

-- Question 3 - TRIGGER après insertion d'un nouveau profil --
DELIMITER //
CREATE TRIGGER register AFTER INSERT ON nageur_profile
FOR EACH ROW
  BEGIN
  INSERT INTO nageur_age_nat
  VALUES (YEAR(CURDATE()) - NEW.profile_annee_naissance, NEW.profile_nationalite, CURDATE());
  END //

-- Question 4 // Création d'un utilisateur avec le droits --
CREATE USER 'etu'@'%.wis.fr' IDENTIFIED BY 'etu';
GRANT EXECUTE ON etudiants_liste.* TO 'etu'@'%.wis.fr';
GRANT SELECT, UPDATE ON etudiants_liste.wis_b1 TO 'etu'@'%.wis.fr';
GRANT SELECT, UPDATE ON etudiants_liste.wis_b2 TO 'etu'@'%.wis.fr';
FLUSH PRIVILEGES;               
SHOW GRANTS FOR 'etu'@'%.wis.fr';

-- Question Bonus --
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `afficher`(IN `nageurid` INT, IN `clubid` INT, OUT `nb_performance` INT)
BEGIN
SELECT COUNT(id_perf) INTO nb_performance FROM nageur_performance WHERE fk_id_profile = nageurid and fk_id_club = clubid;
END$$
-- Par exemple
CALL `afficher`(13,9,@nombre); SELECT @nombre AS `nb_performance`; renvoie 47 résultats
-- affiche le nombre de performances pour un nageur pour un club particulier (recherche par id profile du nageur et par id club)
