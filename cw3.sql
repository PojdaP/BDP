CREATE EXTENSION POSTGIS;

CREATE TEMP TABLE renewed AS 
SELECT T2018.polygon_id AS polygon_id, T2019.geom AS geom FROM T2019_KAR_BUILDINGS T2019
FULL JOIN T2018_KAR_BUILDINGS T2018 ON T2018.polygon_id = T2019.polygon_id
WHERE T2018.polygon_id IS NULL 
OR T2018.height <> T2019.height 
OR T2018.type <> T2019.type
OR T2018.geom <> T2019.geom;

CREATE TEMP TABLE new_poi AS 
SELECT T2019.geom AS geom, T2019.type AS "type" FROM T2019_KAR_POI_TABLE T2019
FULL JOIN T2018_KAR_POI_TABLE T2018 ON T2018.poi_id = T2019.poi_id
WHERE T2018.poi_id IS NULL;

SELECT COUNT(1), new_poi.type FROM new_poi 
JOIN renewed ON ST_DWithin(new_poi.geom, renewed.geom, 500)
GROUP BY new_poi.type;

CREATE TABLE streets_reprojected AS
SELECT
	gid,
	link_id,
	st_name,
	ref_in_id,
	nref_in_id,
	func_class,
	speed_cat,
	fr_speed_l,
	to_speed_l,
	dir_travel,
    ST_SetSRID(geom, 31466) AS geom
FROM
    T2019_KAR_STREETS;
	
CREATE TABLE input_points (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY(Point)
);

INSERT INTO input_points (geom)
VALUES
    (ST_MakePoint(8.36093, 49.03174)),
    (ST_MakePoint(8.39876, 49.00644));


UPDATE input_points
SET geom = ST_SetSRID(geom, 31466);
	
UPDATE T2019_KAR_STREET_NODE
SET geom = ST_SetSRID(geom, 31466);

WITH collected AS (
    SELECT ST_Collect(geom) AS geom
    FROM input_points
),
line AS (
    SELECT ST_MakeLine(geom) AS geom
    FROM collected
)
SELECT 
    street_node.node_id,
    street_node.geom,
    ST_Distance(street_node.geom, line.geom) AS distance
FROM 
    T2019_KAR_STREET_NODE street_node,
    line
WHERE 
    ST_DWithin(street_node.geom, line.geom, 200);


SELECT COUNT(1)
FROM 
	T2019_KAR_POI_TABLE points,
	T2019_KAR_LAND_USE_A parks
WHERE points.type = 'Sporting Goods Store' AND
ST_DWithin(points.geom, parks.geom, 300);


SELECT COUNT(1)
FROM 
    T2019_KAR_POI_TABLE points
JOIN 
    T2019_KAR_LAND_USE_A parks 
ON 
    ST_DWithin(points.geom, parks.geom, 300)
WHERE 
    points.type = 'Sporting Goods Store';

SELECT * T2019_KAR_RAILWAYS

CREATE TABLE T2019_KAR_BRIDGES (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY(Point, 31466)
);

INSERT INTO T2019_KAR_BRIDGES (geom)
SELECT ST_Intersection(r.geom, w.geom) AS geom
FROM 
    T2019_KAR_RAILWAYS r
JOIN 
    T2019_KAR_WATER_LINES w
ON 
    ST_Intersects(r.geom, w.geom);



