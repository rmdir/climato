--
-- On trouve les stations sur 
-- https://hydro.eaufrance.fr/rechercher/entites-hydrometriques
--
COPY public.stations (id, description, bassin) FROM stdin;
Q9350020	Adour à Bayonne	Adour/Garonne
P9160001	La Dordogne à Bayon-sur-Gironde	Adour/Garonne
O9790001	La Garonne à Ambès	Adour/Garonne
\.

