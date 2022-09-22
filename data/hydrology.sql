--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: debits; Type: TABLE; Schema: public; Owner: mesures
--

CREATE TABLE public.debits (
    date timestamp with time zone NOT NULL,
    station character varying(20) NOT NULL,
    debit double precision
);


ALTER TABLE public.debits OWNER TO mesures;

--
-- Name: marees; Type: TABLE; Schema: public; Owner: mesures
--

CREATE TABLE public.marees (
    port integer NOT NULL,
    date timestamp with time zone NOT NULL,
    hauteur double precision
);


ALTER TABLE public.marees OWNER TO mesures;

--
-- Name: mesures; Type: TABLE; Schema: public; Owner: mesures
--

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
-- Name: ports; Type: TABLE; Schema: public; Owner: mesures
--

CREATE TABLE public.ports (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    lat character varying(10) NOT NULL,
    lon character varying(10) NOT NULL
);


ALTER TABLE public.ports OWNER TO mesures;

--
-- Name: ports_id_seq; Type: SEQUENCE; Schema: public; Owner: mesures
--

CREATE SEQUENCE public.ports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ports_id_seq OWNER TO mesures;

--
-- Name: ports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mesures
--

ALTER SEQUENCE public.ports_id_seq OWNED BY public.ports.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: mesures
--

CREATE TABLE public.stations (
    id character varying(20) NOT NULL,
    description character varying(200) NOT NULL,
    bassin character varying(200) NOT NULL,
    debit boolean DEFAULT false
);


ALTER TABLE public.stations OWNER TO mesures;

--
-- Name: ports id; Type: DEFAULT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.ports ALTER COLUMN id SET DEFAULT nextval('public.ports_id_seq'::regclass);


--
-- Name: debits debits_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.debits
    ADD CONSTRAINT debits_pkey PRIMARY KEY (date, station);


--
-- Name: marees marees_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.marees
    ADD CONSTRAINT marees_pkey PRIMARY KEY (port, date);


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
-- Name: ports ports_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: debits debits_station_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.debits
    ADD CONSTRAINT debits_station_fkey FOREIGN KEY (station) REFERENCES public.stations(id);


--
-- Name: marees marees_port_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.marees
    ADD CONSTRAINT marees_port_fkey FOREIGN KEY (port) REFERENCES public.ports(id);


--
-- Name: mesures mesures_station_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mesures
--

ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_station_fkey FOREIGN KEY (station) REFERENCES public.stations(id);


--
-- PostgreSQL database dump complete
--

