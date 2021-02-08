/* Partie C - écriture de requêtes */
#### 1 ####
SELECT perf_temps, perf_date FROM nageur_performance ORDER BY perf_date DESC LIMIT 10

#### 2 ####
SELECT profile_genre, profile_nom, perf_temps, CONCAT(perf_distance,' ',perf_style) FROM nageur_performance
INNER JOIN nageur_profile ON nageur_profile.id_profile = nageur_performance.fk_id_profile
WHERE CONCAT(perf_distance,' ',perf_style) ='100 nage libre' and profile_genre = 'f'

#### 3 ####
SELECT profile_nom, profile_prenom, perf_temps, CONCAT(perf_distance,' ', perf_style) FROM nageur_performance Perf INNER JOIN nageur_profile Profil ON Perf.fk_id_profile = Profil.id_profile WHERE profile_nom LIKE 'met%'

#### 4 ####
SELECT CONCAT (profile_prenom, " ", profile_nom), club_nom FROM nageur_profile INNER JOIN nageur_club ON nageur_profile.profile_fk_club_actuel = nageur_club.id_club

#### 5 ####
SELECT COUNT(profile_fk_club_actuel) AS NB, club_nom FROM nageur_profile INNER JOIN nageur_club ON nageur_profile.profile_fk_club_actuel = nageur_club.id_club GROUP BY id_club ORDER BY NB DESC

#### 6 ####
SELECT * FROM nageur_performance WHERE fk_id_profile = 13 and perf_bassin="25m" ORDER BY perf_style, perf_distance

#### 7 ####
SELECT COUNT(id_profile), profile_genre FROM nageur_profile GROUP BY profile_genre

#### 8 ####
SELECT COUNT(CONCAT(perf_style, perf_distance)) AS NBPERF, CONCAT(perf_distance," ",perf_style) AS STYLENAGE FROM nageur_performance GROUP BY perf_style, perf_distance


#### 9 ####
SELECT id_profile, profile_nom, perf_temps, CONCAT(perf_distance," ",perf_style) FROM nageur_performance, nageur_profile WHERE perf_temps IN (SELECT MIN(perf_temps) FROM nageur_performance GROUP BY CONCAT(perf_distance,perf_style)) and id_profile = fk_id_profile


#### 10 ####
SELECT COUNT(nageur_performance.fk_id_club) AS NBPERF, club_nom  FROM nageur_performance INNER JOIN nageur_club ON nageur_performance.fk_id_club = nageur_club.id_club GROUP BY nageur_performance.fk_id_club ORDER BY NBPERF DESC

#### 11 ####
SELECT profile_nom, profile_prenom, perf_distance, perf_style, perf_date, perf_temps, perf_lieu, club_nom FROM nageur_performance AS P
INNER JOIN nageur_profile N ON P.fk_id_profile = N.id_profile
INNER JOIN nageur_club AS C ON P.fk_id_club = C.id_club
WHERE N.id_profile = 10 and perf_bassin="50m" ORDER BY perf_style, perf_distance


#### 12 ####
SELECT profile_nom, profile_prenom, perf_distance, perf_style, perf_date, perf_temps, perf_lieu, club_nom, YEAR(perf_date) - profile_annee_naissance AS AGE FROM nageur_performance AS P
INNER JOIN nageur_profile N ON P.fk_id_profile = N.id_profile
INNER JOIN nageur_club AS C ON P.fk_id_club = C.id_club
WHERE N.id_profile = 10 and perf_bassin="50m" ORDER BY perf_style, perf_distance

#### 13 ####
SELECT MIN(perf_temps ), perf_style, perf_distance, fk_id_profile FROM nageur_performance WHERE perf_style= "Nage libre" and perf_distance = 100  GROUP BY fk_id_profile

#### 14 ####
SELECT MIN(perf_temps) AS tps, fk_id_profile FROM nageur_performance WHERE perf_distance = 50 and perf_style = "Brasse" GROUP BY fk_id_profile HAVING tps < '00:00:35.000'

#### 15 ####
SELECT * FROM nageur_profile WHERE id_profile NOT IN (
SELECT fk_id_profile FROM nageur_performance WHERE perf_style = "Nage libre" and perf_distance = 1500)


## OU ##

SELECT * FROM nageur_profile WHERE NOT EXISTS (
SELECT fk_id_profile FROM nageur_performance WHERE perf_style = "Nage libre" and perf_distance = 1500 and fk_id_profile = id_profile)

#### 16 ####
SELECT club_nom, id_perf FROM nageur_club
LEFT JOIN nageur_performance ON nageur_performance.fk_id_club = nageur_club.id_club
WHERE id_perf IS NULL

#### 17 ####
SELECT perf_temps, profile_nom, YEAR(perf_date) - profile_annee_naissance as AGE FROM nageur_performance
INNER JOIN nageur_profile ON nageur_profile.id_profile = nageur_performance.fk_id_profile
WHERE fk_id_profile = 11

/* D . 2 */
SELECT DISTINCT CONCAT(perf_distance," ", perf_style) FROM nageur_performance;

/* D . 5 */
ALTER TABLE nageur_profile
ADD CONSTRAINT fk_club
FOREIGN KEY (profile_fk_club_actuel) REFERENCES nageur_club(id_club) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE nageur_performance
ADD CONSTRAINT fk_clubid
FOREIGN KEY (`fk_id_club`) REFERENCES nageur_club(id_club) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE nageur_performance
ADD CONSTRAINT fk_nageurid
FOREIGN KEY (`fk_id_profile`) REFERENCES nageur_profile(id_profile) ON DELETE CASCADE ON UPDATE CASCADE;

/* E . 1 */
INSERT INTO `nageur_profile` (`id_profile`, `profile_nom`, `profile_prenom`, `profile_genre`, `profile_annee_naissance`, `profile_nationalite`, `profile_vignette`, `profile_fk_club_actuel`) VALUES (NULL, 'FINDING', 'Nemo', 'h', '2003', 'IT', NULL, 1);
INSERT INTO nageur_performance VALUES(NULL,100,'Nage libre','25m','00:02:00.17','REG','Montpellier','2021-02-05',1,27);

/* E . 2 */
DELETE FROM nageur_profile WHERE profile_prenom = 'Nemo'

/* E . 3 */
START TRANSACTION;
INSERT INTO `nageur_profile` (`id_profile`, `profile_nom`, `profile_prenom`, `profile_genre`, `profile_annee_naissance`, `profile_nationalite`, `profile_vignette`, `profile_fk_club_actuel`) VALUES (NULL, 'FINDING', 'Nemo', 'h', '2003', 'IT', NULL, 1);
SELECT * FROM nageur_profile;
ROLLBACK;

/* E . 4 */
START TRANSACTION;
INSERT INTO `nageur_profile` (`id_profile`, `profile_nom`, `profile_prenom`, `profile_genre`, `profile_annee_naissance`, `profile_nationalite`, `profile_vignette`, `profile_fk_club_actuel`) VALUES (NULL, 'FINDING', 'Nemo', 'h', '2003', 'IT', NULL, 99);
SELECT * FROM nageur_profile;
COMMIT;

START TRANSACTION;
INSERT INTO `nageur_profile` (`id_profile`, `profile_nom`, `profile_prenom`, `profile_genre`, `profile_annee_naissance`, `profile_nationalite`, `profile_vignette`, `profile_fk_club_actuel`) VALUES (NULL, 'FINDING', 'Nemo', 'h', '2003', 'IT', NULL, 2);
SELECT * FROM nageur_profile;
COMMIT;

/* F . 1 */
CREATE VIEW nageuses AS
SELECT id_profile, profile_nom, profile_prenom, profile_annee_naissance FROM nageur_profile
WHERE profile_genre = 'f';

/* F . 2 */
DELIMITER //
CREATE TRIGGER `checkdate` BEFORE INSERT ON `nageur_performance`
FOR EACH ROW
  BEGIN
    IF NEW.perf_date > CURDATE()
    THEN SET NEW.perf_date = CURDATE();
    END IF;
  END //


/* G . 1 */

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `record_nageur`(IN `identifiant` INT, IN `bassin` VARCHAR(3))
    SQL SECURITY INVOKER
BEGIN
	SELECT MIN(perf_temps),fk_id_profile, perf_distance, perf_style FROM nageur_performance WHERE fk_id_profile = identifiant and perf_bassin = bassin GROUP BY perf_distance, perf_style;
END$$
DELIMITER ;

/* G . 2 */
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `afficher_nageur`(IN `nageur_name` VARCHAR(10))
BEGIN
DECLARE profile_founded VARCHAR(30);
SELECT CONCAT(profile_nom," | ",profile_annee_naissance) INTO profile_founded FROM nageur_profile WHERE profile_nom LIKE CONCAT(nageur_name,"%");
SELECT profile_founded;
END$$

/* G . 3 */
DELIMITER $$
CREATE PROCEDURE `creer_club`(IN nom VARCHAR(15), IN ville VARCHAR(10), IN codepostal MEDIUMINT, IN region VARCHAR(15), IN url VARCHAR(100), OUT club_name VARCHAR(20))
BEGIN
INSERT INTO nageur_club VALUES (NULL, nom, ville, codepostal, region, url);
SELECT nom INTO club_name
END$$

SET @club = "";
CALL creer_club("Les poissons","Paris",75000,"IDF", "http://www.lespoissons.fr", @club);
SELECT @club;

/* G . 4 */
DELIMITER $$
CREATE PROCEDURE `ajouter_nageur`(IN nom VARCHAR(15), IN prenom VARCHAR(15), IN genre VARCHAR(1), IN annee YEAR, IN nationalite VARCHAR(2), IN club INT)
BEGIN
DECLARE clubInconnu CONDITION FOR 1452;
DECLARE EXIT HANDLER FOR clubInconnu SELECT 'Club inconnu' as erreur;
INSERT INTO nageur_profile VALUES (NULL,nom,prenom,genre,annee,nationalite,NULL,club);
SELECT @@identity;
END$$

SET @p0='dory'; SET @p1='sans'; SET @p2='g'; SET @p3='2000'; SET @p4='ES'; SET @p5='99'; CALL `ajouter_nageur`(@p0, @p1, @p2, @p3, @p4, @p5);
