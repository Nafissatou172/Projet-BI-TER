
-- 1️⃣ Complétude : vérifier les NULL dans les dimensions
SELECT 'Dim_Train capacite NULL' AS test, COUNT(*) AS nb_problemes FROM ter_mobilite.Dim_Train WHERE capacite IS NULL;
SELECT 'Dim_Station latitude/longitude NULL' AS test, COUNT(*) AS nb_problemes FROM ter_mobilite.Dim_Station WHERE latitude IS NULL OR longitude IS NULL;
SELECT 'Fait_Mobilite train_id NULL' AS test, COUNT(*) AS nb_problemes FROM ter_mobilite.Fait_Mobilite WHERE train_id IS NULL;

-- 2️⃣ Validité : valeurs hors plage
SELECT 'Dim_Train capacite <= 0' AS test, COUNT(*) AS nb_problemes FROM ter_mobilite.Dim_Train WHERE capacite <= 0;
SELECT 'Dim_Station latitude out of range' AS test, COUNT(*) AS nb_problemes FROM ter_mobilite.Dim_Station WHERE latitude NOT BETWEEN -90 AND 90;

-- 3️⃣ Unicité : doublons sur trajets (exemple : même train, même date, même heure)
-- (Supposons qu'on a une colonne heure_depart dans Fait_Mobilite)
SELECT 'Doublons trajets' AS test, COUNT(*) AS nb_doublons FROM (
    SELECT train_id, date_id, heure_depart, COUNT(*)
    FROM ter_mobilite.Fait_Mobilite
    GROUP BY train_id, date_id, heure_depart
    HAVING COUNT(*) > 1
) AS sous_requete;

-- 4️⃣ Conformité : train_id commence par 'T'
SELECT 'Dim_Train format train_id' AS test, COUNT(*) AS nb_problemes FROM ter_mobilite.Dim_Train WHERE train_id NOT LIKE 'T%';

-- 5️⃣ Intégrité référentielle : train_id orphelins
SELECT 'Fait_Mobilite train_id orphelin' AS test, COUNT(*) AS nb_problemes FROM (
    SELECT f.train_id
    FROM ter_mobilite.Fait_Mobilite f
    LEFT JOIN ter_mobilite.Dim_Train d ON f.train_id = d.train_id
    WHERE d.train_id IS NULL
) AS sous_requete;
