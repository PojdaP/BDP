CREATE TABLE roads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geometry GEOMETRY(LINESTRING)
);

CREATE TABLE poi (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geometry GEOMETRY(POINT)
);

CREATE TABLE buildings (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    geometry GEOMETRY(POLYGON)
);

INSERT INTO roads (id, name, geometry) values (1, 'RoadX', 'LINESTRING(0 4.5, 12 4.5)');
INSERT INTO roads (id, name, geometry) values (2, 'RoadY', 'LINESTRING(7.5 10.5, 7.5 0)');

INSERT INTO poi (id, name, geometry) values (1, 'G', 'POINT(1 3.5)');
INSERT INTO poi (id, name, geometry) values (2, 'H', 'POINT(5.5 1.5)');
INSERT INTO poi (id, name, geometry) values (3, 'I', 'POINT(9.5 6)');
INSERT INTO poi (id, name, geometry) values (4, 'J', 'POINT(6.5 6)');
INSERT INTO poi (id, name, geometry) values (5, 'K', 'POINT(6 9.5)');

INSERT INTO buildings (id, name, geometry) values (1, 'BuildingA', 'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))');
INSERT INTO buildings (id, name, geometry) values (2, 'BuildingB', 'POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))');
INSERT INTO buildings (id, name, geometry) values (3, 'BuildingC', 'POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))');
INSERT INTO buildings (id, name, geometry) values (4, 'BuildingD', 'POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))');
INSERT INTO buildings (id, name, geometry) values (5, 'BuildingF', 'POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))');

--a
SELECT SUM(ST_Length(geometry)) FROM roads;

--b
SELECT geometry, ST_Area(geometry), ST_Perimeter(geometry) 
FROM buildings 
WHERE name='BuildingA';

--c
SELECT name, ST_Area(geometry) 
FROM buildings 
ORDER BY name;

--d
SELECT name, ST_Perimeter(geometry) 
FROM buildings 
ORDER BY ST_Area(geometry) 
LIMIT 2;

--e
SELECT ST_Distance(b.geometry, p.geometry)
FROM buildings b 
CROSS JOIN poi p
WHERE b.name='BuildingC' and p.name='K';

--f
SELECT ST_Area(ST_Difference(c.geometry, ST_Buffer(b.geometry, 0.5)))
FROM buildings c, buildings b
WHERE c.name='BuildingC' AND b.name='BuildingB';

--g
SELECT b.*
FROM buildings b
JOIN roads r ON r.name = 'RoadX'
WHERE ST_Y(ST_Centroid(b.geometry)) > ST_Y(ST_Centroid(r.geometry));

--h
SELECT ST_Area(ST_Difference(c.geometry, 
          ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) AS area
FROM buildings c
WHERE c.name = 'BuildingC';

