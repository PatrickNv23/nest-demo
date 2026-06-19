--
-- PostgreSQL database dump
--

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.0

-- Started on 2026-05-28 17:39:37

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
-- SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16490)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4459 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 16638)
-- Name: comment_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    comment_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url text NOT NULL,
    file_type character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.comment_attachments OWNER TO admin;

--
-- TOC entry 225 (class 1259 OID 16627)
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ticket_id uuid NOT NULL,
    user_id uuid NOT NULL,
    content text NOT NULL,
    is_internal boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.comments OWNER TO  admin;

--
-- TOC entry 219 (class 1259 OID 16537)
-- Name: departments; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.departments OWNER TO  admin;

--
-- TOC entry 227 (class 1259 OID 16653)
-- Name: notifications; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    type character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.notifications OWNER TO  admin;

--
-- TOC entry 218 (class 1259 OID 16527)
-- Name: roles; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.roles OWNER TO  admin;

--
-- TOC entry 224 (class 1259 OID 16611)
-- Name: ticket_status_history; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.ticket_status_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ticket_id uuid NOT NULL,
    status_before character varying(50),
    status_after character varying(50) NOT NULL,
    changed_by_user_id uuid NOT NULL,
    change_reason text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ticket_status_history OWNER TO  admin;

--
-- TOC entry 221 (class 1259 OID 16569)
-- Name: ticket_statuses; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.ticket_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(50) NOT NULL,
    step_order integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ticket_statuses OWNER TO  admin;

--
-- TOC entry 222 (class 1259 OID 16581)
-- Name: ticket_types; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.ticket_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ticket_types OWNER TO  admin;

--
-- TOC entry 223 (class 1259 OID 16591)
-- Name: tickets; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.tickets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    status_id uuid NOT NULL,
    priority character varying(20) NOT NULL,
    type_id uuid NOT NULL,
    creator_user_id uuid NOT NULL,
    assigned_agent_id uuid,
    department_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.tickets OWNER TO  admin;

--
-- TOC entry 220 (class 1259 OID 16547)
-- Name: users; Type: TABLE; Schema: public; Owner:  admin
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(20),
    password_hash character varying(255) NOT NULL,
    role_id uuid NOT NULL,
    department_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.users OWNER TO  admin;

--
-- TOC entry 4452 (class 0 OID 16638)
-- Dependencies: 226
-- Data for Name: comment_attachments; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.comment_attachments VALUES ('579b3680-4044-4f60-ae16-33c662665ddf', 'a1a65429-f0e1-495b-8b27-7df6d1681b3b', 'prueba1.txt', '/uploads/comments/51d55690-b204-417b-9774-d9ee4ec41048.txt', 'text/plain', '2026-05-01 19:49:19.814+00', '2026-05-01 19:49:19.814+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);
INSERT INTO public.comment_attachments VALUES ('39e7b893-f4b3-4230-b80c-37302602fe60', 'a1a65429-f0e1-495b-8b27-7df6d1681b3b', 'prueba2.txt', '/uploads/comments/1cbbefa0-509e-4feb-9966-acda35f52d05.txt', 'text/plain', '2026-05-01 19:49:19.814+00', '2026-05-01 19:49:19.814+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);
INSERT INTO public.comment_attachments VALUES ('b5199fd1-87f0-42c9-b23d-8c66462e314e', '68538b4c-66e7-40f7-9cc2-24509fe0299c', 'prueba3.txt', '/uploads/comments/e8724ad2-8656-4fe6-ae7d-f83b9ab6cf0c.txt', 'text/plain', '2026-05-01 20:23:39.227+00', '2026-05-01 20:23:39.227+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);


--
-- TOC entry 4451 (class 0 OID 16627)
-- Dependencies: 225
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.comments VALUES ('4bd998cf-720b-4581-8ed3-c68049a0af62', 'd30d46be-5d4e-4573-ac9a-28548d1dbf4a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', 'comentario 1 ticket error 3', false, '2026-05-01 19:47:25.239+00', '2026-05-01 19:47:25.239+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);
INSERT INTO public.comments VALUES ('a1a65429-f0e1-495b-8b27-7df6d1681b3b', 'd30d46be-5d4e-4573-ac9a-28548d1dbf4a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', 'comentario 2 ticket error 3', false, '2026-05-01 19:49:19.717+00', '2026-05-01 19:49:19.717+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);
INSERT INTO public.comments VALUES ('68538b4c-66e7-40f7-9cc2-24509fe0299c', 'd30d46be-5d4e-4573-ac9a-28548d1dbf4a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', 'comentario 3 ticket error 3', false, '2026-05-01 20:23:39.133+00', '2026-05-01 20:23:39.133+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);


--
-- TOC entry 4445 (class 0 OID 16537)
-- Dependencies: 219
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.departments VALUES ('0a2660d0-9a31-4c48-86da-5688d3b766a2', 'IT Support', 'Technical incidents and hardware support', '2026-03-02 22:16:07.254032+00', '2026-03-02 22:16:07.254032+00', NULL, NULL, true);
INSERT INTO public.departments VALUES ('1fd8f022-71e2-4391-bd7d-ce6c30a21856', 'Sales', 'Billing and commercial inquiries', '2026-03-02 22:16:07.254032+00', '2026-03-02 22:16:07.254032+00', NULL, NULL, true);
INSERT INTO public.departments VALUES ('9a962c3b-2f5a-4cad-b97f-d7825b0c713b', 'HR', 'Staff management and internal benefits', '2026-03-02 22:16:07.254032+00', '2026-03-02 22:16:07.254032+00', NULL, NULL, true);
INSERT INTO public.departments VALUES ('aa3472f3-6145-4b07-b1d7-c25e435d1f12', 'Software Development', 'Bug tracking and feature requests', '2026-03-02 22:16:07.254032+00', '2026-03-02 22:16:07.254032+00', NULL, NULL, true);
INSERT INTO public.departments VALUES ('3a37f6e9-1863-448d-9598-99c795117b11', 'COE Data', 'COE Data department with full access updated database', '2026-04-14 03:56:44.109+00', '2026-04-14 04:02:37.396+00', NULL, NULL, false);
INSERT INTO public.departments VALUES ('ec7e32cb-278c-461a-917d-b0b076f8f595', 'Shop', 'Shop department with full access database', '2026-04-14 04:06:20.295+00', '2026-04-14 04:06:20.295+00', NULL, NULL, true);


--
-- TOC entry 4453 (class 0 OID 16653)
-- Dependencies: 227
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner:  admin
--



--
-- TOC entry 4444 (class 0 OID 16527)
-- Dependencies: 218
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.roles VALUES ('00bb65f3-c4f7-433a-8b36-a3bb77cf765b', 'CUSTOMER', '2026-03-02 22:15:48.798246+00', '2026-03-02 22:15:48.798246+00', NULL, NULL, true);
INSERT INTO public.roles VALUES ('1987a053-4e9c-4174-9012-bd97bb6e82ab', 'AGENT', '2026-03-02 22:15:48.798246+00', '2026-03-02 22:15:48.798246+00', NULL, NULL, true);
INSERT INTO public.roles VALUES ('3568728c-1280-47d0-862a-49af1eb41069', 'ADMIN', '2026-03-02 22:15:48.798246+00', '2026-03-02 22:15:48.798246+00', NULL, NULL, true);


--
-- TOC entry 4450 (class 0 OID 16611)
-- Dependencies: 224
-- Data for Name: ticket_status_history; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.ticket_status_history VALUES ('1516b79f-4dcb-4569-bf8a-8959f3f3de56', 'bca1a685-def7-4064-8ea4-76b31ccd5e04', 'OPEN', 'ASSIGNED', '9d3fc2c7-9f79-4344-967f-08051635d282', 'El ticket de inicio de sesión cambió', '2026-04-18 00:13:19.775+00', '2026-04-18 00:13:19.775+00', '9d3fc2c7-9f79-4344-967f-08051635d282', '9d3fc2c7-9f79-4344-967f-08051635d282', true);


--
-- TOC entry 4447 (class 0 OID 16569)
-- Dependencies: 221
-- Data for Name: ticket_statuses; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.ticket_statuses VALUES ('91758f01-68fc-4464-9edc-9cbca7e69b18', 'OPEN', 1, '2026-03-02 22:16:19.141975+00', '2026-03-02 22:16:19.141975+00', NULL, NULL, true);
INSERT INTO public.ticket_statuses VALUES ('6567e73a-a548-4c99-b68d-d69e7385a7e7', 'ASSIGNED', 2, '2026-03-02 22:16:19.141975+00', '2026-03-02 22:16:19.141975+00', NULL, NULL, true);
INSERT INTO public.ticket_statuses VALUES ('b964d615-e946-4003-8d16-99eadff3ed58', 'IN_PROGRESS', 3, '2026-03-02 22:16:19.141975+00', '2026-03-02 22:16:19.141975+00', NULL, NULL, true);
INSERT INTO public.ticket_statuses VALUES ('b70b20b9-8088-42f6-a787-d95006ed1728', 'WAITING_CUSTOMER', 4, '2026-03-02 22:16:19.141975+00', '2026-03-02 22:16:19.141975+00', NULL, NULL, true);
INSERT INTO public.ticket_statuses VALUES ('9cb64c1d-5bae-42b3-a7bd-26da1aadde0a', 'RESOLVED', 5, '2026-03-02 22:16:19.141975+00', '2026-03-02 22:16:19.141975+00', NULL, NULL, true);
INSERT INTO public.ticket_statuses VALUES ('57f8e062-3916-4957-a69a-ddd735b2bd6e', 'CLOSED', 6, '2026-03-02 22:16:19.141975+00', '2026-03-02 22:16:19.141975+00', NULL, NULL, true);


--
-- TOC entry 4448 (class 0 OID 16581)
-- Dependencies: 222
-- Data for Name: ticket_types; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.ticket_types VALUES ('f7307c3f-e774-4c0c-ba72-cc5f64ad0af2', 'TECHNICAL_ISSUE', '2026-03-02 22:16:31.129182+00', '2026-03-02 22:16:31.129182+00', NULL, NULL, true);
INSERT INTO public.ticket_types VALUES ('c1b4654c-91c3-4d1b-9987-93f96f324133', 'SERVICE_REQUEST', '2026-03-02 22:16:31.129182+00', '2026-03-02 22:16:31.129182+00', NULL, NULL, true);
INSERT INTO public.ticket_types VALUES ('3d7122bb-1adb-49fa-b861-6d4ea0ae53da', 'INQUIRY', '2026-03-02 22:16:31.129182+00', '2026-03-02 22:16:31.129182+00', NULL, NULL, true);
INSERT INTO public.ticket_types VALUES ('8ffcd68e-88de-49e0-80b0-aa105f6a2e88', 'ACCESS_PERMISSIONS', '2026-03-02 22:16:31.129182+00', '2026-03-02 22:16:31.129182+00', NULL, NULL, true);


--
-- TOC entry 4449 (class 0 OID 16591)
-- Dependencies: 223
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.tickets VALUES ('5371fca0-4ebf-4a17-8a3b-ec81475fc2f7', 'Error en el inicio de sesión 2', 'El usuario no puede acceder a su cuenta tras el último despliegue. Se adjunta captura del error 500 2.', '91758f01-68fc-4464-9edc-9cbca7e69b18', 'alta', 'f7307c3f-e774-4c0c-ba72-cc5f64ad0af2', '4deaaf11-265e-4b5a-8a99-1244bd97169a', 'aaec28ef-fb33-4d7d-941a-8295a858d82f', '0a2660d0-9a31-4c48-86da-5688d3b766a2', '2026-04-17 23:57:13.311+00', '2026-04-17 23:57:13.311+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);
INSERT INTO public.tickets VALUES ('bca1a685-def7-4064-8ea4-76b31ccd5e04', 'Error en el inicio de sesión', 'El usuario no puede acceder a su cuenta tras el último despliegue. Se adjunta captura del error 500.', '6567e73a-a548-4c99-b68d-d69e7385a7e7', 'alta', 'f7307c3f-e774-4c0c-ba72-cc5f64ad0af2', '4deaaf11-265e-4b5a-8a99-1244bd97169a', NULL, '0a2660d0-9a31-4c48-86da-5688d3b766a2', '2026-04-16 00:23:24.952+00', '2026-04-18 00:13:19.678+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '9d3fc2c7-9f79-4344-967f-08051635d282', true);
INSERT INTO public.tickets VALUES ('d30d46be-5d4e-4573-ac9a-28548d1dbf4a', 'Error 3', 'El usuario no puede acceder a su cuenta tras el último despliegue. Se adjunta captura del error 500 3.', '91758f01-68fc-4464-9edc-9cbca7e69b18', 'baja', 'f7307c3f-e774-4c0c-ba72-cc5f64ad0af2', '4deaaf11-265e-4b5a-8a99-1244bd97169a', NULL, '0a2660d0-9a31-4c48-86da-5688d3b766a2', '2026-05-01 04:44:13.943+00', '2026-05-01 04:44:13.943+00', '4deaaf11-265e-4b5a-8a99-1244bd97169a', '4deaaf11-265e-4b5a-8a99-1244bd97169a', true);


--
-- TOC entry 4446 (class 0 OID 16547)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner:  admin
--

INSERT INTO public.users VALUES ('9d3fc2c7-9f79-4344-967f-08051635d282', 'patricknv', 'patricknv@email.com', '+51999888777', '$2a$10$sfiaHrue7a8hXcZ7ss4GtOzWLn8j2fyb4Trh2Kdzs/05kH.pv9xl.', '3568728c-1280-47d0-862a-49af1eb41069', NULL, '2026-03-04 00:27:19.380288+00', '2026-03-04 00:27:19.380288+00', NULL, NULL, true);
INSERT INTO public.users VALUES ('b63616b0-c1bb-4fc8-a8fc-a4f04f8d7de8', 'nuevo3updated', 'mondoño@filopedo12.com', '+51974673624', '$2a$10$AP11xkHL/XRyuDhhdnuHQetZSRAXQdpzL8i89azDc5dNFOPgVXR3q', '00bb65f3-c4f7-433a-8b36-a3bb77cf765b', NULL, '2026-03-04 22:42:57.060992+00', '2026-03-04 23:08:33.937345+00', NULL, NULL, true);
INSERT INTO public.users VALUES ('0f216f9d-f1ed-4122-9b3a-7544d44e9e04', 'Mondoño', 'mondoño@filopedo.com', '+51974673624', '$2a$10$Fh9g3E8AYKOz0gFTomYZ8efW6DcdzZ24PSYKHJlE4Uk.rnRpN5/wC', '00bb65f3-c4f7-433a-8b36-a3bb77cf765b', NULL, '2026-03-04 22:26:38.231621+00', '2026-03-04 22:27:41.080457+00', NULL, NULL, false);
INSERT INTO public.users VALUES ('aaec28ef-fb33-4d7d-941a-8295a858d82f', 'miguel_updated', 'miguelupdated@email.com', '+51987464745', '$2b$10$unYMH0v.clgHftuPVyvWsu4aZQytd4wQApm79UioKzwndSGNqNATe', '1987a053-4e9c-4174-9012-bd97bb6e82ab', 'aa3472f3-6145-4b07-b1d7-c25e435d1f12', '2026-04-11 00:47:26.032+00', '2026-04-11 01:05:49.449+00', NULL, NULL, true);
INSERT INTO public.users VALUES ('4deaaf11-265e-4b5a-8a99-1244bd97169a', 'cristoph', 'cristoph@email.com', '+51982321231', '$2b$10$Jh/wsQ1UTnt5q6nFKjGo3uQiZLYBPC1OMbhQ/wUbuMK8S.UfMIA2m', '1987a053-4e9c-4174-9012-bd97bb6e82ab', 'aa3472f3-6145-4b07-b1d7-c25e435d1f12', '2026-04-14 03:05:58.715+00', '2026-04-14 03:05:58.715+00', NULL, NULL, true);
INSERT INTO public.users VALUES ('a3991b2f-b994-4f03-89b8-3732d8505c26', 'pruebaauth1', 'pruebaauth1@email.com', '+51982321232', '$2b$10$8vRHnNxE9/VnB9OKf2MVVOLZ5SSwLzprpSKSD6Czy4EkZMqExkL/W', '1987a053-4e9c-4174-9012-bd97bb6e82ab', 'aa3472f3-6145-4b07-b1d7-c25e435d1f12', '2026-04-23 02:10:20.204+00', '2026-04-23 02:10:20.204+00', NULL, NULL, true);


--
-- TOC entry 4290 (class 2606 OID 16647)
-- Name: comment_attachments comment_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.comment_attachments
    ADD CONSTRAINT comment_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 4288 (class 2606 OID 16637)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 4266 (class 2606 OID 16546)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 4292 (class 2606 OID 16663)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4262 (class 2606 OID 16536)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- TOC entry 4264 (class 2606 OID 16534)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4286 (class 2606 OID 16620)
-- Name: ticket_status_history ticket_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_status_history
    ADD CONSTRAINT ticket_status_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4274 (class 2606 OID 16578)
-- Name: ticket_statuses ticket_statuses_name_key; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_statuses
    ADD CONSTRAINT ticket_statuses_name_key UNIQUE (name);


--
-- TOC entry 4276 (class 2606 OID 16576)
-- Name: ticket_statuses ticket_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_statuses
    ADD CONSTRAINT ticket_statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 4278 (class 2606 OID 16580)
-- Name: ticket_statuses ticket_statuses_step_order_key; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_statuses
    ADD CONSTRAINT ticket_statuses_step_order_key UNIQUE (step_order);


--
-- TOC entry 4280 (class 2606 OID 16590)
-- Name: ticket_types ticket_types_name_key; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_types
    ADD CONSTRAINT ticket_types_name_key UNIQUE (name);


--
-- TOC entry 4282 (class 2606 OID 16588)
-- Name: ticket_types ticket_types_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_types
    ADD CONSTRAINT ticket_types_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 16600)
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 4268 (class 2606 OID 16558)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4270 (class 2606 OID 16554)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4272 (class 2606 OID 16556)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4298 (class 2606 OID 16648)
-- Name: comment_attachments fk_attachment_comment; Type: FK CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.comment_attachments
    ADD CONSTRAINT fk_attachment_comment FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- TOC entry 4297 (class 2606 OID 16621)
-- Name: ticket_status_history fk_history_ticket; Type: FK CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.ticket_status_history
    ADD CONSTRAINT fk_history_ticket FOREIGN KEY (ticket_id) REFERENCES public.tickets(id) ON DELETE CASCADE;


--
-- TOC entry 4295 (class 2606 OID 16601)
-- Name: tickets fk_ticket_status; Type: FK CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_ticket_status FOREIGN KEY (status_id) REFERENCES public.ticket_statuses(id);


--
-- TOC entry 4296 (class 2606 OID 16606)
-- Name: tickets fk_ticket_type; Type: FK CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT fk_ticket_type FOREIGN KEY (type_id) REFERENCES public.ticket_types(id);


--
-- TOC entry 4293 (class 2606 OID 16564)
-- Name: users fk_user_department; Type: FK CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 4294 (class 2606 OID 16559)
-- Name: users fk_user_role; Type: FK CONSTRAINT; Schema: public; Owner:  admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-05-28 17:39:49

--
-- PostgreSQL database dump complete
--

