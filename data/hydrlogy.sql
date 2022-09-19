
CREATE TABLE public.marees (
    port integer NOT NULL,
    date timestamp with time zone NOT NULL,
    hauteur double precision
);


ALTER TABLE public.marees OWNER TO mesures;


CREATE TABLE public.mesures (
    date timestamp with time zone NOT NULL,
    station character varying(20) NOT NULL,
    hauteur double precision NOT NULL
);


ALTER TABLE public.mesures OWNER TO mesures;


CREATE TABLE public.pluviometrie (
    date timestamp with time zone NOT NULL,
    moyenne double precision NOT NULL
);


ALTER TABLE public.pluviometrie OWNER TO mesures;

CREATE TABLE public.ports (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    lat character varying(10) NOT NULL,
    lon character varying(10) NOT NULL
);


ALTER TABLE public.ports OWNER TO mesures;


CREATE SEQUENCE public.ports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ports_id_seq OWNER TO mesures;
ALTER SEQUENCE public.ports_id_seq OWNED BY public.ports.id;


CREATE TABLE public.stations (
    id character varying(20) NOT NULL,
    description character varying(200) NOT NULL,
    bassin character varying(200) NOT NULL
);


ALTER TABLE public.stations OWNER TO mesures;
ALTER TABLE ONLY public.ports ALTER COLUMN id SET DEFAULT nextval('public.ports_id_seq'::regclass);

ALTER TABLE ONLY public.marees
    ADD CONSTRAINT marees_pkey PRIMARY KEY (port, date);
ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_pkey PRIMARY KEY (date, station);
ALTER TABLE ONLY public.pluviometrie
    ADD CONSTRAINT pluviometrie_pkey PRIMARY KEY (date, moyenne);
ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.marees
    ADD CONSTRAINT marees_port_fkey FOREIGN KEY (port) REFERENCES public.ports(id);

ALTER TABLE ONLY public.mesures
    ADD CONSTRAINT mesures_station_fkey FOREIGN KEY (station) REFERENCES public.stations(id);
