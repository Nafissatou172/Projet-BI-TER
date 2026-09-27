
-- Index pour Dim_Train
CREATE INDEX idx_dim_train_train_id ON ter_mobilite.Dim_Train(train_id);

-- Index pour Dim_Station
CREATE INDEX idx_dim_station_station_id ON ter_mobilite.Dim_Station(station_id);

-- Index pour Dim_Temps
CREATE INDEX idx_dim_temps_date_id ON ter_mobilite.Dim_Temps(date_id);

-- Index pour Dim_Passager
CREATE INDEX idx_dim_passager_passager_id ON ter_mobilite.Dim_Passager(passager_id);

-- Index sur Fait_Mobilite
CREATE INDEX idx_fait_mobilite_train_id ON ter_mobilite.Fait_Mobilite(train_id);
CREATE INDEX idx_fait_mobilite_station_depart ON ter_mobilite.Fait_Mobilite(station_depart);
CREATE INDEX idx_fait_mobilite_station_arrivee ON ter_mobilite.Fait_Mobilite(station_arrivee);
CREATE INDEX idx_fait_mobilite_date_id ON ter_mobilite.Fait_Mobilite(date_id);
CREATE INDEX idx_fait_mobilite_passager_id ON ter_mobilite.Fait_Mobilite(passager_id);
