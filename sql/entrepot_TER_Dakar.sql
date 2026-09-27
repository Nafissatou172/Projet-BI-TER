
-- Création du schéma (optionnel)
CREATE SCHEMA IF NOT EXISTS ter_mobilite;
SET search_path TO ter_mobilite;

-- 1️⃣ Dimension : Dim_Train
CREATE TABLE IF NOT EXISTS Dim_Train (
    train_id VARCHAR(10) PRIMARY KEY,
    capacite INTEGER,
    type_train VARCHAR(50)
);

-- 2️⃣ Dimension : Dim_Station
CREATE TABLE IF NOT EXISTS Dim_Station (
    station_id VARCHAR(10) PRIMARY KEY,
    nom_station VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- 3️⃣ Dimension : Dim_Temps
CREATE TABLE IF NOT EXISTS Dim_Temps (
    date_id DATE PRIMARY KEY,
    jour INTEGER,
    mois INTEGER,
    annee INTEGER,
    semaine INTEGER
);

-- 4️⃣ Dimension : Dim_Passager
CREATE TABLE IF NOT EXISTS Dim_Passager (
    passager_id VARCHAR(10) PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    age INTEGER,
    genre VARCHAR(10)
);

-- 5️⃣ Table de faits : Fait_Mobilite
CREATE TABLE IF NOT EXISTS Fait_Mobilite (
    trajet_id VARCHAR(10) PRIMARY KEY,
    train_id VARCHAR(10),
    station_depart VARCHAR(10),
    station_arrivee VARCHAR(10),
    passager_id VARCHAR(10),
    date_id DATE,
    capacite_train INTEGER,
    duree_trajet INTEGER, -- en minutes
    statut_retard BOOLEAN,
    FOREIGN KEY (train_id) REFERENCES Dim_Train(train_id),
    FOREIGN KEY (station_depart) REFERENCES Dim_Station(station_id),
    FOREIGN KEY (station_arrivee) REFERENCES Dim_Station(station_id),
    FOREIGN KEY (date_id) REFERENCES Dim_Temps(date_id),
    FOREIGN KEY (passager_id) REFERENCES Dim_Passager(passager_id)
);
