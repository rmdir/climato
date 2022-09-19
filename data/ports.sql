--
-- Trouver les coordonnées du port
-- %s => nom du port
-- http://webservices.meteoconsult.fr/meteoconsultmarine/android/100/fr/v20/recherche.php?rech=%s&type=48

COPY public.ports (id, name, lat, lon) FROM stdin;
1	Soulac-sur-Mer	45.4886	-1.14333
2	Anglet	43.5267	-1.50833
3	Royan	45.62	-1.025
\.
