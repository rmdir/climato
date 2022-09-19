CREATE TABLE public.mesures (
    date timestamp with time zone NOT NULL,
    station character varying(20) NOT NULL,
    hauteur double precision NOT NULL
);


ALTER TABLE public.mesures OWNER TO mesures;

--
-- Name: pluviometrie; Type: TABLE; Schema: public; Owner: mesures
--

CREATE TABLE public.pluviometrie (
    date timestamp with time zone NOT NULL,
    moyenne double precision NOT NULL
);


ALTER TABLE public.pluviometrie OWNER TO mesures;

--
-- Name: stations; Type: TABLE; Schema: public; Owner: mesures
--

CREATE TABLE public.stations (
    id character varying(20) NOT NULL,
    description character varying(200) NOT NULL,
    bassin character varying(200) NOT NULL
);


ALTER TABLE public.stations OWNER TO mesures;

--
-- Name: mesures mesures_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_pkey PRIMARY KEY (date, station);


--
-- Name: pluviometrie pluviometrie_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.pluviometrie
    ADD CONSTRAINT pluviometrie_pkey PRIMARY KEY (date, moyenne);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: mesures mesures_station_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_station_fkey FOREIGN KEY (station) REFERENCES public.stations(id);


--
-- PostgreSQL database dump complete
--

