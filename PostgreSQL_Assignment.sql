-- Active: 1747589344280@@localhost@5432@conservation_db
CREATE DATABASE conservation_db;

/* Connect to the conservation_db database */
\c conservation_db;

CREATE TABLE ranger(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);


CREATE TABLE sighting(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL REFERENCES ranger(ranger_id),
    species_id INT NOT NULL REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT
);  

INSERT INTO ranger (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');



INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');



-- Insert the provided data into the sighting table
INSERT INTO sighting (sighting_id, ranger_id, species_id, sighting_time, location, notes) VALUES
(1, 1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(4, 2, 1, '2024-05-18 18:30:00', 'Snowfall Pass', NULL);



-- Problem 1: Register a new ranger
INSERT INTO ranger (name, region) VALUES
('Derek Fox', 'Coastal Plains');


-- Problem 2: Count unique species ever sighted
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sighting;

-- Problem 3: find all sighting where location contains the word 'pass'
SELECT * FROM sighting
WHERE LOWER(location) LIKE '%pass%';

-- Problem 4:  List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM ranger as r
LEFT JOIN sighting as s ON r.ranger_id = s.ranger_id
GROUP BY r.name;

-- Problem 5: List species that have never been sighted.
SELECT s.common_name
FROM species as s
LEFT JOIN sighting as si ON s.species_id = si.species_id
WHERE si.sighting_id IS NULL;

-- Problem 6: Show the most recent 2 sightings
SELECT common_Name, sighting_Time, name
FROM sighting AS si
JOIN species AS sp ON si.species_id = sp.species_id
JOIN ranger AS r ON si.ranger_id = r.ranger_id
ORDER BY sighting_time DESC
LIMIT 2;

-- Problem 7: Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';


-- Problem 8: Lebel each sighting time as 'Morning', 'Afternoon', or 'Evening'.

SELECT sighting_id, 
       CASE 
           WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM sighting_time) < 17 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sighting;

-- Problem 9: Delete rangers who have never sighted any species
DELETE FROM ranger
WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sighting);



