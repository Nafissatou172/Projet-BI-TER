<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" />
  <img src="https://img.shields.io/badge/Talend-FF6D70?style=for-the-badge&logo=talend&logoColor=white" />
  <img src="https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
  <img src="https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=databricks&logoColor=white" />
</p>

# 🚄 Entrepôt de Données — TER de Dakar

> Conception et mise en œuvre d'un **Système d'Information Décisionnel (SID)** pour l'analyse de la mobilité ferroviaire du Train Express Régional (TER) de Dakar.

---

## 📋 Contexte

Le **TER de Dakar** est une infrastructure de transport majeure reliant Dakar à l'Aéroport International Blaise Diagne (AIBD) via plusieurs gares intermédiaires. Ce projet vise à construire un entrepôt de données permettant d'analyser les flux de mobilité, d'optimiser l'exploitation du réseau et de fournir des indicateurs décisionnels clés aux opérateurs.

## 🎯 Objectifs

- **Analyser les flux de passagers** et le taux d'occupation des trains
- **Identifier les patterns de mobilité** quotidiens et hebdomadaires
- **Mesurer la ponctualité** du service (taux de retard par train, par période)
- **Optimiser la planification** des horaires et capacités
- **Fournir des KPIs** via des tableaux de bord interactifs

## 🏗️ Architecture

Le système repose sur une **architecture en étoile (Star Schema)** optimisée pour les requêtes analytiques :

```
                    ┌──────────────┐
                    │  Dim_Temps   │
                    │  (Temporel)  │
                    └──────┬───────┘
                           │
┌──────────────┐   ┌───────┴────────┐   ┌──────────────────┐
│  Dim_Train   ├───┤ Fait_Mobilite  ├───┤  Dim_Station     │
│  (Matériel)  │   │   (Trajets)    │   │  (Géographique)  │
└──────────────┘   └───────┬────────┘   └──────────────────┘
                           │
                    ┌──────┴───────┐
                    │ Dim_Passager │
                    │(Démographie) │
                    └──────────────┘
```

### Tables de dimensions

| Dimension | Description | Attributs clés |
|-----------|-------------|----------------|
| `Dim_Train` | Caractéristiques du matériel roulant | `train_id`, `capacite`, `type_train` |
| `Dim_Station` | Données géographiques des gares | `station_id`, `nom_station`, `latitude`, `longitude` |
| `Dim_Temps` | Décomposition temporelle | `date_id`, `jour`, `mois`, `annee`, `semaine` |
| `Dim_Passager` | Profil démographique des usagers | `passager_id`, `nom`, `prenom`, `age`, `genre` |

### Table de faits

| Table | Mesures | Clés étrangères |
|-------|---------|-----------------|
| `Fait_Mobilite` | `capacite_train`, `duree_trajet`, `statut_retard` | `train_id`, `station_depart`, `station_arrivee`, `date_id`, `passager_id` |

## 🔧 Stack technique

| Composant | Technologie | Rôle |
|-----------|-------------|------|
| **Base de données** | PostgreSQL | Hébergement de l'entrepôt de données |
| **ETL** | Talend Open Studio | Extraction, transformation et chargement des données |
| **Visualisation** | Power BI | Tableaux de bord et rapports interactifs |
| **Modélisation** | SQL | Création du schéma, indexation, tests de qualité |

## 📂 Structure du projet

```
TER/
├── datasets/                           # Données sources (CSV)
│   ├── Passagers.csv                   # Profils des passagers
│   ├── Stations.csv                    # Gares du réseau TER
│   ├── Trains.csv                      # Matériel roulant
│   └── Trajets.csv                     # Données de trajets
├── sql/
│   ├── entrepot_TER_Dakar.sql          # DDL — Schéma en étoile complet
│   ├── indexation_entrepot_TER_Dakar.sql   # Index de performance
│   └── tests_qualite_donnees_TER_Dakar.sql # Tests de qualité des données
└── README.md
```

## ⚙️ Pipeline ETL

Le pipeline ETL a été développé avec **Talend Open Studio** selon un flux structuré pour chaque dimension :

```
📄 CSV Source  →  🔄 tMap (Transformation)  →  🗄️ PostgreSQL (Chargement)
```

### Jobs implémentés

| Job | Source | Cible | Volume | Temps |
|-----|--------|-------|--------|-------|
| `Job_Dim_Train` | `trains.csv` | `dim_train` | 4 lignes | 0.73s |
| `Job_Dim_Passager` | `passagers.csv` | `dim_passager` | 4 lignes | 0.02s |
| `Job_Dim_Station` | `stations.csv` | `dim_station` | 4 lignes | 0.02s |
| `Job_Dim_Temps` | `tRowGenerator` | `dim_temps` | 100 lignes | 0.72s |
| `Job_Fait_Mobilite` | Multiple CSV + Dim_Temps | `fait_mobilite` | 6 400 lignes | 6.36s |

## 🛡️ Qualité des données

Des tests SQL automatisés couvrent **5 axes de qualité** :

| Test | Vérification |
|------|-------------|
| **Complétude** | Détection des valeurs `NULL` dans les dimensions et la table de faits |
| **Validité** | Valeurs hors plage (capacité ≤ 0, coordonnées GPS invalides) |
| **Unicité** | Détection des doublons sur les trajets |
| **Conformité** | Respect des formats (ex: `train_id` commence par `T`) |
| **Intégrité référentielle** | Clés étrangères orphelines |

## 📊 Analyses & résultats clés

Les requêtes analytiques et les dashboards Power BI ont permis d'extraire les insights suivants :

| Indicateur | Résultat |
|-----------|----------|
| Durée moyenne d'un trajet | **48.75 minutes** |
| Taux de retard global | **25%** |
| Station la plus sollicitée (départ) | **Dakar Plateau (S001)** |
| Trajet le plus long | **TR004 — 80 min** |
| Train avec le plus de retards | **T004 — 100%** |

### Visualisations Power BI

- 📈 Évolution quotidienne du nombre de trajets
- 📊 Nombre de trajets par train
- 🎯 Taux d'occupation moyen par train
- 👥 Évolution du nombre de passagers dans le temps
- 🗺️ Stations les plus utilisées comme point de départ

## 🚀 Mise en route

### Prérequis

- PostgreSQL 12+
- Talend Open Studio (pour les jobs ETL)
- Power BI Desktop (pour les dashboards)

### Installation

```bash
# 1. Cloner le dépôt
git clone https://github.com/Nafissatou172/ter-dakar-data-warehouse.git
cd ter-dakar-data-warehouse

# 2. Créer la base de données
psql -U postgres -c "CREATE DATABASE ter_mobilite_dw;"

# 3. Exécuter le schéma en étoile
psql -U postgres -d ter_mobilite_dw -f sql/entrepot_TER_Dakar.sql

# 4. Créer les index de performance
psql -U postgres -d ter_mobilite_dw -f sql/indexation_entrepot_TER_Dakar.sql

# 5. Lancer les tests de qualité des données
psql -U postgres -d ter_mobilite_dw -f sql/tests_qualite_donnees_TER_Dakar.sql
```

## 🔮 Améliorations futures

- [ ] Intégration de **données temps réel** via des connecteurs streaming
- [ ] Enrichissement du modèle avec de nouvelles dimensions (**tarifs**, **incidents**, **météo**)
- [ ] Développement de **rapports automatisés** et d'alertes
- [ ] Mise en place d'un **pipeline CI/CD** pour les tests de qualité
- [ ] Migration vers un **data lakehouse** pour le passage à l'échelle

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

<p align="center">
  <b>Nafissatou Mouhamed SOW</b> · M1 IABD · 2024/2025
</p>
