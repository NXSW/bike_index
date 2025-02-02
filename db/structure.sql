--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads (
    id integer NOT NULL,
    title character varying(255),
    body text,
    image character varying(255),
    target_url text,
    organization_id integer,
    live boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ads_id_seq OWNED BY public.ads.id;


--
-- Name: alert_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alert_images (
    id integer NOT NULL,
    stolen_record_id integer NOT NULL,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: alert_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alert_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alert_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alert_images_id_seq OWNED BY public.alert_images.id;


--
-- Name: ambassador_task_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ambassador_task_assignments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    ambassador_task_id integer NOT NULL,
    completed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ambassador_task_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ambassador_task_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ambassador_task_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ambassador_task_assignments_id_seq OWNED BY public.ambassador_task_assignments.id;


--
-- Name: ambassador_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ambassador_tasks (
    id integer NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: ambassador_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ambassador_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ambassador_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ambassador_tasks_id_seq OWNED BY public.ambassador_tasks.id;


--
-- Name: b_params; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.b_params (
    id integer NOT NULL,
    old_params text,
    bike_title character varying(255),
    creator_id integer,
    created_bike_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bike_errors text,
    image character varying(255),
    image_tmp character varying(255),
    image_processed boolean DEFAULT true,
    id_token text,
    params json DEFAULT '{"bike":{}}'::json,
    origin character varying,
    organization_id integer,
    email character varying
);


--
-- Name: b_params_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.b_params_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: b_params_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.b_params_id_seq OWNED BY public.b_params.id;


--
-- Name: bike_code_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bike_code_batches (
    id integer NOT NULL,
    user_id integer,
    organization_id integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    code_number_length integer,
    prefix character varying
);


--
-- Name: bike_code_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bike_code_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bike_code_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bike_code_batches_id_seq OWNED BY public.bike_code_batches.id;


--
-- Name: bike_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bike_codes (
    id integer NOT NULL,
    kind integer DEFAULT 0,
    code character varying,
    bike_id integer,
    organization_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    claimed_at timestamp without time zone,
    previous_bike_id integer,
    bike_code_batch_id integer,
    code_integer integer,
    code_prefix character varying
);


--
-- Name: bike_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bike_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bike_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bike_codes_id_seq OWNED BY public.bike_codes.id;


--
-- Name: bike_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bike_organizations (
    id integer NOT NULL,
    bike_id integer,
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    can_not_edit_claimed boolean DEFAULT false NOT NULL
);


--
-- Name: bike_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bike_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bike_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bike_organizations_id_seq OWNED BY public.bike_organizations.id;


--
-- Name: bikes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bikes (
    id integer NOT NULL,
    name character varying(255),
    serial_number character varying(255) NOT NULL,
    frame_model character varying(255),
    manufacturer_id integer,
    rear_tire_narrow boolean DEFAULT true,
    number_of_seats integer,
    creation_organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stolen boolean DEFAULT false NOT NULL,
    propulsion_type_other character varying(255),
    manufacturer_other character varying(255),
    zipcode character varying(255),
    cached_data text,
    description text,
    owner_email text,
    thumb_path text,
    video_embed text,
    year integer,
    creator_id integer,
    front_tire_narrow boolean,
    primary_frame_color_id integer,
    secondary_frame_color_id integer,
    tertiary_frame_color_id integer,
    handlebar_type_other character varying(255),
    front_wheel_size_id integer,
    rear_wheel_size_id integer,
    rear_gear_type_id integer,
    front_gear_type_id integer,
    additional_registration character varying(255),
    belt_drive boolean DEFAULT false NOT NULL,
    coaster_brake boolean DEFAULT false NOT NULL,
    frame_size character varying(255),
    frame_size_unit character varying(255),
    pdf character varying(255),
    abandoned boolean DEFAULT false NOT NULL,
    paint_id integer,
    registered_new boolean,
    example boolean DEFAULT false NOT NULL,
    country_id integer,
    serial_normalized character varying(255),
    stock_photo_url character varying(255),
    current_stolen_record_id integer,
    listing_order integer,
    approved_stolen boolean,
    all_description text,
    mnfg_name character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    frame_size_number double precision,
    updator_id integer,
    is_for_sale boolean DEFAULT false NOT NULL,
    made_without_serial boolean DEFAULT false NOT NULL,
    creation_state_id integer,
    frame_material integer,
    handlebar_type integer,
    cycle_type integer DEFAULT 0,
    propulsion_type integer DEFAULT 0,
    deleted_at timestamp without time zone,
    city character varying,
    latitude double precision,
    longitude double precision
);


--
-- Name: bikes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bikes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bikes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bikes_id_seq OWNED BY public.bikes.id;


--
-- Name: blogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blogs (
    id integer NOT NULL,
    title text,
    title_slug character varying(255),
    body text,
    body_abbr text,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    published_at timestamp without time zone,
    tags character varying(255),
    published boolean,
    old_title_slug character varying(255),
    description_abbr text,
    is_listicle boolean DEFAULT false NOT NULL,
    index_image character varying(255),
    index_image_id integer,
    index_image_lg character varying(255),
    language integer DEFAULT 0 NOT NULL,
    canonical_url character varying
);


--
-- Name: blogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blogs_id_seq OWNED BY public.blogs.id;


--
-- Name: bulk_imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bulk_imports (
    id integer NOT NULL,
    organization_id integer,
    user_id integer,
    file text,
    progress integer DEFAULT 0,
    no_notify boolean DEFAULT false,
    import_errors json DEFAULT '{}'::json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_ascend boolean DEFAULT false
);


--
-- Name: bulk_imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_imports_id_seq OWNED BY public.bulk_imports.id;


--
-- Name: cgroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cgroups (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cgroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cgroups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cgroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cgroups_id_seq OWNED BY public.cgroups.id;


--
-- Name: colors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.colors (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    priority integer,
    display character varying(255)
);


--
-- Name: colors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.colors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: colors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.colors_id_seq OWNED BY public.colors.id;


--
-- Name: components; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.components (
    id integer NOT NULL,
    cmodel_name character varying(255),
    year integer,
    description text,
    manufacturer_id integer,
    ctype_id integer,
    ctype_other character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bike_id integer,
    front boolean,
    rear boolean,
    manufacturer_other character varying(255),
    serial_number character varying(255),
    is_stock boolean DEFAULT false NOT NULL
);


--
-- Name: components_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.components_id_seq OWNED BY public.components.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying(255),
    iso character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: creation_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creation_states (
    id integer NOT NULL,
    bike_id integer,
    organization_id integer,
    origin character varying,
    is_bulk boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_pos boolean DEFAULT false NOT NULL,
    is_new boolean DEFAULT false NOT NULL,
    creator_id integer,
    bulk_import_id integer,
    pos_kind integer DEFAULT 0
);


--
-- Name: creation_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.creation_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: creation_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.creation_states_id_seq OWNED BY public.creation_states.id;


--
-- Name: ctypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ctypes (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    secondary_name character varying(255),
    image character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    has_multiple boolean DEFAULT false NOT NULL,
    cgroup_id integer
);


--
-- Name: ctypes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ctypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ctypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ctypes_id_seq OWNED BY public.ctypes.id;


--
-- Name: customer_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_contacts (
    id integer NOT NULL,
    user_id integer,
    user_email character varying(255),
    creator_id integer,
    creator_email character varying(255),
    title character varying(255),
    body text,
    bike_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    info_hash jsonb DEFAULT '{}'::jsonb,
    kind integer DEFAULT 0 NOT NULL
);


--
-- Name: customer_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_contacts_id_seq OWNED BY public.customer_contacts.id;


--
-- Name: duplicate_bike_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.duplicate_bike_groups (
    id integer NOT NULL,
    ignore boolean DEFAULT false NOT NULL,
    added_bike_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: duplicate_bike_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.duplicate_bike_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: duplicate_bike_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.duplicate_bike_groups_id_seq OWNED BY public.duplicate_bike_groups.id;


--
-- Name: exports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exports (
    id integer NOT NULL,
    organization_id integer,
    user_id integer,
    file text,
    file_format integer DEFAULT 0,
    kind integer DEFAULT 0,
    progress integer DEFAULT 0,
    rows integer,
    options jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: exports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exports_id_seq OWNED BY public.exports.id;


--
-- Name: external_registry_bikes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_registry_bikes (
    id integer NOT NULL,
    type character varying NOT NULL,
    country_id integer NOT NULL,
    serial_number character varying NOT NULL,
    serial_normalized character varying NOT NULL,
    external_id character varying NOT NULL,
    additional_registration character varying,
    date_stolen timestamp without time zone,
    category character varying,
    cycle_type character varying,
    description character varying,
    frame_colors character varying,
    frame_model character varying,
    location_found character varying,
    mnfg_name character varying,
    status character varying,
    info_hash jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: external_registry_bikes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.external_registry_bikes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_registry_bikes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.external_registry_bikes_id_seq OWNED BY public.external_registry_bikes.id;


--
-- Name: external_registry_credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_registry_credentials (
    id integer NOT NULL,
    type character varying NOT NULL,
    app_id character varying,
    access_token character varying,
    access_token_expires_at timestamp without time zone,
    refresh_token character varying,
    info_hash jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: external_registry_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.external_registry_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_registry_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.external_registry_credentials_id_seq OWNED BY public.external_registry_credentials.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    title character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    feedback_type character varying(255),
    user_id integer,
    feedback_hash jsonb
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedbacks_id_seq OWNED BY public.feedbacks.id;


--
-- Name: flipper_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flipper_features (
    id integer NOT NULL,
    key character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flipper_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flipper_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flipper_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flipper_features_id_seq OWNED BY public.flipper_features.id;


--
-- Name: flipper_gates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flipper_gates (
    id integer NOT NULL,
    feature_key character varying NOT NULL,
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flipper_gates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flipper_gates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flipper_gates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flipper_gates_id_seq OWNED BY public.flipper_gates.id;


--
-- Name: front_gear_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.front_gear_types (
    id integer NOT NULL,
    name character varying(255),
    count integer,
    internal boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    standard boolean,
    slug character varying(255)
);


--
-- Name: front_gear_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.front_gear_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: front_gear_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.front_gear_types_id_seq OWNED BY public.front_gear_types.id;


--
-- Name: impound_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.impound_records (
    id integer NOT NULL,
    bike_id integer,
    user_id integer,
    organization_id integer,
    retrieved_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: impound_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.impound_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impound_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.impound_records_id_seq OWNED BY public.impound_records.id;


--
-- Name: integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integrations (
    id integer NOT NULL,
    user_id integer,
    access_token text,
    provider_name character varying(255),
    information text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.integrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.integrations_id_seq OWNED BY public.integrations.id;


--
-- Name: invoice_paid_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_paid_features (
    id integer NOT NULL,
    invoice_id integer,
    paid_feature_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invoice_paid_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_paid_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_paid_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoice_paid_features_id_seq OWNED BY public.invoice_paid_features.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    organization_id integer,
    first_invoice_id integer,
    is_active boolean DEFAULT false NOT NULL,
    force_active boolean DEFAULT false NOT NULL,
    subscription_start_at timestamp without time zone,
    subscription_end_at timestamp without time zone,
    amount_due_cents integer,
    amount_paid_cents integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text,
    child_paid_feature_slugs jsonb,
    currency character varying DEFAULT 'USD'::character varying NOT NULL
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: listicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.listicles (
    id integer NOT NULL,
    list_order integer,
    body text,
    blog_id integer,
    image character varying(255),
    title text,
    body_html text,
    image_width integer,
    image_height integer,
    image_credits text,
    image_credits_html text,
    crop_top_offset integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: listicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.listicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: listicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.listicles_id_seq OWNED BY public.listicles.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    organization_id integer,
    zipcode character varying(255),
    city character varying(255),
    street character varying(255),
    phone character varying(255),
    email character varying(255),
    name character varying(255),
    latitude double precision,
    longitude double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    shown boolean DEFAULT false,
    country_id integer,
    state_id integer
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: lock_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lock_types (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lock_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lock_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lock_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lock_types_id_seq OWNED BY public.lock_types.id;


--
-- Name: locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locks (
    id integer NOT NULL,
    lock_type_id integer DEFAULT 1,
    has_key boolean DEFAULT true,
    has_combination boolean,
    combination character varying(255),
    key_serial character varying(255),
    manufacturer_id integer,
    manufacturer_other character varying(255),
    user_id integer,
    lock_model character varying(255),
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locks_id_seq OWNED BY public.locks.id;


--
-- Name: mail_snippets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_snippets (
    id integer NOT NULL,
    name character varying(255),
    is_enabled boolean DEFAULT false NOT NULL,
    is_location_triggered boolean DEFAULT false NOT NULL,
    body text,
    address character varying(255),
    latitude double precision,
    longitude double precision,
    proximity_radius integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer,
    kind integer DEFAULT 0
);


--
-- Name: mail_snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mail_snippets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mail_snippets_id_seq OWNED BY public.mail_snippets.id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manufacturers (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    website character varying(255),
    frame_maker boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    total_years_active character varying(255),
    notes text,
    open_year integer,
    close_year integer,
    logo character varying(255),
    description text,
    logo_source character varying(255)
);


--
-- Name: manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manufacturers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manufacturers_id_seq OWNED BY public.manufacturers.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.memberships (
    id integer NOT NULL,
    organization_id integer NOT NULL,
    user_id integer,
    role character varying(255) DEFAULT 'member'::character varying NOT NULL,
    invited_email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    sender_id integer,
    claimed_at timestamp without time zone,
    email_invitation_sent_at timestamp without time zone
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.memberships_id_seq OWNED BY public.memberships.id;


--
-- Name: normalized_serial_segments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.normalized_serial_segments (
    id integer NOT NULL,
    segment character varying(255),
    bike_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    duplicate_bike_group_id integer
);


--
-- Name: normalized_serial_segments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.normalized_serial_segments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: normalized_serial_segments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.normalized_serial_segments_id_seq OWNED BY public.normalized_serial_segments.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying(255) NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying(255)
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_grants_id_seq OWNED BY public.oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer,
    token character varying(255) NOT NULL,
    refresh_token character varying(255),
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying(255)
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_tokens_id_seq OWNED BY public.oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_applications (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner_id integer,
    owner_type character varying(255),
    is_internal boolean DEFAULT false NOT NULL,
    can_send_stolen_notifications boolean DEFAULT false NOT NULL,
    scopes character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_applications_id_seq OWNED BY public.oauth_applications.id;


--
-- Name: organization_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_messages (
    id integer NOT NULL,
    kind integer DEFAULT 0,
    organization_id integer,
    sender_id integer,
    bike_id integer,
    email character varying,
    body text,
    delivery_status character varying,
    address character varying,
    latitude double precision,
    longitude double precision,
    accuracy double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_messages_id_seq OWNED BY public.organization_messages.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255) NOT NULL,
    available_invitation_count integer DEFAULT 10,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    website character varying(255),
    short_name character varying(255),
    show_on_map boolean,
    deleted_at timestamp without time zone,
    is_suspended boolean DEFAULT false NOT NULL,
    auto_user_id integer,
    access_token character varying(255),
    api_access_approved boolean DEFAULT false NOT NULL,
    approved boolean DEFAULT true,
    avatar character varying(255),
    is_paid boolean DEFAULT false NOT NULL,
    lock_show_on_map boolean DEFAULT false NOT NULL,
    landing_html text,
    paid_feature_slugs jsonb,
    parent_organization_id integer,
    kind integer,
    ascend_name character varying,
    registration_field_labels jsonb DEFAULT '{}'::jsonb,
    pos_kind integer DEFAULT 0,
    previous_slug character varying,
    child_ids jsonb,
    search_radius integer DEFAULT 50 NOT NULL,
    location_latitude double precision,
    location_longitude double precision,
    regional_ids jsonb
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: other_listings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.other_listings (
    id integer NOT NULL,
    bike_id integer,
    url character varying(255),
    listing_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: other_listings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.other_listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: other_listings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.other_listings_id_seq OWNED BY public.other_listings.id;


--
-- Name: ownerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ownerships (
    id integer NOT NULL,
    bike_id integer,
    user_id integer,
    owner_email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    current boolean DEFAULT false,
    claimed boolean,
    example boolean DEFAULT false NOT NULL,
    send_email boolean DEFAULT true,
    user_hidden boolean DEFAULT false NOT NULL
);


--
-- Name: ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ownerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ownerships_id_seq OWNED BY public.ownerships.id;


--
-- Name: paid_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paid_features (
    id integer NOT NULL,
    kind integer DEFAULT 0,
    amount_cents integer,
    name character varying,
    description text,
    details_link character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    feature_slugs text[] DEFAULT '{}'::text[],
    currency character varying DEFAULT 'USD'::character varying NOT NULL
);


--
-- Name: paid_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.paid_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paid_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.paid_features_id_seq OWNED BY public.paid_features.id;


--
-- Name: paints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.paints (
    id integer NOT NULL,
    name character varying(255),
    color_id integer,
    manufacturer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    secondary_color_id integer,
    tertiary_color_id integer,
    bikes_count integer DEFAULT 0 NOT NULL
);


--
-- Name: paints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.paints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: paints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.paints_id_seq OWNED BY public.paints.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    user_id integer,
    is_current boolean DEFAULT true,
    is_recurring boolean DEFAULT false NOT NULL,
    stripe_id character varying(255),
    last_payment_date timestamp without time zone,
    first_payment_date timestamp without time zone,
    amount_cents integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255),
    is_payment boolean DEFAULT false NOT NULL,
    kind integer DEFAULT 0,
    organization_id integer,
    invoice_id integer,
    currency character varying DEFAULT 'USD'::character varying NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: public_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.public_images (
    id integer NOT NULL,
    image character varying(255),
    name character varying(255),
    listing_order integer DEFAULT 0,
    imageable_id integer,
    imageable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_private boolean DEFAULT false NOT NULL,
    external_image_url text
);


--
-- Name: public_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.public_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: public_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.public_images_id_seq OWNED BY public.public_images.id;


--
-- Name: rear_gear_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rear_gear_types (
    id integer NOT NULL,
    name character varying(255),
    count integer,
    internal boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    standard boolean,
    slug character varying(255)
);


--
-- Name: rear_gear_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rear_gear_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rear_gear_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rear_gear_types_id_seq OWNED BY public.rear_gear_types.id;


--
-- Name: recovery_displays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recovery_displays (
    id integer NOT NULL,
    stolen_record_id integer,
    quote text,
    quote_by character varying(255),
    recovered_at timestamp without time zone,
    link character varying(255),
    image character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recovery_displays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recovery_displays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recovery_displays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recovery_displays_id_seq OWNED BY public.recovery_displays.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    id integer NOT NULL,
    name character varying(255),
    abbreviation character varying(255),
    country_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- Name: stolen_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stolen_notifications (
    id integer NOT NULL,
    subject character varying(255),
    message text,
    sender_id integer,
    receiver_id integer,
    bike_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    receiver_email character varying(255),
    oauth_application_id integer,
    reference_url text,
    send_dates json
);


--
-- Name: stolen_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stolen_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stolen_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stolen_notifications_id_seq OWNED BY public.stolen_notifications.id;


--
-- Name: stolen_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stolen_records (
    id integer NOT NULL,
    zipcode character varying(255),
    city character varying(255),
    theft_description text,
    "time" text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    bike_id integer,
    current boolean DEFAULT true,
    street character varying(255),
    latitude double precision,
    longitude double precision,
    date_stolen timestamp without time zone,
    phone character varying(255),
    phone_for_everyone boolean,
    phone_for_users boolean DEFAULT true,
    phone_for_shops boolean DEFAULT true,
    phone_for_police boolean DEFAULT true,
    police_report_number character varying(255),
    locking_description character varying(255),
    lock_defeat_description character varying(255),
    country_id integer,
    police_report_department character varying(255),
    state_id integer,
    creation_organization_id integer,
    secondary_phone character varying(255),
    approved boolean DEFAULT false NOT NULL,
    receive_notifications boolean DEFAULT true,
    proof_of_ownership boolean,
    recovered_at timestamp without time zone,
    recovered_description text,
    index_helped_recovery boolean DEFAULT false NOT NULL,
    can_share_recovery boolean DEFAULT false NOT NULL,
    recovery_posted boolean DEFAULT false,
    recovery_tweet text,
    recovery_share text,
    create_open311 boolean DEFAULT false NOT NULL,
    tsved_at timestamp without time zone,
    estimated_value integer,
    recovery_link_token text,
    show_address boolean DEFAULT false,
    recovering_user_id integer,
    recovery_display_status integer DEFAULT 0,
    neighborhood character varying
);


--
-- Name: stolen_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stolen_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stolen_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stolen_records_id_seq OWNED BY public.stolen_records.id;


--
-- Name: theft_alert_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.theft_alert_plans (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    amount_cents integer NOT NULL,
    views integer NOT NULL,
    duration_days integer NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    language integer DEFAULT 0 NOT NULL,
    currency character varying DEFAULT 'USD'::character varying NOT NULL
);


--
-- Name: theft_alert_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.theft_alert_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: theft_alert_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.theft_alert_plans_id_seq OWNED BY public.theft_alert_plans.id;


--
-- Name: theft_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.theft_alerts (
    id integer NOT NULL,
    stolen_record_id integer,
    theft_alert_plan_id integer,
    payment_id integer,
    user_id integer,
    status integer DEFAULT 0 NOT NULL,
    facebook_post_url character varying DEFAULT ''::character varying NOT NULL,
    begin_at timestamp without time zone,
    end_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notes text
);


--
-- Name: theft_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.theft_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: theft_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.theft_alerts_id_seq OWNED BY public.theft_alerts.id;


--
-- Name: tweets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tweets (
    id integer NOT NULL,
    twitter_id character varying,
    twitter_response json,
    body_html text,
    image character varying,
    alignment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    twitter_account_id integer,
    stolen_record_id integer,
    original_tweet_id integer
);


--
-- Name: tweets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tweets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tweets_id_seq OWNED BY public.tweets.id;


--
-- Name: twitter_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.twitter_accounts (
    id integer NOT NULL,
    active boolean DEFAULT false NOT NULL,
    "default" boolean DEFAULT false NOT NULL,
    "national" boolean DEFAULT false NOT NULL,
    latitude double precision,
    longitude double precision,
    address character varying,
    append_block character varying,
    city character varying,
    consumer_key character varying NOT NULL,
    consumer_secret character varying NOT NULL,
    country character varying,
    language character varying,
    neighborhood character varying,
    screen_name character varying NOT NULL,
    state character varying,
    user_secret character varying NOT NULL,
    user_token character varying NOT NULL,
    twitter_account_info jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_error character varying,
    last_error_at timestamp without time zone
);


--
-- Name: twitter_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.twitter_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: twitter_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.twitter_accounts_id_seq OWNED BY public.twitter_accounts.id;


--
-- Name: user_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_emails (
    id integer NOT NULL,
    email character varying(255),
    user_id integer,
    old_user_id integer,
    confirmation_token text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_emails_id_seq OWNED BY public.user_emails.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    password text,
    last_login_at timestamp without time zone,
    superuser boolean DEFAULT false NOT NULL,
    password_reset_token text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying(255),
    banned boolean DEFAULT false NOT NULL,
    phone character varying(255),
    zipcode character varying(255),
    twitter character varying(255),
    show_twitter boolean DEFAULT false NOT NULL,
    website character varying(255),
    show_website boolean DEFAULT false NOT NULL,
    show_phone boolean DEFAULT true,
    show_bikes boolean DEFAULT false NOT NULL,
    username character varying(255),
    avatar character varying(255),
    description text,
    title text,
    terms_of_service boolean DEFAULT false NOT NULL,
    vendor_terms_of_service boolean,
    when_vendor_terms_of_service timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    confirmation_token character varying(255),
    can_send_many_stolen_notifications boolean DEFAULT false NOT NULL,
    auth_token character varying(255),
    stripe_id character varying(255),
    notification_newsletters boolean DEFAULT false NOT NULL,
    developer boolean DEFAULT false NOT NULL,
    partner_data jsonb,
    latitude double precision,
    longitude double precision,
    street character varying,
    city character varying,
    country_id integer,
    state_id integer,
    notification_unstolen boolean DEFAULT true,
    my_bikes_hash jsonb,
    preferred_language character varying,
    last_login_ip character varying,
    magic_link_token text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: wheel_sizes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wheel_sizes (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    iso_bsd integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    priority integer
);


--
-- Name: wheel_sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wheel_sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wheel_sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wheel_sizes_id_seq OWNED BY public.wheel_sizes.id;


--
-- Name: ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads ALTER COLUMN id SET DEFAULT nextval('public.ads_id_seq'::regclass);


--
-- Name: alert_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_images ALTER COLUMN id SET DEFAULT nextval('public.alert_images_id_seq'::regclass);


--
-- Name: ambassador_task_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassador_task_assignments ALTER COLUMN id SET DEFAULT nextval('public.ambassador_task_assignments_id_seq'::regclass);


--
-- Name: ambassador_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassador_tasks ALTER COLUMN id SET DEFAULT nextval('public.ambassador_tasks_id_seq'::regclass);


--
-- Name: b_params id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.b_params ALTER COLUMN id SET DEFAULT nextval('public.b_params_id_seq'::regclass);


--
-- Name: bike_code_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bike_code_batches ALTER COLUMN id SET DEFAULT nextval('public.bike_code_batches_id_seq'::regclass);


--
-- Name: bike_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bike_codes ALTER COLUMN id SET DEFAULT nextval('public.bike_codes_id_seq'::regclass);


--
-- Name: bike_organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bike_organizations ALTER COLUMN id SET DEFAULT nextval('public.bike_organizations_id_seq'::regclass);


--
-- Name: bikes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bikes ALTER COLUMN id SET DEFAULT nextval('public.bikes_id_seq'::regclass);


--
-- Name: blogs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs ALTER COLUMN id SET DEFAULT nextval('public.blogs_id_seq'::regclass);


--
-- Name: bulk_imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_imports ALTER COLUMN id SET DEFAULT nextval('public.bulk_imports_id_seq'::regclass);


--
-- Name: cgroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cgroups ALTER COLUMN id SET DEFAULT nextval('public.cgroups_id_seq'::regclass);


--
-- Name: colors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colors ALTER COLUMN id SET DEFAULT nextval('public.colors_id_seq'::regclass);


--
-- Name: components id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.components ALTER COLUMN id SET DEFAULT nextval('public.components_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: creation_states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creation_states ALTER COLUMN id SET DEFAULT nextval('public.creation_states_id_seq'::regclass);


--
-- Name: ctypes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ctypes ALTER COLUMN id SET DEFAULT nextval('public.ctypes_id_seq'::regclass);


--
-- Name: customer_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_contacts ALTER COLUMN id SET DEFAULT nextval('public.customer_contacts_id_seq'::regclass);


--
-- Name: duplicate_bike_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duplicate_bike_groups ALTER COLUMN id SET DEFAULT nextval('public.duplicate_bike_groups_id_seq'::regclass);


--
-- Name: exports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports ALTER COLUMN id SET DEFAULT nextval('public.exports_id_seq'::regclass);


--
-- Name: external_registry_bikes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_registry_bikes ALTER COLUMN id SET DEFAULT nextval('public.external_registry_bikes_id_seq'::regclass);


--
-- Name: external_registry_credentials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_registry_credentials ALTER COLUMN id SET DEFAULT nextval('public.external_registry_credentials_id_seq'::regclass);


--
-- Name: feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks ALTER COLUMN id SET DEFAULT nextval('public.feedbacks_id_seq'::regclass);


--
-- Name: flipper_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_features ALTER COLUMN id SET DEFAULT nextval('public.flipper_features_id_seq'::regclass);


--
-- Name: flipper_gates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_gates ALTER COLUMN id SET DEFAULT nextval('public.flipper_gates_id_seq'::regclass);


--
-- Name: front_gear_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.front_gear_types ALTER COLUMN id SET DEFAULT nextval('public.front_gear_types_id_seq'::regclass);


--
-- Name: impound_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impound_records ALTER COLUMN id SET DEFAULT nextval('public.impound_records_id_seq'::regclass);


--
-- Name: integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations ALTER COLUMN id SET DEFAULT nextval('public.integrations_id_seq'::regclass);


--
-- Name: invoice_paid_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_paid_features ALTER COLUMN id SET DEFAULT nextval('public.invoice_paid_features_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: listicles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listicles ALTER COLUMN id SET DEFAULT nextval('public.listicles_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: lock_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lock_types ALTER COLUMN id SET DEFAULT nextval('public.lock_types_id_seq'::regclass);


--
-- Name: locks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locks ALTER COLUMN id SET DEFAULT nextval('public.locks_id_seq'::regclass);


--
-- Name: mail_snippets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_snippets ALTER COLUMN id SET DEFAULT nextval('public.mail_snippets_id_seq'::regclass);


--
-- Name: manufacturers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN id SET DEFAULT nextval('public.manufacturers_id_seq'::regclass);


--
-- Name: memberships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships ALTER COLUMN id SET DEFAULT nextval('public.memberships_id_seq'::regclass);


--
-- Name: normalized_serial_segments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.normalized_serial_segments ALTER COLUMN id SET DEFAULT nextval('public.normalized_serial_segments_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications ALTER COLUMN id SET DEFAULT nextval('public.oauth_applications_id_seq'::regclass);


--
-- Name: organization_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_messages ALTER COLUMN id SET DEFAULT nextval('public.organization_messages_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: other_listings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_listings ALTER COLUMN id SET DEFAULT nextval('public.other_listings_id_seq'::regclass);


--
-- Name: ownerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships ALTER COLUMN id SET DEFAULT nextval('public.ownerships_id_seq'::regclass);


--
-- Name: paid_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_features ALTER COLUMN id SET DEFAULT nextval('public.paid_features_id_seq'::regclass);


--
-- Name: paints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paints ALTER COLUMN id SET DEFAULT nextval('public.paints_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: public_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_images ALTER COLUMN id SET DEFAULT nextval('public.public_images_id_seq'::regclass);


--
-- Name: rear_gear_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rear_gear_types ALTER COLUMN id SET DEFAULT nextval('public.rear_gear_types_id_seq'::regclass);


--
-- Name: recovery_displays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recovery_displays ALTER COLUMN id SET DEFAULT nextval('public.recovery_displays_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- Name: stolen_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stolen_notifications ALTER COLUMN id SET DEFAULT nextval('public.stolen_notifications_id_seq'::regclass);


--
-- Name: stolen_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stolen_records ALTER COLUMN id SET DEFAULT nextval('public.stolen_records_id_seq'::regclass);


--
-- Name: theft_alert_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alert_plans ALTER COLUMN id SET DEFAULT nextval('public.theft_alert_plans_id_seq'::regclass);


--
-- Name: theft_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alerts ALTER COLUMN id SET DEFAULT nextval('public.theft_alerts_id_seq'::regclass);


--
-- Name: tweets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweets ALTER COLUMN id SET DEFAULT nextval('public.tweets_id_seq'::regclass);


--
-- Name: twitter_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.twitter_accounts ALTER COLUMN id SET DEFAULT nextval('public.twitter_accounts_id_seq'::regclass);


--
-- Name: user_emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_emails ALTER COLUMN id SET DEFAULT nextval('public.user_emails_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wheel_sizes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wheel_sizes ALTER COLUMN id SET DEFAULT nextval('public.wheel_sizes_id_seq'::regclass);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: alert_images alert_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_images
    ADD CONSTRAINT alert_images_pkey PRIMARY KEY (id);


--
-- Name: ambassador_task_assignments ambassador_task_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassador_task_assignments
    ADD CONSTRAINT ambassador_task_assignments_pkey PRIMARY KEY (id);


--
-- Name: ambassador_tasks ambassador_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassador_tasks
    ADD CONSTRAINT ambassador_tasks_pkey PRIMARY KEY (id);


--
-- Name: b_params b_params_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.b_params
    ADD CONSTRAINT b_params_pkey PRIMARY KEY (id);


--
-- Name: bike_code_batches bike_code_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bike_code_batches
    ADD CONSTRAINT bike_code_batches_pkey PRIMARY KEY (id);


--
-- Name: bike_codes bike_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bike_codes
    ADD CONSTRAINT bike_codes_pkey PRIMARY KEY (id);


--
-- Name: bike_organizations bike_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bike_organizations
    ADD CONSTRAINT bike_organizations_pkey PRIMARY KEY (id);


--
-- Name: bikes bikes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bikes
    ADD CONSTRAINT bikes_pkey PRIMARY KEY (id);


--
-- Name: blogs blogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blogs
    ADD CONSTRAINT blogs_pkey PRIMARY KEY (id);


--
-- Name: bulk_imports bulk_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_imports
    ADD CONSTRAINT bulk_imports_pkey PRIMARY KEY (id);


--
-- Name: cgroups cgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cgroups
    ADD CONSTRAINT cgroups_pkey PRIMARY KEY (id);


--
-- Name: colors colors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_pkey PRIMARY KEY (id);


--
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: creation_states creation_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creation_states
    ADD CONSTRAINT creation_states_pkey PRIMARY KEY (id);


--
-- Name: ctypes ctypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ctypes
    ADD CONSTRAINT ctypes_pkey PRIMARY KEY (id);


--
-- Name: customer_contacts customer_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_contacts
    ADD CONSTRAINT customer_contacts_pkey PRIMARY KEY (id);


--
-- Name: duplicate_bike_groups duplicate_bike_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.duplicate_bike_groups
    ADD CONSTRAINT duplicate_bike_groups_pkey PRIMARY KEY (id);


--
-- Name: exports exports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exports
    ADD CONSTRAINT exports_pkey PRIMARY KEY (id);


--
-- Name: external_registry_bikes external_registry_bikes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_registry_bikes
    ADD CONSTRAINT external_registry_bikes_pkey PRIMARY KEY (id);


--
-- Name: external_registry_credentials external_registry_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_registry_credentials
    ADD CONSTRAINT external_registry_credentials_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: flipper_features flipper_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_features
    ADD CONSTRAINT flipper_features_pkey PRIMARY KEY (id);


--
-- Name: flipper_gates flipper_gates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flipper_gates
    ADD CONSTRAINT flipper_gates_pkey PRIMARY KEY (id);


--
-- Name: front_gear_types front_gear_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.front_gear_types
    ADD CONSTRAINT front_gear_types_pkey PRIMARY KEY (id);


--
-- Name: impound_records impound_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.impound_records
    ADD CONSTRAINT impound_records_pkey PRIMARY KEY (id);


--
-- Name: integrations integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (id);


--
-- Name: invoice_paid_features invoice_paid_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_paid_features
    ADD CONSTRAINT invoice_paid_features_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: listicles listicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.listicles
    ADD CONSTRAINT listicles_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: lock_types lock_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lock_types
    ADD CONSTRAINT lock_types_pkey PRIMARY KEY (id);


--
-- Name: locks locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locks
    ADD CONSTRAINT locks_pkey PRIMARY KEY (id);


--
-- Name: mail_snippets mail_snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_snippets
    ADD CONSTRAINT mail_snippets_pkey PRIMARY KEY (id);


--
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: memberships memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: normalized_serial_segments normalized_serial_segments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.normalized_serial_segments
    ADD CONSTRAINT normalized_serial_segments_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: organization_messages organization_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_messages
    ADD CONSTRAINT organization_messages_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: other_listings other_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_listings
    ADD CONSTRAINT other_listings_pkey PRIMARY KEY (id);


--
-- Name: ownerships ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships
    ADD CONSTRAINT ownerships_pkey PRIMARY KEY (id);


--
-- Name: paid_features paid_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paid_features
    ADD CONSTRAINT paid_features_pkey PRIMARY KEY (id);


--
-- Name: paints paints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.paints
    ADD CONSTRAINT paints_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: public_images public_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.public_images
    ADD CONSTRAINT public_images_pkey PRIMARY KEY (id);


--
-- Name: rear_gear_types rear_gear_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rear_gear_types
    ADD CONSTRAINT rear_gear_types_pkey PRIMARY KEY (id);


--
-- Name: recovery_displays recovery_displays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recovery_displays
    ADD CONSTRAINT recovery_displays_pkey PRIMARY KEY (id);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: stolen_records stolen_bike_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stolen_records
    ADD CONSTRAINT stolen_bike_descriptions_pkey PRIMARY KEY (id);


--
-- Name: stolen_notifications stolen_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stolen_notifications
    ADD CONSTRAINT stolen_notifications_pkey PRIMARY KEY (id);


--
-- Name: theft_alert_plans theft_alert_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alert_plans
    ADD CONSTRAINT theft_alert_plans_pkey PRIMARY KEY (id);


--
-- Name: theft_alerts theft_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alerts
    ADD CONSTRAINT theft_alerts_pkey PRIMARY KEY (id);


--
-- Name: tweets tweets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweets
    ADD CONSTRAINT tweets_pkey PRIMARY KEY (id);


--
-- Name: twitter_accounts twitter_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.twitter_accounts
    ADD CONSTRAINT twitter_accounts_pkey PRIMARY KEY (id);


--
-- Name: user_emails user_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_emails
    ADD CONSTRAINT user_emails_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wheel_sizes wheel_sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wheel_sizes
    ADD CONSTRAINT wheel_sizes_pkey PRIMARY KEY (id);


--
-- Name: index_alert_images_on_stolen_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alert_images_on_stolen_record_id ON public.alert_images USING btree (stolen_record_id);


--
-- Name: index_ambassador_task_assignments_on_ambassador_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ambassador_task_assignments_on_ambassador_task_id ON public.ambassador_task_assignments USING btree (ambassador_task_id);


--
-- Name: index_ambassador_task_assignments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ambassador_task_assignments_on_user_id ON public.ambassador_task_assignments USING btree (user_id);


--
-- Name: index_ambassador_tasks_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ambassador_tasks_on_title ON public.ambassador_tasks USING btree (title);


--
-- Name: index_b_params_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_b_params_on_organization_id ON public.b_params USING btree (organization_id);


--
-- Name: index_bike_code_batches_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_code_batches_on_organization_id ON public.bike_code_batches USING btree (organization_id);


--
-- Name: index_bike_code_batches_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_code_batches_on_user_id ON public.bike_code_batches USING btree (user_id);


--
-- Name: index_bike_codes_on_bike_code_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_codes_on_bike_code_batch_id ON public.bike_codes USING btree (bike_code_batch_id);


--
-- Name: index_bike_codes_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_codes_on_bike_id ON public.bike_codes USING btree (bike_id);


--
-- Name: index_bike_organizations_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_organizations_on_bike_id ON public.bike_organizations USING btree (bike_id);


--
-- Name: index_bike_organizations_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_organizations_on_deleted_at ON public.bike_organizations USING btree (deleted_at);


--
-- Name: index_bike_organizations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bike_organizations_on_organization_id ON public.bike_organizations USING btree (organization_id);


--
-- Name: index_bikes_on_creation_state_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_creation_state_id ON public.bikes USING btree (creation_state_id);


--
-- Name: index_bikes_on_current_stolen_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_current_stolen_record_id ON public.bikes USING btree (current_stolen_record_id);


--
-- Name: index_bikes_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_deleted_at ON public.bikes USING btree (deleted_at);


--
-- Name: index_bikes_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_latitude_and_longitude ON public.bikes USING btree (latitude, longitude);


--
-- Name: index_bikes_on_listing_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_listing_order ON public.bikes USING btree (listing_order DESC);


--
-- Name: index_bikes_on_manufacturer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_manufacturer_id ON public.bikes USING btree (manufacturer_id);


--
-- Name: index_bikes_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_organization_id ON public.bikes USING btree (creation_organization_id);


--
-- Name: index_bikes_on_paint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_paint_id ON public.bikes USING btree (paint_id);


--
-- Name: index_bikes_on_primary_frame_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_primary_frame_color_id ON public.bikes USING btree (primary_frame_color_id);


--
-- Name: index_bikes_on_secondary_frame_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_secondary_frame_color_id ON public.bikes USING btree (secondary_frame_color_id);


--
-- Name: index_bikes_on_tertiary_frame_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_tertiary_frame_color_id ON public.bikes USING btree (tertiary_frame_color_id);


--
-- Name: index_components_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_components_on_bike_id ON public.components USING btree (bike_id);


--
-- Name: index_components_on_manufacturer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_components_on_manufacturer_id ON public.components USING btree (manufacturer_id);


--
-- Name: index_creation_states_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_creation_states_on_bike_id ON public.creation_states USING btree (bike_id);


--
-- Name: index_creation_states_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_creation_states_on_creator_id ON public.creation_states USING btree (creator_id);


--
-- Name: index_creation_states_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_creation_states_on_organization_id ON public.creation_states USING btree (organization_id);


--
-- Name: index_exports_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exports_on_organization_id ON public.exports USING btree (organization_id);


--
-- Name: index_exports_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exports_on_user_id ON public.exports USING btree (user_id);


--
-- Name: index_external_registry_bikes_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_registry_bikes_on_country_id ON public.external_registry_bikes USING btree (country_id);


--
-- Name: index_external_registry_bikes_on_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_registry_bikes_on_external_id ON public.external_registry_bikes USING btree (external_id);


--
-- Name: index_external_registry_bikes_on_serial_normalized; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_registry_bikes_on_serial_normalized ON public.external_registry_bikes USING btree (serial_normalized);


--
-- Name: index_external_registry_bikes_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_registry_bikes_on_type ON public.external_registry_bikes USING btree (type);


--
-- Name: index_external_registry_credentials_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_registry_credentials_on_type ON public.external_registry_credentials USING btree (type);


--
-- Name: index_feedbacks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedbacks_on_user_id ON public.feedbacks USING btree (user_id);


--
-- Name: index_flipper_features_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flipper_features_on_key ON public.flipper_features USING btree (key);


--
-- Name: index_flipper_gates_on_feature_key_and_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flipper_gates_on_feature_key_and_key_and_value ON public.flipper_gates USING btree (feature_key, key, value);


--
-- Name: index_impound_records_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_impound_records_on_bike_id ON public.impound_records USING btree (bike_id);


--
-- Name: index_impound_records_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_impound_records_on_organization_id ON public.impound_records USING btree (organization_id);


--
-- Name: index_impound_records_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_impound_records_on_user_id ON public.impound_records USING btree (user_id);


--
-- Name: index_integrations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_integrations_on_user_id ON public.integrations USING btree (user_id);


--
-- Name: index_invoice_paid_features_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoice_paid_features_on_invoice_id ON public.invoice_paid_features USING btree (invoice_id);


--
-- Name: index_invoice_paid_features_on_paid_feature_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoice_paid_features_on_paid_feature_id ON public.invoice_paid_features USING btree (paid_feature_id);


--
-- Name: index_invoices_on_first_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_first_invoice_id ON public.invoices USING btree (first_invoice_id);


--
-- Name: index_invoices_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_organization_id ON public.invoices USING btree (organization_id);


--
-- Name: index_locks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locks_on_user_id ON public.locks USING btree (user_id);


--
-- Name: index_mail_snippets_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mail_snippets_on_organization_id ON public.mail_snippets USING btree (organization_id);


--
-- Name: index_memberships_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_organization_id ON public.memberships USING btree (organization_id);


--
-- Name: index_memberships_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_sender_id ON public.memberships USING btree (sender_id);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_memberships_on_user_id ON public.memberships USING btree (user_id);


--
-- Name: index_normalized_serial_segments_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_normalized_serial_segments_on_bike_id ON public.normalized_serial_segments USING btree (bike_id);


--
-- Name: index_normalized_serial_segments_on_duplicate_bike_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_normalized_serial_segments_on_duplicate_bike_group_id ON public.normalized_serial_segments USING btree (duplicate_bike_group_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON public.oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON public.oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON public.oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON public.oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON public.oauth_applications USING btree (owner_id, owner_type);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON public.oauth_applications USING btree (uid);


--
-- Name: index_organization_messages_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_messages_on_bike_id ON public.organization_messages USING btree (bike_id);


--
-- Name: index_organization_messages_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_messages_on_organization_id ON public.organization_messages USING btree (organization_id);


--
-- Name: index_organization_messages_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_messages_on_sender_id ON public.organization_messages USING btree (sender_id);


--
-- Name: index_organizations_on_location_latitude_and_location_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_location_latitude_and_location_longitude ON public.organizations USING btree (location_latitude, location_longitude);


--
-- Name: index_organizations_on_parent_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_parent_organization_id ON public.organizations USING btree (parent_organization_id);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON public.organizations USING btree (slug);


--
-- Name: index_ownerships_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ownerships_on_bike_id ON public.ownerships USING btree (bike_id);


--
-- Name: index_ownerships_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ownerships_on_creator_id ON public.ownerships USING btree (creator_id);


--
-- Name: index_ownerships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ownerships_on_user_id ON public.ownerships USING btree (user_id);


--
-- Name: index_payments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_user_id ON public.payments USING btree (user_id);


--
-- Name: index_public_images_on_imageable_id_and_imageable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_public_images_on_imageable_id_and_imageable_type ON public.public_images USING btree (imageable_id, imageable_type);


--
-- Name: index_recovery_displays_on_stolen_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recovery_displays_on_stolen_record_id ON public.recovery_displays USING btree (stolen_record_id);


--
-- Name: index_states_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_states_on_country_id ON public.states USING btree (country_id);


--
-- Name: index_stolen_notifications_on_oauth_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stolen_notifications_on_oauth_application_id ON public.stolen_notifications USING btree (oauth_application_id);


--
-- Name: index_stolen_records_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stolen_records_on_bike_id ON public.stolen_records USING btree (bike_id);


--
-- Name: index_stolen_records_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stolen_records_on_latitude_and_longitude ON public.stolen_records USING btree (latitude, longitude);


--
-- Name: index_stolen_records_on_recovering_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stolen_records_on_recovering_user_id ON public.stolen_records USING btree (recovering_user_id);


--
-- Name: index_theft_alerts_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_theft_alerts_on_payment_id ON public.theft_alerts USING btree (payment_id);


--
-- Name: index_theft_alerts_on_stolen_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_theft_alerts_on_stolen_record_id ON public.theft_alerts USING btree (stolen_record_id);


--
-- Name: index_theft_alerts_on_theft_alert_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_theft_alerts_on_theft_alert_plan_id ON public.theft_alerts USING btree (theft_alert_plan_id);


--
-- Name: index_theft_alerts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_theft_alerts_on_user_id ON public.theft_alerts USING btree (user_id);


--
-- Name: index_tweets_on_original_tweet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_original_tweet_id ON public.tweets USING btree (original_tweet_id);


--
-- Name: index_tweets_on_stolen_record_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_stolen_record_id ON public.tweets USING btree (stolen_record_id);


--
-- Name: index_tweets_on_twitter_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_twitter_account_id ON public.tweets USING btree (twitter_account_id);


--
-- Name: index_twitter_accounts_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_twitter_accounts_on_latitude_and_longitude ON public.twitter_accounts USING btree (latitude, longitude);


--
-- Name: index_twitter_accounts_on_screen_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_twitter_accounts_on_screen_name ON public.twitter_accounts USING btree (screen_name);


--
-- Name: index_user_emails_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_emails_on_user_id ON public.user_emails USING btree (user_id);


--
-- Name: index_users_on_password_reset_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_password_reset_token ON public.users USING btree (password_reset_token);


--
-- Name: unique_assignment_to_ambassador; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_assignment_to_ambassador ON public.ambassador_task_assignments USING btree (user_id, ambassador_task_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- Name: theft_alerts fk_rails_3c23dcdc45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alerts
    ADD CONSTRAINT fk_rails_3c23dcdc45 FOREIGN KEY (stolen_record_id) REFERENCES public.stolen_records(id) ON DELETE CASCADE;


--
-- Name: theft_alerts fk_rails_4d1dc73022; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alerts
    ADD CONSTRAINT fk_rails_4d1dc73022 FOREIGN KEY (theft_alert_plan_id) REFERENCES public.theft_alert_plans(id) ON DELETE CASCADE;


--
-- Name: theft_alerts fk_rails_58c070cc66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alerts
    ADD CONSTRAINT fk_rails_58c070cc66 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ambassador_task_assignments fk_rails_6c31316b38; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassador_task_assignments
    ADD CONSTRAINT fk_rails_6c31316b38 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: theft_alerts fk_rails_6dac5d87d9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.theft_alerts
    ADD CONSTRAINT fk_rails_6dac5d87d9 FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: alert_images fk_rails_95dc479c85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_images
    ADD CONSTRAINT fk_rails_95dc479c85 FOREIGN KEY (stolen_record_id) REFERENCES public.stolen_records(id);


--
-- Name: ambassador_task_assignments fk_rails_d557be2cfa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ambassador_task_assignments
    ADD CONSTRAINT fk_rails_d557be2cfa FOREIGN KEY (ambassador_task_id) REFERENCES public.ambassador_tasks(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20120911182934');

INSERT INTO schema_migrations (version) VALUES ('20120911183639');

INSERT INTO schema_migrations (version) VALUES ('20120911184407');

INSERT INTO schema_migrations (version) VALUES ('20120911185927');

INSERT INTO schema_migrations (version) VALUES ('20120911230801');

INSERT INTO schema_migrations (version) VALUES ('20120912003857');

INSERT INTO schema_migrations (version) VALUES ('20120913164701');

INSERT INTO schema_migrations (version) VALUES ('20120914193704');

INSERT INTO schema_migrations (version) VALUES ('20120914194950');

INSERT INTO schema_migrations (version) VALUES ('20120914214119');

INSERT INTO schema_migrations (version) VALUES ('20120914221204');

INSERT INTO schema_migrations (version) VALUES ('20121010120352');

INSERT INTO schema_migrations (version) VALUES ('20121012140221');

INSERT INTO schema_migrations (version) VALUES ('20121028230353');

INSERT INTO schema_migrations (version) VALUES ('20121029020401');

INSERT INTO schema_migrations (version) VALUES ('20121029232446');

INSERT INTO schema_migrations (version) VALUES ('20121030004253');

INSERT INTO schema_migrations (version) VALUES ('20121031232916');

INSERT INTO schema_migrations (version) VALUES ('20121031234103');

INSERT INTO schema_migrations (version) VALUES ('20121101002812');

INSERT INTO schema_migrations (version) VALUES ('20121101002951');

INSERT INTO schema_migrations (version) VALUES ('20121102144757');

INSERT INTO schema_migrations (version) VALUES ('20121103160512');

INSERT INTO schema_migrations (version) VALUES ('20121103201904');

INSERT INTO schema_migrations (version) VALUES ('20121107230721');

INSERT INTO schema_migrations (version) VALUES ('20121108220013');

INSERT INTO schema_migrations (version) VALUES ('20121111190041');

INSERT INTO schema_migrations (version) VALUES ('20121114221424');

INSERT INTO schema_migrations (version) VALUES ('20121114223945');

INSERT INTO schema_migrations (version) VALUES ('20121117213635');

INSERT INTO schema_migrations (version) VALUES ('20121122183150');

INSERT INTO schema_migrations (version) VALUES ('20121124163916');

INSERT INTO schema_migrations (version) VALUES ('20121216155454');

INSERT INTO schema_migrations (version) VALUES ('20121218161337');

INSERT INTO schema_migrations (version) VALUES ('20121218163801');

INSERT INTO schema_migrations (version) VALUES ('20121218165048');

INSERT INTO schema_migrations (version) VALUES ('20121218175444');

INSERT INTO schema_migrations (version) VALUES ('20121218232923');

INSERT INTO schema_migrations (version) VALUES ('20121223151926');

INSERT INTO schema_migrations (version) VALUES ('20121223152831');

INSERT INTO schema_migrations (version) VALUES ('20121223160807');

INSERT INTO schema_migrations (version) VALUES ('20121223175254');

INSERT INTO schema_migrations (version) VALUES ('20130111143823');

INSERT INTO schema_migrations (version) VALUES ('20130111161224');

INSERT INTO schema_migrations (version) VALUES ('20130111165852');

INSERT INTO schema_migrations (version) VALUES ('20130111230539');

INSERT INTO schema_migrations (version) VALUES ('20130116160029');

INSERT INTO schema_migrations (version) VALUES ('20130120201311');

INSERT INTO schema_migrations (version) VALUES ('20130125155810');

INSERT INTO schema_migrations (version) VALUES ('20130126000921');

INSERT INTO schema_migrations (version) VALUES ('20130126010711');

INSERT INTO schema_migrations (version) VALUES ('20130128182738');

INSERT INTO schema_migrations (version) VALUES ('20130128183512');

INSERT INTO schema_migrations (version) VALUES ('20130206030035');

INSERT INTO schema_migrations (version) VALUES ('20130210182811');

INSERT INTO schema_migrations (version) VALUES ('20130210183940');

INSERT INTO schema_migrations (version) VALUES ('20130210184643');

INSERT INTO schema_migrations (version) VALUES ('20130212215600');

INSERT INTO schema_migrations (version) VALUES ('20130213230159');

INSERT INTO schema_migrations (version) VALUES ('20130214204648');

INSERT INTO schema_migrations (version) VALUES ('20130214211116');

INSERT INTO schema_migrations (version) VALUES ('20130214231224');

INSERT INTO schema_migrations (version) VALUES ('20130217161855');

INSERT INTO schema_migrations (version) VALUES ('20130217161945');

INSERT INTO schema_migrations (version) VALUES ('20130217170709');

INSERT INTO schema_migrations (version) VALUES ('20130220010120');

INSERT INTO schema_migrations (version) VALUES ('20130225180109');

INSERT INTO schema_migrations (version) VALUES ('20130225202426');

INSERT INTO schema_migrations (version) VALUES ('20130225215129');

INSERT INTO schema_migrations (version) VALUES ('20130226165427');

INSERT INTO schema_migrations (version) VALUES ('20130226170115');

INSERT INTO schema_migrations (version) VALUES ('20130226171603');

INSERT INTO schema_migrations (version) VALUES ('20130227022823');

INSERT INTO schema_migrations (version) VALUES ('20130308162717');

INSERT INTO schema_migrations (version) VALUES ('20130312214622');

INSERT INTO schema_migrations (version) VALUES ('20130312234622');

INSERT INTO schema_migrations (version) VALUES ('20130314000516');

INSERT INTO schema_migrations (version) VALUES ('20130314202232');

INSERT INTO schema_migrations (version) VALUES ('20130314214024');

INSERT INTO schema_migrations (version) VALUES ('20130314235254');

INSERT INTO schema_migrations (version) VALUES ('20130315022544');

INSERT INTO schema_migrations (version) VALUES ('20130318004611');

INSERT INTO schema_migrations (version) VALUES ('20130329212736');

INSERT INTO schema_migrations (version) VALUES ('20130403012755');

INSERT INTO schema_migrations (version) VALUES ('20130420195053');

INSERT INTO schema_migrations (version) VALUES ('20130422133115');

INSERT INTO schema_migrations (version) VALUES ('20130422162415');

INSERT INTO schema_migrations (version) VALUES ('20130422162432');

INSERT INTO schema_migrations (version) VALUES ('20130422170303');

INSERT INTO schema_migrations (version) VALUES ('20130424134913');

INSERT INTO schema_migrations (version) VALUES ('20130424155646');

INSERT INTO schema_migrations (version) VALUES ('20130424161125');

INSERT INTO schema_migrations (version) VALUES ('20130424225341');

INSERT INTO schema_migrations (version) VALUES ('20130506191950');

INSERT INTO schema_migrations (version) VALUES ('20130506194218');

INSERT INTO schema_migrations (version) VALUES ('20130507033150');

INSERT INTO schema_migrations (version) VALUES ('20130508162206');

INSERT INTO schema_migrations (version) VALUES ('20130509213617');

INSERT INTO schema_migrations (version) VALUES ('20130510144825');

INSERT INTO schema_migrations (version) VALUES ('20130510154536');

INSERT INTO schema_migrations (version) VALUES ('20130510161119');

INSERT INTO schema_migrations (version) VALUES ('20130510191228');

INSERT INTO schema_migrations (version) VALUES ('20130511175952');

INSERT INTO schema_migrations (version) VALUES ('20130511181304');

INSERT INTO schema_migrations (version) VALUES ('20130511182611');

INSERT INTO schema_migrations (version) VALUES ('20130515014438');

INSERT INTO schema_migrations (version) VALUES ('20130515140718');

INSERT INTO schema_migrations (version) VALUES ('20130515202608');

INSERT INTO schema_migrations (version) VALUES ('20130517154952');

INSERT INTO schema_migrations (version) VALUES ('20130522165237');

INSERT INTO schema_migrations (version) VALUES ('20130524164449');

INSERT INTO schema_migrations (version) VALUES ('20130604205407');

INSERT INTO schema_migrations (version) VALUES ('20130607162957');

INSERT INTO schema_migrations (version) VALUES ('20130613144600');

INSERT INTO schema_migrations (version) VALUES ('20130613153522');

INSERT INTO schema_migrations (version) VALUES ('20130619234253');

INSERT INTO schema_migrations (version) VALUES ('20130621012516');

INSERT INTO schema_migrations (version) VALUES ('20130628161112');

INSERT INTO schema_migrations (version) VALUES ('20130629152453');

INSERT INTO schema_migrations (version) VALUES ('20130629152508');

INSERT INTO schema_migrations (version) VALUES ('20130629162208');

INSERT INTO schema_migrations (version) VALUES ('20130629165920');

INSERT INTO schema_migrations (version) VALUES ('20130629165929');

INSERT INTO schema_migrations (version) VALUES ('20130629171337');

INSERT INTO schema_migrations (version) VALUES ('20130629183647');

INSERT INTO schema_migrations (version) VALUES ('20130629183656');

INSERT INTO schema_migrations (version) VALUES ('20130630190556');

INSERT INTO schema_migrations (version) VALUES ('20130709160337');

INSERT INTO schema_migrations (version) VALUES ('20130709215543');

INSERT INTO schema_migrations (version) VALUES ('20130711200929');

INSERT INTO schema_migrations (version) VALUES ('20130711201434');

INSERT INTO schema_migrations (version) VALUES ('20130711230226');

INSERT INTO schema_migrations (version) VALUES ('20130714155827');

INSERT INTO schema_migrations (version) VALUES ('20130716213553');

INSERT INTO schema_migrations (version) VALUES ('20130717195126');

INSERT INTO schema_migrations (version) VALUES ('20130718175528');

INSERT INTO schema_migrations (version) VALUES ('20130724145302');

INSERT INTO schema_migrations (version) VALUES ('20130725191328');

INSERT INTO schema_migrations (version) VALUES ('20130729190352');

INSERT INTO schema_migrations (version) VALUES ('20130729190514');

INSERT INTO schema_migrations (version) VALUES ('20130729195607');

INSERT INTO schema_migrations (version) VALUES ('20130802145610');

INSERT INTO schema_migrations (version) VALUES ('20130807173218');

INSERT INTO schema_migrations (version) VALUES ('20130807215021');

INSERT INTO schema_migrations (version) VALUES ('20130809155956');

INSERT INTO schema_migrations (version) VALUES ('20130820145312');

INSERT INTO schema_migrations (version) VALUES ('20130820150839');

INSERT INTO schema_migrations (version) VALUES ('20130820173657');

INSERT INTO schema_migrations (version) VALUES ('20130821134559');

INSERT INTO schema_migrations (version) VALUES ('20130821135549');

INSERT INTO schema_migrations (version) VALUES ('20130821230157');

INSERT INTO schema_migrations (version) VALUES ('20130903142657');

INSERT INTO schema_migrations (version) VALUES ('20130905215302');

INSERT INTO schema_migrations (version) VALUES ('20131009140156');

INSERT INTO schema_migrations (version) VALUES ('20131013171704');

INSERT INTO schema_migrations (version) VALUES ('20131013172625');

INSERT INTO schema_migrations (version) VALUES ('20131013233351');

INSERT INTO schema_migrations (version) VALUES ('20131018221510');

INSERT INTO schema_migrations (version) VALUES ('20131029004416');

INSERT INTO schema_migrations (version) VALUES ('20131029144536');

INSERT INTO schema_migrations (version) VALUES ('20131030132116');

INSERT INTO schema_migrations (version) VALUES ('20131030161105');

INSERT INTO schema_migrations (version) VALUES ('20131031222251');

INSERT INTO schema_migrations (version) VALUES ('20131101002019');

INSERT INTO schema_migrations (version) VALUES ('20131105010837');

INSERT INTO schema_migrations (version) VALUES ('20131117232341');

INSERT INTO schema_migrations (version) VALUES ('20131202181502');

INSERT INTO schema_migrations (version) VALUES ('20131204230644');

INSERT INTO schema_migrations (version) VALUES ('20131205145316');

INSERT INTO schema_migrations (version) VALUES ('20131211163130');

INSERT INTO schema_migrations (version) VALUES ('20131212161639');

INSERT INTO schema_migrations (version) VALUES ('20131213185845');

INSERT INTO schema_migrations (version) VALUES ('20131216154423');

INSERT INTO schema_migrations (version) VALUES ('20131218201839');

INSERT INTO schema_migrations (version) VALUES ('20131219182417');

INSERT INTO schema_migrations (version) VALUES ('20131221193910');

INSERT INTO schema_migrations (version) VALUES ('20131227132337');

INSERT INTO schema_migrations (version) VALUES ('20131227133553');

INSERT INTO schema_migrations (version) VALUES ('20131227135813');

INSERT INTO schema_migrations (version) VALUES ('20131227151833');

INSERT INTO schema_migrations (version) VALUES ('20131229194508');

INSERT INTO schema_migrations (version) VALUES ('20140103144654');

INSERT INTO schema_migrations (version) VALUES ('20140103161433');

INSERT INTO schema_migrations (version) VALUES ('20140103222943');

INSERT INTO schema_migrations (version) VALUES ('20140103235111');

INSERT INTO schema_migrations (version) VALUES ('20140104011352');

INSERT INTO schema_migrations (version) VALUES ('20140105181220');

INSERT INTO schema_migrations (version) VALUES ('20140106031356');

INSERT INTO schema_migrations (version) VALUES ('20140108195016');

INSERT INTO schema_migrations (version) VALUES ('20140108202025');

INSERT INTO schema_migrations (version) VALUES ('20140108203313');

INSERT INTO schema_migrations (version) VALUES ('20140109001625');

INSERT INTO schema_migrations (version) VALUES ('20140111142521');

INSERT INTO schema_migrations (version) VALUES ('20140111183125');

INSERT INTO schema_migrations (version) VALUES ('20140112004042');

INSERT INTO schema_migrations (version) VALUES ('20140113181408');

INSERT INTO schema_migrations (version) VALUES ('20140114230221');

INSERT INTO schema_migrations (version) VALUES ('20140115041923');

INSERT INTO schema_migrations (version) VALUES ('20140116214759');

INSERT INTO schema_migrations (version) VALUES ('20140116222529');

INSERT INTO schema_migrations (version) VALUES ('20140122181025');

INSERT INTO schema_migrations (version) VALUES ('20140122181308');

INSERT INTO schema_migrations (version) VALUES ('20140204162239');

INSERT INTO schema_migrations (version) VALUES ('20140225203114');

INSERT INTO schema_migrations (version) VALUES ('20140227225103');

INSERT INTO schema_migrations (version) VALUES ('20140301174242');

INSERT INTO schema_migrations (version) VALUES ('20140312191710');

INSERT INTO schema_migrations (version) VALUES ('20140313002428');

INSERT INTO schema_migrations (version) VALUES ('20140426211337');

INSERT INTO schema_migrations (version) VALUES ('20140504234957');

INSERT INTO schema_migrations (version) VALUES ('20140507023948');

INSERT INTO schema_migrations (version) VALUES ('20140510155037');

INSERT INTO schema_migrations (version) VALUES ('20140510163446');

INSERT INTO schema_migrations (version) VALUES ('20140523122545');

INSERT INTO schema_migrations (version) VALUES ('20140524183616');

INSERT INTO schema_migrations (version) VALUES ('20140525163552');

INSERT INTO schema_migrations (version) VALUES ('20140525173416');

INSERT INTO schema_migrations (version) VALUES ('20140525183759');

INSERT INTO schema_migrations (version) VALUES ('20140526141810');

INSERT INTO schema_migrations (version) VALUES ('20140526161223');

INSERT INTO schema_migrations (version) VALUES ('20140614190845');

INSERT INTO schema_migrations (version) VALUES ('20140615230212');

INSERT INTO schema_migrations (version) VALUES ('20140621013108');

INSERT INTO schema_migrations (version) VALUES ('20140621171727');

INSERT INTO schema_migrations (version) VALUES ('20140629144444');

INSERT INTO schema_migrations (version) VALUES ('20140629162651');

INSERT INTO schema_migrations (version) VALUES ('20140629170842');

INSERT INTO schema_migrations (version) VALUES ('20140706170329');

INSERT INTO schema_migrations (version) VALUES ('20140713182107');

INSERT INTO schema_migrations (version) VALUES ('20140720175226');

INSERT INTO schema_migrations (version) VALUES ('20140809102725');

INSERT INTO schema_migrations (version) VALUES ('20140817160101');

INSERT INTO schema_migrations (version) VALUES ('20140830152248');

INSERT INTO schema_migrations (version) VALUES ('20140902230041');

INSERT INTO schema_migrations (version) VALUES ('20140903191321');

INSERT INTO schema_migrations (version) VALUES ('20140907144150');

INSERT INTO schema_migrations (version) VALUES ('20140916141534');

INSERT INTO schema_migrations (version) VALUES ('20140916185511');

INSERT INTO schema_migrations (version) VALUES ('20141006184444');

INSERT INTO schema_migrations (version) VALUES ('20141008160942');

INSERT INTO schema_migrations (version) VALUES ('20141010145930');

INSERT INTO schema_migrations (version) VALUES ('20141025185722');

INSERT INTO schema_migrations (version) VALUES ('20141026172449');

INSERT INTO schema_migrations (version) VALUES ('20141030140601');

INSERT INTO schema_migrations (version) VALUES ('20141031152955');

INSERT INTO schema_migrations (version) VALUES ('20141105172149');

INSERT INTO schema_migrations (version) VALUES ('20141110174307');

INSERT INTO schema_migrations (version) VALUES ('20141210002148');

INSERT INTO schema_migrations (version) VALUES ('20141210031732');

INSERT INTO schema_migrations (version) VALUES ('20141210233551');

INSERT INTO schema_migrations (version) VALUES ('20141217191826');

INSERT INTO schema_migrations (version) VALUES ('20141217200937');

INSERT INTO schema_migrations (version) VALUES ('20141224165646');

INSERT INTO schema_migrations (version) VALUES ('20141231170329');

INSERT INTO schema_migrations (version) VALUES ('20150111193842');

INSERT INTO schema_migrations (version) VALUES ('20150111211009');

INSERT INTO schema_migrations (version) VALUES ('20150122195921');

INSERT INTO schema_migrations (version) VALUES ('20150123233624');

INSERT INTO schema_migrations (version) VALUES ('20150127220842');

INSERT INTO schema_migrations (version) VALUES ('20150208001048');

INSERT INTO schema_migrations (version) VALUES ('20150321233527');

INSERT INTO schema_migrations (version) VALUES ('20150325145515');

INSERT INTO schema_migrations (version) VALUES ('20150402051334');

INSERT INTO schema_migrations (version) VALUES ('20150507222158');

INSERT INTO schema_migrations (version) VALUES ('20150518192613');

INSERT INTO schema_migrations (version) VALUES ('20150701151619');

INSERT INTO schema_migrations (version) VALUES ('20150805160333');

INSERT INTO schema_migrations (version) VALUES ('20150903194549');

INSERT INTO schema_migrations (version) VALUES ('20150916133842');

INSERT INTO schema_migrations (version) VALUES ('20151122175408');

INSERT INTO schema_migrations (version) VALUES ('20160314144745');

INSERT INTO schema_migrations (version) VALUES ('20160317183354');

INSERT INTO schema_migrations (version) VALUES ('20160320154610');

INSERT INTO schema_migrations (version) VALUES ('20160406202125');

INSERT INTO schema_migrations (version) VALUES ('20160425185052');

INSERT INTO schema_migrations (version) VALUES ('20160509110049');

INSERT INTO schema_migrations (version) VALUES ('20160509120017');

INSERT INTO schema_migrations (version) VALUES ('20160529093040');

INSERT INTO schema_migrations (version) VALUES ('20160614112308');

INSERT INTO schema_migrations (version) VALUES ('20160629152210');

INSERT INTO schema_migrations (version) VALUES ('20160630161603');

INSERT INTO schema_migrations (version) VALUES ('20160630175602');

INSERT INTO schema_migrations (version) VALUES ('20160631175602');

INSERT INTO schema_migrations (version) VALUES ('20160711183247');

INSERT INTO schema_migrations (version) VALUES ('20160714182030');

INSERT INTO schema_migrations (version) VALUES ('20160808133129');

INSERT INTO schema_migrations (version) VALUES ('20160813191639');

INSERT INTO schema_migrations (version) VALUES ('20160901175004');

INSERT INTO schema_migrations (version) VALUES ('20160910174549');

INSERT INTO schema_migrations (version) VALUES ('20160910184053');

INSERT INTO schema_migrations (version) VALUES ('20160913155615');

INSERT INTO schema_migrations (version) VALUES ('20160923180542');

INSERT INTO schema_migrations (version) VALUES ('20160923215650');

INSERT INTO schema_migrations (version) VALUES ('20161222154603');

INSERT INTO schema_migrations (version) VALUES ('20170227012150');

INSERT INTO schema_migrations (version) VALUES ('20170503024611');

INSERT INTO schema_migrations (version) VALUES ('20170617222902');

INSERT INTO schema_migrations (version) VALUES ('20170618205609');

INSERT INTO schema_migrations (version) VALUES ('20170731023746');

INSERT INTO schema_migrations (version) VALUES ('20180225205617');

INSERT INTO schema_migrations (version) VALUES ('20180624192035');

INSERT INTO schema_migrations (version) VALUES ('20180624211320');

INSERT INTO schema_migrations (version) VALUES ('20180624211323');

INSERT INTO schema_migrations (version) VALUES ('20180706162137');

INSERT INTO schema_migrations (version) VALUES ('20180730013343');

INSERT INTO schema_migrations (version) VALUES ('20180731194240');

INSERT INTO schema_migrations (version) VALUES ('20180801010129');

INSERT INTO schema_migrations (version) VALUES ('20180801011704');

INSERT INTO schema_migrations (version) VALUES ('20180801025713');

INSERT INTO schema_migrations (version) VALUES ('20180802235809');

INSERT INTO schema_migrations (version) VALUES ('20180803003635');

INSERT INTO schema_migrations (version) VALUES ('20180804170624');

INSERT INTO schema_migrations (version) VALUES ('20180806172125');

INSERT INTO schema_migrations (version) VALUES ('20180813004404');

INSERT INTO schema_migrations (version) VALUES ('20180813020849');

INSERT INTO schema_migrations (version) VALUES ('20180813023344');

INSERT INTO schema_migrations (version) VALUES ('20180818194244');

INSERT INTO schema_migrations (version) VALUES ('20180911215238');

INSERT INTO schema_migrations (version) VALUES ('20180918220604');

INSERT INTO schema_migrations (version) VALUES ('20181130200131');

INSERT INTO schema_migrations (version) VALUES ('20181204215943');

INSERT INTO schema_migrations (version) VALUES ('20181205180633');

INSERT INTO schema_migrations (version) VALUES ('20181213224936');

INSERT INTO schema_migrations (version) VALUES ('20190110210704');

INSERT INTO schema_migrations (version) VALUES ('20190201193608');

INSERT INTO schema_migrations (version) VALUES ('20190201214042');

INSERT INTO schema_migrations (version) VALUES ('20190206044915');

INSERT INTO schema_migrations (version) VALUES ('20190208195902');

INSERT INTO schema_migrations (version) VALUES ('20190214192448');

INSERT INTO schema_migrations (version) VALUES ('20190301020053');

INSERT INTO schema_migrations (version) VALUES ('20190306223523');

INSERT INTO schema_migrations (version) VALUES ('20190306232544');

INSERT INTO schema_migrations (version) VALUES ('20190307232718');

INSERT INTO schema_migrations (version) VALUES ('20190308235449');

INSERT INTO schema_migrations (version) VALUES ('20190309021455');

INSERT INTO schema_migrations (version) VALUES ('20190312185621');

INSERT INTO schema_migrations (version) VALUES ('20190314182139');

INSERT INTO schema_migrations (version) VALUES ('20190315183047');

INSERT INTO schema_migrations (version) VALUES ('20190315213846');

INSERT INTO schema_migrations (version) VALUES ('20190317191821');

INSERT INTO schema_migrations (version) VALUES ('20190327164432');

INSERT INTO schema_migrations (version) VALUES ('20190329233031');

INSERT INTO schema_migrations (version) VALUES ('20190401233010');

INSERT INTO schema_migrations (version) VALUES ('20190402230848');

INSERT INTO schema_migrations (version) VALUES ('20190422221408');

INSERT INTO schema_migrations (version) VALUES ('20190424001657');

INSERT INTO schema_migrations (version) VALUES ('20190514155447');

INSERT INTO schema_migrations (version) VALUES ('20190516222221');

INSERT INTO schema_migrations (version) VALUES ('20190517161246');

INSERT INTO schema_migrations (version) VALUES ('20190517200357');

INSERT INTO schema_migrations (version) VALUES ('20190524191139');

INSERT INTO schema_migrations (version) VALUES ('20190529024835');

INSERT INTO schema_migrations (version) VALUES ('20190606214539');

INSERT INTO schema_migrations (version) VALUES ('20190607174104');

INSERT INTO schema_migrations (version) VALUES ('20190611203612');

INSERT INTO schema_migrations (version) VALUES ('20190611223723');

INSERT INTO schema_migrations (version) VALUES ('20190612183532');

INSERT INTO schema_migrations (version) VALUES ('20190614223136');

INSERT INTO schema_migrations (version) VALUES ('20190617174200');

INSERT INTO schema_migrations (version) VALUES ('20190617193251');

INSERT INTO schema_migrations (version) VALUES ('20190617193255');

INSERT INTO schema_migrations (version) VALUES ('20190620203854');

INSERT INTO schema_migrations (version) VALUES ('20190621183811');

INSERT INTO schema_migrations (version) VALUES ('20190624171627');

INSERT INTO schema_migrations (version) VALUES ('20190625151428');

INSERT INTO schema_migrations (version) VALUES ('20190703194554');

INSERT INTO schema_migrations (version) VALUES ('20190705230020');

INSERT INTO schema_migrations (version) VALUES ('20190708181605');

INSERT INTO schema_migrations (version) VALUES ('20190709011902');

INSERT INTO schema_migrations (version) VALUES ('20190710203715');

INSERT INTO schema_migrations (version) VALUES ('20190710230727');

INSERT INTO schema_migrations (version) VALUES ('20190725141309');

INSERT INTO schema_migrations (version) VALUES ('20190725172835');

INSERT INTO schema_migrations (version) VALUES ('20190726160009');

INSERT INTO schema_migrations (version) VALUES ('20190726183859');

INSERT INTO schema_migrations (version) VALUES ('20190806155914');

INSERT INTO schema_migrations (version) VALUES ('20190806170520');

INSERT INTO schema_migrations (version) VALUES ('20190806214815');

INSERT INTO schema_migrations (version) VALUES ('20190809200257');

INSERT INTO schema_migrations (version) VALUES ('20190809214414');

INSERT INTO schema_migrations (version) VALUES ('20190829221522');

INSERT INTO schema_migrations (version) VALUES ('20190903145420');

INSERT INTO schema_migrations (version) VALUES ('20190904161424');

INSERT INTO schema_migrations (version) VALUES ('20190909190050');

INSERT INTO schema_migrations (version) VALUES ('20190913132047');

INSERT INTO schema_migrations (version) VALUES ('20190916190441');

INSERT INTO schema_migrations (version) VALUES ('20190916190442');

INSERT INTO schema_migrations (version) VALUES ('20190916191514');

INSERT INTO schema_migrations (version) VALUES ('20190918121951');

INSERT INTO schema_migrations (version) VALUES ('20190918143646');

INSERT INTO schema_migrations (version) VALUES ('20190919145324');

INSERT INTO schema_migrations (version) VALUES ('20190923181352');

INSERT INTO schema_migrations (version) VALUES ('20191010182940');

INSERT INTO schema_migrations (version) VALUES ('20191018140618');

INSERT INTO schema_migrations (version) VALUES ('20191022123037');

INSERT INTO schema_migrations (version) VALUES ('20191022143755');

INSERT INTO schema_migrations (version) VALUES ('20191028130015');

INSERT INTO schema_migrations (version) VALUES ('20191106210313');

INSERT INTO schema_migrations (version) VALUES ('20191108195338');

INSERT INTO schema_migrations (version) VALUES ('20191117123105');

INSERT INTO schema_migrations (version) VALUES ('20191209160937');

