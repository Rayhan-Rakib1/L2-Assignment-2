-- create rangers
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    ranger_name VARCHAR(50) NOT NULL,
    region  VARCHAR(50) NOT NULL
);


INSERT INTO rangers (ranger_id, ranger_name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range'),
(4, 'David Stone', 'Northern Hills'),
(5, 'Eva Black', 'River Delta'),
(6, 'Frank Moore', 'Mountain Range'),
(7, 'Grace Lee', 'Northern Hills'),
(8, 'Henry Ford', 'River Delta'),
(9, 'Isla Ray', 'Mountain Range'),
(10, 'Jack Miles', 'Northern Hills');
SELECT * FROM  rangers;


-- --------------------------  Create species  ----------------------
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(100) NOT NULL
);



INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'African Elephant', 'Loxodonta africana', '1825-06-15', 'Vulnerable'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Snow Leopard', 'Panthera uncia', '1775-03-20', 'Vulnerable'),
(4, 'Mountain Gorilla', 'Gorilla beringei beringei', '1902-10-17', 'Endangered'),
(5, 'Red Panda', 'Ailurus fulgens', '1825-12-12', 'Endangered'),
(6, 'Giant Panda', 'Ailuropoda melanoleuca', '1869-03-11', 'Vulnerable'),
(7, 'Komodo Dragon', 'Varanus komodoensis', '1910-04-26', 'Vulnerable'),
(8, 'Black Rhino', 'Diceros bicornis', '1758-01-01', 'Critically Endangered'),
(9, 'Blue Whale', 'Balaenoptera musculus', '1758-01-01', 'Endangered'),
(10, 'California Condor', 'Gymnogyps californianus', '1797-05-01', 'Critically Endangered');

SELECT * FROM species;


-- ----------------------- Create sightings Table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT NOT NULL,
    species_id INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT,

    CONSTRAINT fk_ranger
        FOREIGN KEY (ranger_id)
        REFERENCES rangers(ranger_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_species
        FOREIGN KEY (species_id)
        REFERENCES species(species_id)
        ON DELETE CASCADE
);




INSERT INTO sightings (ranger_id, species_id, location, sighting_time, notes) VALUES
(1, 1, 'Northern Hills - Zone A', '2025-05-10 08:30:00', 'Elephant near water source.'),
(2, 1, 'Northern Hills - Zone B', '2025-05-11 09:45:00', 'Elephant herd moving through forest.'),
(4, 2, 'River Delta - Sector 5', '2025-05-11 17:45:00', 'Tiger tracks found.'),
(5, 2, 'River Delta - Sector 6', '2025-05-12 18:00:00', 'Tiger spotted near river.'),
(5, 3, 'Mountain Range - Ridge 4', '2025-05-09 12:00:00', 'Snow leopard resting on rock.'),
(6, 3, 'Mountain Range - Ridge 5', '2025-05-10 14:30:00', 'Snow leopard crossing trail.'),
(6, 4, 'Northern Hills - Zone C', '2025-05-12 15:20:00', 'Mountain gorilla family observed.'),
(3, 9, 'River Delta - Sector 7', '2025-05-08 09:10:00', 'Red panda near bamboo.'),
(9, 8, 'River Delta - Sector 7', '2025-05-13 10:00:00', 'Red panda feeding.'),
(10, 1, 'Northern Hills - Zone A', '2025-05-14 16:40:00', 'Elephant herd near river.'),
(10, 7, 'Snowfall Pass - Zone A', '2025-05-14 16:40:00', 'Elephant herd near river.');

SELECT * FROM sightings;


-- problem 1   -----------------
INSERT INTO rangers(ranger_id, ranger_name, region) VALUES (11, 'Derek Fox', 'Coastal Plains') ;


-- Problem 2
SELECT COUNT(DISTINCT species_id ) FROM sightings; 

-- Problem 3
SELECT location FROM sightings
WHERE location ILIKE '%pass%';

-- Problem 4
SELECT rangers.ranger_name, rangers.ranger_id, count(sightings.sighting_id) AS total_sightings FROM rangers 
LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY  rangers.ranger_name, rangers.ranger_id
ORDER BY total_sightings DESC;

-- problem 5
SELECT species.species_id, species.common_name FROM species
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL ;

-- problem 6  
SELECT  rangers.ranger_name, species.common_name, sightings.sighting_time FROM sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers on sightings.ranger_id = rangers.ranger_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;


-- problem 7 
UPDATE species 
set conservation_status = 'Historic'
WHERE discovery_date  < '1800-1-1';

-- Problem 8
SELECT sighting_id, ranger_id, species_id, sighting_time ,
CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 5 AND 11  THEN 'Morning'  
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16  THEN 'Afternoon'  
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 17 AND 28  THEN 'Evening'  
    ELSE  'Night'
END FROM sightings;

-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
)