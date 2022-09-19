CREATE TABLE public.mesures (
    date timestamp with time zone NOT NULL,
    station character varying(20) NOT NULL,
    debit double precision NOT NULL
);

ALTER TABLE public.mesures OWNER TO mesures;

CREATE TABLE public.stations (
    id character varying(20) NOT NULL,
    description character varying(200) NOT NULL,
    bassin character varying(200) NOT NULL
);

ALTER TABLE public.stations OWNER TO mesures;

ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_pkey PRIMARY KEY (date, station);

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_station_fkey FOREIGN KEY (station) REFERENCES public.stations(id);
