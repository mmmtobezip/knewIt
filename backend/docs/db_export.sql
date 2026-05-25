--
-- PostgreSQL database dump
--

\restrict 9pKvqLFum2bObsviCR0UicKS5iVsqoRBndlIA3a7Sk5yUuhmJuTfXG0xxMdpCDZ

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

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
-- Name: assignment_role; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.assignment_role AS ENUM (
    'PRIMARY',
    'SUPPORT'
);


ALTER TYPE public.assignment_role OWNER TO pos;

--
-- Name: event_direction; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.event_direction AS ENUM (
    'UP',
    'DOWN'
);


ALTER TYPE public.event_direction OWNER TO pos;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: pos
--

CREATE TYPE public.user_role AS ENUM (
    'SALES',
    'MANAGER',
    'ADMIN'
);


ALTER TYPE public.user_role OWNER TO pos;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO pos;

--
-- Name: assigned_customers; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.assigned_customers (
    user_id character varying(64) NOT NULL,
    customer_id character varying(128) NOT NULL,
    role public.assignment_role NOT NULL,
    assigned_at character varying(10) NOT NULL
);


ALTER TABLE public.assigned_customers OWNER TO pos;

--
-- Name: customer_profiles; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.customer_profiles (
    customer_id character varying(128) NOT NULL,
    industry character varying(128) NOT NULL,
    market_region character varying(64) NOT NULL,
    product_group character varying[] NOT NULL,
    sensitive_topics character varying[] NOT NULL,
    risk_factors character varying[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customer_profiles OWNER TO pos;

--
-- Name: indicators; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.indicators (
    id bigint NOT NULL,
    source character varying(64) NOT NULL,
    country character varying(32),
    category_big character varying(32),
    category_mid character varying(32),
    category_small character varying(32),
    feature_name character varying(256) NOT NULL,
    date date NOT NULL,
    value double precision NOT NULL,
    unit character varying(32) NOT NULL,
    cycle character varying(2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.indicators OWNER TO pos;

--
-- Name: indicators_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.indicators_id_seq OWNER TO pos;

--
-- Name: indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.indicators_id_seq OWNED BY public.indicators.id;


--
-- Name: order_lines; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.order_lines (
    order_line_no character varying(32) NOT NULL,
    customer_name character varying(128) NOT NULL,
    variant_code character varying(16) NOT NULL,
    salesperson character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_lines OWNER TO pos;

--
-- Name: org_hierarchy; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.org_hierarchy (
    manager_id character varying(64) NOT NULL,
    subordinate_id character varying(64) NOT NULL
);


ALTER TABLE public.org_hierarchy OWNER TO pos;

--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.product_variants (
    variant_code character varying(16) NOT NULL,
    variant_name character varying(16) NOT NULL,
    product character varying(32) NOT NULL,
    detail character varying(128),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_variants OWNER TO pos;

--
-- Name: products; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.products (
    code character varying(64) NOT NULL,
    key_features character varying[] NOT NULL,
    key_feature_importance double precision[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    key_feature_cycle character varying[] DEFAULT '{}'::character varying[] NOT NULL
);


ALTER TABLE public.products OWNER TO pos;

--
-- Name: sales_actuals; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.sales_actuals (
    id bigint NOT NULL,
    actual_value double precision NOT NULL,
    unit character varying(8) DEFAULT '천톤'::character varying NOT NULL,
    ym_str character varying(6) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    product character varying(32) NOT NULL,
    sales_group character varying(32) DEFAULT ''::character varying NOT NULL,
    customer_name character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.sales_actuals OWNER TO pos;

--
-- Name: sales_actuals_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.sales_actuals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_actuals_id_seq OWNER TO pos;

--
-- Name: sales_actuals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.sales_actuals_id_seq OWNED BY public.sales_actuals.id;


--
-- Name: sales_guides; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.sales_guides (
    id bigint NOT NULL,
    guide_value double precision NOT NULL,
    unit character varying(8) DEFAULT '천톤'::character varying NOT NULL,
    ym_str character varying(6) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    product character varying(32) NOT NULL,
    sales_group character varying(32) DEFAULT ''::character varying NOT NULL,
    customer_name character varying(128) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.sales_guides OWNER TO pos;

--
-- Name: sales_guides_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.sales_guides_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_guides_id_seq OWNER TO pos;

--
-- Name: sales_guides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.sales_guides_id_seq OWNED BY public.sales_guides.id;


--
-- Name: shipments; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.shipments (
    id bigint NOT NULL,
    shipped_at date NOT NULL,
    customer_name character varying(128) NOT NULL,
    weight_kg double precision NOT NULL,
    weight_unit character varying(8) DEFAULT 'Kg'::character varying NOT NULL,
    order_line_no character varying(32) NOT NULL,
    variant_code character varying(16) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.shipments OWNER TO pos;

--
-- Name: shipments_id_seq; Type: SEQUENCE; Schema: public; Owner: pos
--

CREATE SEQUENCE public.shipments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shipments_id_seq OWNER TO pos;

--
-- Name: shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pos
--

ALTER SEQUENCE public.shipments_id_seq OWNED BY public.shipments.id;


--
-- Name: trigger_events; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.trigger_events (
    event_id character varying(64) NOT NULL,
    feature character varying(256) NOT NULL,
    product_code character varying(32) NOT NULL,
    customer_id character varying(128),
    change_rate double precision NOT NULL,
    direction public.event_direction NOT NULL,
    date date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.trigger_events OWNER TO pos;

--
-- Name: users; Type: TABLE; Schema: public; Owner: pos
--

CREATE TABLE public.users (
    user_id character varying(64) NOT NULL,
    name character varying(128),
    role public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    primary_product_code character varying(64),
    employee_no character varying(32),
    department character varying(128),
    email character varying(128)
);


ALTER TABLE public.users OWNER TO pos;

--
-- Name: indicators id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.indicators ALTER COLUMN id SET DEFAULT nextval('public.indicators_id_seq'::regclass);


--
-- Name: sales_actuals id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_actuals ALTER COLUMN id SET DEFAULT nextval('public.sales_actuals_id_seq'::regclass);


--
-- Name: sales_guides id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_guides ALTER COLUMN id SET DEFAULT nextval('public.sales_guides_id_seq'::regclass);


--
-- Name: shipments id; Type: DEFAULT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shipments ALTER COLUMN id SET DEFAULT nextval('public.shipments_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.alembic_version (version_num) FROM stdin;
cefb545822eb
\.


--
-- Data for Name: assigned_customers; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.assigned_customers (user_id, customer_id, role, assigned_at) FROM stdin;
emp_2026001	고려제강	PRIMARY	2026-05-20
emp_2026001	Borcelik Celik Sanayii VE Ticaret AS	PRIMARY	2026-05-20
emp_2026001	Nissan Motor Co., Ltd	PRIMARY	2026-05-20
emp_2026001	Berg Steel Pipe Corp	PRIMARY	2026-05-20
emp_2026001	썬시멘트주식회사	PRIMARY	2026-05-20
emp_2026001	New Best Wire Industrial Co., Ltd	PRIMARY	2026-05-20
emp_2026001	JFE Techno Wire Corporation	PRIMARY	2026-05-20
emp_2026001	동일제강	PRIMARY	2026-05-20
emp_2026001	세아씨엠	PRIMARY	2026-05-20
emp_2026001	Ningbo Dafeng Machinery Co., Ltd	PRIMARY	2026-05-20
emp_2026003	포스코인터내셔널	PRIMARY	2026-05-24
emp_2026003	고려제강	PRIMARY	2026-05-24
emp_2026003	Nissan Motor Co., Ltd	PRIMARY	2026-05-24
emp_2026003	New Best Wire Industrial Co., Ltd	PRIMARY	2026-05-24
emp_2026003	동일제강	PRIMARY	2026-05-24
emp_2026004	현대중공업	PRIMARY	2026-05-24
emp_2026004	삼성중공업	PRIMARY	2026-05-24
emp_2026004	한화오션	PRIMARY	2026-05-24
emp_2026004	포스코건설	PRIMARY	2026-05-24
emp_2026004	포스코인터내셔널	PRIMARY	2026-05-24
\.


--
-- Data for Name: customer_profiles; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.customer_profiles (customer_id, industry, market_region, product_group, sensitive_topics, risk_factors, created_at, updated_at) FROM stdin;
고려제강	건설/인프라용 선재	국내/글로벌	{선재}	{"건설 경기","철스크랩 가격","수입재 가격 경쟁","국내 재고"}	{"국내 건설 수주 감소","중국산 저가재 점유율 확대"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
Borcelik Celik Sanayii VE Ticaret AS	자동차/가전 외판재	유럽/터키	{HR(고로밀)}	{"글로벌 열연 가격","에너지 비용","유럽 제조업 경기",환율}	{"CBAM 규제","터키 내수 경기 변동성"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
Nissan Motor Co., Ltd	완성차	일본/글로벌	{선재}	{"자동차 생산","부품 재고","EV 전환","공급망 안정성"}	{"공급망 중단","신규 모델 출시 지연"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
Berg Steel Pipe Corp	에너지 강관(Oil & Gas)	북미	{후판}	{"에너지 프로젝트","후판 납기","수입 규제","원자재 가격"}	{"북미 에너지 정책 변화","프로젝트 지연"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
썬시멘트주식회사	시멘트/건설소재	국내	{부산물(철스크랩)}	{"건설 경기","원가 절감","에너지 비용","환경 규제"}	{"건설 착공 감소","환경 규제 강화"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
New Best Wire Industrial Co., Ltd	글로벌 부품 제조	글로벌	{선재}	{"중국산 오퍼 가격","글로벌 제조업 경기","해상 물류비","가격 경쟁"}	{"글로벌 수요 둔화","재고 과잉"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
JFE Techno Wire Corporation	고기능성 특수 선재	일본	{선재}	{"기술 스펙","동아시아 철스크랩 가격","일본 제조업 경기","원재료 수급"}	{"일본 내수 시황 위축","원재료 수급 불안"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
동일제강	건설/산업용 선재 가공	국내	{선재}	{"건설 경기","철스크랩 가격","유통 재고","수입재 가격"}	{"국내 건설 경기 하락","저가 수입재 유입"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
세아씨엠	컬러강판/가전/건재	국내	{HR(고로밀)}	{"열연 소재 가격","컬러강판 수요","가전 경기","건설 경기"}	{"가전 및 건설 경기 부진","중국산 열연 가격 압박"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
Ningbo Dafeng Machinery Co., Ltd	산업기계 부품	중국	{선재}	{"중국 제조업 경기","중국 내수 가격",가동률,"공급 과잉"}	{"중국 경기 부양 효과 약화","현지 공급 과잉"}	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09
현대중공업	조선 (상선/해양플랜트)	글로벌	{후판}	{"선가(Newbuilding Price) 추이","후판가 연동제","수주 잔량"}	{"인건비 및 에너지 비용 상승","글로벌 물동량 변화","후판가 인상에 따른 수익성 악화"}	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09
삼성중공업	조선 (LNG선/FLNG 특화)	글로벌	{후판}	{"고부가가치선 수주 현황","니켈/원료가 변동","탄소 중립 선박"}	{"환율 변동 리스크","글로벌 환경 규제 강화","특수강 소재 수급 불안"}	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09
한화오션	조선 (특수선/상선)	글로벌	{후판}	{"방산/특수선 비중","생산 공정 정상화","중국재 대비 가격 경쟁력"}	{"인력 수급 문제","원가 상승 압박","생산 스케줄 지연"}	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09
포스코건설	건설 (플랜트/인프라/건축)	국내/글로벌	{후판}	{"국내 건설 기성액","사회인프라(SOC) 예산","강구조 수요"}	{"분양 시장 위축","공사비 증액에 따른 발주 취소","원자재가 변동"}	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09
포스코인터내셔널	글로벌 트레이딩/유통	글로벌 (동남아/미주/유럽)	{후판,선재}	{"글로벌 오퍼 가격","물류 및 용선료","수출 쿼터 및 통상 이슈","중국산 선재 오퍼가 변동","지역별 선재 스폿 가격차(Price Gap)","수출 환율 변동성"}	{"보호무역주의 확산","지정학적 리스크에 따른 물류 차질","가격 하락 시 재고 평가 손실","각국 보호무역 조치(반덤핑 등) 강화","도착지별 재고 과잉 및 수요 둔화"}	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09
\.


--
-- Data for Name: indicators; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.indicators (id, source, country, category_big, category_mid, category_small, feature_name, date, value, unit, cycle, created_at, updated_at) FROM stdin;
7499	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-01	50085	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7500	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-04	49920.5	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7501	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-05	50234.3	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7502	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-06	50416.7	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7503	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-07	50298.9	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7504	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-08	50521.4	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7505	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-11	50344.2	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7506	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-12	50687.5	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7507	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-13	50832.1	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7508	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-14	50610.3	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7509	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-05-15	50923.6	USD	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7510	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-01	3450	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7511	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-04	3445	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7512	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-05	3460	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7513	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-06	3455	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7514	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-07	3470	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7515	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-08	3465	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7516	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-11	3475	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7517	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-12	3480	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7518	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-13	3475	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7519	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-14	3490	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7520	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-05-15	3495	CNY/MT	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7521	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-01	4.352	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7522	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-04	4.318	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7523	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-05	4.341	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7524	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-06	4.299	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7525	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-07	4.325	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7526	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-08	4.307	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7527	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-11	4.285	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7528	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-12	4.271	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7529	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-13	4.298	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7530	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-14	4.262	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
7531	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-05-15	4.247	%	D	2026-05-25 00:41:42.240418+09	2026-05-25 00:41:42.240418+09
4524	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-11-21	940	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4525	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-11-28	970	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4526	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-12-05	980	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4527	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-12-12	995	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4528	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-12-19	1005	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4529	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-12-26	1015	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4530	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-01-02	1025	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2074	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-01-31	49.1	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2075	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-02-28	50.2	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2076	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-03-31	50.5	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2077	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-04-30	49.8	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2078	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-05-31	49.5	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2079	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-06-30	49.3	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2080	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-07-31	49.4	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2081	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-08-31	49.1	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2082	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-09-30	49.8	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2083	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-10-31	50.1	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2084	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-11-30	50.3	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2085	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2025-12-31	50.1	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2086	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2026-01-31	49.9	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2087	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2026-02-28	50.2	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2088	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2026-03-31	50.5	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
2089	NBS	중국	경기	제조업	\N	중국 수출 구매자 관리자 지수(PMI)	2026-04-30	50.4	pt	M	2026-05-24 14:23:09.91612+09	2026-05-24 14:23:09.91612+09
1	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-02	3205	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-05	3180	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
3	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-08	3165	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-12	3220	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
5	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-15	3240	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
6	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-19	3210	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
7	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-22	3150	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
8	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-26	3110	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
9	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-28	3080	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
10	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-05-30	3060	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
11	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-02	3090	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
12	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-05	3115	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
13	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-09	3105	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
14	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-12	3085	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
15	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-16	3140	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
16	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-19	3180	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
17	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-23	3205	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
18	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-25	3190	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
19	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-27	3230	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
20	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-06-30	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
21	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-02	3350	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
22	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-07	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
23	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-10	3505	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
24	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-14	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
25	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-17	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
26	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-21	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
27	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-24	3510	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
28	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-28	3470	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
29	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-30	3430	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
30	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-07-31	3405	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
31	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-04	3460	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
32	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-07	3485	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
33	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-11	3450	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
34	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-14	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2544	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-30	2990	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
35	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-18	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
36	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-21	3360	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
37	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-25	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
38	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-27	3350	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
39	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-28	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
40	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-08-29	3340	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
41	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-02	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
42	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-05	3395	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
43	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-09	3360	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
44	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-12	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
45	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-16	3340	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
46	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-19	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
47	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-23	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
48	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-25	3250	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
49	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-29	3275	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
50	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-09-30	3260	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
51	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-06	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
52	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-09	3210	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
53	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-13	3230	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
54	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-16	3260	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
55	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-20	3305	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
56	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-23	3340	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
57	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-27	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
58	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-29	3260	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
59	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-30	3285	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
60	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-10-31	3250	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
61	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-04	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
62	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-07	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
63	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-11	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
64	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-14	3240	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
65	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-18	3265	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
66	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-21	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
67	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-25	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
68	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-27	3315	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
69	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-28	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
70	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-11-29	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
71	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-02	3285	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
72	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-05	3315	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
73	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-09	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
74	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-12	3295	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
75	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-16	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
76	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-19	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
77	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-23	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
78	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-26	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
79	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-29	3250	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
80	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2025-12-31	3230	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
81	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-05	3215	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
82	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-08	3225	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
83	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-12	3205	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
84	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-15	3240	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
85	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-19	3210	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
86	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-22	3260	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
87	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-26	3235	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
88	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-28	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
89	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-29	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
90	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-01-30	3315	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
91	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-03	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
92	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-06	3260	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
93	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-10	3245	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
94	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-13	3220	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
95	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-17	3240	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
96	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-20	3265	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
97	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-24	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
98	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-26	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
99	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-27	3285	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
100	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-02-28	3305	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
101	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-03	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
102	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-06	3295	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
103	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-10	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
104	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-13	3285	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
105	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-17	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
106	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-20	3350	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
107	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-24	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
108	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-26	3340	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
109	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-28	3365	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
110	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-03-31	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
111	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-02	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
112	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-07	3385	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
113	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-10	3400	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
114	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-14	3425	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
115	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-17	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
116	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-21	3415	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
117	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-24	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
118	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-27	3405	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
119	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-29	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
120	Bloomberg	중국	가격	철강재	열연	열연(HR) Coil 선물가 (상하이 선물거래소 1차)	2026-04-30	3435	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2210	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2026-03-01	87000	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2211	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2026-02-01	76100	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2212	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2026-01-01	75300	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2213	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-12-01	68200	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2214	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-11-01	69900	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2215	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-10-01	72000	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2216	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-09-01	73500	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2217	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-08-01	77400	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2218	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-07-01	79700	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2219	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-06-01	83200	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2220	Bloomberg	중국	생산	철강재	공통	중국의 조강 생산량 (세계철강협회)	2025-05-01	86600	1,000MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2221	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-30	1.753	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2222	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-29	1.747	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2223	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-28	1.763	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2224	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-27	1.767	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2225	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-24	1.761	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2226	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-23	1.746	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2227	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-22	1.737	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2228	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-21	1.752	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2229	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-20	1.761	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2230	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-17	1.765	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2231	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-16	1.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2232	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-15	1.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2233	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-14	1.785	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2234	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-13	1.797	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2235	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-10	1.815	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2236	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-09	1.818	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2237	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-08	1.812	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2238	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-07	1.816	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2239	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-03	1.819	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2240	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-02	1.822	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2241	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-04-01	1.824	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2242	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-31	1.818	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2243	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-30	1.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2244	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-27	1.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2245	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-26	1.823	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2246	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-25	1.825	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2247	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-24	1.834	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2248	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-23	1.835	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2249	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-20	1.832	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2250	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-19	1.829	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2251	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-18	1.821	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2252	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-17	1.835	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2253	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-16	1.835	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2254	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-13	1.844	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2255	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-12	1.815	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2256	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-11	1.844	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2257	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-10	1.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2258	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-09	1.88	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2259	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-06	1.797	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2260	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-05	1.795	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2261	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-04	1.799	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2262	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-03	1.73	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2263	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-03-02	1.801	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2264	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-28	1.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2265	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-27	1.829	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2266	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-26	1.824	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2267	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-25	1.815	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2268	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-24	1.799	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2269	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-14	1.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2270	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-13	1.812	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2271	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-12	1.785	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2272	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-11	1.802	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2273	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-10	1.807	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2274	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-09	1.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2275	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-06	1.807	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2276	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-05	1.815	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2277	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-04	1.816	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2278	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-03	1.816	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2279	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-02-02	1.809	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2280	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-30	1.803	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2281	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-29	1.818	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2282	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-28	1.818	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2283	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-27	1.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2284	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-26	1.826	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2285	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-23	1.832	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2286	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-22	1.838	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2287	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-21	1.835	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2288	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-20	1.801	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2289	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-19	1.839	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2290	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-16	1.845	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2291	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-15	1.861	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2292	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-14	1.851	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2293	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-13	1.855	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2294	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-12	1.861	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2295	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-09	1.877	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2296	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-08	1.893	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2297	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-07	1.871	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2298	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-06	1.89	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2299	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-05	1.871	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2300	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2026-01-04	1.877	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2301	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-31	1.862	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2302	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-30	1.872	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2303	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-29	1.867	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2304	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-26	1.829	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2305	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-25	1.842	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2306	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-24	1.854	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2307	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-23	1.865	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2308	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-22	1.854	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2309	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-19	1.822	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2310	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-18	1.798	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2311	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-17	1.845	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2312	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-16	1.795	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2313	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-15	1.795	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2314	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-12	1.849	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2315	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-11	1.852	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2316	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-10	1.857	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2317	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-09	1.871	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2318	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-08	1.875	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2319	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-05	1.858	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2320	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-04	1.862	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2321	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-03	1.842	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2322	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-02	1.844	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2323	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-12-01	1.84	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2324	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-28	1.832	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2325	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-27	1.849	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2326	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-26	1.833	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2327	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-25	1.822	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2328	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-24	1.826	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2329	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-21	1.821	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2330	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-20	1.823	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2331	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-19	1.816	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2332	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-18	1.814	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2333	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-17	1.815	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2334	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-14	1.807	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2335	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-13	1.814	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2336	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-12	1.816	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2337	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-11	1.825	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2338	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-10	1.814	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2339	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-07	1.758	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2340	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-06	1.756	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2341	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-05	1.745	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2342	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-04	1.747	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2343	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-11-03	1.757	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2344	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-31	1.764	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2345	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-30	1.762	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2346	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-29	1.766	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2347	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-28	1.773	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2348	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-27	1.781	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2349	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-24	1.789	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2350	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-23	1.781	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2351	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-22	1.779	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2352	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-21	1.777	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2353	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-20	1.776	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2354	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-17	1.763	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2355	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-16	1.769	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2356	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-15	1.774	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2357	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-14	1.769	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2358	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-13	1.771	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2359	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-11	1.857	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2360	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-10	1.861	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2361	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-10-09	1.925	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2362	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-30	1.878	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2363	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-29	1.895	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2364	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-28	1.906	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2365	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-26	1.914	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2366	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-25	1.903	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2367	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-24	1.903	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2368	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-23	1.886	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2369	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-22	1.881	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2370	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-19	1.872	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2371	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-18	1.866	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2372	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-17	1.87	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2373	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-16	1.879	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2374	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-15	1.889	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2375	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-12	1.817	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2376	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-11	1.811	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2377	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-10	1.813	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2378	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-09	1.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2379	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-08	1.788	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2380	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-05	1.766	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2381	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-04	1.769	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2382	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-03	1.775	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2383	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-02	1.787	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2384	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-09-01	1.792	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2385	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-29	1.785	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2386	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-28	1.786	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2387	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-27	1.772	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2388	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-26	1.772	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2389	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-25	1.784	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2390	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-22	1.789	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2391	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-21	1.774	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2392	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-20	1.789	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2393	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-19	1.779	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2394	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-18	1.769	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2395	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-15	1.748	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2396	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-14	1.737	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2397	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-13	1.733	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2398	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-12	1.728	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2399	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-11	1.714	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2400	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-08	1.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2401	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-07	1.698	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2402	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-06	1.718	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2403	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-05	1.715	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2404	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-04	1.72	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2405	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-08-01	1.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2406	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-31	1.728	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2407	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-30	1.736	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2408	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-29	1.736	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2409	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-28	1.735	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2410	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-25	1.736	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2411	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-24	1.74	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2412	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-23	1.704	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2413	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-22	1.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2414	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-21	1.682	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2415	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-18	1.674	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2416	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-17	1.662	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2417	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-16	1.662	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2418	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-15	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2419	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-14	1.672	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2420	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-11	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2421	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-10	1.663	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2422	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-09	1.649	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2423	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-08	1.655	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2424	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-07	1.651	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2425	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-04	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2426	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-03	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2427	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-02	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2428	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-07-01	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2429	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-30	1.65	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2430	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-27	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2431	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-26	1.65	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2432	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-25	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2433	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-24	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2434	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-23	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2435	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-20	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2436	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-19	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2437	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-18	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2438	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-17	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2439	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-16	1.62	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2440	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-13	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2441	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-12	1.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2442	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-11	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2443	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-10	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2444	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-09	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2445	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-06	1.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2446	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-05	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2447	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-04	1.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2448	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-06-03	1.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2449	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-30	1.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2450	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-29	1.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2451	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-28	1.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2452	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-27	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2453	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-26	1.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2454	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-23	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2455	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-22	1.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2456	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-21	1.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2457	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-20	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2458	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-19	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2459	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-16	1.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2460	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-15	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2461	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-14	1.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2462	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-13	1.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2463	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-12	1.65	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2464	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-09	1.63	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2465	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-08	1.63	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2466	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-07	1.64	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2467	Bloomberg	중국	경제/산업	거시경제	채권/금리	중국 10년 만기 국채 수익률	2025-05-06	1.63	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
121	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-05-07	1580	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
122	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-05-21	1620	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
123	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-06-04	1550	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
124	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-06-18	1520	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
125	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-07-02	1560	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
126	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-07-16	1530	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
127	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-08-06	1550	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
128	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-08-20	1510	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
129	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-09-03	1540	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
130	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-09-17	1580	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
131	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-10-08	1520	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
132	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-10-22	1640	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
133	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-11-05	1500	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
134	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-11-19	1540	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
135	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-12-03	1480	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
136	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2025-12-17	1580	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
137	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-01-07	1450	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
138	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-01-21	1560	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
139	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-02-04	1610	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
140	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-02-18	1520	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
141	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-03-04	1780	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
142	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-03-18	1710	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
143	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-04-08	1760	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
144	Bloomberg	중국	재고	철강재	공통	중국 10일 주기 주요 제철소 철강 재고(CISA)	2026-04-22	1863	10,000MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
145	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2026-03-01	1	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
146	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2026-02-01	1.3	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
147	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2026-01-01	0.2	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
148	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-12-01	0.8	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
149	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-11-01	0.7	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
150	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-10-01	0.2	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
151	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-09-01	-0.3	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
152	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-08-01	-0.4	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
153	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-07-01	0	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
154	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-06-01	0.1	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
155	Bloomberg	중국	경제/산업	거시경제	CPI	중국 소비자 물가지수 연간 변동률	2025-05-01	0.1	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2503	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2026-04-01	50.3	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2504	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2026-03-01	50.4	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2505	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2026-02-01	49	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2506	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2026-01-01	49.3	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2507	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-12-01	50.1	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2508	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-11-01	49.2	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2509	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-10-01	49	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2510	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-09-01	49.8	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2511	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-08-01	49.4	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2512	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-07-01	49.3	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2513	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-06-01	49.7	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2514	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2025-05-01	49.5	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
156	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2026-03-01	9130	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
157	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2026-02-01	7840	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
158	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-12-01	11300	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
159	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-11-01	9980	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
160	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-10-01	9780	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
161	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-09-01	10470	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
162	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-08-01	9510	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
163	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-07-01	9840	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
164	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-06-01	9680	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
165	Bloomberg	중국	수출입	철강재	공통	중국 철강제품 수출량	2025-05-01	10580	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2525	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-02	3090	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2526	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-06	3075	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2527	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-09	3110	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2528	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-13	3080	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2529	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-16	3040	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2530	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-20	3065	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2531	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-23	3020	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2532	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-27	2980	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2533	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-29	2960	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2534	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-05-31	2950	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2535	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-03	2940	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2536	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-06	2920	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2537	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-10	2955	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2538	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-13	2930	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2539	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-17	2970	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2540	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-20	2985	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2541	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-24	2975	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2542	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-26	2965	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2543	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-06-28	2980	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2545	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-02	3030	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2546	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-07	3085	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2547	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-10	3070	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2548	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-14	3140	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2549	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-17	3155	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2550	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-21	3210	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2551	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-24	3290	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2552	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-28	3340	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2553	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-30	3270	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2554	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-07-31	3305	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2555	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-04	3240	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2556	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-07	3210	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2557	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-11	3255	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2558	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-14	3220	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2559	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-18	3180	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2560	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-21	3145	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2561	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-25	3170	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2562	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-27	3130	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2563	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-28	3150	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2564	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-08-29	3140	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2565	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-02	3185	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2566	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-05	3170	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2567	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-09	3120	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2568	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-12	3160	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2569	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-16	3180	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2570	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-19	3150	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2571	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-23	3110	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2572	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-25	3090	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2573	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-29	3125	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2574	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-09-30	3115	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2575	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-06	3070	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2576	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-09	3095	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2577	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-13	3065	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2578	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-16	3120	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2579	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-20	3100	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2580	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-23	3140	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2581	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-27	3080	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2582	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-29	3050	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2583	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-30	3075	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2584	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-10-31	3060	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2585	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-04	3085	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2586	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-07	3115	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2587	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-11	3100	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2588	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-14	3050	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2589	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-18	3070	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2590	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-21	3090	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2591	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-25	3120	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2592	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-27	3145	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2593	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-28	3175	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2594	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-11-29	3190	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2595	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-02	3150	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2596	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-05	3110	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2597	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-09	3085	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2598	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-12	3105	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2599	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-16	3130	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2600	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-19	3155	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2601	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-23	3140	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2602	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-26	3120	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2603	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-29	3165	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2604	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2025-12-31	3195	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2605	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-05	3175	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2606	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-08	3150	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2607	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-12	3180	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2608	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-15	3130	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2609	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-19	3160	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2610	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-22	3175	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2611	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-26	3140	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2612	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-28	3110	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2613	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-29	3090	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2614	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-01-30	3075	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2615	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-03	3070	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2616	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-06	3060	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2617	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-10	3050	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2618	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-13	3075	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2619	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-17	3095	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2620	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-20	3090	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2621	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-24	3120	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2622	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-26	3135	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2623	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-27	3160	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2624	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-02-28	3155	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2625	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-03	3170	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2626	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-06	3145	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2627	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-10	3165	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2628	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-13	3135	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2629	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-17	3110	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2630	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-20	3125	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2631	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-24	3115	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2632	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-26	3135	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2633	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-28	3155	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2634	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-03-31	3180	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2635	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-02	3205	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2636	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-07	3185	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2637	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-10	3200	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2638	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-14	3225	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2639	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-17	3245	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2640	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-21	3210	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2641	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-24	3190	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2642	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-27	3220	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2643	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-29	3240	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2644	Bloomberg	중국	가격	철강재	기타	중국 철근(Rebar) 선물가	2026-04-30	3260	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
166	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2026-03-01	-11.2	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
167	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2026-02-01	-11.1	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
168	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-12-01	-17.2	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
169	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-11-01	-15.9	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
170	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-10-01	-14.7	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
171	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-09-01	-13.9	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
172	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-08-01	-12.9	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
173	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-07-01	-12	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
174	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-06-01	-11.2	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
175	Bloomberg	중국	경제/산업	거시경제	기타	중국 부동산 개발 투자율 YoY	2025-05-01	-10.7	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2655	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2026-03-01	1178	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2656	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2026-02-01	1231	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2657	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-12-01	1188	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2658	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-11-01	1181	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2659	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-10-01	1167	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2660	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-09-01	1173	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2661	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-08-01	1165	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2662	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-07-01	1155	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2663	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-06-01	1143	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2664	Bloomberg	중국	경제/산업	거시경제	기타	중국 무역수지 NSA	2025-05-01	1081.9	USD10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2665	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-30	49652.14	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2666	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-29	48861.81	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2667	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-28	49141.93	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2668	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-27	49167.79	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2669	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-24	49230.71	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2670	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-23	49310.32	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2671	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-22	49490.03	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2672	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-21	49149.38	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2673	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-20	49442.56	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2674	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-17	49447.43	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2675	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-16	48578.72	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2676	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-15	48463.72	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2677	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-14	48535.99	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2678	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-13	48218.25	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2679	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-10	47916.57	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2680	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-09	48185.8	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2681	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-08	47909.92	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2682	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-07	46584.46	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2683	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-06	46669.88	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2684	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-02	46504.67	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2685	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-04-01	46565.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2686	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-31	46341.51	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2687	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-30	45216.14	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2688	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-27	45166.64	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2689	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-26	45960.11	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2690	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-25	46429.49	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2691	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-24	46124.06	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2692	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-23	46208.47	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2693	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-20	45577.47	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2694	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-19	46021.43	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2695	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-18	46225.15	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2696	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-17	46993.26	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2697	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-16	46946.41	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2698	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-13	46558.47	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2699	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-12	46677.85	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2700	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-11	47417.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2701	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-10	47706.51	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2702	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-09	47740.8	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2703	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-06	47501.55	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2704	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-05	47954.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2705	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-04	48739.41	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2706	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-03	48501.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2707	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-03-02	48904.78	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2708	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-27	48977.92	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2709	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-26	49499.2	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2710	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-25	49482.15	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2711	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-24	49174.5	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2712	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-23	48804.06	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2713	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-20	49625.97	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2714	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-19	49395.16	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2715	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-18	49662.66	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2716	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-17	49533.19	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2717	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-13	49500.93	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2718	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-12	49451.98	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2719	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-11	50121.4	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2720	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-10	50188.14	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2721	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-09	50135.87	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2722	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-06	50115.67	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2723	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-05	48908.72	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2724	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-04	49501.3	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2725	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-03	49240.99	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2726	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-02-02	49407.66	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2727	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-30	48892.47	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2728	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-29	49071.56	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2729	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-28	49015.6	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2730	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-27	49003.41	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2731	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-26	49412.4	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2732	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-23	49098.71	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2733	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-22	49384.01	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2734	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-21	49077.23	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2735	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-20	48488.59	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2736	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-16	49359.33	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2737	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-15	49442.44	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2738	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-14	49149.63	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2739	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-13	49191.99	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2740	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-12	49590.2	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2741	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-09	49504.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2742	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-08	49266.11	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2743	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-07	48996.08	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2744	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-06	49462.08	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2745	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-05	48977.18	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2746	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2026-01-02	48382.39	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2747	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-31	48063.29	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4500	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-06-06	970	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2748	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-30	48367.06	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2749	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-29	48461.93	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2750	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-26	48710.97	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2751	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-25	48731.16	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2752	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-24	48731.16	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2753	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-23	48442.41	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2754	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-22	48362.68	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2755	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-19	48134.89	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2756	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-18	47951.85	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2757	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-17	47885.97	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2758	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-16	48114.26	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2759	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-15	48416.56	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2760	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-12	48458.05	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2761	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-11	48704.01	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2762	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-10	48057.75	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2763	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-09	47560.29	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2764	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-08	47739.32	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2765	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-05	47954.99	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2766	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-04	47850.94	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2767	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-03	47882.9	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2768	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-02	47474.46	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2769	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-12-01	47289.33	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2770	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-28	47716.42	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2771	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-26	47427.12	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2772	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-25	47112.45	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2773	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-24	46448.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2774	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-21	46245.41	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2775	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-20	45752.26	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2776	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-19	46138.77	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2777	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-18	46091.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2778	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-17	46590.24	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2779	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-14	47147.48	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2780	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-13	47457.22	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2781	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-12	48254.82	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2782	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-11	47927.96	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2783	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-10	47368.63	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2784	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-07	46987.1	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2785	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-06	46912.3	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2786	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-05	47311	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2787	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-04	47085.24	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2788	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-11-03	47336.68	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2789	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-31	47562.87	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2790	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-30	47522.12	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2791	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-29	47632	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2792	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-28	47706.37	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2793	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-27	47544.59	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2794	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-24	47207.12	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2795	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-23	46734.61	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2796	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-22	46590.41	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4501	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-06-13	965	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2797	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-21	46924.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2798	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-20	46706.58	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2799	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-17	46190.61	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2800	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-16	45952.24	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2801	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-15	46253.31	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2802	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-14	46270.46	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2803	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-13	46067.58	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2804	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-10	45479.6	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2805	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-09	46358.42	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2806	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-08	46601.78	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2807	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-07	46602.98	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2808	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-06	46694.97	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2809	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-03	46758.28	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2810	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-02	46519.72	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2811	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-10-01	46441.1	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2812	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-30	46397.89	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2813	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-29	46316.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2814	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-26	46247.29	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2815	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-25	45947.32	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2816	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-24	46121.28	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2817	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-23	46292.78	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2818	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-22	46381.54	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2819	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-19	46315.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2820	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-18	46142.42	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2821	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-17	46018.32	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2822	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-16	45757.9	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2823	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-15	45883.45	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2824	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-12	45834.22	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2825	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-11	46108	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2826	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-10	45490.92	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2827	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-09	45711.34	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2828	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-08	45514.95	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2829	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-05	45400.86	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2830	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-04	45621.29	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2831	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-03	45271.23	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2832	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-09-02	45295.81	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2833	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-29	45544.88	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2834	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-28	45636.9	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2835	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-27	45565.23	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2836	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-26	45418.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2837	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-25	45282.47	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2838	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-22	45631.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2839	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-21	44785.5	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2840	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-20	44938.31	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2841	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-19	44922.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2842	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-18	44911.82	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2843	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-15	44946.12	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2844	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-14	44911.26	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2845	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-13	44922.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4502	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-06-20	960	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2846	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-12	44458.61	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2847	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-11	43975.09	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2848	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-08	44175.61	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2849	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-07	43968.64	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2850	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-06	44193.12	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2851	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-05	44111.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2852	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-04	44173.64	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2853	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-08-01	43588.58	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2854	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-31	44130.98	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2855	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-30	44461.28	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2856	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-29	44632.99	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2857	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-28	44837.56	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2858	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-25	44901.92	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2859	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-24	44693.91	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2860	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-23	45010.29	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2861	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-22	44502.44	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2862	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-21	44323.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2863	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-18	44342.19	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2864	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-17	44484.49	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2865	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-16	44254.78	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2866	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-15	44023.29	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2867	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-14	44459.65	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2868	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-11	44371.51	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2869	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-10	44650.64	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2870	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-09	44458.3	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2871	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-08	44240.76	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2872	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-07	44406.36	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2873	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-03	44828.53	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2874	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-02	44484.42	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2875	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-07-01	44494.94	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2876	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-30	44094.77	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2877	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-27	43819.27	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2878	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-26	43386.84	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2879	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-25	42982.43	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2880	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-24	43089.02	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2881	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-23	42581.78	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2882	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-20	42206.82	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2883	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-18	42171.66	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2884	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-17	42215.8	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2885	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-16	42515.09	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2886	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-13	42197.79	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2887	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-12	42967.62	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2888	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-11	42865.77	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2889	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-10	42866.87	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2890	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-09	42761.76	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2891	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-06	42762.87	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2892	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-05	42319.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2893	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-04	42427.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2894	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-03	42519.64	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4503	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-06-27	955	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2895	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-06-02	42305.48	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2896	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-30	42270.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2897	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-29	42215.73	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2898	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-28	42098.7	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2899	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-27	42343.65	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2900	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-23	41603.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2901	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-22	41859.09	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2902	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-21	41860.44	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2903	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-20	42677.24	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2904	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-19	42792.07	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2905	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-16	42654.74	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2906	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-15	42322.75	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2907	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-14	42051.06	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2908	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-13	42140.43	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2909	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-12	42410.1	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2910	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-09	41249.38	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2911	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-08	41368.45	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2912	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-07	41113.97	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2913	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-06	40829	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2914	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-05	41218.83	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2915	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-02	41317.43	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2916	Bloomberg	미국	경제/산업	거시경제	금융지수	다우존스 산업평균지수	2025-05-01	40752.96	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
176	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-30	4.39	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
177	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-29	4.416	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
178	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-28	4.354	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
179	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-27	4.336	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
180	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-24	4.31	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
181	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-23	4.323	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
182	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-22	4.294	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
183	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-21	4.292	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
184	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-20	4.25	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
185	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-17	4.244	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
186	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-16	4.309	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
187	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-15	4.279	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
188	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-14	4.256	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
189	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-13	4.297	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
190	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-10	4.317	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
191	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-09	4.293	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
192	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-08	4.291	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
193	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-07	4.343	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
194	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-06	4.335	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
195	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-03	4.346	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
196	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-02	4.313	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
197	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-04-01	4.321	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
198	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-31	4.311	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
199	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-30	4.342	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
200	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-27	4.44	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
201	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-26	4.416	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
202	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-25	4.328	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4504	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-07-04	950	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
203	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-24	4.392	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
204	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-23	4.336	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
205	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-20	4.392	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
206	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-19	4.283	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
207	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-18	4.257	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
208	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-17	4.202	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
209	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-16	4.22	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
210	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-13	4.285	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
211	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-12	4.273	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
212	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-11	4.206	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
213	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-10	4.136	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
214	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-09	4.134	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
215	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-06	4.132	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
216	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-05	4.146	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
217	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-04	4.082	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
218	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-03	4.057	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
219	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-03-02	4.052	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
220	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-27	3.962	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
221	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-26	4.017	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
222	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-25	4.048	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
223	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-24	4.033	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
224	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-23	4.027	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
225	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-20	4.085	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
226	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-19	4.075	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
227	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-18	4.081	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
228	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-17	4.054	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
229	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-16	4.042	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
230	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-15	4.054	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
231	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-13	4.056	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
232	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-12	4.104	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
233	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-11	4.172	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
234	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-10	4.145	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
235	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-09	4.198	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
236	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-06	4.206	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
237	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-05	4.21	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
238	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-04	4.278	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
239	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-03	4.273	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
240	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-02-02	4.277	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
241	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-30	4.241	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
242	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-29	4.227	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
243	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-28	4.251	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
244	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-27	4.223	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
245	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-26	4.211	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
246	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-23	4.239	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
247	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-22	4.251	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
248	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-21	4.253	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
249	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-20	4.295	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
250	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-19	4.263	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
251	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-18	4.224	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4505	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-07-11	955	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
252	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-16	4.231	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
253	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-15	4.16	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
254	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-14	4.14	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
255	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-13	4.171	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
256	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-12	4.187	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
257	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-09	4.171	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
258	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-08	4.183	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
259	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-07	4.138	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
260	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-06	4.179	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
261	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-05	4.163	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
262	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-02	4.189	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
263	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2026-01-01	4.175	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
264	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-31	4.153	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
265	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-30	4.128	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
266	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-29	4.116	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
267	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-26	4.134	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
268	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-25	4.133	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
269	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-24	4.134	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
270	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-23	4.169	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
271	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-22	4.171	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
272	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-19	4.151	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
273	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-18	4.116	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
274	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-17	4.151	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
275	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-16	4.149	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
276	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-15	4.182	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
277	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-12	4.196	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
278	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-11	4.141	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
279	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-10	4.164	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
280	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-09	4.186	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
281	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-08	4.172	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
282	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-05	4.139	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
283	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-04	4.108	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
284	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-03	4.058	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
285	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-02	4.088	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
286	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-12-01	4.096	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
287	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-28	4.019	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
288	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-27	4.005	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
289	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-26	3.998	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
290	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-25	4.002	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
291	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-24	4.036	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
292	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-21	4.063	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
293	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-20	4.104	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
294	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-19	4.131	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
295	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-18	4.121	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
296	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-17	4.133	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
297	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-14	4.148	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
298	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-13	4.111	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
299	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-12	4.067	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
300	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-11	4.069	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4506	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-07-18	960	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
301	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-10	4.11	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
302	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-07	4.093	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
303	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-06	4.093	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
304	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-05	4.157	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
305	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-04	4.091	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
306	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-11-03	4.107	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
307	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-31	4.101	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
308	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-30	4.093	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
309	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-29	4.058	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
310	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-28	3.983	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
311	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-27	3.997	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
312	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-24	3.997	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
313	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-23	3.989	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
314	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-22	3.953	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
315	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-21	3.963	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
316	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-20	3.988	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
317	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-17	4.009	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
318	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-16	3.976	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
319	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-15	4.045	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
320	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-14	4.022	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
321	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-13	4.055	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
322	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-12	4.076	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
323	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-10	4.051	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
324	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-09	4.148	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
325	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-08	4.131	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
326	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-07	4.127	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
327	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-06	4.162	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
328	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-03	4.119	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
329	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-02	4.09	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
330	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-10-01	4.106	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
331	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-30	4.15	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
332	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-29	4.141	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
333	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-26	4.187	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
334	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-25	4.174	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
335	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-24	4.147	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
336	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-23	4.118	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
337	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-22	4.145	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
338	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-19	4.139	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
339	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-18	4.104	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
340	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-17	4.076	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
341	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-16	4.026	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
342	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-15	4.034	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
343	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-12	4.06	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
344	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-11	4.011	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
345	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-10	4.032	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
346	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-09	4.074	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
347	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-08	4.046	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
348	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-05	4.086	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
349	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-04	4.176	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4507	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-07-25	970	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
350	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-03	4.211	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
351	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-02	4.277	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
352	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-09-01	4.253	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
353	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-31	4.237	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
354	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-29	4.226	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
355	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-28	4.207	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
356	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-27	4.238	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
357	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-26	4.256	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
358	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-25	4.275	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
359	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-22	4.258	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
360	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-21	4.332	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
361	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-20	4.296	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
362	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-19	4.302	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
363	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-18	4.339	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
364	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-15	4.328	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
365	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-14	4.293	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
366	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-13	4.24	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
367	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-12	4.293	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
368	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-11	4.273	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
369	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-08	4.283	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
370	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-07	4.244	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
371	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-06	4.218	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
372	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-05	4.196	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
373	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-04	4.198	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
374	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-08-01	4.22	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
375	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-31	4.36	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
376	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-30	4.378	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
377	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-29	4.328	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
378	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-28	4.42	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
379	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-25	4.386	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
380	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-24	4.408	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
381	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-23	4.388	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
382	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-22	4.336	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
383	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-21	4.37	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
384	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-18	4.431	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
385	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-17	4.463	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
386	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-16	4.455	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
387	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-15	4.489	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
388	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-14	4.427	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
389	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-11	4.423	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
390	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-10	4.346	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
391	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-09	4.342	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
392	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-08	4.417	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
393	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-07	4.382	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
394	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-04	4.328	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
395	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-03	4.346	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
396	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-02	4.282	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
397	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-07-01	4.241	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
398	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-30	4.231	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4508	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-08-01	960	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
399	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-27	4.274	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
400	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-26	4.245	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
401	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-25	4.29	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
402	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-24	4.294	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
403	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-23	4.341	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
404	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-20	4.376	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
405	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-19	4.385	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
406	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-18	4.39	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
407	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-17	4.386	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
408	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-16	4.448	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
409	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-13	4.406	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
410	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-12	4.364	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
411	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-11	4.419	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
412	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-10	4.473	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
413	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-09	4.475	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
414	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-06	4.505	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
415	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-05	4.389	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
416	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-04	4.356	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
417	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-03	4.457	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
418	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-06-02	4.441	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
419	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-30	4.397	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
420	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-29	4.425	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
421	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-28	4.474	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
422	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-27	4.445	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
423	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-26	4.511	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
424	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-25	4.559	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
425	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-23	4.507	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
426	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-22	4.528	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
427	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-21	4.595	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
428	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-20	4.483	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
429	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-19	4.447	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
430	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-16	4.443	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
431	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-15	4.431	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
432	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-14	4.541	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
433	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-13	4.47	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
434	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-12	4.472	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
435	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-09	4.381	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
436	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-08	4.379	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
437	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-07	4.268	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
438	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-06	4.298	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
439	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-05	4.348	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
440	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-02	4.307	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
441	Bloomberg	미국	경제/산업	거시경제	미국	미국 10년 만기 국채 수익률	2025-05-01	4.215	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
442	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2026-02-01	1.72	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
443	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2026-01-01	1.76	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
444	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-12-01	1.77	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
445	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-11-01	1.8	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
446	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-10-01	1.79	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
447	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-09-01	1.77	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4509	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-08-08	950	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
448	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-08-01	1.79	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
449	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-07-01	1.77	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
450	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-06-01	1.78	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
451	Bloomberg	미국	재고	철강재	공통	미국 1차 금속 제조업체 재고율(SA)	2025-05-01	1.79	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
452	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2026-02-01	2389	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
453	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2026-01-01	2331	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
454	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-12-01	2371	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
455	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-11-01	2295	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
456	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-10-01	2291	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
457	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-09-01	2242	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
458	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-08-01	2340	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
459	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-07-01	2310	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
460	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-06-01	2276	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
461	Bloomberg	미국	경제/산업	산업	가전	미국 가전제품 신규 주문액 NSA	2025-05-01	2212	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
3203	Bloomberg	미국	가격	철강재	냉연	미국 냉연CR SHEET 수출가	2026-02-01	1626	USD/MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3204	Bloomberg	미국	가격	철강재	냉연	미국 냉연CR SHEET 수출가	2025-11-01	1469	USD/MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3205	Bloomberg	미국	가격	철강재	냉연	미국 냉연CR SHEET 수출가	2025-10-01	1506	USD/MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3206	Bloomberg	미국	가격	철강재	냉연	미국 냉연CR SHEET 수출가	2025-08-01	1585	USD/MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3207	Bloomberg	미국	가격	철강재	냉연	미국 냉연CR SHEET 수출가	2025-07-01	1617	USD/MT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
462	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2026-03-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
463	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2026-02-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
464	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2026-01-01	15	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
465	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-12-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
466	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-11-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
467	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-10-01	15	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
468	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-09-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
469	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-08-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
470	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-07-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
471	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-06-01	15	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
472	Bloomberg	미국	경제/산업	산업	자동차	미국 자동차 판매대수SAAR	2025-05-01	16	100만 Unit	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
473	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2026-03-01	99.99	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
474	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2026-02-01	99.9	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
475	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2026-01-01	99.63	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
476	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-12-01	98.86	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
477	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-11-01	98.95	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
478	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-10-01	50.33	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
479	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-09-01	99.08	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
480	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-08-01	98.98	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
481	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-07-01	99.03	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
482	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-06-01	98.95	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
483	Bloomberg	미국	경제/산업	거시경제	금융지수	미국 제조업 신뢰지수 SA	2025-05-01	98.95	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
3230	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-30	1081	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3231	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-29	1082	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3232	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-28	1042	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3233	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-27	1042	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3234	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-24	1042	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3235	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-23	1045	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3236	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-22	1045	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3237	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-21	1047	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3238	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-20	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3239	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-17	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3240	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-16	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3241	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-15	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3242	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-14	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3243	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-13	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3244	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-10	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3245	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-09	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3246	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-08	1046	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3247	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-07	1048	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3248	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-06	1051	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3249	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-03	1051	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3250	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-02	1051	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3251	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-04-01	1049	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3252	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-31	1048	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3253	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-30	1048	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3254	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-27	1041	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3255	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-26	1045	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3256	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-25	1047	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3257	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-24	1009	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3258	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-23	1009	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3259	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-20	1012	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3260	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-19	1009	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3261	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-18	1014	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3262	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-17	1015	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3263	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-16	1016	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3264	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-13	1011	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3265	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-12	1017	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3266	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-11	1017	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3267	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-10	1018	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3268	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-09	1017	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3269	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-06	1018	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3270	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-05	1016	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3271	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-04	1014	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3272	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-03	1016	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3273	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-03-02	1015	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3274	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-27	1017	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3275	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-26	1016	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3276	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-25	1007	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3277	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-24	984	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3278	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-23	984	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3279	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-20	981	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3280	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-19	982	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3281	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-18	982	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3282	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-17	980	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3283	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-16	980	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3284	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-13	979	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3285	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-12	980	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3286	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-11	976	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4510	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-08-15	940	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3287	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-10	976	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3288	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-09	977	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3289	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-06	977	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3290	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-05	973	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3291	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-04	976	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3292	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-03	971	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3293	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-02-02	972	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3294	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-30	972	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3295	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-29	972	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3296	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-28	972	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3297	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-27	942	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3298	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-26	942	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3299	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-23	942	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3300	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-22	943	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3301	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-21	941	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3302	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-20	940	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3303	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-16	939	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3304	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-15	939	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3305	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-14	939	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3306	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-13	942	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3307	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-12	943	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3308	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-09	940	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3309	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-08	938	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3310	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-07	938	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3311	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-06	930	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3312	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-05	933	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3313	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2026-01-02	940	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3314	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-31	935	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3315	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-30	904	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3316	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-29	906	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3317	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-26	906	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3318	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-24	906	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3319	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-23	908	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3320	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-22	908	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3321	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-19	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3322	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-18	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3323	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-17	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3324	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-16	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3325	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-15	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3326	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-12	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3327	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-11	907	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3328	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-10	906	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3329	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-09	910	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3330	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-08	908	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3331	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-05	908	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3332	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-04	906	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3333	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-03	906	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3334	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-02	901	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3335	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-12-01	903	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4511	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-08-22	930	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3336	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-28	908	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3337	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-26	904	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3338	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-25	854	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3339	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-24	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3340	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-21	857	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3341	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-20	856	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3342	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-19	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3343	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-18	856	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3344	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-17	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3345	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-14	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3346	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-13	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3347	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-12	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3348	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-11	852	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3349	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-10	851	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3350	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-07	847	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3351	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-06	847	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3352	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-05	845	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3353	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-04	848	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3354	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-11-03	848	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3355	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-31	851	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3356	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-30	850	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3357	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-29	847	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3358	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-28	814	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3359	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-27	814	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3360	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-24	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3361	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-23	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3362	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-22	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3363	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-21	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3364	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-20	812	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3365	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-17	814	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3366	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-16	815	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3367	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-15	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3368	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-14	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3369	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-13	814	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3370	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-10	814	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3371	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-09	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3372	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-08	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3373	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-07	805	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3374	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-06	801	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3375	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-03	804	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3376	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-02	805	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3377	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-10-01	806	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3378	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-30	800	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3379	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-29	802	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3380	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-26	805	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3381	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-25	818	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3382	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-24	823	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3383	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-23	809	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3384	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-22	811	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4512	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-08-29	920	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3385	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-19	812	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3386	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-18	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3387	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-17	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3388	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-16	810	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3389	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-15	808	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3390	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-12	808	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3391	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-11	810	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3392	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-10	805	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3393	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-09	799	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3394	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-08	808	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3395	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-05	799	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3396	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-04	800	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3397	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-03	799	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3398	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-02	795	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3399	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-09-01	793	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3400	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-29	793	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3401	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-28	810	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3402	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-27	813	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3403	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-26	831	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3404	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-25	832	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3405	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-22	832	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3406	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-21	831	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3407	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-20	834	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3408	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-19	832	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3409	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-18	832	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3410	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-15	832	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3411	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-14	831	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3412	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-13	833	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3413	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-12	834	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3414	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-11	835	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3415	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-08	835	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3416	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-07	838	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3417	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-06	843	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3418	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-05	850	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3419	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-04	855	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3420	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-08-01	847	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3421	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-31	842	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3422	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-30	860	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3423	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-29	875	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3424	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-28	873	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3425	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-25	871	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3426	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-24	872	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3427	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-23	876	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3428	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-22	874	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3429	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-21	874	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3430	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-18	875	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3431	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-17	875	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3432	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-16	873	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3433	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-15	881	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4513	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-09-05	900	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3434	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-14	881	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3435	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-11	877	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3436	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-10	882	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3437	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-09	882	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3438	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-08	890	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3439	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-07	879	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3440	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-03	885	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3441	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-02	885	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3442	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-07-01	883	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3443	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-30	880	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3444	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-27	883	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3445	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-26	885	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3446	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-25	889	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3447	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-24	872	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3448	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-23	872	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3449	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-20	872	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3450	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-18	870	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3451	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-17	864	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3452	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-16	864	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3453	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-13	862	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3454	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-12	862	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3455	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-11	862	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3456	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-10	883	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3457	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-09	881	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3458	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-06	878	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3459	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-05	878	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3460	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-04	872	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3461	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-03	870	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3462	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-06-02	893	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3463	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-30	840	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3464	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-29	842	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3465	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-28	835	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3466	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-27	903	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3467	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-26	900	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3468	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-23	903	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3469	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-22	903	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3470	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-21	903	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3471	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-20	893	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3472	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-19	895	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3473	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-16	895	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3474	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-15	900	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3475	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-14	891	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3476	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-13	885	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3477	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-12	890	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3478	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-09	890	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3479	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-08	890	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3480	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-07	890	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3481	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-06	872	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3482	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-05	875	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4514	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-09-12	895	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3483	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-02	874	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3484	Bloomberg	미국	가격	철강재	냉연	미국 열연 Coil 현재 선물가	2025-05-01	867	USD/ST	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3485	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-30	2.517	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3486	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-29	2.464	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3487	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-28	2.467	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3488	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-27	2.47	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3489	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-24	2.437	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3490	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-23	2.425	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3491	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-22	2.402	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3492	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-21	2.383	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3493	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-20	2.398	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3494	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-17	2.422	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3495	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-16	2.403	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3496	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-15	2.408	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3497	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-14	2.417	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3498	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-13	2.468	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3499	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-10	2.436	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3500	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-09	2.396	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3501	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-08	2.371	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3502	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-07	2.412	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3503	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-06	2.427	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3504	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-03	2.381	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3505	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-02	2.385	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3506	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-04-01	2.302	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3507	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-31	2.359	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3508	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-30	2.356	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3509	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-27	2.375	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3510	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-26	2.278	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3511	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-25	2.256	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3512	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-24	2.271	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3513	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-23	2.309	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3514	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-20	2.264	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3515	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-19	2.264	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3516	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-18	2.212	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3517	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-17	2.27	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3518	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-16	2.275	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3519	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-13	2.24	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3520	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-12	2.185	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3521	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-11	2.161	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3522	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-10	2.181	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3523	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-09	2.184	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3524	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-06	2.164	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3525	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-05	2.159	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3526	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-04	2.111	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3527	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-03	2.148	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3528	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-03-02	2.066	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3529	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-27	2.116	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3530	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-26	2.152	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3531	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-25	2.137	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3532	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-24	2.104	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3533	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-23	2.101	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3534	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-20	2.105	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3535	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-19	2.14	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3536	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-18	2.139	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3537	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-17	2.127	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3538	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-16	2.211	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3539	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-13	2.214	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3540	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-12	2.23	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3541	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-11	2.237	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3542	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-10	2.238	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3543	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-09	2.292	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3544	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-06	2.235	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3545	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-05	2.227	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3546	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-04	2.252	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3547	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-03	2.257	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3548	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-02-02	2.231	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3549	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-30	2.245	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3550	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-29	2.251	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3551	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-28	2.236	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3552	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-27	2.285	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3553	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-26	2.241	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3554	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-23	2.26	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3555	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-22	2.239	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3556	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-21	2.286	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3557	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-20	2.341	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3558	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-19	2.274	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3559	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-16	2.182	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3560	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-15	2.161	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3561	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-14	2.18	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3562	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-13	2.163	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3563	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-12	2.084	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3564	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-09	2.094	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3565	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-08	2.076	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3566	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-07	2.124	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3567	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-06	2.133	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3568	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-05	2.12	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3569	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-02	2.072	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3570	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2026-01-01	2.072	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3571	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-31	2.079	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3572	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-30	2.07	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3573	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-29	2.056	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3574	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-26	2.04	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3575	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-25	2.05	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3576	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-24	2.044	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3577	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-23	2.04	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3578	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-22	2.084	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3579	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-19	2.023	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3580	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-18	1.971	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3581	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-17	1.976	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3582	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-16	1.953	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3583	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-15	1.959	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3584	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-12	1.952	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3585	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-11	1.928	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3586	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-10	1.956	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3587	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-09	1.96	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3588	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-08	1.964	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3589	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-05	1.949	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3590	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-04	1.937	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3591	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-03	1.893	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3592	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-02	1.856	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3593	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-12-01	1.874	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3594	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-28	1.807	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3595	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-27	1.795	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3596	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-26	1.814	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3597	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-25	1.804	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3598	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-24	1.781	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3599	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-21	1.785	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3600	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-20	1.817	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3601	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-19	1.763	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3602	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-18	1.743	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3603	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-17	1.73	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3604	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-14	1.703	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3605	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-13	1.696	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3606	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-12	1.689	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3607	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-11	1.691	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3608	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-10	1.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3609	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-07	1.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3610	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-06	1.683	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3611	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-05	1.663	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3612	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-04	1.675	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3613	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-11-03	1.654	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3614	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-31	1.659	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3615	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-30	1.646	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3616	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-29	1.651	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3617	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-28	1.643	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3618	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-27	1.671	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3619	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-24	1.656	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3620	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-23	1.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3621	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-22	1.654	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3622	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-21	1.656	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3623	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-20	1.669	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3624	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-17	1.625	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3625	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-16	1.657	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3626	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-15	1.651	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3627	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-14	1.661	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3628	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-13	1.693	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3629	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-10	1.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3630	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-09	1.694	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3631	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-08	1.696	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3632	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-07	1.677	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3633	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-06	1.676	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3634	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-03	1.661	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3635	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-02	1.663	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3636	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-10-01	1.65	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3637	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-30	1.648	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3638	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-29	1.642	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3639	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-26	1.659	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3640	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-25	1.647	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3641	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-24	1.641	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3642	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-23	1.659	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3643	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-22	1.655	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3644	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-19	1.641	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3645	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-18	1.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3646	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-17	1.596	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3647	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-16	1.606	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3648	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-15	1.594	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3649	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-12	1.596	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3650	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-11	1.576	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3651	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-10	1.565	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3652	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-09	1.561	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3653	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-08	1.571	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3654	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-05	1.571	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3655	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-04	1.606	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3656	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-03	1.633	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3657	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-02	1.603	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3658	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-09-01	1.623	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3659	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-29	1.603	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3660	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-28	1.62	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3661	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-27	1.626	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3662	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-26	1.623	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3663	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-25	1.616	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3664	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-22	1.616	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3665	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-21	1.608	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3666	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-20	1.61	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3667	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-19	1.591	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3668	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-18	1.571	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3669	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-15	1.564	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3670	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-14	1.554	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3671	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-13	1.519	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3672	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-12	1.499	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3673	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-11	1.482	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3674	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-08	1.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3675	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-07	1.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3676	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-06	1.496	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3677	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-05	1.473	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3678	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-04	1.506	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3679	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-08-01	1.555	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3680	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-31	1.553	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3681	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-30	1.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3682	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-29	1.558	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3683	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-28	1.566	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3684	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-25	1.603	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3685	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-24	1.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3686	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-23	1.595	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3687	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-22	1.503	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3688	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-21	1.519	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3689	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-18	1.522	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3690	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-17	1.559	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3691	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-16	1.572	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3692	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-15	1.588	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3693	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-14	1.574	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3694	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-11	1.501	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3695	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-10	1.495	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3696	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-09	1.504	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3697	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-08	1.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3698	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-07	1.455	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3699	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-04	1.442	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3700	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-03	1.447	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3701	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-02	1.43	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3702	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-07-01	1.395	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3703	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-30	1.429	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3704	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-27	1.428	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3705	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-26	1.415	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3706	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-25	1.398	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3707	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-24	1.416	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3708	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-23	1.407	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3709	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-20	1.397	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3710	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-19	1.413	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3711	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-18	1.454	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3712	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-17	1.474	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3713	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-16	1.449	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3714	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-13	1.403	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3715	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-12	1.453	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3716	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-11	1.455	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3717	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-10	1.474	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3718	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-09	1.469	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3719	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-06	1.45	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3720	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-05	1.457	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3721	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-04	1.497	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3722	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-03	1.479	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3723	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-06-02	1.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3724	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-30	1.497	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3725	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-29	1.516	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3726	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-28	1.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3727	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-27	1.463	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3728	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-26	1.501	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3729	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-25	1.524	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3730	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-23	1.538	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3731	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-22	1.556	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3732	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-21	1.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3733	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-20	1.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3734	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-19	1.479	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3735	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-18	1.467	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3736	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-16	1.448	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3737	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-15	1.475	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3738	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-14	1.448	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3739	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-13	1.443	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3740	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-12	1.392	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3741	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-09	1.356	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3742	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-08	1.33	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3743	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-07	1.301	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3744	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-02	1.27	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3745	Bloomberg	일본	경제/산업	거시경제	채권/금리	일본 10년 만기 국채 수깅률	2025-05-01	1.281	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
484	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-05-07	620	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
485	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-05-21	620	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
486	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-06-04	620	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
487	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-06-18	610	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
488	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-07-02	610	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
489	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-07-16	610	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
490	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-08-06	610	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
491	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-08-20	610	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
492	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-09-03	605	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
493	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-09-17	585	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
494	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-10-08	570	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
495	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-10-22	570	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
496	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-11-05	560	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
497	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-11-19	560	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
498	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-12-03	560	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
499	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2025-12-26	550	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
500	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-01-07	560	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
501	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-01-21	570	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
502	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-02-04	570	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
503	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-02-18	570	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
504	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-03-04	575	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
505	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-03-18	585	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
506	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-04-08	615	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
507	Bloomberg	일본	가격	철강재	냉연	일본 냉연 Coil 현물가 -FOB	2026-04-22	650	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
3770	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산대수(년)	1905-07-17	7207025	Unit	Y	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
508	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2026-02-01	0.9	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
509	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2026-01-01	-0.6	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
510	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-12-01	1.9	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
511	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-11-01	-7.2	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
512	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-10-01	-0.3	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
513	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-09-01	-0.1	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
514	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-08-01	0.4	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
515	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-07-01	-7.5	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
516	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-06-01	5	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
517	Bloomberg	일본	경제/산업	산업	자동차	일본 자동차 생산량 YoY(월)	2025-05-01	-2.1	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
518	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2026-03-01	75080	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
519	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2026-02-01	65716	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
520	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2026-01-01	62103	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
521	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-12-01	63000	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
522	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-11-01	60601	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
523	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-10-01	66400	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
524	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-09-01	66089	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
525	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-08-01	50509	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
526	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-07-01	63320	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
527	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-06-01	60908	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
528	Bloomberg	일본	경제/산업	산업	가전	일본 전기제품 출하액	2025-05-01	53700	JPY 100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
529	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2026-03-01	6900	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
530	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2026-02-01	6400	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
531	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2026-01-01	6800	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
532	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-12-01	6600	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
533	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-11-01	6800	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
534	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-10-01	6900	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
535	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-09-01	6400	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
536	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-08-01	6600	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
537	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-07-01	6900	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
538	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-06-01	6700	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
539	Bloomberg	일본	생산	철강재	공통	일본 조강생산량	2025-05-01	6800	1000MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
540	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2026-03-01	2491990	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
541	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2026-02-01	2159063	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
542	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2026-01-01	2262028	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
543	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-12-01	2562489	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
544	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-11-01	2374786	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
545	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-10-01	2515989	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
546	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-09-01	2473639	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
547	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-08-01	2440805	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
548	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-07-01	2602872	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
549	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-06-01	2493095	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
550	Bloomberg	일본	수출입	철강재	공통	일본 철강제품 수출량	2025-05-01	2502664	MT	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
3814	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2026-03-01	3.88	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3815	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2026-02-01	2.13	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3816	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2026-01-01	1.81	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3817	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-12-01	0.83	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3818	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-11-01	-0.32	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3819	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-10-01	-1.21	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3820	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-09-01	0.13	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3821	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-08-01	0.52	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3822	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-07-01	-0.58	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3823	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-06-01	-0.13	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3824	Bloomberg	인도	경제/산업	거시경제	금융지수	일본 도매물가지수 - 전체 상품 YoY	2025-05-01	0.39	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3825	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2026-02-01	7245	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3826	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2026-01-01	750	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3827	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-12-01	1134	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3828	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-11-01	1065	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3829	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-10-01	1542	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3830	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-09-01	1406	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3831	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-08-01	1121	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3832	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-07-01	7304	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3833	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-06-01	3554	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3834	Bloomberg	인도	경제/산업	거시경제	기타	인도 외국인 직접 투자 유입액	2025-05-01	2159	USD100만	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3835	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2026-03-01	1793	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3836	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2026-02-01	1705	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3837	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2026-01-01	1671	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3838	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-12-01	1710	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3839	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-11-01	1638	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3840	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-10-01	1623	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3841	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-09-01	1478	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3842	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-08-01	1484	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3843	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-07-01	1467	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3844	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-06-01	1509	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3845	Bloomberg	인도	경제/산업	산업	건설	인도 은행 대출 총액 - 건설	2025-05-01	1509	INR10억	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
551	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2026-03-01	4409	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
552	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2026-02-01	4184	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
553	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2026-01-01	4112	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
554	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-12-01	4175	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
555	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-11-01	4814	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
556	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-10-01	4083	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
557	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-09-01	3116	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
558	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-08-01	2926	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
559	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-07-01	3765	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
560	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-06-01	4147	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
561	Bloomberg	인도	경제/산업	산업	가전	인도 전자제품 수출액	2025-05-01	4569	USD100만	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
3857	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2026-03-01	171	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3858	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2026-02-01	163	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3859	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2026-01-01	164	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3860	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-12-01	154	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3861	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-11-01	150	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3862	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-10-01	141	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3863	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-09-01	152	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3864	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-08-01	141	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3865	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-07-01	143	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3866	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-06-01	135	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3867	Bloomberg	인도	경제/산업	산업	자동차	인도 자동차 및 트레일러 제조업 생산지수	2025-05-01	142	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3868	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2026-03-01	103	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3869	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2026-02-01	89	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3870	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2026-01-01	94	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3871	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-12-01	82	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3872	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-11-01	95	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3873	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-10-01	101	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3874	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-09-01	100	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3875	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-08-01	85	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3876	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-07-01	88	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3877	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-06-01	102	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3878	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 산업 생산지수 - 자동차 (2016=100)	2025-05-01	107	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3879	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2026-03-01	54	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3880	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2026-02-01	53	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3881	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2026-01-01	52	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3882	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-12-01	57	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3883	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-11-01	56	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3884	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-10-01	56	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3885	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-09-01	54	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3886	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-08-01	52	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3887	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-07-01	51.9	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3888	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-06-01	51.7	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3889	Bloomberg	태국	경제/산업	거시경제	제조업지수	태국 제조업 구매관리자 지수 (PMI) (SA)	2025-05-01	51.2	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3890	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2026-03-01	76.59	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3891	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2026-02-01	60.38	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3892	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2026-01-01	65	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3893	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-12-01	43.28	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3894	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-11-01	43.89	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3895	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-10-01	44.5	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3896	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-09-01	42.3	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3897	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-08-01	41.97	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3898	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-07-01	51.5	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3899	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-06-01	57.11	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
3900	Bloomberg	태국	경제/산업	산업	산업기계	태국 기계 및 장비 산업 설비가동률(NSA)	2025-05-01	69.62	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
562	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-02	17340000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
563	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-06	17350000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
564	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-09	17345000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
565	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-13	17320000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
566	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-16	17280000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
567	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-20	17300000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
568	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-23	17290000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
569	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-27	17250000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
570	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-29	17230000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
571	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-05-31	17220000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4515	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-09-19	890	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
572	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-03	17200000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
573	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-06	17180000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
574	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-10	17150000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
575	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-13	17170000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
576	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-17	17130000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
577	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-20	17100000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
578	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-24	17080000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
579	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-26	17050000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
580	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-28	17020000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
581	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-06-30	17000000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
582	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-02	16950000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
583	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-07	16880000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
584	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-10	16850000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
585	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-14	16820000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
586	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-17	16800000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
587	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-21	16780000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
588	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-24	16750000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
589	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-28	16720000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
590	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-30	16700000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
591	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-07-31	16680000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
592	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-04	16650000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
593	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-07	16620000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
594	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-11	16640000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
595	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-14	16670000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
596	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-18	16650000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
597	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-21	16680000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
598	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-25	16700000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
599	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-27	16720000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
600	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-28	16750000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
601	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-08-29	16780000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
602	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-02	16850000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
603	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-05	16920000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
604	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-09	17000000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
605	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-12	17050000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
606	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-16	17080000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
607	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-19	17100000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
608	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-23	17120000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
609	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-25	17100000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
610	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-29	17110000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
611	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-09-30	17100000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
612	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-06	17050000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
613	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-09	17000000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
614	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-13	16980000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
615	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-16	16950000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
616	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-20	16920000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
617	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-23	16900000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
618	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-27	16880000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
619	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-29	16910000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
620	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-30	16890000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
621	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-10-31	16900000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
622	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-04	16880000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
623	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-07	16860000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
624	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-11	16850000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
625	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-14	16870000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
626	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-18	16890000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
627	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-21	16880000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
628	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-25	16850000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
629	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-27	16820000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
630	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-28	16800000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
631	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-11-29	16780000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
632	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-02	16750000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
633	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-05	16730000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
634	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-09	16710000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
635	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-12	16700000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
636	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-16	16720000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
637	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-19	16740000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
638	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-23	16760000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
639	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-26	16750000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
640	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-29	16780000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
641	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2025-12-31	16800000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
642	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-05	16850000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
643	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-08	16900000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
644	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-12	17050000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
645	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-15	17150000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
646	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-19	17180000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
647	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-22	17200000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
648	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-26	17210000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
649	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-28	17200000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
650	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-29	17180000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
651	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-01-30	17220000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
652	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-03	17250000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
653	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-06	17280000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
654	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-10	17300000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
655	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-13	17280000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
656	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-17	17310000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
657	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-20	17330000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
658	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-24	17350000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
659	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-26	17380000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
660	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-27	17420000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
661	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-02-28	17450000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
662	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-03	17800000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
663	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-06	18100000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
664	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-10	18400000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
665	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-13	18500000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
666	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-17	18550000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
667	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-20	18600000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
668	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-24	18650000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
669	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-26	18680000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
670	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-28	18720000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
671	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-03-31	18750000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
672	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-02	18820000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
673	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-07	18850000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
674	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-10	18900000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
675	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-14	18950000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
676	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-17	19000000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
677	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-21	19050000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
678	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-24	19100000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
679	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-27	19150000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
680	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-29	19180000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
681	Bloomberg	베트남	가격	철강재	냉연	베트남 냉연(CR) Coil SPCC 1.0mm 가격	2026-04-30	19200000	VND/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4021	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2026-03-01	6.9	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4022	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2026-02-01	1	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4023	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2026-01-01	21.5	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4024	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-12-01	10.1	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4025	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-11-01	10.8	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4026	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-10-01	10.8	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4027	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-09-01	13.6	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4028	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-08-01	8.9	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4029	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-07-01	8.5	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4030	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-06-01	10.8	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4031	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 산업 생산지수(YoY)	2025-05-01	9.4	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4032	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2026-03-01	51.2	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4033	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2026-02-01	54.3	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4034	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2026-01-01	52.5	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4035	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-12-01	53	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4036	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-11-01	53.8	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4037	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-10-01	54.5	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4038	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-09-01	50.4	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4039	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-08-01	50.4	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4040	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-07-01	52.4	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4041	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-06-01	48.9	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4042	Bloomberg	베트남	경제/산업	거시경제	제조업지수	베트남 제조업 구매관리자 지수(PMI)(SA)	2025-05-01	49.8	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4043	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2026-03-01	48.9	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4044	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2026-02-01	47.1	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4045	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2026-01-01	46.3	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4046	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-12-01	46.1	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4047	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-11-01	47.3	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4048	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-10-01	49.6	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4049	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-09-01	49.6	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4516	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-09-26	880	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4050	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-08-01	50.2	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4051	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-07-01	49.1	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4052	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-06-01	46.3	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4053	Bloomberg	멕시코	경제/산업	거시경제	제조업지수	멕시코 제조업 구매관리자 지수(PMI)(SA)	2025-05-01	46.7	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4054	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2026-03-01	2.77	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4055	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2026-02-01	1.14	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4056	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2026-01-01	1.49	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4057	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2025-12-01	2.06	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4058	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2025-11-01	2.36	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4059	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2025-07-01	3.77	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4060	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2025-06-01	4.89	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4061	Bloomberg	멕시코	경제/산업	거시경제	PPI	멕시코 생산자물가지수(PPI)(YoY)	2025-05-01	6.38	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4062	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2026-04-01	717	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4063	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2026-03-01	1006	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4064	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2026-02-01	807	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4065	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2026-01-01	623	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4066	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-12-01	554	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4067	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-11-01	563	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4068	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-10-01	535	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4069	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-09-01	773	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4070	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-08-01	631	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4071	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-07-01	613	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4072	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-06-01	614	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4073	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2025-05-01	742	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4074	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2026-04-01	343	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4075	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2026-03-01	363	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4076	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2026-02-01	360	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4077	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2026-01-01	447	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4078	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-12-01	553	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4079	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-11-01	384	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4080	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-10-01	258	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4081	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-09-01	314	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4082	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-08-01	282	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4083	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-07-01	319	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4084	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-06-01	299	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4085	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2025-05-01	269	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4086	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-05-01	4111	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4087	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4088	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-05-01	5443	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4089	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)소계	2025-05-01	1743	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4090	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-05-01	728	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4091	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-05-01	540	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4092	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-05-01	320	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4093	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4094	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4095	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4096	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4097	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4098	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4099	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4100	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4101	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-05-01	90	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4102	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-05-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4103	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-05-01	65	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4104	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-06-01	946	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4105	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-06-01	652	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4106	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-06-01	7234	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4107	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-06-01	811	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4108	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-06-01	1094	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4109	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-06-01	56	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4110	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-06-01	1166	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4111	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-06-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4112	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-06-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4113	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-06-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4114	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-06-01	650	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4115	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-06-01	1238	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4116	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-06-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4117	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-06-01	294	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4118	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-06-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4119	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-06-01	842	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4120	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-06-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4121	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-07-01	351	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4122	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-07-01	1410	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4123	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-07-01	10178	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4124	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)소계	2025-07-01	10813	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4125	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-07-01	3792	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4126	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-07-01	325	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4127	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-07-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4128	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-07-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4129	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-07-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4130	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-07-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4131	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-07-01	987	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4132	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-07-01	3719	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4133	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-07-01	413	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4134	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-07-01	728	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4135	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-07-01	60	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4136	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-07-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4137	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-07-01	434	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4138	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-07-01	355	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4139	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-08-01	2034	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4140	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-08-01	1985	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4141	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-08-01	6353	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4142	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-08-01	2289	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4143	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4144	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4145	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-08-01	100	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4146	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-08-01	316	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4147	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4148	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-08-01	1145	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4517	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-10-03	900	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4149	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-08-01	243	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4150	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-08-01	1222	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4151	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4152	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4153	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4154	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-08-01	994	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4155	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-08-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4156	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-09-01	254	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4157	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-09-01	3779	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4158	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-09-01	8404	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4159	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-09-01	3245	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4160	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-09-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4161	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-09-01	571	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4162	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-09-01	1130	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4163	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-09-01	1450	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4164	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-09-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4165	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-09-01	295	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4166	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-09-01	1042	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4167	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-09-01	1900	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4168	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-09-01	284	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4169	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-09-01	94	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4170	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-09-01	463	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4171	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-09-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4172	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-09-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4173	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-10-01	3022	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4174	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-10-01	1199	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4175	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-10-01	10460	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4176	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-10-01	1094	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4177	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-10-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4178	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-10-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4179	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-10-01	299	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4180	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-10-01	700	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4181	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-10-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4182	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-10-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4183	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-10-01	1618	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4184	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-10-01	2370	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4185	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-10-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4186	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-10-01	1071	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4187	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-10-01	2166	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4188	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-10-01	387	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4189	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-10-01	69	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4190	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-11-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4191	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-11-01	2433	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4192	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-11-01	15792	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4193	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-11-01	291	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4194	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-11-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4195	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-11-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4196	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-11-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4197	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-11-01	1150	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4518	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-10-10	910	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4198	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-11-01	424	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4199	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-11-01	150	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4200	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-11-01	757	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4201	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-11-01	2338	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4202	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-11-01	508	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4203	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-11-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4204	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-11-01	72	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4205	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-11-01	3306	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4206	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-11-01	209	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4207	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2025-12-01	435	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4208	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2025-12-01	3408	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4209	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2025-12-01	6473	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4210	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2025-12-01	1848	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4211	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4212	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4213	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4214	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2025-12-01	2302	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4215	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2025-12-01	643	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4216	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4217	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4218	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4219	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2025-12-01	48	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4220	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2025-12-01	305	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4221	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2025-12-01	264	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4222	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2025-12-01	453	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4223	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2025-12-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4224	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2026-01-01	959	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4225	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2026-01-01	2568	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4226	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2026-01-01	2513	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4227	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2026-01-01	924	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4228	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4229	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4230	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2026-01-01	341	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4231	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4232	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4233	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4234	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2026-01-01	501	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4235	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4236	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4237	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4238	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4239	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2026-01-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4240	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2026-01-01	94	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4241	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2026-02-01	876	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4242	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4243	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2026-02-01	6377	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4244	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2026-02-01	669	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4245	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4246	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4519	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-10-17	920	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4247	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4248	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4249	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4250	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4251	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4252	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2026-02-01	1948	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4253	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4254	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4255	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2026-02-01	1004	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4256	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2026-02-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4257	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2026-02-01	50	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4258	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)서울	2026-03-01	5097	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4259	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)인천	2026-03-01	1675	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4260	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경기	2026-03-01	2395	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4261	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)부산	2026-03-01	3458	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4262	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대구	2026-03-01	158	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4263	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)광주	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4264	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)대전	2026-03-01	427	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4265	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)울산	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4266	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)세종	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4267	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)강원	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4268	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충북	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4269	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)충남	2026-03-01	2533	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4270	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전북	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4271	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)전남	2026-03-01	1365	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4272	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경북	2026-03-01	773	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4273	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)경남	2026-03-01	519	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4274	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(분양)제주	2026-03-01	0	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4275	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-05-01	2430	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4276	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-05-01	1144	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4277	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-05-01	5583	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4278	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-05-01	1095	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4279	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-05-01	18	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4280	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-05-01	6	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4281	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-05-01	142	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4282	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-05-01	28	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4283	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-05-01	11	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4284	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-05-01	232	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4285	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-05-01	165	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4286	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-05-01	196	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4287	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-05-01	1333	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4288	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-05-01	233	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4289	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-05-01	216	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4290	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-05-01	2113	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4291	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-05-01	266	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4292	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-06-01	2079	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4293	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-06-01	1116	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4294	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-06-01	17221	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4295	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-06-01	549	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4520	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-10-24	930	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4296	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-06-01	10	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4297	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-06-01	7	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4298	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-06-01	10	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4299	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-06-01	614	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4300	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-06-01	1139	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4301	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-06-01	450	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4302	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-06-01	2572	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4303	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-06-01	188	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4304	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-06-01	97	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4305	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-06-01	1181	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4306	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-06-01	367	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4307	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-06-01	997	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4308	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-06-01	274	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4309	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-07-01	642	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4310	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-07-01	94	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4311	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-07-01	9972	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4312	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-07-01	3130	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4313	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-07-01	396	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4314	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-07-01	11	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4315	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-07-01	-645	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4316	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-07-01	14	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4317	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-07-01	15	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4318	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-07-01	807	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4319	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-07-01	2647	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4320	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-07-01	182	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4321	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-07-01	1559	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4322	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-07-01	258	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4323	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-07-01	684	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4324	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-07-01	1556	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4325	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-07-01	78	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4326	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-08-01	1048	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4327	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-08-01	112	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4328	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-08-01	7852	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4329	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-08-01	9	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4330	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-08-01	-56	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4331	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-08-01	249	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4332	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-08-01	1093	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4333	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-08-01	215	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4334	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-08-01	7	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4335	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-08-01	1525	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4336	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-08-01	1050	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4337	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-08-01	1659	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4338	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-08-01	85	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4339	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-08-01	979	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4340	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-08-01	283	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4341	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-08-01	112	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4342	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-08-01	82	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4343	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-09-01	1386	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4344	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-09-01	3381	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4521	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-10-31	940	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4345	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-09-01	11682	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4346	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-09-01	576	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4347	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-09-01	18	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4348	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-09-01	16	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4349	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-09-01	49	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4350	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-09-01	1335	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4351	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-09-01	434	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4352	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-09-01	214	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4353	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-09-01	1769	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4354	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-09-01	3772	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4355	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-09-01	1235	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4356	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-09-01	570	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4357	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-09-01	311	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4358	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-09-01	2999	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4359	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-09-01	189	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4360	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-10-01	2851	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4361	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-10-01	1351	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4362	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-10-01	5906	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4363	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-10-01	1179	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4364	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-10-01	2437	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4365	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-10-01	10	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4366	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-10-01	450	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4367	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-10-01	56	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4368	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-10-01	13	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4369	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-10-01	171	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4370	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-10-01	114	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4371	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-10-01	1692	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4372	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-10-01	68	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4373	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-10-01	450	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4374	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-10-01	761	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4375	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-10-01	176	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4376	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-10-01	92	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4377	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-11-01	3276	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4378	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-11-01	2058	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4379	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-11-01	9237	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4380	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-11-01	541	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4381	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-11-01	16	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4382	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-11-01	12	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4383	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-11-01	1332	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4384	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-11-01	49	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4385	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-11-01	4	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4386	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-11-01	151	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4387	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-11-01	161	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4388	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-11-01	847	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4389	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-11-01	399	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4390	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-11-01	865	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4391	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-11-01	277	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4392	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-11-01	601	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4393	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-11-01	86	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4522	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-11-07	905	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4394	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2025-12-01	10050	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4395	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2025-12-01	5170	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4396	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2025-12-01	25124	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4397	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2025-12-01	3437	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4398	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2025-12-01	1521	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4399	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2025-12-01	2866	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4400	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2025-12-01	495	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4401	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2025-12-01	45	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4402	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2025-12-01	1859	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4403	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2025-12-01	367	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4404	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2025-12-01	1502	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4405	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2025-12-01	4204	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4406	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2025-12-01	822	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4407	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2025-12-01	1616	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4408	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2025-12-01	1685	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4409	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2025-12-01	3331	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4410	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2025-12-01	115	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4411	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2026-01-01	741	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4412	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2026-01-01	207	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4413	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2026-01-01	6581	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4414	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2026-01-01	554	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4415	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2026-01-01	9	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4416	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2026-01-01	165	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4417	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2026-01-01	143	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4418	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2026-01-01	18	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4419	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2026-01-01	50	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4420	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2026-01-01	97	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4421	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2026-01-01	35	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4422	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2026-01-01	995	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4423	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2026-01-01	613	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4424	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2026-01-01	354	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4425	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2026-01-01	526	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4426	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2026-01-01	152	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4427	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2026-01-01	74	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4428	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2026-02-01	3031	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4429	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2026-02-01	368	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4430	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2026-02-01	2995	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4431	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2026-02-01	2671	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4432	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2026-02-01	627	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4433	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2026-02-01	5	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4434	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2026-02-01	5	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4435	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2026-02-01	661	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4436	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2026-02-01	11	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4437	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2026-02-01	334	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4438	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2026-02-01	166	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4439	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2026-02-01	2334	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4440	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2026-02-01	53	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4441	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2026-02-01	101	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4442	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2026-02-01	929	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4523	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-11-14	920	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4443	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2026-02-01	170	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4444	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2026-02-01	334	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4445	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)서울	2026-03-01	1239	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4446	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)인천	2026-03-01	1629	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4447	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경기	2026-03-01	3413	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4448	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)부산	2026-03-01	32	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4449	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대구	2026-03-01	21	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4450	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)광주	2026-03-01	8	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4451	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)대전	2026-03-01	2301	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4452	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)울산	2026-03-01	20	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4453	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)세종	2026-03-01	22	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4454	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)강원	2026-03-01	960	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4455	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충북	2026-03-01	1539	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4456	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)충남	2026-03-01	1702	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4457	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전북	2026-03-01	151	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4458	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)전남	2026-03-01	1832	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4459	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경북	2026-03-01	1553	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4460	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)경남	2026-03-01	2390	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4461	통계누리	대한민국	경제/산업	산업	건설	주택건설실적(착공)제주	2026-03-01	183	호	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4462	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-01-01	463	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4463	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-02-01	465	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4464	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-03-01	466	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4465	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-04-01	459	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4466	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-05-01	458	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4467	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-06-01	446	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4468	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-07-01	462	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4469	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-08-01	476	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4470	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-09-01	473	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4471	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-10-01	466	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4472	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-11-01	457	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4473	CRU	중국	가격	철강재	열연	중국열연현물가fob	2025-12-01	457	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4474	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-01-01	462	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4475	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-02-01	468	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4476	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-03-01	473	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4477	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-04-01	486	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4478	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-01-03	760	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4479	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-01-10	755	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4480	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-01-17	750	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4481	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-01-24	755	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4482	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-01-31	760	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4483	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-02-07	820	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4484	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-02-14	860	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4485	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-02-21	900	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4486	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-02-28	940	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4487	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-03-07	1000	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4488	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-03-14	1030	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4489	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-03-21	1050	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4490	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-03-28	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4491	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-04-04	1140	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4492	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-04-11	1155	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4493	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-04-18	1165	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4494	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-04-25	1171	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4495	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-05-02	1025	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4496	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-05-09	1010	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4497	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-05-16	1000	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4498	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-05-23	990	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4499	CRU	미국	가격	철강재	열연	미국열연현물가fob	2025-05-30	975	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4531	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-01-09	1035	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4532	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-01-16	1045	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4533	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-01-23	1055	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4534	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-01-30	1060	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4535	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-02-06	1050	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4536	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-02-13	1040	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4537	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-02-20	1030	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4538	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-02-27	1020	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4539	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-03-06	1035	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4540	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-03-13	1050	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4541	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-03-20	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4542	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-03-27	1100	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4543	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-04-03	1120	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4544	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-04-10	1140	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4545	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-04-17	1155	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4546	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-04-24	1171	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4547	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-01-01	520	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4548	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-02-01	535	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4549	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-03-01	550	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4550	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-04-01	550	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4551	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-05-01	550	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4552	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-06-01	550	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4553	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-07-01	545	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4554	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-08-01	565	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4555	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-09-01	535	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4556	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-10-01	510	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4557	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-11-01	485	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4558	CRU	일본	가격	철강재	열연	일본열연현물가fob	2025-12-01	475	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4559	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-01-01	498	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4560	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-02-01	510	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4561	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-03-01	510	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4562	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-04-01	498	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4563	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-05-01	503	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4564	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-06-01	504	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4565	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-07-01	500	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4566	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-08-01	530	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4567	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-09-01	518	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4568	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-10-01	510	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4569	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-11-01	491	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4570	CRU	중동_기타	가격	철강재	후판	중동후판현물가fob	2025-12-01	485	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4571	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-01-01	535	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4572	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-02-01	520	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4573	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-03-01	520	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4574	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-04-01	520	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4575	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-05-01	530	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4576	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-06-01	610	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4577	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-07-01	530	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4578	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-08-01	570	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4579	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-09-01	570	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4580	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-10-01	535	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4581	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-11-01	555	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4582	CRU	일본	가격	철강재	후판	일본후판현물가fob	2025-12-01	540	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4583	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-01-01	305	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4584	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-02-01	307	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4585	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-03-01	320	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4586	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-04-01	338	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4587	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-05-01	338	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4588	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-06-01	305	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4589	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-07-01	300	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4590	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-08-01	305	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4591	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-09-01	300	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4592	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-10-01	300	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4593	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-11-01	315	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4594	CRU	미국	가격	원자재	철스크랩	미국철스크랩현물가fob	2025-12-01	320	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4595	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-01-01	264.7	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4596	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-02-01	266.44	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4597	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-03-01	278.92	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4598	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-04-01	291	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4599	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-05-01	302	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4600	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-06-01	291	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4601	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-07-01	284	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4602	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-08-01	294	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4603	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-09-01	290	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4604	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-10-01	286	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4605	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-11-01	299	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4606	CRU	일본	가격	원자재	철스크랩	일본철스크랩현물가fob	2025-12-01	304	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4607	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-01-01	316	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4608	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-02-01	332	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4609	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-03-01	342	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4610	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-04-01	334	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4611	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-05-01	340	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4612	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-06-01	345	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4613	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-07-01	345	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4614	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-08-01	350	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4615	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-09-01	350	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4616	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-10-01	350	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4617	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-11-01	348	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4618	CRU	한국	가격	원자재	철스크랩	한국철스크랩현물가fob	2025-12-01	345	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4619	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-01-01	149	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4620	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-02-01	159	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4621	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-03-01	147	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4622	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-04-01	142	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4623	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-05-01	154	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4624	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-06-01	164	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4625	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-07-01	161	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4626	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-08-01	163	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4627	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-09-01	175	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4628	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-10-01	175	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4629	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-11-01	183	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4630	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2025-12-01	182	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4631	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2026-01-01	201	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4632	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2026-02-01	179	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4633	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2026-03-01	156	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4634	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2026-04-01	168	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4635	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-01-01	203	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4636	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-02-01	212	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4637	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-03-01	252	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4638	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-04-01	256	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4639	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-05-01	245	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4640	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-06-01	235	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4641	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-07-01	240	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4642	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-08-01	237	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4643	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-09-01	229	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4644	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-10-01	236	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4645	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-11-01	248	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4646	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2025-12-01	254	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4647	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2026-01-01	263	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4648	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2026-02-01	263	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4649	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2026-03-01	270	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4650	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2026-04-01	275	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4651	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-01-01	150	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4652	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-02-01	153	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4653	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-03-01	154	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4654	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-04-01	153	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4655	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-05-01	150	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4656	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-06-01	146	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4657	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-07-01	144	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4658	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-08-01	152	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4659	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-09-01	152	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4660	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-10-01	151	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4661	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-11-01	147	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4662	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2025-12-01	146	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4663	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2026-01-01	151	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4664	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2026-02-01	150	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4665	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2026-03-01	152	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4666	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2026-04-01	160	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4667	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-01-01	178	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4668	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-02-01	184	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4669	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-03-01	198	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4670	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-04-01	199	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4671	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-05-01	195	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4672	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-06-01	188	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4673	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-07-01	188	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4674	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-08-01	186	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4675	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-09-01	188	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4676	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-10-01	188	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4677	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-11-01	186	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4678	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2025-12-01	188	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4679	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2026-01-01	191	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4680	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2026-02-01	195	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4681	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2026-03-01	199	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4682	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2026-04-01	205	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4683	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-01-01	201	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4684	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-02-01	212	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4685	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-03-01	220	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4686	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-04-01	223	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4687	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-05-01	223	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4688	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-06-01	212	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4689	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-07-01	204	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4690	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-08-01	201	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4691	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-09-01	207	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4692	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-10-01	203	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4693	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-11-01	211	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4694	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2025-12-01	210	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4695	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2026-01-01	213	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4696	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2026-02-01	221	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4697	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2026-03-01	232	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4698	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2026-04-01	237	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
682	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-01-01	146	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
683	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-02-01	146	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
684	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-03-01	146	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
685	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-04-01	146	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
686	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-05-01	146	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
687	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-06-01	143	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
688	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-07-01	140	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
689	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-08-01	141	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
690	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-09-01	141	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
691	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-10-01	141	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
692	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-11-01	143	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
693	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2025-12-01	141	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
694	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2026-01-01	143	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
695	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2026-02-01	148	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
696	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2026-03-01	154	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
697	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2026-04-01	160	%	M	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4715	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-01-08	5.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4716	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-01-15	5.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4717	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-01-22	5.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4718	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-01-29	5.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4719	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-02-05	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4720	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-02-12	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4721	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-02-19	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4722	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-02-26	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4723	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-03-05	6.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4724	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-03-12	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4725	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-03-19	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4726	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-03-26	6.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4727	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-04-02	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4728	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-04-09	6.1	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4729	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-04-16	6.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4730	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-04-23	6.1	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4731	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-04-30	6.1	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4732	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-05-07	5.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4733	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-05-14	5.8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4734	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-05-21	5.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4735	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-05-28	5.8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4736	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-06-04	4.8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4737	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-06-11	4.8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4738	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-06-18	4.8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4739	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-06-25	4.8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4740	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-07-02	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4741	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-07-09	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4742	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-07-16	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4743	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-07-23	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4744	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-07-30	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4745	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-08-06	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4746	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-08-13	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4747	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-08-20	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4748	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-08-27	4.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4749	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-09-03	4.5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4750	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-09-10	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4751	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-09-17	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4752	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-09-24	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4753	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-10-01	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4754	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-10-08	4.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4755	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-10-15	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4756	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-10-22	5.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4757	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-10-29	5.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4758	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-11-05	5.2	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4759	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-11-12	6	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4760	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-11-19	6	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4761	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-11-26	6	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4762	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-12-03	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4763	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-12-10	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4764	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-12-17	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4765	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-12-24	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4766	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2025-12-31	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4767	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-01-07	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4768	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-01-14	5.9	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4769	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-01-21	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4770	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-01-28	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4771	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-02-04	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4772	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-02-11	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4773	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-02-18	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4774	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-02-25	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4775	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-03-04	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4776	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-03-11	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4777	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-03-18	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4778	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-03-25	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4779	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-04-01	6.4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4780	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-04-08	6.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4781	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-04-15	6.1	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4782	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-04-22	6.1	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4783	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-04-29	6.1	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4784	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-01-08	3.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4785	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-01-15	3.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4786	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-01-22	3.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4787	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-01-29	3.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4788	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-02-05	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4789	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-02-12	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4790	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-02-19	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4791	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-02-26	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4792	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-03-05	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4793	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-03-12	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4794	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-03-19	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4795	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-03-26	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4796	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-04-02	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4797	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-04-09	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4798	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-04-16	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4799	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-04-23	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4800	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-04-30	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4801	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-05-07	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4802	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-05-14	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4803	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-05-21	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4804	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-05-28	5.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4805	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-06-04	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4806	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-06-11	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4807	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-06-18	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4808	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-06-25	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4809	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-07-02	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4810	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-07-09	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4811	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-07-16	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4812	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-07-23	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4813	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-07-30	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4814	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-08-06	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4815	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-08-13	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4816	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-08-20	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4817	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-08-27	4.3	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4818	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-09-03	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4819	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-09-10	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4820	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-09-17	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4821	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-09-24	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4822	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-10-01	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4823	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-10-08	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4824	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-10-15	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4825	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-10-22	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4826	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-10-29	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4827	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-11-05	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4828	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-11-12	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4829	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-11-19	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4830	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-11-26	4	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4831	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-12-03	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4832	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-12-10	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4833	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-12-17	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4834	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-12-24	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4835	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2025-12-31	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4836	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-01-07	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4837	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-01-14	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4838	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-01-21	4.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4839	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-01-28	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4840	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-02-04	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4841	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-02-11	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4842	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-02-18	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4843	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-02-25	5	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4844	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-03-04	8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4845	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-03-11	8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4846	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-03-18	8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4847	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-03-25	8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4848	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-04-01	8	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4849	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-04-08	7.7	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4850	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-04-15	10	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4851	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-04-22	10	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4852	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-04-29	10	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
698	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-01-08	480	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
699	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-01-15	475	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
700	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-01-22	477	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
701	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-01-29	477	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
702	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-02-05	474	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
703	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-02-12	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
704	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-02-19	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
705	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-02-26	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
706	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-03-05	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
707	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-03-12	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
708	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-03-19	475	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
709	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-03-26	478	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
710	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-04-02	474	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
711	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-04-09	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
712	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-04-16	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
713	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-04-23	475	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
714	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-04-30	476	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
715	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-05-07	475	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
716	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-05-14	473	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
717	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-05-21	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
718	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-05-28	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
719	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-06-04	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
720	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-06-11	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
721	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-06-18	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
722	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-06-25	470	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
723	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-07-02	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
724	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-07-09	472	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
725	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-07-16	480	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
726	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-07-23	495	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
727	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-07-30	496	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
728	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-08-06	495	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
729	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-08-13	500	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
730	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-08-20	498	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
731	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-08-27	500	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
732	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-09-03	500	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
733	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-09-10	500	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
734	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-09-17	510	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
735	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-09-24	509	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
736	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-10-01	507	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
737	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-10-08	507	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
738	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-10-15	485	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
739	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-10-22	483	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
740	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-10-29	485	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
741	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-11-05	483	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
742	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-11-12	480	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
743	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-11-19	482	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
744	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-11-26	482	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
745	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-12-03	478	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
746	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-12-10	478	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
747	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-12-17	478	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
748	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-12-24	477	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
749	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2025-12-31	474	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
750	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-01-07	480	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
751	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-01-14	484	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
752	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-01-21	485	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
753	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-01-28	480	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
754	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-02-04	480	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
755	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-02-11	481	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
756	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-02-18	481	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
757	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-02-25	483	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
758	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-03-04	483	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
759	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-03-11	485	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
760	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-03-18	490	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
761	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-03-25	492	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
762	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-04-01	495	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
763	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-04-08	495	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
764	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-04-15	497	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
765	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-04-22	505	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
766	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-04-29	507	USD	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
767	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-01-01	12950	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
768	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-02-01	12800	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
769	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-03-01	12900	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
770	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-04-01	13600	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
771	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-05-01	13000	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
772	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-06-01	13000	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
773	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-07-01	12500	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
774	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-08-01	12600	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
775	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-09-01	12800	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
776	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-10-01	13200	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
777	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-11-01	13000	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
778	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2025-12-01	12650	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
779	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2026-01-01	12800	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
780	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2026-02-01	14300	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
781	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2026-03-01	14300	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
782	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2026-04-01	14500	CNY	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
4938	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-01-01	2904	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4939	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-02-01	2903	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4940	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-03-01	2894	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4941	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-04-01	2875	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4942	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-05-01	2691	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4943	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-06-01	2616	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4944	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-07-01	2562	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4945	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-08-01	2517	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4946	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-09-01	2552	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4947	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-10-01	2532	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4948	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-11-01	2561	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4949	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2025-12-01	2580	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4950	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2026-01-01	2535	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4951	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2026-02-01	2837	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4952	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2026-03-01	2862	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4953	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2026-04-01	2971	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4954	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-01-01	1140	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4955	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-02-01	1140	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4956	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-03-01	1180	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4957	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-04-01	1130	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4958	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-05-01	1080	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4959	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-06-01	1020	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4960	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-07-01	103	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4961	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-08-01	1040	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4962	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-09-01	1060	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4963	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-10-01	1060	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4964	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-11-01	1070	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4965	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2025-12-01	1080	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4966	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2026-01-01	1110	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4967	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2026-02-01	1120	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4968	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2026-03-01	1130	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4969	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2026-04-01	1190	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4970	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-01-01	1018	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4971	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-02-01	1032	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4972	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-03-01	1018	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4973	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-04-01	1008	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4974	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-05-01	973	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4975	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-06-01	950	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4976	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-07-01	947	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4977	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-08-01	952	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4978	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-09-01	969	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4979	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-10-01	954	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4980	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-11-01	967	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4981	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2025-12-01	986	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4982	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2026-01-01	1003	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4983	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2026-02-01	1007	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4984	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2026-03-01	1013	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4985	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2026-04-01	1048	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4986	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-01-01	92000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4987	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-02-01	92000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4988	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-03-01	92000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4989	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-04-01	89000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4990	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-05-01	89000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4991	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-06-01	89000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4992	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-07-01	89000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4993	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-08-01	89000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4994	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-09-01	89000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4995	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-10-01	86000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4996	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-11-01	86000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4997	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2025-12-01	86000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4998	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2026-01-01	86000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
4999	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2026-02-01	86000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5000	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2026-03-01	86000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5001	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2026-04-01	93000	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
783	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-01-08	79	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
784	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-01-15	79	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
785	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-01-22	79	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
786	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-01-29	79	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
787	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-02-05	79	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
788	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-02-12	81	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
789	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-02-19	84	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
790	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-02-26	84	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
791	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-03-05	85	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
792	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-03-12	86	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
793	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-03-19	86	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
794	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-03-26	88	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
795	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-04-02	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
796	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-04-09	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
797	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-04-16	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
798	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-04-23	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
799	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-04-30	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
800	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-05-07	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
801	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-05-14	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
802	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-05-21	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
803	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-05-28	89	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
804	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-06-04	88	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
805	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-06-11	88	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
806	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-06-18	88	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
807	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-06-25	88	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
808	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-07-02	89	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
809	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-07-09	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
810	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-07-16	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
811	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-07-23	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
812	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-07-30	90	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
813	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-08-06	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
814	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-08-13	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
815	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-08-20	92	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
816	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-08-27	93.5	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
817	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-09-03	95	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
818	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-09-10	95	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
819	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-09-17	96	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
820	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-09-24	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
821	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-10-01	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
822	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-10-08	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
823	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-10-15	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
824	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-10-22	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
825	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-10-29	96	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
826	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-11-05	93	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
827	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-11-12	91	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
828	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-11-19	92	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
829	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-11-26	93	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
830	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-12-03	92	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
831	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-12-10	92	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
832	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-12-17	93	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
833	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-12-24	93	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
834	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2025-12-31	93	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
835	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-01-07	95	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
836	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-01-14	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
837	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-01-21	98	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
838	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-01-28	100	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
839	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-02-04	99	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
840	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-02-11	101	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
841	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-02-18	101	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
842	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-02-25	101	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
843	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-03-04	100	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
844	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-03-11	100	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
845	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-03-18	98	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
846	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-03-25	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
847	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-04-01	98	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
848	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-04-08	97	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
849	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-04-15	96	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
850	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-04-22	96	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
851	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-04-29	96	USC	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
5071	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-01-08	1155	USC	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5072	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-01-15	1155	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5073	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-01-22	1150	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5074	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-01-29	1150	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5075	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-02-05	1145	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5076	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-02-12	1145	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5077	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-02-19	1145	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5078	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-02-26	1145	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5079	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-03-05	1135	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5080	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-03-12	1105	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5081	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-03-19	1105	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5082	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-03-26	1105	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5083	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-04-02	1105	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5084	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-04-09	1110	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5085	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-04-16	1120	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5086	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-04-23	1120	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5087	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-04-30	1110	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5088	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-05-07	1105	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5089	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-05-14	1100	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5090	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-05-21	1090	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5091	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-05-28	1080	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5092	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-06-04	1090	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5093	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-06-11	1075	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5094	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-06-18	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5095	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-06-25	1040	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5096	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-07-02	1040	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5097	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-07-09	1055	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5098	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-07-16	1055	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5099	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-07-23	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5100	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-07-30	1085	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5101	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-08-06	1085	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5102	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-08-13	1085	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5103	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-08-20	1085	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5104	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-08-27	1077	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5105	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-09-03	1075	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5106	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-09-10	1075	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5107	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-09-17	1075	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5108	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-09-24	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5109	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-10-01	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5110	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-10-08	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5111	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-10-15	1060	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5112	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-10-22	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5113	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-10-29	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5114	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-11-05	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5115	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-11-12	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5116	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-11-19	1065	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5117	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-11-26	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5118	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-12-03	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5119	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-12-10	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5120	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-12-17	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5121	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-12-24	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5122	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2025-12-31	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5123	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-01-07	1070	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5124	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-01-14	1090	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5125	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-01-21	1090	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5126	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-01-28	1100	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5127	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-02-04	1110	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5128	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-02-11	1115	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5129	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-02-18	1115	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5130	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-02-25	1125	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5131	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-03-04	1135	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5132	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-03-11	1140	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5133	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-03-18	1150	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5134	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-03-25	1150	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5135	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-04-01	1155	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5136	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-04-08	1185	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5137	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-04-15	1190	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5138	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-04-22	1190	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5139	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-04-29	1185	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5140	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-01-01	114	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5141	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-02-01	117	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5142	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-03-01	119	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5143	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-04-01	117	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5144	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-05-01	113	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5145	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-06-01	113	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5146	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-07-01	110	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5147	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-08-01	113	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5148	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-09-01	116	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5149	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-10-01	115	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5150	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-11-01	110	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5151	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2025-12-01	111	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5152	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2026-01-01	126	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5153	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2026-02-01	131	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5154	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2026-03-01	138	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5155	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2026-04-01	139	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
852	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-01-08	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
853	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-01-15	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
854	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-01-22	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
855	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-01-29	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
856	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-02-05	94	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
857	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-02-12	96	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
858	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-02-19	91	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
859	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-02-26	94	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
860	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-03-05	91	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
861	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-03-12	88	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
862	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-03-19	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
863	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-03-26	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
864	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-04-02	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
865	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-04-09	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
866	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-04-16	86	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
867	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-04-23	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
868	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-04-30	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
869	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-05-07	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
870	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-05-14	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
871	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-05-21	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
872	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-05-28	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
873	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-06-04	75	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
874	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-06-11	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
875	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-06-18	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
876	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-06-25	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
877	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-07-09	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
878	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-07-16	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
879	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-07-23	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
880	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-07-30	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
881	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-08-06	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
882	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-08-13	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
883	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-08-20	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
884	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-08-27	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
885	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-09-03	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
886	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-09-10	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
887	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-09-17	80	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
888	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-09-24	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
889	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-10-01	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
890	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-10-08	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
891	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-10-15	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
892	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-10-22	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
893	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-10-29	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
894	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-11-05	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
895	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-11-12	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
896	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-11-19	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
897	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-11-26	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
898	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-12-03	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
899	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-12-10	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
900	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-12-17	80	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
901	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-12-24	80	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
902	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2025-12-31	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
903	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-01-07	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
904	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-01-14	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
905	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-01-21	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
906	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-01-28	77	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
907	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-02-04	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
908	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-02-11	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
909	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-02-18	93	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
910	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-02-25	94	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
911	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-03-04	90	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
912	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-03-11	89	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
913	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-03-18	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
914	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-03-25	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
915	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-04-01	80	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
916	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-04-08	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
917	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-04-15	80	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
918	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-04-22	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
919	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-04-29	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
920	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-01-08	74	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
921	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-01-15	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
922	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-01-22	74	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
923	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-01-29	76	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
924	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-02-05	88	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
925	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-02-12	89	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
926	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-02-19	89	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
927	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-02-26	87	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
928	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-03-05	86	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
929	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-03-12	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
930	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-03-19	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
931	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-03-26	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
932	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-04-02	86	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
933	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-04-09	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
934	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-04-16	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
935	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-04-23	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
936	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-04-30	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
937	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-05-07	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
938	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-05-14	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
939	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-05-21	87	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
940	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-05-28	86	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
941	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-06-04	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
942	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-06-11	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
943	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-06-18	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
944	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-06-25	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
945	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-07-02	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
946	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-07-09	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
947	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-07-16	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
948	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-07-23	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
949	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-07-30	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
950	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-08-06	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
951	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-08-13	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
952	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-08-20	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
953	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-08-27	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
954	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-09-03	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
955	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-09-10	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
956	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-09-17	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
957	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-09-24	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
958	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-10-01	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
959	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-10-08	87	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
960	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-10-15	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
961	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-10-22	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
962	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-10-29	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
963	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-11-05	84	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
964	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-11-12	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
965	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-11-19	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
966	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-11-26	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
967	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-12-03	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
968	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-12-10	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
969	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-12-17	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
970	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-12-24	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
971	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2025-12-31	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
972	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-01-07	81	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
973	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-01-14	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
974	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-01-21	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
975	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-01-28	82	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
976	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-02-04	78	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
977	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-02-11	79	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
978	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-02-18	92	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
979	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-02-25	93	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
980	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-03-04	87	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
981	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-03-11	89	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
982	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-03-18	89	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
983	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-03-25	88	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
984	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-04-01	88	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
985	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-04-08	86	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
986	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-04-15	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
987	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-04-22	83	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
988	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-04-29	85	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
5293	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-01-08	302	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5294	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-01-15	303	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5295	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-01-22	320	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5296	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-01-29	322	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5297	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-02-05	323	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5298	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-02-12	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5299	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-02-19	328	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5300	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-02-26	327	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5301	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-03-05	323	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5302	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-03-12	311	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5303	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-03-19	318	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5304	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-03-26	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5305	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-04-02	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5306	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-04-09	322	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5307	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-04-16	313	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5308	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-04-23	314	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5309	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-04-30	317	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5310	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-05-07	319	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5311	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-05-14	320	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5312	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-05-21	311	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5313	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-05-28	305	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5314	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-06-04	319	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5315	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-06-11	328	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5316	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-06-18	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5317	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-06-25	325	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5318	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-07-02	327	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5319	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-07-09	328	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5320	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-07-16	323	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5321	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-07-23	321	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5322	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-07-30	317	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5323	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-08-06	322	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5324	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-08-13	314	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5325	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-08-20	315	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5326	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-08-27	325	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5327	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-09-03	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5328	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-09-10	314	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5329	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-09-17	325	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5330	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-09-24	326	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5331	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-10-01	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5332	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-10-08	324	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5333	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-10-15	323	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5334	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-10-22	321	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5335	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-10-29	322	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5336	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-11-05	323	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5337	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-11-12	318	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5338	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-11-19	313	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5339	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-11-26	316	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5340	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-12-03	319	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5341	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-12-10	314	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5342	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-12-17	308	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5343	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-12-24	291	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5344	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2025-12-31	293	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5345	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-01-07	304	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5346	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-01-14	305	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5347	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-01-21	308	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5348	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-01-28	305	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5349	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-02-04	309	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5350	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-02-11	309	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5351	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-02-18	307	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5352	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-02-25	309	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5353	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-03-04	309	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5354	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-03-11	301	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5355	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-03-18	295	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5356	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-03-25	300	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5357	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-04-01	305	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5358	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-04-08	306	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5359	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-04-15	301	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5360	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-04-22	302	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5361	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-04-29	305	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
989	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-01-08	152	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
990	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-01-15	151	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
991	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-01-22	150	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
992	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-01-29	153	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
993	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-02-05	150	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
994	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-02-12	149	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
995	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-02-19	149	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
996	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-02-26	153	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
997	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-03-05	155	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
998	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-03-12	145	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
999	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-03-19	144	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1000	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-03-26	150	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1001	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-04-02	151	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1002	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-04-09	155	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1003	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-04-16	154	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1004	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-04-23	156	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1005	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-04-30	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1006	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-05-07	159	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1007	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-05-14	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1008	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-05-21	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1009	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-05-28	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1010	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-06-04	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1011	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-06-11	157	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1012	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-06-18	161	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1013	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-06-25	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1014	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-07-02	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1015	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-07-09	164	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1016	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-07-16	165	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1017	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-07-23	165	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1018	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-07-30	164	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1019	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-08-06	166	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1020	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-08-13	167	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1021	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-08-20	165	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1022	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-08-27	156	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1023	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-09-03	150	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1024	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-09-10	152	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1025	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-09-17	157	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1026	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-09-24	159	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1027	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-10-01	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1028	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-10-08	161	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1029	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-10-15	161	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1030	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-10-22	163	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1031	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-10-29	159	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1032	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-11-05	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1033	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-11-12	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1034	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-11-19	163	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1035	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-11-26	159	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1036	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-12-03	157	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1037	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-12-10	163	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1038	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-12-17	160	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1039	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-12-24	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1040	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2025-12-31	151	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1041	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-01-07	149	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1042	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-01-14	157	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1043	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-01-21	158	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1044	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-01-28	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1045	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-02-04	162	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1046	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-02-11	159	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1047	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-02-18	164	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1048	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-02-25	166	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1049	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-03-04	163	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1050	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-03-11	164	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1051	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-03-18	166	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1052	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-03-25	163	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1053	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-04-01	164	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1054	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-04-08	169	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1055	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-04-15	168	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1056	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-04-22	168	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1057	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-04-29	169	10Kt	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1058	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-01-08	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1059	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-01-15	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1060	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-01-22	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1061	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-01-29	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1062	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-02-05	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1063	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-02-12	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1064	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-02-19	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1065	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-02-26	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1066	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-03-05	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1067	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-03-12	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1068	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-03-19	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1069	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-03-26	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1070	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-04-02	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1071	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-04-09	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1072	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-04-16	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1073	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-04-23	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1074	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-04-30	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1075	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-05-07	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1076	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-05-14	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1077	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-05-21	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1078	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-05-28	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1079	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-06-04	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1080	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-06-11	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1081	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-06-18	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1082	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-06-25	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1083	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-07-02	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1084	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-07-09	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1085	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-07-16	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1086	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-07-23	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1087	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-07-30	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1088	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-08-06	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1089	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-08-13	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1090	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-08-20	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1091	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-08-27	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1092	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-09-03	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1093	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-09-10	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1094	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-09-17	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1095	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-09-24	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1096	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-10-01	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1097	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-10-08	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1098	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-10-15	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1099	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-10-22	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1100	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-10-29	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1101	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-11-05	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1102	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-11-12	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1103	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-11-19	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1104	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-11-26	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1105	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-12-03	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1106	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-12-10	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1107	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-12-17	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1108	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-12-24	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1109	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2025-12-31	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1110	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-01-07	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1111	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-01-14	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1112	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-01-21	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1113	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-01-28	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1114	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-02-04	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1115	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-02-11	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1116	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-02-18	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1117	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-02-25	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1118	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-03-04	77	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1119	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-03-11	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1120	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-03-18	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1121	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-03-25	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1122	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-04-01	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1123	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-04-08	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1124	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-04-15	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1125	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-04-22	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1126	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-04-29	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1127	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-01-08	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1128	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-01-15	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1129	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-01-22	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1130	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-01-29	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1131	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-02-05	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1132	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-02-12	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1133	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-02-19	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1134	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-02-26	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1135	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-03-05	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1136	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-03-12	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1137	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-03-19	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1138	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-03-26	82	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1139	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-04-02	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1140	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-04-09	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1141	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-04-16	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1142	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-04-23	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1143	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-04-30	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1144	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-05-07	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1145	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-05-14	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1146	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-05-21	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1147	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-05-28	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1148	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-06-04	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1149	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-06-11	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1150	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-06-18	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1151	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-06-25	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1152	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-07-02	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1153	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-07-09	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1154	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-07-16	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1155	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-07-23	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1156	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-07-30	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1157	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-08-06	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1158	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-08-13	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1159	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-08-20	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1160	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-08-27	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1161	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-09-03	76	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1162	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-09-10	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1163	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-09-17	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1164	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-09-24	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1165	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-10-01	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1166	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-10-08	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1167	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-10-15	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1168	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-10-22	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1169	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-10-29	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1170	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-11-05	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1171	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-11-12	76	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1172	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-11-19	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1173	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-11-26	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1174	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-12-03	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1175	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-12-10	75	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1176	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-12-17	75	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1177	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-12-24	76	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1178	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2025-12-31	76	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1179	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-01-07	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1180	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-01-14	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1181	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-01-21	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1182	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-01-28	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1183	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-02-04	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1184	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-02-11	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1185	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-02-18	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1186	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-02-25	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1187	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-03-04	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1188	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-03-11	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1189	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-03-18	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1190	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-03-25	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1191	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-04-01	76	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1192	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-04-08	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1193	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-04-15	78	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1194	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-04-22	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1195	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-04-29	79	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1196	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-01-08	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1197	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-01-15	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1198	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-01-22	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1199	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-01-29	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1200	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-02-05	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1201	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-02-12	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1202	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-02-19	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1203	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-02-26	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1204	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-03-05	86	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1205	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-03-12	84	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1206	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-03-19	86	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1207	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-03-26	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1208	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-04-02	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1209	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-04-09	89	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1210	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-04-16	89	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1211	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-04-23	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1212	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-04-30	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1213	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-05-07	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1214	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-05-14	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1215	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-05-21	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1216	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-05-28	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1217	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-06-04	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1218	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-06-11	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1219	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-06-18	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1220	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-06-25	94	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1221	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-07-02	94	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1222	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-07-09	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1223	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-07-16	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1224	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-07-23	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1225	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-07-30	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1226	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-08-06	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1227	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-08-13	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1228	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-08-20	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1229	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-08-27	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1230	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-09-03	93	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1231	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-09-10	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1232	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-09-17	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1233	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-09-24	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1234	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-10-01	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1235	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-10-08	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1236	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-10-15	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1237	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-10-22	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1238	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-10-29	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1239	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-11-05	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1240	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-11-12	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1241	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-11-19	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1242	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-11-26	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1243	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-12-03	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1244	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-12-10	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1245	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-12-17	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1246	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-12-24	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1247	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2025-12-31	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1248	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-01-07	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1249	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-01-14	83	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1250	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-01-21	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1251	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-01-28	80	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1252	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-02-04	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1253	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-02-11	81	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1254	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-02-18	85	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1255	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-02-25	85	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1256	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-03-04	85	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1257	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-03-11	90	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1258	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-03-18	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1259	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-03-25	88	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1260	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-04-01	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1261	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-04-08	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1262	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-04-15	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1263	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-04-22	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1264	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-04-29	91	%	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
5638	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-02	2.282	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5639	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-07	2.253	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5640	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-08	2.281	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5641	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-09	2.331	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5642	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-12	2.33	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5643	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-13	2.37	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5644	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-14	2.351	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5645	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-15	2.362	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5646	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-16	2.319	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5647	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-19	2.366	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5648	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-20	2.33	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5649	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-21	2.345	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5650	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-22	2.336	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5651	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-23	2.338	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5652	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-26	2.348	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5653	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-27	2.34	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5654	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-28	2.314	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5655	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-29	2.341	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5656	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-05-30	2.347	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5657	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-02	2.34	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5658	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-04	2.414	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5659	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-05	2.412	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5660	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-09	2.405	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5661	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-10	2.385	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5662	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-11	2.419	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5663	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-12	2.429	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5664	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-13	2.462	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5665	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-16	2.483	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5666	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-17	2.448	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5667	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-18	2.472	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5668	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-19	2.475	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5669	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-20	2.463	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5670	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-23	2.498	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5671	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-24	2.461	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5672	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-25	2.46	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5673	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-26	2.454	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5674	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-27	2.453	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5675	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-06-30	2.452	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5676	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-01	2.454	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5677	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-02	2.483	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5678	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-03	2.449	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5679	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-04	2.467	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5680	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-07	2.482	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5681	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-08	2.477	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5682	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-09	2.478	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5683	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-10	2.433	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5684	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-11	2.448	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5685	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-14	2.474	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5686	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-15	2.463	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5687	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-16	2.459	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5688	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-17	2.479	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5689	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-18	2.474	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5690	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-21	2.456	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5691	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-22	2.463	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5692	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-23	2.458	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5693	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-24	2.467	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5694	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-25	2.485	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5695	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-28	2.464	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5696	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-29	2.46	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5697	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-30	2.454	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5698	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-07-31	2.46	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5699	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-01	2.478	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5700	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-04	2.421	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5701	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-05	2.425	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5702	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-06	2.43	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5703	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-07	2.408	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5704	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-08	2.409	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5705	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-11	2.42	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5706	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-12	2.431	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5707	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-13	2.417	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5708	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-14	2.404	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5709	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-18	2.426	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5710	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-19	2.444	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5711	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-20	2.441	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5712	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-21	2.438	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5713	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-22	2.456	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5714	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-25	2.434	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5715	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-26	2.422	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5716	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-27	2.402	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5717	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-28	2.416	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5718	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-08-29	2.426	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5719	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-01	2.435	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5720	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-02	2.45	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5721	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-03	2.475	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5722	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-04	2.472	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5723	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-05	2.46	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5724	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-08	2.448	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5725	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-09	2.425	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5726	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-10	2.43	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5727	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-11	2.42	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5728	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-12	2.431	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5729	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-15	2.443	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5730	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-16	2.417	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5731	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-17	2.418	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5732	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-18	2.403	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5733	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-19	2.441	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5734	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-22	2.459	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5735	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-23	2.46	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5736	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-24	2.489	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5737	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-25	2.528	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5738	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-26	2.562	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5739	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-29	2.563	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5740	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-09-30	2.582	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5741	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-01	2.596	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5742	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-02	2.581	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5743	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-10	2.591	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5744	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-13	2.554	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5745	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-14	2.533	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5746	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-15	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5747	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-16	2.569	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5748	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-17	2.555	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5749	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-20	2.569	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5750	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-21	2.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5751	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-22	2.572	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5752	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-23	2.605	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5753	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-24	2.591	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5754	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-27	2.62	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5755	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-28	2.633	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5756	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-29	2.677	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5757	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-30	2.732	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5758	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-10-31	2.716	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5759	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-03	2.741	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5760	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-04	2.729	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5761	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-05	2.767	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5762	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-06	2.834	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5763	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-07	2.894	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5764	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-10	2.865	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5765	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-11	2.831	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5766	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-12	2.923	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5767	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-13	2.932	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5768	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-14	2.944	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5769	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-17	2.914	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5770	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-18	2.872	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5771	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-19	2.869	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5772	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-20	2.908	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5773	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-21	2.872	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5774	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-24	2.904	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5775	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-25	2.902	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5776	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-26	2.895	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5777	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-27	3.013	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5778	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-11-28	2.991	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5779	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-01	3.045	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5780	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-02	3.022	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5781	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-03	3.041	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5782	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-04	3.025	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5783	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-05	2.994	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5784	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-08	3.034	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5785	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-09	3.084	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5786	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-10	3.095	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5787	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-11	3.101	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5788	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-12	3.093	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5789	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-15	3	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5790	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-16	2.999	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5791	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-17	2.996	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5792	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-18	2.967	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5793	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-19	3.01	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5794	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-22	2.999	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5795	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-23	2.963	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5796	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-24	2.939	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5797	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-26	2.958	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5798	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-29	2.939	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5799	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-30	2.952	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5800	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2025-12-31	2.953	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5801	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-02	2.935	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5802	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-05	2.933	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5803	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-06	2.948	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5804	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-07	2.91	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5805	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-08	2.902	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5806	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-09	2.942	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5807	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-12	2.98	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5808	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-13	3.003	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5809	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-14	2.996	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5810	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-15	3.09	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5811	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-16	3.08	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5812	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-19	3.13	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5813	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-20	3.191	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5814	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-21	3.138	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5815	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-22	3.109	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5816	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-23	3.137	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5817	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-26	3.096	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5818	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-27	3.094	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5819	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-28	3.067	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5820	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-29	3.106	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5821	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-01-30	3.138	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5822	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-02	3.152	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5823	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-03	3.189	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5824	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-04	3.212	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5825	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-05	3.204	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5826	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-06	3.233	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5827	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-09	3.267	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5828	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-10	3.224	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5829	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-11	3.2	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5830	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-12	3.154	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5831	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-13	3.142	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5832	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-19	3.178	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5833	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-20	3.143	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5834	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-23	3.154	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5835	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-24	3.158	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5836	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-25	3.124	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5837	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-26	3.062	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5838	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-02-27	3.041	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5839	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-03	3.18	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5840	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-04	3.223	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5841	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-05	3.189	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5842	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-06	3.227	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5843	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-09	3.42	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5844	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-10	3.283	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5845	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-11	3.253	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5846	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-12	3.271	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5847	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-13	3.338	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5848	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-16	3.3	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5849	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-17	3.324	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5850	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-18	3.261	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5851	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-19	3.329	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5852	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-20	3.41	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5853	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-23	3.617	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5854	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-24	3.523	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5855	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-25	3.558	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5856	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-26	3.552	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5857	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-27	3.582	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5858	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-30	3.542	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5859	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-03-31	3.552	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5860	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-01	3.37	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5861	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-02	3.477	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5862	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-03	3.448	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5863	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-06	3.432	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5864	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-07	3.451	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5865	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-08	3.315	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5866	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-09	3.338	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5867	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-10	3.36	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5868	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-13	3.382	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5869	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-14	3.339	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5870	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-15	3.328	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5871	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-16	3.34	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5872	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-17	3.371	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5873	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-20	3.348	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5874	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-21	3.33	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5875	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-22	3.365	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5876	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-23	3.458	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5877	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-24	3.496	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5878	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-27	3.492	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5879	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-04-28	3.529	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5880	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-02	2.872	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5881	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-07	2.846	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5882	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-08	2.867	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5883	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-09	2.91	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5884	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-12	2.91	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5885	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-13	2.939	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5886	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-14	2.924	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5887	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-15	2.931	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5888	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-16	2.896	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5889	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-19	2.935	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5890	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-20	2.907	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5891	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-21	2.921	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5892	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-22	2.917	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5893	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-23	2.921	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5894	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-26	2.926	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5895	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-27	2.913	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5896	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-28	2.893	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5897	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-29	2.914	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5898	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-05-30	2.917	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5899	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-02	2.916	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5900	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-04	2.982	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5901	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-05	2.973	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5902	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-09	2.96	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5903	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-10	2.955	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5904	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-11	2.974	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5905	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-12	2.972	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5906	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-13	2.997	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5907	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-16	3.016	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5908	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-17	2.986	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5909	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-18	3	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5910	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-19	3.005	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5911	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-20	2.996	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5912	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-23	3.019	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5913	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-24	2.983	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5914	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-25	2.981	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6151	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-18	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5915	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-26	2.969	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5916	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-27	2.967	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5917	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-06-30	2.963	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5918	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-01	2.959	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5919	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-02	2.981	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5920	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-03	2.952	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5921	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-04	2.965	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5922	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-07	2.973	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5923	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-08	2.968	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5924	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-09	2.967	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5925	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-10	2.928	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5926	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-11	2.938	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5927	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-14	2.959	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5928	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-15	2.953	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5929	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-16	2.95	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5930	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-17	2.968	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5931	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-18	2.961	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5932	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-21	2.948	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5933	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-22	2.952	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5934	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-23	2.95	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5935	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-24	2.96	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5936	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-25	2.974	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5937	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-28	2.958	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5938	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-29	2.952	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5939	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-30	2.946	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5940	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-07-31	2.952	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5941	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-01	2.97	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5942	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-04	2.917	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5943	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-05	2.917	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5944	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-06	2.918	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5945	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-07	2.901	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5946	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-08	2.902	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5947	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-11	2.909	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5948	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-12	2.917	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5949	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-13	2.907	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5950	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-14	2.896	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5951	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-18	2.912	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5952	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-19	2.924	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5953	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-20	2.923	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5954	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-21	2.921	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5955	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-22	2.932	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5956	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-25	2.915	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5957	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-26	2.902	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5958	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-27	2.887	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5959	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-28	2.898	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5960	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-08-29	2.906	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5961	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-01	2.913	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5962	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-02	2.924	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5963	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-03	2.946	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5964	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-04	2.943	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5965	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-05	2.931	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5966	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-08	2.918	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5967	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-09	2.898	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5968	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-10	2.902	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5969	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-11	2.892	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5970	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-12	2.901	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5971	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-15	2.909	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5972	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-16	2.885	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5973	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-17	2.881	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5974	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-18	2.868	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5975	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-19	2.898	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5976	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-22	2.912	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5977	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-23	2.912	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5978	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-24	2.935	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5979	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-25	2.969	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5980	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-26	3.001	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5981	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-29	3.004	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5982	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-09-30	3.022	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5983	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-01	3.033	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5984	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-02	3.019	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5985	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-10	3.026	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5986	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-13	2.995	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5987	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-14	2.975	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5988	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-15	2.966	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5989	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-16	3.004	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5990	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-17	2.99	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5991	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-20	3.004	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5992	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-21	3.024	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5993	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-22	2.999	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5994	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-23	3.027	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5995	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-24	3.013	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5996	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-27	3.036	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5997	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-28	3.047	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5998	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-29	3.085	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
5999	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-30	3.135	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6000	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-10-31	3.122	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6001	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-03	3.147	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6002	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-04	3.136	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6003	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-05	3.169	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6004	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-06	3.232	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6005	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-07	3.286	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6006	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-10	3.261	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6007	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-11	3.236	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6008	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-12	3.331	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6009	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-13	3.345	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6010	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-14	3.365	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6011	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-17	3.342	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6012	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-18	3.309	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6013	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-19	3.308	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6014	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-20	3.34	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6015	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-21	3.308	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6016	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-24	3.338	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6017	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-25	3.334	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6018	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-26	3.328	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6019	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-27	3.446	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6020	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-11-28	3.428	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6021	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-01	3.481	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6022	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-02	3.463	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6023	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-03	3.484	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6024	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-04	3.474	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6025	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-05	3.453	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6026	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-08	3.492	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6027	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-09	3.545	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6028	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-10	3.574	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6029	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-11	3.585	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6030	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-12	3.582	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6031	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-15	3.499	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6032	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-16	3.507	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6033	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-17	3.507	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6034	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-18	3.484	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6035	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-19	3.523	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6036	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-22	3.513	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6037	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-23	3.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6038	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-24	3.475	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6039	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-26	3.489	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6040	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-29	3.47	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6041	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-30	3.476	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6042	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2025-12-31	3.476	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6043	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-02	3.459	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6044	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-05	3.457	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6045	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-06	3.46	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6046	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-07	3.423	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6047	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-08	3.418	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6048	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-09	3.445	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6049	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-12	3.469	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6050	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-13	3.486	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6051	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-14	3.481	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6052	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-15	3.565	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6053	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-16	3.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6054	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-19	3.599	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6055	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-20	3.653	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6056	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-21	3.624	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6057	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-22	3.615	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6058	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-23	3.644	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6059	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-26	3.611	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6060	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-27	3.607	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6061	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-28	3.589	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6062	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-29	3.626	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6063	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-01-30	3.658	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6064	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-02	3.668	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6065	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-03	3.708	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6066	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-04	3.731	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6067	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-05	3.724	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6068	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-06	3.755	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6069	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-09	3.787	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6070	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-10	3.759	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6071	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-11	3.746	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6072	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-12	3.716	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6073	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-13	3.705	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6074	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-19	3.735	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6075	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-20	3.718	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6076	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-23	3.725	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6077	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-24	3.73	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6078	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-25	3.705	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6079	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-26	3.653	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6080	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-02-27	3.637	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6081	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-03	3.769	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6082	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-04	3.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6083	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-05	3.777	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6084	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-06	3.815	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6085	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-09	3.997	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6086	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-10	3.874	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6087	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-11	3.845	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6088	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-12	3.866	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6089	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-13	3.919	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6090	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-16	3.887	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6091	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-17	3.906	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6092	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-18	3.855	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6093	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-19	3.915	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6094	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-20	3.991	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6095	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-23	4.197	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6096	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-24	4.121	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6097	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-25	4.158	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6098	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-26	4.156	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6099	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-27	4.182	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6100	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-30	4.157	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6101	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-03-31	4.166	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6102	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-01	4.011	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6103	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-02	4.114	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6104	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-03	4.093	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6105	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-06	4.081	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6106	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-07	4.107	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6107	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-08	3.973	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6108	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-09	3.999	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6109	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-10	4.018	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6110	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-13	4.043	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6111	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-14	4.005	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6112	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-15	3.995	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6113	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-16	4.005	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6114	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-17	4.037	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6115	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-20	4.016	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6116	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-21	3.994	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6117	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-22	4.028	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6118	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-23	4.107	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6119	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-24	4.145	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6120	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-27	4.147	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6121	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-04-28	4.182	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6122	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-02	2.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6123	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-07	2.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6124	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-08	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6125	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-09	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6126	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-12	2.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6127	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-13	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6128	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-14	2.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6129	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-15	2.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6130	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-16	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6131	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-19	2.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6132	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-20	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6133	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-21	2.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6134	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-22	2.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6135	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-23	2.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6136	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-26	2.67	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6137	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-27	2.66	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6138	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-28	2.63	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6139	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-29	2.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6140	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-05-30	2.59	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6141	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-02	2.59	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6142	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-04	2.58	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6143	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-05	2.58	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6144	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-09	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6145	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-10	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6146	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-11	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6147	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-12	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6148	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-13	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6149	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-16	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6150	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-17	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6152	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-19	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6153	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-20	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6154	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-23	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6155	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-24	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6156	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-25	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6157	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-26	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6158	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-27	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6159	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-06-30	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6160	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-01	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6161	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-02	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6162	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-03	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6163	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-04	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6164	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-07	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6165	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-08	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6166	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-09	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6167	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-10	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6168	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-11	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6169	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-14	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6170	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-15	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6171	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-16	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6172	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-17	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6173	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-18	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6174	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-21	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6175	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-22	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6176	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-23	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6177	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-24	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6178	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-25	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6179	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-28	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6180	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-29	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6181	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-30	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6182	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-07-31	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6183	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-01	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6184	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-04	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6185	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-05	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6186	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-06	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6187	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-07	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6188	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-08	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6189	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-11	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6190	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-12	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6191	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-13	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6192	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-14	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6193	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-18	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6194	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-19	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6195	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-20	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6196	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-21	2.52	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6197	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-22	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6198	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-25	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6199	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-26	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6200	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-27	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6201	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-28	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6202	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-08-29	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6203	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-01	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6204	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-02	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6205	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-03	2.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6206	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-04	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6207	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-05	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6208	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-08	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6209	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-09	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6210	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-10	2.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6211	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-11	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6212	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-12	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6213	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-15	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6214	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-16	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6215	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-17	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6216	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-18	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6217	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-19	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6218	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-22	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6219	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-23	2.58	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6220	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-24	2.58	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6221	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-25	2.59	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6222	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-26	2.58	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6223	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-29	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6224	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-09-30	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6225	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-01	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6226	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-02	2.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6227	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-10	2.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6228	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-13	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6229	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-14	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6230	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-15	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6231	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-16	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6232	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-17	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6233	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-20	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6234	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-21	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6235	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-22	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6236	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-23	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6237	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-24	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6238	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-27	2.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6239	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-28	2.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6240	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-29	2.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6241	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-30	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6242	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-10-31	2.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6243	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-03	2.56	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6244	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-04	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6245	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-05	2.57	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6246	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-06	2.58	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6247	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-07	2.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6248	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-10	2.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6249	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-11	2.6	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6250	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-12	2.61	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6251	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-13	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6252	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-14	2.72	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6253	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-17	2.74	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6254	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-18	2.74	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6255	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-19	2.75	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6256	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-20	2.76	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6257	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-21	2.76	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6258	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-24	2.76	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6259	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-25	2.76	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6260	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-26	2.76	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6261	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-27	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6262	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-11-28	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6263	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-01	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6264	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-02	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6265	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-03	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6266	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-04	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6267	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-05	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6268	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-08	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6269	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-09	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6270	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-10	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6271	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-11	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6272	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-12	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6273	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-15	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6274	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-16	2.84	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6275	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-17	2.84	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6276	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-18	2.84	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6277	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-19	2.85	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6278	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-22	2.85	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6279	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-23	2.85	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6280	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-24	2.86	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6281	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-26	2.87	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6282	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-29	2.87	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6283	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-30	2.87	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6284	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2025-12-31	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6285	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-02	2.77	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6286	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-05	2.76	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6287	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-06	2.75	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6288	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-07	2.72	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6289	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-08	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6290	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-09	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6291	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-12	2.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6292	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-13	2.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6293	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-14	2.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6294	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-15	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6295	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-16	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6296	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-19	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6297	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-20	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6298	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-21	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6299	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-22	2.68	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6300	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-23	2.69	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6301	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-26	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6302	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-27	2.71	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6303	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-28	2.7	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6304	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-29	2.72	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6305	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-01-30	2.73	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6306	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-02	2.74	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6307	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-03	2.74	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6308	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-04	2.75	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6309	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-05	2.75	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6310	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-06	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6311	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-09	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6312	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-10	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6313	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-11	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6314	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-12	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6315	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-13	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6316	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-19	2.78	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6317	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-20	2.79	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6318	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-23	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6319	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-24	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6320	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-25	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6321	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-26	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6322	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-02-27	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6323	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-03	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6324	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-04	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6325	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-05	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6326	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-06	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6327	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-09	2.84	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6328	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-10	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6329	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-11	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6330	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-12	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6331	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-13	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6332	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-16	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6333	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-17	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6334	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-18	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6335	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-19	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6336	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-20	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6337	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-23	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6338	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-24	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6339	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-25	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6340	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-26	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6341	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-27	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6342	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-30	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6343	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-03-31	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6344	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-01	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6345	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-02	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6346	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-03	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6347	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-06	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6348	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-07	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6349	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-08	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6350	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-09	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6351	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-10	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6352	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-13	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6353	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-14	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6354	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-15	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6355	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-16	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6356	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-17	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6357	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-20	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6358	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-21	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6359	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-22	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6360	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-23	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6361	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-24	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6362	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-27	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6363	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-04-28	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
1265	한국은행	대한민국	경제/산업	산업	건설	한국 건설 기성액(총기성액)(경상지수)	1905-07-16	170064972	KRW100만	Y	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
6365	한국은행	대한민국	경제/산업	산업	건설	한국 건설 기성액(총기성액)(계절조정)	1905-07-16	171041061	KRW100만	Y	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6366	한국은행	대한민국	경제/산업	산업	건설	한국 건설 기성액(총기성액)(불변 계절조정)	1905-07-16	119679905	KRW100만	Y	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6367	한국은행	대한민국	경제/산업	산업	건설	한국 건설 기성액(총기성액)(불변지수)	1905-07-16	118968921	KRW100만	Y	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
1266	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-01	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1267	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-02	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1268	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-03	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1269	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-04	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1270	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-05	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1271	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-06	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1272	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-07	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1273	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-08	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1274	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-09	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1275	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-10	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1276	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-11	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1277	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-12	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1278	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-13	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1279	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-14	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1280	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-15	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1281	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-16	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1282	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-17	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1283	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-18	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1284	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-19	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1285	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-20	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1286	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-21	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1287	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-22	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1288	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-23	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1289	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-24	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1290	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-25	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1291	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-26	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1292	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-27	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1293	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-28	2.75	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1294	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1295	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1296	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-05-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1297	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1298	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1299	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1300	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1301	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1302	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1303	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1304	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1305	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1306	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1307	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1308	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1309	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1310	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1311	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1312	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1313	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1314	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1315	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1316	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1317	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1318	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1319	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1320	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1321	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1322	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1323	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1324	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1325	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1326	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-06-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1327	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1328	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1329	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1330	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1331	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1332	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1333	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1334	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1335	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1336	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1337	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1338	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1339	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1340	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1341	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1342	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1343	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1344	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1345	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1346	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1347	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1348	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1349	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1350	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1351	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1352	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1353	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1354	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1355	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1356	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1357	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-07-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1358	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1359	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1360	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1361	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1362	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1363	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1364	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1365	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1366	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1367	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1368	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1369	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1370	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1371	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1372	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1373	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1374	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1375	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1376	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1377	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1378	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1379	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1380	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1381	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1382	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1383	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1384	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1385	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1386	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1387	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1388	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-08-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1389	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1390	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1391	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1392	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1393	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1394	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1395	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1396	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1397	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1398	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1399	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1400	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1401	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1402	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1403	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1404	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1405	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1406	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1407	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1408	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1409	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1410	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1411	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1412	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1413	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1414	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1415	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1416	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1417	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1418	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-09-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1419	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1420	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1421	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1422	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1423	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1424	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1425	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1426	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1427	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1428	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1429	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1430	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1431	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1432	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1433	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1434	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1435	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1436	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1437	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1438	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1439	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1440	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1441	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1442	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1443	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1444	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1445	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1446	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1447	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1448	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1449	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-10-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1450	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1451	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1452	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1453	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1454	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1455	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1456	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1457	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1458	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1459	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1460	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1461	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1462	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1463	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1464	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1465	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1466	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1467	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1468	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1469	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1470	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1471	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1472	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1473	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1474	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1475	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1476	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1477	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1478	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1479	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-11-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1480	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1481	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1482	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1483	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1484	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1485	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1486	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1487	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1488	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1489	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1490	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1491	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1492	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1493	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1494	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1495	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1496	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1497	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1498	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1499	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1500	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1501	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1502	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1503	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1504	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1505	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1506	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1507	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1508	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1509	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1510	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2025-12-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1511	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1512	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1513	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1514	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1515	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1516	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1517	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1518	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1519	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1520	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1521	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1522	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1523	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1524	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1525	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1526	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1527	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1528	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1529	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1530	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1531	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1532	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1533	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1534	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1535	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1536	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1537	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1538	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1539	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1540	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1541	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-01-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1542	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1543	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1544	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1545	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1546	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1547	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1548	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1549	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1550	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1551	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1552	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1553	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1554	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1555	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1556	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1557	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1558	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1559	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1560	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1561	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1562	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1563	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1564	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1565	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1566	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1567	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1568	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1569	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-02-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1570	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1571	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1572	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1573	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1574	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1575	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1576	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1577	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1578	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1579	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1580	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1581	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1582	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1583	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1584	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1585	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1586	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1587	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1588	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1589	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1590	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1591	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1592	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1593	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1594	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1595	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1596	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1597	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1598	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-29	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1599	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-30	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1600	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-03-31	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1601	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-01	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1602	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-02	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1603	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-03	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1604	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-04	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1605	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-05	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1606	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-06	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1607	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-07	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1608	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-08	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1609	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-09	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1610	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-10	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1611	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-11	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1612	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-12	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1613	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-13	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1614	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-14	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1615	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-15	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1616	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-16	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1617	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-17	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1618	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-18	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1619	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-19	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1620	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-20	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1621	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-21	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1622	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-22	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1623	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-23	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1624	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-24	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1625	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-25	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1626	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-26	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1627	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-27	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1628	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-04-28	2.5	%	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1629	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-05-02	185	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1630	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-05-22	185	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1631	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-06-05	184.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1632	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-06-19	173	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1633	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-07-03	182	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1634	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-07-18	180	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1635	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-08-07	183.2	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1636	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-08-21	188.4	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1637	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-09-01	185.4	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1638	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-09-17	187	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1639	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-10-01	190.2	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1640	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-10-24	194.2	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1641	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-11-06	196.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1642	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-11-19	195	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1643	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-12-01	199.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1644	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2025-12-18	216.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1645	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-01-07	218	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1646	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-01-19	237	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1647	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-02-06	252.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1648	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-02-20	242.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1649	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-03-03	211	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1650	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-03-16	230	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1651	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-04-01	236.8	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1652	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-04-24	231.3	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1653	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-05-02	337	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1654	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-05-16	335	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1655	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-06-06	335	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1656	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-06-20	335	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1657	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-07-04	335	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1658	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-07-18	335	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1659	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-08-01	335	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1660	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-08-15	340	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1661	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-09-05	341	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1662	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-09-19	345	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1663	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-10-03	345	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1664	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-10-17	345	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1665	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-11-07	343	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1666	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-11-21	344	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1667	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-12-05	347	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1668	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2025-12-19	346	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1669	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-01-02	341	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1670	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-01-22	342	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1671	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-02-06	343	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1672	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-02-20	348	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1673	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-03-06	349	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1674	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-03-20	360	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1675	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-04-03	382	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1676	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-04-24	398	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1677	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-05-02	348	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1678	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-05-16	338	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1679	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-06-06	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1680	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-06-20	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1681	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-07-04	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1682	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-07-18	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1683	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-08-01	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1684	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-08-15	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1685	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-09-05	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1686	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-09-19	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1687	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-10-03	311	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1688	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-10-17	309	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1689	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-11-07	308	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1690	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-11-21	308	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1691	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-12-05	308	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1692	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2025-12-19	327	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1693	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-01-02	328	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1694	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-01-22	358	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1695	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-02-06	358	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1696	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-02-20	388.33	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1697	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-03-06	388.33	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1698	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-03-20	388.33	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1699	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-04-03	388.33	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1700	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-04-24	368.33	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
6803	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-05-02	1350	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6804	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-05-16	1350	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6805	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-06-06	1325	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6806	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-06-20	1325	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6807	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-07-04	1325	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6808	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-07-18	1375	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6809	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-08-01	1262.5	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6810	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-08-15	1262.5	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6811	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-09-05	1262.5	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6812	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-09-19	1262.5	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6813	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-10-03	1150	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6814	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-10-17	1150	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6815	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-11-07	1150	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6816	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-11-21	1150	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6817	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-12-05	1150	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6818	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2025-12-19	1050	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6819	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-01-02	1075	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6820	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-01-23	1200	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6821	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-02-06	1225	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6822	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-02-20	1300	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6823	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-03-06	1300	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6824	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-03-20	1227.5	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6825	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-04-03	1227.5	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6826	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-04-24	1320	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
1701	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-05-06	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1702	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-05-15	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1703	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-05-28	3210	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1704	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-06-10	3220	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1705	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-06-20	3220	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1706	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-06-24	3210	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1707	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-07-03	3250	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1708	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-07-11	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1709	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-07-30	3530	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1710	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-08-06	3500	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1711	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-08-12	3540	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1712	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-08-28	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1713	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-09-01	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1714	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-09-10	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1715	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-09-24	3430	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1716	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-10-09	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1717	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-10-20	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1718	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-10-27	3360	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1719	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-11-11	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1720	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-11-17	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1721	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-11-28	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1722	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-12-03	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1723	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-12-11	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1724	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2025-12-30	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1725	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-01-06	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1726	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-01-11	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1727	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-01-27	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1728	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-02-02	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1729	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-02-11	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1730	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-02-28	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1731	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-03-11	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1732	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-03-23	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1733	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-03-31	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1734	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-04-01	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1735	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-04-15	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1736	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-04-28	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
6863	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-05-02	93	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6864	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-05-16	93	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6865	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-06-06	92.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6866	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-06-19	92.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6867	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-07-04	92.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6868	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-07-18	91.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6869	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-08-07	91.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6870	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-08-21	92.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6871	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-09-01	105	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6872	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-09-17	100	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6873	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-10-01	105	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6874	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-10-24	106.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6875	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-11-06	105.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6876	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-11-19	106	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6877	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-12-01	97	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6878	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2025-12-18	98.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6879	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-01-07	98.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6880	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-01-19	95	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6881	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-02-06	97	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6882	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-02-20	106.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6883	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-03-03	104.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6884	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-03-16	98	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6885	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-04-01	96.5	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6886	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-04-24	102	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6887	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-05-02	462	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6888	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-05-16	460	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6889	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-06-06	455	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6890	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-06-19	450	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6891	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-07-04	450	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6892	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-07-18	470	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6893	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-08-07	471	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6894	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-08-21	480	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6895	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-09-01	475	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6896	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-09-17	480	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6897	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-10-01	480	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6898	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-10-24	455	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6899	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-11-06	440	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6900	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-11-19	450	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6901	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-12-01	450	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6902	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2025-12-18	445	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6903	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-01-07	455	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6904	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-01-19	460	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6905	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-02-06	463	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6906	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-02-20	470	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6907	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-03-03	480	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6908	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-03-16	486	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6909	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-04-01	483	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
6910	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-04-24	488	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
1737	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-02	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1738	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-08	3500	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1739	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-12	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1740	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-13	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1741	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-19	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1742	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-22	3470	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1743	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-23	3470	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1744	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-26	3450	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1745	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-27	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1746	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-05-30	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1747	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-03	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1748	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-04	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1749	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-09	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1750	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-11	3400	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1751	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-13	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1752	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-17	3360	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1753	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-18	3360	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1754	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-26	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1755	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-27	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1756	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-06-30	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1757	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-01	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1758	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-02	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1759	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-03	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1760	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-04	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1761	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-08	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1762	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-09	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1763	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-15	3100	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1764	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-25	3460	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1765	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-28	3450	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1766	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-07-30	3360	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1767	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-01	3450	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1768	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-04	3450	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1769	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-05	3470	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1770	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-11	3470	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1771	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-12	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1772	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-25	3510	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1773	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-26	3510	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1774	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-27	3510	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1775	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-28	3500	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1776	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-08-29	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1777	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-01	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1778	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-03	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1779	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-04	3480	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1780	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-05	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1781	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-14	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1782	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-15	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1783	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-18	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1784	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-22	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1785	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-23	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1786	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-25	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1787	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-09-27	3490	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1788	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-07	3470	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1789	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-08	3460	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1790	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-11	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1791	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-13	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1792	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-15	3420	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1793	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-17	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1794	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-20	3400	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1795	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-22	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1796	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-23	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1797	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-27	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1798	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-10-31	3390	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1799	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-03	3380	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1800	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-04	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1801	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-06	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1802	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-10	3350	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1803	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-13	3340	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1804	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-14	3340	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1805	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-18	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1806	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-20	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1807	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-22	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1808	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-24	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1809	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-25	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1810	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-11-27	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1811	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-03	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1812	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-04	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1813	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-08	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1814	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-09	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1815	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-12	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1816	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-15	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1817	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-17	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1818	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-18	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1819	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-22	3300	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1820	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-24	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1821	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-25	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1822	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2025-12-27	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1823	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-04	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1824	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-05	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1825	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-06	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1826	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-08	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1827	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-09	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1828	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-14	3320	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1829	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-15	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1830	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-19	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1831	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-22	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1832	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-23	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1833	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-26	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1834	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-01-27	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1835	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-04	3330	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1836	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-05	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1837	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-09	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1838	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-10	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1839	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-11	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1840	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-13	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1841	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-14	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1842	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-24	3290	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1843	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-25	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1844	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-26	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1845	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-02-28	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1846	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-02	3280	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1847	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-03	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1848	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-04	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1849	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-05	3270	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1850	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-11	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1851	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-13	3310	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1852	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-17	3350	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1853	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-19	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1854	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-20	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1855	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-23	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1856	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-25	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1857	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-26	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1858	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-03-27	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1859	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-01	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1860	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-02	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1861	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-07	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1862	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-13	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1863	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-15	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1864	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-17	3370	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1865	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-21	3400	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1866	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-23	3410	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1867	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-27	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1868	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-04-28	3440	CNY/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
7043	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-05-02	750	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7044	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-05-16	740	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7045	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-06-06	720	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7046	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-06-19	720	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7047	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-07-04	710	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7048	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-07-18	710	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7049	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-08-07	720	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7050	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-08-21	740	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7051	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-09-05	750	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7052	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-09-17	750	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7053	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-10-03	760	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7054	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-10-24	750	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7055	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-11-07	760	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7056	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-11-21	760	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7057	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-12-05	750	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7058	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2025-12-19	740	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7059	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-01-09	740	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7060	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-01-23	760	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7061	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-02-06	770	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7062	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-02-20	800	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7063	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-03-06	810	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7064	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-03-20	830	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7065	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-04-03	870	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7066	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-04-24	900	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
1869	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-05-06	351	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1870	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-05-13	375	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1871	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-06-03	380	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1872	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-06-10	380	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1873	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-07-01	371	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1874	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-07-15	357	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1875	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-08-05	363	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1876	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-08-19	378	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1877	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-09-02	388	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1878	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-09-16	388	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1879	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-10-07	375	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1880	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-10-21	375	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1881	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-11-04	377	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1882	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-11-18	376	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1883	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-12-02	373	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1884	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2025-12-16	377	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1885	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-01-06	389	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1886	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-01-20	408	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1887	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-02-03	422	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1888	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-02-17	420	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1889	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-03-03	417	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1890	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-03-17	421	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1891	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-04-07	420	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1892	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-04-21	422	KRW/kg	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1893	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-01	15210	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1894	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-06	15500	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1895	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-12	15675	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1896	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-13	15625	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1897	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-19	15525	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1898	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-22	15400	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1899	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-23	15395	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1900	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-27	15410	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1901	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-28	15120	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1902	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-05-30	15320	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1903	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-03	15375	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1904	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-04	15480	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1905	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-09	15475	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1906	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-11	15200	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1907	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-13	15170	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1908	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-17	15015	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1909	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-18	15035	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1910	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-26	15160	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1911	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-27	15210	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1912	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-06-30	15220	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1913	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-01	15225	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1914	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-02	15400	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1915	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-03	15225	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1916	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-04	15315	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1917	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-08	15125	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1918	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-09	15000	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1919	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-15	14980	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1920	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-25	15400	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1921	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-28	15230	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1922	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-07-30	15080	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1923	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-01	14810	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1924	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-04	14950	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1925	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-05	15140	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1926	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-11	15250	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1927	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-12	15180	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1928	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-25	15190	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1929	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-26	15120	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1930	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-27	15190	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1931	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-28	15190	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1932	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-08-29	15375	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1933	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-01	15465	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1934	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-03	15285	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1935	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-04	15215	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1936	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-05	15275	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1937	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-14	15460	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1938	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-15	15415	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1939	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-18	15280	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1940	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-22	15240	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1941	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-23	15270	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1942	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-25	15470	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1943	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-09-27	15225	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1944	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-07	15160	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1945	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-08	15345	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1946	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-11	15205	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1947	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-13	15100	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1948	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-15	15210	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1949	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-17	15125	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1950	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-20	15280	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1951	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-22	15340	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1952	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-23	15280	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1953	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-27	15340	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1954	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-10-31	15320	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1955	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-03	15175	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1956	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-04	15115	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1957	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-06	15060	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1958	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-10	15105	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1959	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-13	15060	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1960	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-14	14860	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1961	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-18	14740	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1962	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-20	14530	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1963	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-22	14450	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1964	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-24	14635	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1965	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-25	14870	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1966	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-11-27	14830	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1967	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-03	14870	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1968	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-04	14920	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1969	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-08	14905	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1970	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-09	14735	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1971	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-12	14600	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1972	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-15	14410	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1973	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-17	14530	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1974	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-18	14770	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1975	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-22	15100	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1976	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-24	15600	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1977	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-25	16050	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1978	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2025-12-27	16910	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1979	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-04	16910	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1980	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-05	16860	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1981	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-06	18045	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1982	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-08	18625	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1983	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-09	17775	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1984	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-14	18140	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1985	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-15	18050	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1986	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-19	17800	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1987	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-22	17900	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1988	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-23	18720	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1989	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-26	18565	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1990	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-01-27	18400	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1991	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-04	16775	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1992	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-05	16676	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1993	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-09	17435	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1994	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-10	16879	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1995	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-11	17040	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1996	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-13	17330	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1997	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-14	16960	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1998	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-24	17560	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
1999	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-25	17950	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2000	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-26	17700	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2001	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-02-27	17880	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2002	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-02	17550	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2003	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-03	17120	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2004	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-04	17525	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2005	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-05	17380	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2006	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-11	17520	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2007	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-13	17330	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2008	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-17	17380	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2009	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-19	17160	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2010	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-20	16450	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2011	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-23	17050	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2012	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-25	17525	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2013	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-26	17190	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2014	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-03-27	17910	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2015	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-01	17225	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2016	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-02	17345	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2017	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-07	17200	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2018	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-13	18325	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2019	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-15	18260	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2020	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-17	19460	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2021	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-21	19220	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2022	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-23	19450	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2023	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-27	19460	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2024	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-04-28	19450	USD/MT	D	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
7223	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-05-02	47.9	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7224	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-05-09	47.8	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7225	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-06-06	50.2	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7226	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-06-13	51.6	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7227	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-07-04	51.7	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7228	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-07-18	53	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7229	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-08-01	55.4	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7230	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-08-22	57.6	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7231	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-09-05	59.2	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7232	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-09-19	57.7	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7233	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-10-03	56.4	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7234	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-10-17	56.5	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7235	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-11-07	57.2	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7236	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-11-21	53.9	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7237	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-12-05	50.8	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7238	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2025-12-19	52	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7239	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-01-09	52.5	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7240	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-01-23	51.5	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7241	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-02-06	55.6	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7242	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-02-20	68.8	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7243	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-03-06	65.7	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7244	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-03-20	63.8	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7245	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-04-03	63.5	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7246	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-04-17	63.5	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2025	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-05-02	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2026	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-05-09	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2027	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-06-06	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2028	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-06-13	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2029	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-07-04	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2030	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-07-18	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2031	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-08-01	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2032	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-08-22	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2033	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-09-05	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2034	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-09-19	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2035	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-10-03	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2036	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-10-17	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2037	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-11-07	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2038	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-11-21	375	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2039	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-12-05	491	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2040	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2025-12-19	491	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2041	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-01-09	491	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2042	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-01-23	491	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2043	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-02-06	569	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2044	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-02-20	569	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2045	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-03-06	569	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2046	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-03-20	569	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2047	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-04-03	569	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2048	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-04-17	569	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
7271	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-05-02	970	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7272	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-05-09	970	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7273	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-06-06	960	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7274	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-06-13	960	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7275	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-07-04	960	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7276	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-07-18	960	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7277	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-08-01	950	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7278	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-08-22	950	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7279	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-09-05	950	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7280	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-09-19	950	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7281	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-10-03	950	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7282	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-10-17	950	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7283	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-11-07	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7284	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-11-21	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7285	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-12-05	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7286	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2025-12-19	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7287	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-01-09	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7288	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-01-23	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7289	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-02-06	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7290	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-02-20	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7291	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-03-06	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7292	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-03-20	940	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7293	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-04-03	960	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7294	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-04-17	960	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7295	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-05-02	375	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7296	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-05-09	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7297	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-06-06	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7298	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-06-13	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7299	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-07-04	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7300	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-07-18	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7301	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-08-01	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7302	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-08-22	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7303	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-09-05	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7304	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-09-19	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7305	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-10-03	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7306	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-10-17	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7307	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-11-07	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7308	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-11-21	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7309	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-12-05	330	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7310	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2025-12-19	350	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7311	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-01-09	350	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7312	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-01-23	350	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7313	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-02-06	380	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7314	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-02-20	400	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7315	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-03-06	400	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7316	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-03-20	400	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7317	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-04-03	400	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7318	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-04-17	380	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
2049	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-05-02	96.9	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2050	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-05-22	99.7	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2051	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-06-05	95.65	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2052	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-06-19	93.05	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2053	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-07-03	96.3	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2054	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-07-18	100.2	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2055	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-08-07	101.5	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2056	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-08-21	100.8	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2057	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-09-04	101.85	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2058	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-09-18	106.1	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2059	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-10-02	104	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2060	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-10-23	105.15	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2061	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-11-06	104.7	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2062	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-11-20	105.1	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2063	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-12-04	105.37	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2064	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2025-12-18	108.35	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2065	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-01-07	109.25	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2066	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-01-22	104.45	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2067	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-02-05	98.7	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2068	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-02-19	96.4	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2069	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-03-05	100.55	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2070	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-03-19	108.2	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2071	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-04-02	107.35	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
2072	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-04-23	108	USD/MT	W	2026-05-20 23:16:57.266409+09	2026-05-20 23:16:57.266409+09
7343	Bloomberg	중국	경제/산업	거시경제	제조업지수	중국 수출 구매자 관리자 지수(PMI	2026-05-01	50.51	Pt	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7344	KISCON	한국	경제/산업	산업	건설	한국 건설업 등록 업체 수	2026-05-01	706.78	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7345	KISCON	한국	경제/산업	산업	건설	한국 건설업 폐업 업체수	2026-05-01	340.69	UNIT	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7346	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-01	484.92	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7347	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-04	485.84	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7348	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-05	486.53	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7349	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-06	488.06	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7350	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-07	486.45	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7351	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-08	486.15	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7352	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-11	484.32	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7353	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-12	483.23	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7354	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-13	483.25	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7355	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-14	481.42	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7356	CRU	중국	가격	철강재	열연	중국열연현물가fob	2026-05-15	480.26	USD	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7357	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-05-07	1173.81	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7358	CRU	미국	가격	철강재	열연	미국열연현물가fob	2026-05-14	1174.65	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7359	CRU	서유럽	경제산업	산업	기타	유럽 철강 산업 CO2, 온실가스 배출 저감가치(full Abatement)	2026-05-01	166.59	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7360	CRU	북미_기타	경제산업	철강재	기타	북미 철강 가격 지수(CRU)	2026-05-01	275.74	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7361	CRU	동북아_기타	경제산업	철강재	기타	아시아 철강 가격 지수 (CRU)	2026-05-01	161.49	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7362	CRU	서유럽_기타	경제산업	철강재	기타	글로벌 철강 가격 지수(CRU)	2026-05-01	201.96	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7363	CRU	서유럽_기타	경제산업	철강재	기타	유럽 철강 가격 지수(CRU)	2026-05-01	239.17	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7364	CRU	기타	경제산업	철강재	STS 300계	글로벌 스테인리스강(STS) 가격 지수(CRU)	2026-05-01	160.95	%	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7365	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-05-07	6.08	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7366	Platts	미국	생산	철강재	열연	미국 열연(HR) Coil 생산 납기	2026-05-14	6.05	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7367	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-05-07	10.07	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7368	Platts	미국	생산	철강재	후판	미국 후판(Plate) 생산 납기	2026-05-14	10.04	-	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7369	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-05-07	503.7	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7370	Platts	중국	가격	철강재	후판	중국 후판(Plate) 현물가-FOB(상하이시)	2026-05-14	500.45	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7371	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2026-05-07	14580.62	CNY	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7372	Platts	중국	가격	철강재	STS 300계	중국 스테인리스(STS) 304 현물가	2026-05-14	14604.82	CNY	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7373	Platts	-	가격	철강재	STS 300계	유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge	2026-05-01	2998.37	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7374	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 420 Bright Bar Alloy Surcharge	2026-05-01	1198.2	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7375	Platts	-	가격	철강재	STS 400계	유럽 국내 생산 스테인리스(STS) 430 Coil Alloy Surcharge	2026-05-01	1049.14	EUR	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7376	Platts	일본	가격	철강재	열연	일본 열연(HR) Coil 내수가(도쿄제철)	2026-05-01	94319.99	JPY	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7377	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-05-07	95.81	USC	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7378	Platts	중국	가격	원자재	크롬	중국 페로크롬(FeCr) 58~60% 현물가	2026-05-14	95.89	USC	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7379	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-05-07	1191.25	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7380	Platts	중국	가격	원자재	페로실리콘	중국 페로실리콘(FeSi) 75% 현물가	2026-05-14	1193.51	USD	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7381	Platts	인도네시아	가격	원자재	니켈	인도네시아 NPI(Nickel Pig Iron) 월간평균가fob	2026-05-01	140.51	USD	M	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7382	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-05-07	82.1	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7383	MySteel	중국	재고	철강재	열연	중국 열연(HR) Sheet/Coil Mill 재고	2026-05-14	82.37	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7384	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-05-07	84.38	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7385	MySteel	중국	재고	철강재	후판	중국 후판(Plate) Mill 재고	2026-05-14	84.01	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7386	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-05-07	303.97	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7387	MySteel	중국	생산	철강재	열연	중국 열연(HR) Sheet/Coil Mill 생산량	2026-05-14	301.93	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7388	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-05-07	168.28	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7389	MySteel	중국	생산	철강재	후판	중국 후판(Plate) Mill 생산량	2026-05-14	167.21	10Kt	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7390	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-05-07	82.71	%	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7391	MySteel	중국	가동률	철강재	공통	중국 247개 철강사 고로 운영률(Operating Rate)	2026-05-14	82.89	%	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7392	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-05-07	78.83	%	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7393	MySteel	중국	가동률	철강재	열연	중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)	2026-05-14	78.67	%	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7394	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-05-07	90.58	%	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7395	MySteel	중국	가동률	철강재	후판	중국 후판(Plate) Mill 운영률(Operating Rate)	2026-05-14	90.24	%	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7396	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-01	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7397	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-04	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7398	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-05	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7399	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-06	3.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7400	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-07	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7401	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-08	3.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7402	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-11	3.53	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7403	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-12	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7404	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-13	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7405	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-14	3.54	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7406	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국 3년 만기 국채 수익률	2026-05-15	3.55	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7407	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-01	4.19	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7408	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-04	4.2	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7409	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-05	4.19	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7410	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-06	4.17	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7411	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-07	4.16	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7412	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-08	4.15	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7413	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-11	4.14	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7414	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-12	4.15	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7415	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-13	4.16	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7416	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-14	4.15	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7417	한국은행	대한민국	경제/산업	거시경제	채권/금리	회사채수익률(3년,AA-)	2026-05-15	4.16	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7418	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-01	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7419	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-04	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7420	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-05	2.83	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7421	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-06	2.82	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7422	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-07	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7423	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-08	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7424	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-11	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7425	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-12	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7426	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-13	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7427	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-14	2.81	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7428	한국은행	대한민국	경제/산업	거시경제	채권/금리	CD수익률(91일)	2026-05-15	2.8	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7429	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-01	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7430	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-04	2.51	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7431	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-05	2.5	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7432	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-06	2.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7433	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-07	2.48	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7434	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-08	2.48	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7435	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-11	2.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7436	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-12	2.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7437	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-13	2.48	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7438	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-14	2.48	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7439	한국은행	대한민국	경제/산업	거시경제	채권/금리	한국은행 기준금리	2026-05-15	2.49	%	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7440	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-05-07	231.41	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7441	스틸데일리	기타	가격	원자재	철광석/석탄	글로벌 강점탄 수출가	2026-05-14	233.15	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7442	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-05-07	400.3	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7443	스틸데일리	동북아/기타	가격	원자재	철스크랩	동아시아 철스크랩 수입가	2026-05-14	397.17	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7444	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-05-07	369.63	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7445	스틸데일리	미국	가격	원자재	철스크랩	미국 철스크랩 컴포짓가	2026-05-14	370.7	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7446	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-05-07	1320.78	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7447	스틸데일리	미국	가격	원자재	망간	미국 페로망간(FeMn) 하이카본 76% 가격	2026-05-14	1315.85	USD/LT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7448	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-01	3413.85	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7449	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-04	3403.24	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7450	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-05	3401.46	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7451	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-06	3400.2	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7452	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-07	3412.54	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7453	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-08	3422.8	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7454	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-11	3416.32	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7455	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-12	3416.34	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7456	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-13	3407.56	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7457	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-14	3418.81	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7458	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) 3.0mm 유통가	2026-05-15	3428.94	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7459	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-05-07	101.67	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7460	스틸데일리	일본	가격	원자재	크롬	일본 페로크롬(FeCr) 60~65% 가격	2026-05-14	101.9	USD0.01/1b	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7461	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-05-07	488.85	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7462	스틸데일리	중국	가격	철강재	열연	중국 열연(HR) Coil SS400 수출가	2026-05-14	486.13	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7463	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-01	3447.22	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7464	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-04	3448.31	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7465	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-05	3456	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7466	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-06	3456.84	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7467	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-07	3443.03	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7468	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-08	3438.19	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7469	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-11	3424.97	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7470	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-12	3436.73	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7471	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-13	3447.14	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7472	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-14	3456.29	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7473	스틸데일리	중국	가격	철강재	후판	중국 중후판(Plate) 20mm 유통가	2026-05-15	3450.97	CNY/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7474	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-05-07	893.63	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7475	스틸데일리	한국	가격	철강재	열연	한국 열연(HR) SS275 3.0mm 수입 유통가	2026-05-14	899.03	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7476	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-05-07	425.02	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7477	스틸데일리	한국	가격	원자재	철스크랩	한국 철스크랩 생철 A (Busheling A) 가격 - 평균	2026-05-14	422.2	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7478	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-01	19447.82	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7479	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-04	19380.8	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7480	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-05	19421.21	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7481	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-06	19462.51	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7482	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-07	19404.65	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7483	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-08	19400.81	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7484	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-11	19408.54	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7485	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-12	19372.06	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7486	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-13	19429.78	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7487	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-14	19417.83	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7488	스틸데일리	기타	가격	원자재	니켈	LME 니켈 3개월 선물	2026-05-15	19373.06	USD/MT	D	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7489	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-05-07	63.54	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7490	스틸데일리	기타	가격	원자재	기타	페로몰리브덴(FeMo) 65% 가격	2026-05-14	63.77	USD/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7491	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-05-07	566.28	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7492	스틸데일리	대한민국	가격	원자재	철스크랩	한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)	2026-05-14	564.57	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7493	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-05-07	967.61	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7494	스틸데일리	대한민국	가격	철강재	도금	한국 전기아연도금강판(EGI) 1.2mm, 도금량 120g/m^2 유통가	2026-05-14	969.93	KRW/kg	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7495	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-05-07	379.62	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7496	스틸데일리	미국	가격	원자재	철스크랩	미국 중서부 철스크랩 1&2 가격	2026-05-14	379.73	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7497	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-05-07	107.35	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
7498	스틸데일리	중국	가격	원자재	철광석/석탄	중국 철광석 수입가 - 호주산 62% 분광	2026-05-14	106.88	USD/MT	W	2026-05-24 14:59:25.088796+09	2026-05-24 14:59:25.088796+09
\.


--
-- Data for Name: order_lines; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.order_lines (order_line_no, customer_name, variant_code, salesperson, created_at, updated_at) FROM stdin;
01S0000035010	포스코건설	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000036010	포스코건설	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000037010	포스코건설	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000041010	포스코인터내셔널	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000042010	포스코인터내셔널	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000043010	포스코인터내셔널	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000044010	포스코인터내셔널	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000045010	포스코인터내셔널	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000046010	포스코인터내셔널	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000047010	포스코인터내셔널	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000048010	포스코인터내셔널	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000049010	포스코인터내셔널	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000050010	포스코인터내셔널	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000051010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000052010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000053010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000054010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000055010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000056010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000057010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000058010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000059010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000060010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000061010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000062010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000063010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000064010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000065010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000066010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000067010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000068010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000069010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000070010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000071010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000072010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000073010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000074010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000075010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000076010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000077010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000078010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000079010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000080010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000081010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000082010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000083010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000084010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000085010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000086010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000087010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000088010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000089010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000090010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000091010	현대중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000092010	삼성중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000093010	한화오션	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000094010	포스코건설	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000095010	포스코인터내셔널	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000096010	고려제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000097010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000098010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000099010	동일제강	WR	박지은	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000100010	포스코인터내셔널	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000101010	삼성중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000102010	삼성중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000103010	삼성중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000104010	삼성중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000105010	삼성중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000106010	삼성중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000107010	삼성중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000108010	삼성중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000109010	삼성중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000110010	삼성중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000111010	포스코건설	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000112010	포스코건설	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000113010	포스코건설	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000114010	포스코건설	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000115010	포스코건설	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000116010	포스코건설	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000117010	포스코인터내셔널	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000118010	포스코인터내셔널	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000119010	포스코인터내셔널	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000120010	포스코인터내셔널	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000001010	현대중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000002010	현대중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000003010	현대중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000004010	현대중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000005010	현대중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000006010	현대중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000007010	현대중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000008010	현대중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000009010	현대중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000010010	현대중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
26S0500001010	고려제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500002010	고려제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500003010	고려제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500004010	고려제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500005010	고려제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500006010	고려제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500007010	동일제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500008010	동일제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500009010	동일제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500010010	동일제강	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500011010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500012010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500013010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500014010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500015010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500016010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500017010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500018010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500019010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500020010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500021010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500022010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500023010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500024010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500025010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500026010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500027010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500028010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500029010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500030010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500031010	포스코인터내셔널	WR	박지은	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500032010	현대중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500033010	현대중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500034010	현대중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500035010	현대중공업	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500036010	현대중공업	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500037010	현대중공업	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500038010	현대중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500039010	삼성중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500040010	삼성중공업	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500041010	삼성중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500042010	삼성중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500043010	삼성중공업	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500044010	삼성중공업	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500045010	한화오션	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500046010	한화오션	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500047010	한화오션	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500048010	한화오션	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500049010	한화오션	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500050010	한화오션	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500051010	포스코건설	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500052010	포스코건설	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500053010	포스코건설	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500054010	포스코건설	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500055010	포스코인터내셔널	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500056010	포스코인터내셔널	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500057010	포스코인터내셔널	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500058010	포스코인터내셔널	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500059010	포스코인터내셔널	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500060010	포스코인터내셔널	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500061010	포스코인터내셔널	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500062010	포스코인터내셔널	HE	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
26S0500063010	포스코인터내셔널	PJ	박현웅	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
01S0000038010	포스코건설	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000039010	포스코건설	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000040010	포스코건설	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
25S0000001010	현대중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000002010	현대중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000003010	현대중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000004010	현대중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000005010	현대중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000006010	현대중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000007010	현대중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000008010	현대중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000009010	현대중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000010010	현대중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000011010	삼성중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000012010	삼성중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000013010	삼성중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000014010	삼성중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000015010	삼성중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000016010	삼성중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000017010	삼성중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000018010	삼성중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000019010	삼성중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000020010	삼성중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000021010	한화오션	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000022010	한화오션	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000023010	한화오션	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000024010	한화오션	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000025010	한화오션	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000026010	한화오션	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000027010	한화오션	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000028010	한화오션	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000029010	한화오션	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000030010	한화오션	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000031010	포스코건설	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000032010	포스코건설	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000033010	포스코건설	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000034010	포스코건설	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000035010	포스코건설	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000036010	포스코건설	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000037010	포스코건설	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000038010	포스코건설	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000039010	포스코건설	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000040010	포스코건설	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000041010	포스코인터내셔널	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000042010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000043010	포스코인터내셔널	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000044010	포스코인터내셔널	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000045010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000046010	포스코인터내셔널	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000047010	포스코인터내셔널	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000048010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000049010	포스코인터내셔널	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000050010	포스코인터내셔널	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000051010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000052010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000053010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000054010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000055010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000056010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000057010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000058010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000059010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000060010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000061010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000062010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000063010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000064010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000065010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000066010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000067010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000068010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000069010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000070010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000071010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000072010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000073010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000074010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000075010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000076010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000077010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000078010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000079010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000080010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000081010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000082010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000083010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000084010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000085010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000086010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000087010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000088010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000089010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000090010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000091010	현대중공업	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000092010	삼성중공업	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000093010	한화오션	HE	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000094010	포스코건설	PJ	박현웅	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000095010	포스코인터내셔널	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000096010	고려제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000097010	Nissan Motor Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000098010	New Best Wire Industrial Co., Ltd	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
25S0000099010	동일제강	WR	박지은	2026-05-24 22:14:16.557844+09	2026-05-24 22:14:16.557844+09
01S0000011010	삼성중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000012010	삼성중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000013010	삼성중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000014010	삼성중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000015010	삼성중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000016010	삼성중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000017010	삼성중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000018010	삼성중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000019010	삼성중공업	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000020010	삼성중공업	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000021010	한화오션	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000022010	한화오션	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000023010	한화오션	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000024010	한화오션	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000025010	한화오션	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000026010	한화오션	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000027010	한화오션	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000028010	한화오션	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000029010	한화오션	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000030010	한화오션	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000031010	포스코건설	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000032010	포스코건설	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000033010	포스코건설	HE	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000034010	포스코건설	PJ	박현웅	2026-05-24 13:41:57.184636+09	2026-05-24 13:41:57.184636+09
01S0000121010	포스코인터내셔널	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000122010	포스코인터내셔널	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000123010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000124010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000125010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000126010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000127010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000128010	포스코인터내셔널	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000129010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000130010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000131010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000132010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000133010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000134010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000135010	한화오션	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000136010	한화오션	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000137010	한화오션	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000138010	한화오션	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000139010	한화오션	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000140010	한화오션	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000141010	한화오션	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000142010	현대중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000143010	현대중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000144010	현대중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000145010	현대중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000146010	현대중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000147010	현대중공업	HE	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000148010	현대중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000149010	현대중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000150010	현대중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000151010	현대중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
01S0000152010	현대중공업	PJ	박현웅	2026-05-24 22:26:37.80892+09	2026-05-24 22:26:37.80892+09
\.


--
-- Data for Name: org_hierarchy; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.org_hierarchy (manager_id, subordinate_id) FROM stdin;
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.product_variants (variant_code, variant_name, product, detail, created_at, updated_at) FROM stdin;
HE	HE	후판	HR PLATE	2026-05-24 01:09:18.675355+09	2026-05-24 01:09:18.675355+09
PJ	PJ	후판	PLATE	2026-05-24 01:09:18.675355+09	2026-05-24 01:09:18.675355+09
WR	WA	선재	WIRE ROD	2026-05-24 01:09:18.675355+09	2026-05-24 01:09:18.675355+09
WR	WB	선재	WIRE ROD	2026-05-24 01:09:18.675355+09	2026-05-24 01:09:18.675355+09
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.products (code, key_features, key_feature_importance, created_at, updated_at, key_feature_cycle) FROM stdin;
선재	{"중국 철근(Rebar) 선물가","중국 철광석 수입가 - 호주산 62% 분광","열연(HR) Coil 선물가 (상하이 선물거래소 1차)","동아시아 철스크랩 수입가","중국 10일 주기 주요 제철소 철강 재고(CISA)","한국 철스크랩 생철 A (Busheling A) 가격 - 평균","미국 자동차 판매대수SAAR","다우존스 산업평균지수","미국 10년 만기 국채 수익률","한국은행 기준금리"}	{0.2,0.15,0.15,0.1,0.1,0.05,0.05,0.08,0.06,0.06}	2026-05-24 14:36:00.843208+09	2026-05-24 14:36:00.843208+09	{D,W,D,W,W,W,M,D,D,D}
후판	{"중국 중후판(Plate) 20mm 유통가","중국 철광석 수입가 - 호주산 62% 분광","열연(HR) Coil 선물가 (상하이 선물거래소 1차)","중국 후판(Plate) Mill 재고","중국 후판(Plate) Mill 생산량","중국 후판(Plate) Mill 운영률(Operating Rate)","동아시아 철스크랩 수입가","미국 10년 만기 국채 수익률","다우존스 산업평균지수","한국은행 기준금리"}	{0.2,0.15,0.15,0.1,0.1,0.05,0.05,0.08,0.06,0.06}	2026-05-24 14:36:00.843208+09	2026-05-24 14:36:00.843208+09	{D,W,D,W,W,W,W,D,D,D}
HR(고로밀)	{"열연(HR) Coil 선물가 (상하이 선물거래소 1차)","중국 철광석 수입가 - 호주산 62% 분광","중국 열연(HR) 3.0mm 유통가","중국 열연(HR) Sheet/Coil Mill 재고","중국 철강제품 수출량","중국 열연(HR) Sheet/Coil Mill 운영률(Operating Rate)","중국 열연(HR) Coil SS400 수출가","중국 수출 구매자 관리자 지수(PMI)","다우존스 산업평균지수","미국 10년 만기 국채 수익률"}	{0.2,0.15,0.15,0.1,0.1,0.05,0.05,0.08,0.06,0.06}	2026-05-24 14:36:00.843208+09	2026-05-24 14:36:00.843208+09	{D,D,D,W,M,W,W,M,D,D}
냉연(CR)	{"일본 냉연 Coil 현물가 -FOB","열연(HR) Coil 선물가 (상하이 선물거래소 1차)","베트남 냉연(CR) Coil SPCC 1.0mm 가격","중국 열연(HR) 3.0mm 유통가","일본 철강제품 수출량","미국 1차 금속 제조업체 재고율(SA)","미국 가전제품 신규 주문액 NSA","다우존스 산업평균지수","미국 10년 만기 국채 수익률","한국은행 기준금리"}	{0.2,0.15,0.15,0.1,0.1,0.05,0.05,0.08,0.06,0.06}	2026-05-24 14:36:00.843208+09	2026-05-24 14:36:00.843208+09	{W,D,D,D,M,M,M,D,D,D}
STS 304	{"LME 니켈 3개월 선물","중국 스테인리스(STS) 304 현물가","글로벌 스테인리스강(STS) 가격 지수(CRU)","중국 페로크롬(FeCr) 58~60% 현물가","유럽 국내 생산 스테인리스(STS) 304L Bright Bar Alloy Surcharge","중국 10일 주기 주요 제철소 철강 재고(CISA)","중국 철강제품 수출량","다우존스 산업평균지수","미국 10년 만기 국채 수익률","중국 수출 구매자 관리자 지수(PMI)"}	{0.25,0.15,0.15,0.1,0.05,0.05,0.05,0.08,0.06,0.06}	2026-05-24 14:36:00.843208+09	2026-05-24 14:36:00.843208+09	{D,W,M,W,M,W,M,D,D,M}
부산물(철스크랩)	{"한국 철스크랩 생철 A (Busheling A) 가격 - 평균","동아시아 철스크랩 수입가","미국 철스크랩 컴포짓가","중국 철근(Rebar) 선물가","중국 247개 철강사 고로 운영률(Operating Rate)","일본 조강생산량","한국 철스크랩 수입가 (미국산 대형 - 벌크(HMS No.1)","다우존스 산업평균지수","미국 10년 만기 국채 수익률","한국은행 기준금리"}	{0.2,0.15,0.15,0.1,0.1,0.05,0.05,0.08,0.06,0.06}	2026-05-24 14:36:00.843208+09	2026-05-24 14:36:00.843208+09	{W,W,W,D,W,M,W,D,D,D}
\.


--
-- Data for Name: sales_actuals; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.sales_actuals (id, actual_value, unit, ym_str, created_at, updated_at, product, sales_group, customer_name) FROM stdin;
913	22	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
914	22	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
915	23	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
916	15	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
917	25.9	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
918	21.2	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
919	11.5	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
920	7	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
921	17	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
922	22	천톤	202505	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
923	22	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
924	27	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
925	31	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
926	16	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
927	31.4	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
928	25.7	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
929	15	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
930	9	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
931	17	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
932	30	천톤	202506	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
933	17	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
934	24	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
935	31	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
936	18	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
937	29.7	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
938	24.3	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
939	15	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
940	10	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
941	20	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
942	29	천톤	202507	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
943	21	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
944	33	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
945	29	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
946	17	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
947	30.3	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
948	24.8	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
949	16	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
950	10	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
951	16	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
952	28	천톤	202508	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
953	19	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
954	29	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
955	27	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
956	22	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
957	27	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
958	22.1	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
959	13	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
960	10	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
961	16	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
962	26	천톤	202509	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
963	18	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
964	33	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
965	24	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
966	19	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
967	25.9	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
968	21.2	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
969	16	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
970	8	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
971	21	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
972	32	천톤	202510	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
973	15	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
974	34	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
975	30	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
976	18	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
977	30.3	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
978	24.8	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
979	11	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
980	9	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
981	21	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
982	29	천톤	202511	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
983	15	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
984	26	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
985	21	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
986	16	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
987	21.5	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
988	17.6	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
989	11	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
990	9	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
991	16	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
992	24	천톤	202512	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
993	14	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
994	23	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
995	27	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
996	13	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
997	22.6	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
998	18.4	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
999	10	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
1000	7	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1001	13	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
1002	26	천톤	202601	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1003	18	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
1004	27	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
1005	31	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
1006	16	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
1007	29.2	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
1008	23.9	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
1009	16	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
1010	8	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1011	16	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
1012	24	천톤	202602	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1013	16	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
1014	28	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
1015	34	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
1016	17	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
1017	33	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
1018	27	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
1019	15	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
1020	9	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1021	18	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
1022	31	천톤	202603	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1023	20	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	현대중공업
1024	30	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	삼성중공업
1025	30	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	한화오션
1026	20	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코건설
1027	30.3	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	포스코인터내셔널
1028	24.8	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	후판	후판판매그룹	포스코인터내셔널
1029	15	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	고려제강
1030	10	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1031	20	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	동일제강
1032	30	천톤	202604	2026-05-25 01:15:40.017067+09	2026-05-25 01:15:40.017067+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
\.


--
-- Data for Name: sales_guides; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.sales_guides (id, guide_value, unit, ym_str, created_at, updated_at, product, sales_group, customer_name) FROM stdin;
989	20	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
990	25	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
991	25	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
992	20	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
993	30.3	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
994	24.8	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
995	15	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
996	10	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
997	20	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
998	30	천톤	202505	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
999	20	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1000	30	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1001	30	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1002	20	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1003	27.5	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1004	22.5	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1005	15	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1006	10	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1007	20	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1008	30	천톤	202506	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1009	20	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1010	30	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1011	30	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1012	20	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1013	30.3	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1014	24.8	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1015	15	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1016	10	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1017	20	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1018	30	천톤	202507	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1019	20	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1020	30	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1021	30	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1022	20	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1023	33	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1024	27	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1025	15	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1026	10	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1027	20	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1028	35	천톤	202508	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1029	20	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1030	30	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1031	30	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1032	20	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1033	27.5	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1034	22.5	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1035	15	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1036	10	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1037	20	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1038	30	천톤	202509	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1039	20	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1040	30	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1041	30	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1042	20	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1043	30.3	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1044	24.8	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1045	15	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1046	10	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1047	20	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1048	30	천톤	202510	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1049	20	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1050	25	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1051	25	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1052	20	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1053	27.5	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1054	22.5	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1055	15	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1056	10	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1057	20	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1058	30	천톤	202511	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1059	20	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1060	25	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1061	25	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1062	20	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1063	27.5	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1064	22.5	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1065	15	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1066	10	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1067	20	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1068	25	천톤	202512	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1069	20	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1070	25	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1071	25	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1072	15	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1073	24.8	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1074	20.2	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1075	15	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1076	10	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1077	20	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1078	25	천톤	202601	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1079	15	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1080	25	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1081	25	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1082	15	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1083	24.8	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1084	20.2	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1085	15	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1086	10	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1087	15	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1088	25	천톤	202602	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1089	20	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1090	30	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1091	30	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1092	20	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1093	27.5	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1094	22.5	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1095	15	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1096	10	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1097	20	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1098	30	천톤	202603	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1099	20	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1100	30	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1101	30	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1102	20	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1103	30.3	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1104	24.8	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1105	15	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1106	10	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1107	20	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1108	30	천톤	202604	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
1109	20	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	현대중공업
1110	40	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	삼성중공업
1111	45	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	한화오션
1112	20	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코건설
1113	30.3	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	포스코인터내셔널
1114	24.8	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	후판	후판판매그룹	포스코인터내셔널
1115	15	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	고려제강
1116	10	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	Nissan Motor Co., Ltd
1117	20	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	동일제강
1118	30	천톤	202605	2026-05-25 01:15:39.996412+09	2026-05-25 01:15:39.996412+09	선재	선재판매그룹	New Best Wire Industrial Co., Ltd
\.


--
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.shipments (id, shipped_at, customer_name, weight_kg, weight_unit, order_line_no, variant_code, created_at, updated_at) FROM stdin;
204	2026-05-13	포스코인터내셔널	41200	kg	01S0000041010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
205	2026-05-01	포스코인터내셔널	15000	kg	01S0000042010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
206	2026-05-08	포스코인터내셔널	8700	kg	01S0000043010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
207	2026-05-10	포스코인터내셔널	29500	kg	01S0000044010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
208	2026-05-04	포스코인터내셔널	33100	kg	01S0000045010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
209	2026-05-15	포스코인터내셔널	7200	kg	01S0000046010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
139	2026-05-04	삼성중공업	3758004	kg	26S0500039010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
140	2026-05-05	삼성중공업	4806146	kg	26S0500040010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
141	2026-05-05	삼성중공업	3453370	kg	26S0500041010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
142	2026-05-12	삼성중공업	6554641	kg	26S0500042010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
143	2026-05-12	삼성중공업	7208499	kg	26S0500043010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
144	2026-05-15	삼성중공업	1819339	kg	26S0500044010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
145	2026-05-05	한화오션	4092927	kg	26S0500045010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
132	2026-05-01	현대중공업	1245903	kg	26S0500032010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
133	2026-05-06	현대중공업	1748061	kg	26S0500033010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
134	2026-05-07	현대중공업	1555218	kg	26S0500034010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
135	2026-05-08	현대중공업	2801935	kg	26S0500035010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
136	2026-05-13	현대중공업	1594869	kg	26S0500036010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
137	2026-05-15	현대중공업	2114264	kg	26S0500037010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
138	2026-05-15	현대중공업	1339750	kg	26S0500038010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
101	2026-05-01	고려제강	629754	kg	26S0500001010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
102	2026-05-06	고려제강	1229403	kg	26S0500002010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
103	2026-05-12	고려제강	1910998	kg	26S0500003010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
104	2026-05-12	고려제강	1080982	kg	26S0500004010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
105	2026-05-14	고려제강	2142983	kg	26S0500005010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
106	2026-05-15	고려제강	2155881	kg	26S0500006010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
107	2026-05-05	동일제강	2126455	kg	26S0500007010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
108	2026-05-08	동일제강	3601269	kg	26S0500008010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
109	2026-05-14	동일제강	3514040	kg	26S0500009010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
110	2026-05-14	동일제강	2958235	kg	26S0500010010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
111	2026-05-05	New Best Wire Industrial Co., Ltd	2739474	kg	26S0500011010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
112	2026-05-12	New Best Wire Industrial Co., Ltd	3056038	kg	26S0500012010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
113	2026-05-13	New Best Wire Industrial Co., Ltd	3969706	kg	26S0500013010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
114	2026-05-15	New Best Wire Industrial Co., Ltd	6547452	kg	26S0500014010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
115	2026-05-15	New Best Wire Industrial Co., Ltd	1987330	kg	26S0500015010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
116	2026-05-05	Nissan Motor Co., Ltd	918795	kg	26S0500016010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
117	2026-05-07	Nissan Motor Co., Ltd	120597	kg	26S0500017010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
118	2026-05-08	Nissan Motor Co., Ltd	581643	kg	26S0500018010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
119	2026-05-14	Nissan Motor Co., Ltd	1285320	kg	26S0500019010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
120	2026-05-14	Nissan Motor Co., Ltd	517657	kg	26S0500020010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
121	2026-05-14	Nissan Motor Co., Ltd	504700	kg	26S0500021010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
122	2026-05-14	Nissan Motor Co., Ltd	454283	kg	26S0500022010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
123	2026-05-15	Nissan Motor Co., Ltd	809424	kg	26S0500023010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
124	2026-05-15	Nissan Motor Co., Ltd	907582	kg	26S0500024010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
125	2026-05-08	포스코인터내셔널	2039911	kg	26S0500025010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
126	2026-05-08	포스코인터내셔널	2034624	kg	26S0500026010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
127	2026-05-11	포스코인터내셔널	4261475	kg	26S0500027010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
128	2026-05-11	포스코인터내셔널	3810366	kg	26S0500028010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
129	2026-05-13	포스코인터내셔널	3746449	kg	26S0500029010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
130	2026-05-15	포스코인터내셔널	1144940	kg	26S0500030010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
131	2026-05-15	포스코인터내셔널	1262236	kg	26S0500031010	WR	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
210	2026-05-11	포스코인터내셔널	18900	kg	01S0000047010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
211	2026-05-03	포스코인터내셔널	24500	kg	01S0000048010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
212	2026-05-07	포스코인터내셔널	11400	kg	01S0000049010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
213	2026-05-14	포스코인터내셔널	20300	kg	01S0000050010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
214	2026-05-02	고려제강	6500	kg	01S0000051010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
215	2026-05-05	고려제강	14200	kg	01S0000052010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
216	2026-05-12	고려제강	19000	kg	01S0000053010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
217	2026-05-09	고려제강	22500	kg	01S0000054010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
218	2026-05-06	고려제강	13100	kg	01S0000055010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
219	2026-05-13	고려제강	9400	kg	01S0000056010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
220	2026-05-01	고려제강	28000	kg	01S0000057010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
221	2026-05-10	고려제강	17300	kg	01S0000058010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
222	2026-05-04	고려제강	11800	kg	01S0000059010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
223	2026-05-14	고려제강	15600	kg	01S0000060010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
146	2026-05-11	한화오션	2226814	kg	26S0500046010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
147	2026-05-12	한화오션	2736078	kg	26S0500047010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
148	2026-05-12	한화오션	5663539	kg	26S0500048010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
149	2026-05-13	한화오션	5117477	kg	26S0500049010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
150	2026-05-15	한화오션	4163165	kg	26S0500050010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
151	2026-05-01	포스코건설	2568237	kg	26S0500051010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
152	2026-05-12	포스코건설	1174293	kg	26S0500052010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
153	2026-05-13	포스코건설	2311583	kg	26S0500053010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
154	2026-05-14	포스코건설	1545887	kg	26S0500054010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
155	2026-05-04	포스코인터내셔널	831290	kg	26S0500055010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
156	2026-05-05	포스코인터내셔널	763495	kg	26S0500056010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
157	2026-05-06	포스코인터내셔널	819382	kg	26S0500057010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
158	2026-05-07	포스코인터내셔널	1703661	kg	26S0500058010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
159	2026-05-11	포스코인터내셔널	872258	kg	26S0500059010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
160	2026-05-12	포스코인터내셔널	69880	kg	26S0500060010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
161	2026-05-12	포스코인터내셔널	197147	kg	26S0500061010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
162	2026-05-13	포스코인터내셔널	782309	kg	26S0500062010	HE	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
163	2026-05-14	포스코인터내셔널	904577	kg	26S0500063010	PJ	2026-05-24 01:09:23.539577+09	2026-05-24 01:09:23.539577+09
263	2026-05-15	포스코인터내셔널	42700	kg	01S0000100010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
164	2026-05-12	현대중공업	12500	kg	01S0000001010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
165	2026-05-04	동일제강	8400	kg	01S0000002010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
166	2026-05-15	고려제강	24000	kg	01S0000003010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
167	2026-05-08	한화오션	9200	kg	01S0000004010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
168	2026-05-11	현대중공업	9800	kg	01S0000005010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
169	2026-05-02	현대중공업	31500	kg	01S0000006010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
170	2026-05-14	현대중공업	18000	kg	01S0000007010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
171	2026-05-06	현대중공업	11200	kg	01S0000008010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
172	2026-05-05	현대중공업	22400	kg	01S0000009010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
173	2026-05-13	현대중공업	14000	kg	01S0000010010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
174	2026-05-09	삼성중공업	42000	kg	01S0000011010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
175	2026-05-04	삼성중공업	8900	kg	01S0000012010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
176	2026-05-12	삼성중공업	27500	kg	01S0000013010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
177	2026-05-01	삼성중공업	19300	kg	01S0000014010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
178	2026-05-07	삼성중공업	13400	kg	01S0000015010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
179	2026-05-10	삼성중공업	5600	kg	01S0000016010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
180	2026-05-15	삼성중공업	3000	kg	01S0000017010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
181	2026-05-03	삼성중공업	7200	kg	01S0000018010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
224	2026-05-07	Nissan Motor Co., Ltd	21500	kg	01S0000061010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
225	2026-05-15	Nissan Motor Co., Ltd	34000	kg	01S0000062010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
226	2026-05-11	Nissan Motor Co., Ltd	16700	kg	01S0000063010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
227	2026-05-03	Nissan Motor Co., Ltd	12900	kg	01S0000064010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
228	2026-05-09	Nissan Motor Co., Ltd	25000	kg	01S0000065010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
229	2026-05-12	Nissan Motor Co., Ltd	18400	kg	01S0000066010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
230	2026-05-05	Nissan Motor Co., Ltd	9100	kg	01S0000067010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
237	2026-05-04	New Best Wire Industrial Co., Ltd	16800	kg	01S0000074010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
238	2026-05-15	New Best Wire Industrial Co., Ltd	28500	kg	01S0000075010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
239	2026-05-08	New Best Wire Industrial Co., Ltd	33000	kg	01S0000076010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
240	2026-05-11	New Best Wire Industrial Co., Ltd	14300	kg	01S0000077010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
241	2026-05-03	New Best Wire Industrial Co., Ltd	21900	kg	01S0000078010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
242	2026-05-14	New Best Wire Industrial Co., Ltd	9600	kg	01S0000079010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
243	2026-05-07	New Best Wire Industrial Co., Ltd	27100	kg	01S0000080010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
244	2026-05-02	동일제강	13500	kg	01S0000081010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
245	2026-05-12	동일제강	19800	kg	01S0000082010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
246	2026-05-05	동일제강	25400	kg	01S0000083010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
231	2026-05-14	Nissan Motor Co., Ltd	22300	kg	01S0000068010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
363	2025-05-01	현대중공업	10799	kg	25S0000001010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
364	2025-05-08	동일제강	7342	kg	25S0000002010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
365	2025-05-24	고려제강	19735	kg	25S0000003010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
366	2025-05-24	한화오션	12315	kg	25S0000004010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
367	2025-05-03	현대중공업	8714	kg	25S0000005010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
368	2025-05-02	현대중공업	27060	kg	25S0000006010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
369	2025-05-07	현대중공업	14453	kg	25S0000007010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
370	2025-05-20	현대중공업	9220	kg	25S0000008010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
371	2025-05-07	현대중공업	17979	kg	25S0000009010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
372	2025-05-23	현대중공업	12202	kg	25S0000010010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
373	2025-05-08	삼성중공업	35888	kg	25S0000011010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
374	2025-05-09	삼성중공업	7519	kg	25S0000012010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
375	2025-05-01	삼성중공업	24225	kg	25S0000013010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
376	2025-05-06	삼성중공업	16904	kg	25S0000014010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
377	2025-05-11	삼성중공업	11655	kg	25S0000015010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
378	2025-05-07	삼성중공업	21191	kg	25S0000016010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
379	2025-05-11	삼성중공업	29558	kg	25S0000017010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
380	2025-05-13	삼성중공업	13935	kg	25S0000018010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
381	2025-05-28	삼성중공업	17003	kg	25S0000019010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
382	2025-05-09	삼성중공업	13767	kg	25S0000020010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
383	2025-05-24	한화오션	33467	kg	25S0000021010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
384	2025-05-04	한화오션	10828	kg	25S0000022010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
385	2025-05-13	한화오션	26022	kg	25S0000023010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
232	2026-05-02	Nissan Motor Co., Ltd	14600	kg	01S0000069010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
233	2026-05-06	Nissan Motor Co., Ltd	31000	kg	01S0000070010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
234	2026-05-13	New Best Wire Industrial Co., Ltd	19500	kg	01S0000071010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
235	2026-05-01	New Best Wire Industrial Co., Ltd	24200	kg	01S0000072010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
236	2026-05-10	New Best Wire Industrial Co., Ltd	11000	kg	01S0000073010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
247	2026-05-09	동일제강	8900	kg	01S0000084010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
248	2026-05-15	동일제강	31200	kg	01S0000085010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
249	2026-05-06	동일제강	16000	kg	01S0000086010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
250	2026-05-13	동일제강	22700	kg	01S0000087010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
251	2026-05-01	동일제강	11300	kg	01S0000088010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
252	2026-05-10	동일제강	29100	kg	01S0000089010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
253	2026-05-04	동일제강	14500	kg	01S0000090010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
254	2026-05-11	현대중공업	26400	kg	01S0000091010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
255	2026-05-14	삼성중공업	38500	kg	01S0000092010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
256	2026-05-03	한화오션	19000	kg	01S0000093010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
257	2026-05-07	포스코건설	12200	kg	01S0000094010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
258	2026-05-12	포스코인터내셔널	7800	kg	01S0000095010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
259	2026-05-05	고려제강	16300	kg	01S0000096010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
260	2026-05-09	Nissan Motor Co., Ltd	23000	kg	01S0000097010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
261	2026-05-02	New Best Wire Industrial Co., Ltd	34500	kg	01S0000098010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
262	2026-05-13	동일제강	11900	kg	01S0000099010	WR	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
561	2025-05-24	삼성중공업	1857292	kg	01S0000101010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
562	2025-05-18	삼성중공업	671243	kg	01S0000102010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
563	2025-05-03	삼성중공업	1909094	kg	01S0000103010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
564	2025-05-19	삼성중공업	8999840	kg	01S0000104010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
565	2025-05-14	삼성중공업	4683308	kg	01S0000105010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
566	2025-05-21	삼성중공업	141209	kg	01S0000106010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
567	2025-05-23	삼성중공업	916893	kg	01S0000107010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
568	2025-05-18	삼성중공업	105366	kg	01S0000108010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
569	2025-05-14	삼성중공업	1525750	kg	01S0000109010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
570	2025-05-08	삼성중공업	2632227	kg	01S0000110010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
571	2025-05-05	포스코건설	41731	kg	01S0000111010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
572	2025-05-07	포스코건설	2143152	kg	01S0000112010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
573	2025-05-25	포스코건설	2298146	kg	01S0000113010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
574	2025-05-11	포스코건설	691455	kg	01S0000114010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
575	2025-05-04	포스코건설	23188	kg	01S0000115010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
576	2025-05-03	포스코건설	1223726	kg	01S0000116010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
577	2025-05-13	포스코인터내셔널	2124650	kg	01S0000117010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
578	2025-05-03	포스코인터내셔널	267440	kg	01S0000118010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
579	2025-05-18	포스코인터내셔널	499261	kg	01S0000119010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
580	2025-05-10	포스코인터내셔널	306661	kg	01S0000120010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
581	2025-05-27	포스코인터내셔널	159939	kg	01S0000121010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
386	2025-05-10	한화오션	9290	kg	25S0000024010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
387	2025-05-20	한화오션	39732	kg	25S0000025010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
388	2025-05-12	한화오션	18926	kg	25S0000026010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
389	2025-05-23	한화오션	15181	kg	25S0000027010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
390	2025-05-22	한화오션	27597	kg	25S0000028010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
391	2025-05-10	한화오션	8145	kg	25S0000029010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
392	2025-05-28	한화오션	23361	kg	25S0000030010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
393	2025-05-04	포스코건설	15230	kg	25S0000031010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
394	2025-05-15	포스코건설	11061	kg	25S0000032010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
395	2025-05-12	포스코건설	19084	kg	25S0000033010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
396	2025-05-12	포스코건설	24814	kg	25S0000034010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
397	2025-05-09	포스코건설	12150	kg	25S0000035010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
398	2025-05-22	포스코건설	17316	kg	25S0000036010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
399	2025-05-20	포스코건설	23349	kg	25S0000037010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
400	2025-05-18	포스코건설	30740	kg	25S0000038010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
401	2025-05-06	포스코건설	9602	kg	25S0000039010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
402	2025-05-09	포스코건설	20140	kg	25S0000040010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
403	2025-05-21	포스코인터내셔널	37036	kg	25S0000041010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
404	2025-05-08	포스코인터내셔널	13032	kg	25S0000042010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
405	2025-05-27	포스코인터내셔널	7555	kg	25S0000043010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
406	2025-05-02	포스코인터내셔널	25866	kg	25S0000044010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
407	2025-05-02	포스코인터내셔널	27238	kg	25S0000045010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
408	2025-05-13	포스코인터내셔널	6339	kg	25S0000046010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
409	2025-05-07	포스코인터내셔널	15626	kg	25S0000047010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
410	2025-05-19	포스코인터내셔널	21837	kg	25S0000048010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
411	2025-05-11	포스코인터내셔널	10119	kg	25S0000049010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
412	2025-05-16	포스코인터내셔널	16671	kg	25S0000050010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
413	2025-05-21	고려제강	5457	kg	25S0000051010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
414	2025-05-09	고려제강	12011	kg	25S0000052010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
415	2025-05-24	고려제강	15465	kg	25S0000053010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
416	2025-05-09	고려제강	19263	kg	25S0000054010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
417	2025-05-14	고려제강	11458	kg	25S0000055010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
418	2025-05-13	고려제강	8363	kg	25S0000056010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
419	2025-05-05	고려제강	23413	kg	25S0000057010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
420	2025-05-03	고려제강	14721	kg	25S0000058010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
421	2025-05-28	고려제강	10331	kg	25S0000059010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
422	2025-05-21	고려제강	12651	kg	25S0000060010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
423	2025-05-22	Nissan Motor Co., Ltd	17543	kg	25S0000061010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
424	2025-05-03	Nissan Motor Co., Ltd	28635	kg	25S0000062010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
425	2025-05-20	Nissan Motor Co., Ltd	14002	kg	25S0000063010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
426	2025-05-17	Nissan Motor Co., Ltd	11604	kg	25S0000064010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
427	2025-05-18	Nissan Motor Co., Ltd	20628	kg	25S0000065010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
428	2025-05-01	Nissan Motor Co., Ltd	16303	kg	25S0000066010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
429	2025-05-04	Nissan Motor Co., Ltd	7899	kg	25S0000067010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
430	2025-05-18	Nissan Motor Co., Ltd	19360	kg	25S0000068010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
431	2025-05-25	Nissan Motor Co., Ltd	12776	kg	25S0000069010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
432	2025-05-04	Nissan Motor Co., Ltd	26786	kg	25S0000070010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
433	2025-05-06	New Best Wire Industrial Co., Ltd	16172	kg	25S0000071010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
434	2025-05-24	New Best Wire Industrial Co., Ltd	20458	kg	25S0000072010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
435	2025-05-09	New Best Wire Industrial Co., Ltd	9763	kg	25S0000073010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
436	2025-05-25	New Best Wire Industrial Co., Ltd	15072	kg	25S0000074010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
437	2025-05-04	New Best Wire Industrial Co., Ltd	23309	kg	25S0000075010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
438	2025-05-10	New Best Wire Industrial Co., Ltd	29272	kg	25S0000076010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
439	2025-05-17	New Best Wire Industrial Co., Ltd	12643	kg	25S0000077010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
440	2025-05-05	New Best Wire Industrial Co., Ltd	18853	kg	25S0000078010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
441	2025-05-06	New Best Wire Industrial Co., Ltd	8038	kg	25S0000079010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
442	2025-05-25	New Best Wire Industrial Co., Ltd	23141	kg	25S0000080010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
443	2025-05-01	동일제강	12045	kg	25S0000081010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
444	2025-05-16	동일제강	17025	kg	25S0000082010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
445	2025-05-12	동일제강	20369	kg	25S0000083010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
446	2025-05-27	동일제강	7902	kg	25S0000084010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
447	2025-05-08	동일제강	27477	kg	25S0000085010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
448	2025-05-19	동일제강	12892	kg	25S0000086010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
449	2025-05-03	동일제강	20309	kg	25S0000087010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
450	2025-05-27	동일제강	9867	kg	25S0000088010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
451	2025-05-25	동일제강	23481	kg	25S0000089010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
452	2025-05-05	동일제강	12372	kg	25S0000090010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
453	2025-05-16	현대중공업	21458	kg	25S0000091010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
454	2025-05-06	삼성중공업	34445	kg	25S0000092010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
455	2025-05-28	한화오션	15703	kg	25S0000093010	HE	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
456	2025-05-07	포스코건설	10500	kg	25S0000094010	PJ	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
457	2025-05-25	포스코인터내셔널	6964	kg	25S0000095010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
458	2025-05-07	고려제강	14229	kg	25S0000096010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
459	2025-05-13	Nissan Motor Co., Ltd	20039	kg	25S0000097010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
460	2025-05-21	New Best Wire Industrial Co., Ltd	31033	kg	25S0000098010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
461	2025-05-17	동일제강	9964	kg	25S0000099010	WR	2026-05-24 22:14:16.583453+09	2026-05-24 22:14:16.583453+09
582	2025-05-21	포스코인터내셔널	604264	kg	01S0000122010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
583	2025-05-03	포스코인터내셔널	135922	kg	01S0000123010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
584	2025-05-28	포스코인터내셔널	940060	kg	01S0000124010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
585	2025-05-08	포스코인터내셔널	382388	kg	01S0000125010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
182	2026-05-11	삼성중공업	21000	kg	01S0000019010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
183	2026-05-08	삼성중공업	6500	kg	01S0000020010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
184	2026-05-14	한화오션	28000	kg	01S0000021010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
185	2026-05-02	한화오션	12800	kg	01S0000022010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
186	2026-05-05	한화오션	9000	kg	01S0000023010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
187	2026-05-12	한화오션	11500	kg	01S0000024010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
188	2026-05-09	한화오션	45000	kg	01S0000025010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
189	2026-05-06	한화오션	21300	kg	01S0000026010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
190	2026-05-13	한화오션	17700	kg	01S0000027010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
191	2026-05-01	한화오션	34200	kg	01S0000028010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
192	2026-05-10	한화오션	9900	kg	01S0000029010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
193	2026-05-04	한화오션	26000	kg	01S0000030010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
194	2026-05-15	포스코건설	18500	kg	01S0000031010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
195	2026-05-11	포스코건설	13200	kg	01S0000032010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
196	2026-05-07	포스코건설	22100	kg	01S0000033010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
197	2026-05-03	포스코건설	30400	kg	01S0000034010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
198	2026-05-12	포스코건설	14800	kg	01S0000035010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
199	2026-05-05	포스코건설	19900	kg	01S0000036010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
200	2026-05-09	포스코건설	27000	kg	01S0000037010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
201	2026-05-14	포스코건설	35600	kg	01S0000038010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
202	2026-05-02	포스코건설	11000	kg	01S0000039010	HE	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
203	2026-05-06	포스코건설	23800	kg	01S0000040010	PJ	2026-05-24 13:41:57.198562+09	2026-05-24 13:41:57.198562+09
586	2025-05-28	포스코인터내셔널	854147	kg	01S0000126010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
587	2025-05-04	포스코인터내셔널	977353	kg	01S0000127010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
588	2025-05-13	포스코인터내셔널	876290	kg	01S0000128010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
589	2025-05-03	한화오션	668226	kg	01S0000129010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
590	2025-05-20	한화오션	791320	kg	01S0000130010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
591	2025-05-21	한화오션	1293711	kg	01S0000131010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
592	2025-05-06	한화오션	54937	kg	01S0000132010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
593	2025-05-18	한화오션	75068	kg	01S0000133010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
594	2025-05-24	한화오션	543483	kg	01S0000134010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
595	2025-05-08	한화오션	681523	kg	01S0000135010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
596	2025-05-25	한화오션	3412986	kg	01S0000136010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
597	2025-05-25	한화오션	782207	kg	01S0000137010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
598	2025-05-02	한화오션	844405	kg	01S0000138010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
599	2025-05-08	한화오션	5654958	kg	01S0000139010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
600	2025-05-27	한화오션	3686721	kg	01S0000140010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
601	2025-05-02	한화오션	1159480	kg	01S0000141010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
602	2025-05-21	현대중공업	1093994	kg	01S0000142010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
603	2025-05-16	현대중공업	294303	kg	01S0000143010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
604	2025-05-13	현대중공업	243379	kg	01S0000144010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
605	2025-05-21	현대중공업	2912491	kg	01S0000145010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
606	2025-05-15	현대중공업	345036	kg	01S0000146010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
607	2025-05-05	현대중공업	296028	kg	01S0000147010	HE	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
608	2025-05-19	현대중공업	2305539	kg	01S0000148010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
609	2025-05-13	현대중공업	594869	kg	01S0000149010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
610	2025-05-12	현대중공업	1108614	kg	01S0000150010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
611	2025-05-08	현대중공업	10896	kg	01S0000151010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
612	2025-05-05	현대중공업	1361401	kg	01S0000152010	PJ	2026-05-24 22:26:37.831075+09	2026-05-24 22:26:37.831075+09
\.


--
-- Data for Name: trigger_events; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.trigger_events (event_id, feature, product_code, customer_id, change_rate, direction, date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pos
--

COPY public.users (user_id, name, role, created_at, updated_at, primary_product_code, employee_no, department, email) FROM stdin;
emp_2026001	이윤진	SALES	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09	\N	\N	\N	\N
emp_2026002	김매니저	MANAGER	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09	\N	\N	\N	\N
emp_2026099	관리자	ADMIN	2026-05-20 23:12:27.707511+09	2026-05-20 23:12:27.707511+09	\N	\N	\N	\N
emp_2026003	박지은	SALES	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09	선재	301096	열연선재마케팅실	jieun.park@posco.com
emp_2026004	박현웅	SALES	2026-05-24 00:45:29.062737+09	2026-05-24 00:45:29.062737+09	후판	299810	후판마케팅실	woong@posco.com
\.


--
-- Name: indicators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.indicators_id_seq', 7531, true);


--
-- Name: sales_actuals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.sales_actuals_id_seq', 1032, true);


--
-- Name: sales_guides_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.sales_guides_id_seq', 1118, true);


--
-- Name: shipments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pos
--

SELECT pg_catalog.setval('public.shipments_id_seq', 1216, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: assigned_customers assigned_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.assigned_customers
    ADD CONSTRAINT assigned_customers_pkey PRIMARY KEY (user_id, customer_id);


--
-- Name: customer_profiles customer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.customer_profiles
    ADD CONSTRAINT customer_profiles_pkey PRIMARY KEY (customer_id);


--
-- Name: indicators indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.indicators
    ADD CONSTRAINT indicators_pkey PRIMARY KEY (id);


--
-- Name: order_lines order_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.order_lines
    ADD CONSTRAINT order_lines_pkey PRIMARY KEY (order_line_no);


--
-- Name: org_hierarchy org_hierarchy_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.org_hierarchy
    ADD CONSTRAINT org_hierarchy_pkey PRIMARY KEY (manager_id, subordinate_id);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (variant_code, variant_name);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (code);


--
-- Name: sales_actuals sales_actuals_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_actuals
    ADD CONSTRAINT sales_actuals_pkey PRIMARY KEY (id);


--
-- Name: sales_guides sales_guides_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_guides
    ADD CONSTRAINT sales_guides_pkey PRIMARY KEY (id);


--
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);


--
-- Name: trigger_events trigger_events_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.trigger_events
    ADD CONSTRAINT trigger_events_pkey PRIMARY KEY (event_id);


--
-- Name: indicators uq_indicator_feature_date_source; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.indicators
    ADD CONSTRAINT uq_indicator_feature_date_source UNIQUE (feature_name, date, source);


--
-- Name: sales_actuals uq_sales_actual_group_prod_cust_ym; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_actuals
    ADD CONSTRAINT uq_sales_actual_group_prod_cust_ym UNIQUE (sales_group, product, customer_name, ym_str);


--
-- Name: sales_guides uq_sales_guide_group_prod_cust_ym; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.sales_guides
    ADD CONSTRAINT uq_sales_guide_group_prod_cust_ym UNIQUE (sales_group, product, customer_name, ym_str);


--
-- Name: shipments uq_shipment_order_date; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT uq_shipment_order_date UNIQUE (order_line_no, shipped_at);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: ix_indicators_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_indicators_date ON public.indicators USING btree (date);


--
-- Name: ix_indicators_feature_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_indicators_feature_name ON public.indicators USING btree (feature_name);


--
-- Name: ix_order_lines_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_lines_customer_name ON public.order_lines USING btree (customer_name);


--
-- Name: ix_order_lines_salesperson; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_lines_salesperson ON public.order_lines USING btree (salesperson);


--
-- Name: ix_order_lines_variant_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_order_lines_variant_code ON public.order_lines USING btree (variant_code);


--
-- Name: ix_product_variants_product; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_product_variants_product ON public.product_variants USING btree (product);


--
-- Name: ix_sales_actuals_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_actuals_customer_name ON public.sales_actuals USING btree (customer_name);


--
-- Name: ix_sales_actuals_product; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_actuals_product ON public.sales_actuals USING btree (product);


--
-- Name: ix_sales_actuals_sales_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_actuals_sales_group ON public.sales_actuals USING btree (sales_group);


--
-- Name: ix_sales_actuals_ym_str; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_actuals_ym_str ON public.sales_actuals USING btree (ym_str);


--
-- Name: ix_sales_guides_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_guides_customer_name ON public.sales_guides USING btree (customer_name);


--
-- Name: ix_sales_guides_product; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_guides_product ON public.sales_guides USING btree (product);


--
-- Name: ix_sales_guides_sales_group; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_guides_sales_group ON public.sales_guides USING btree (sales_group);


--
-- Name: ix_sales_guides_ym_str; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_sales_guides_ym_str ON public.sales_guides USING btree (ym_str);


--
-- Name: ix_shipments_customer_name; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_shipments_customer_name ON public.shipments USING btree (customer_name);


--
-- Name: ix_shipments_order_line_no; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_shipments_order_line_no ON public.shipments USING btree (order_line_no);


--
-- Name: ix_shipments_shipped_at; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_shipments_shipped_at ON public.shipments USING btree (shipped_at);


--
-- Name: ix_shipments_variant_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_shipments_variant_code ON public.shipments USING btree (variant_code);


--
-- Name: ix_trigger_events_customer_id; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_trigger_events_customer_id ON public.trigger_events USING btree (customer_id);


--
-- Name: ix_trigger_events_date; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_trigger_events_date ON public.trigger_events USING btree (date);


--
-- Name: ix_trigger_events_product_code; Type: INDEX; Schema: public; Owner: pos
--

CREATE INDEX ix_trigger_events_product_code ON public.trigger_events USING btree (product_code);


--
-- Name: assigned_customers assigned_customers_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.assigned_customers
    ADD CONSTRAINT assigned_customers_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer_profiles(customer_id) ON DELETE CASCADE;


--
-- Name: assigned_customers assigned_customers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.assigned_customers
    ADD CONSTRAINT assigned_customers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: org_hierarchy org_hierarchy_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.org_hierarchy
    ADD CONSTRAINT org_hierarchy_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: org_hierarchy org_hierarchy_subordinate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pos
--

ALTER TABLE ONLY public.org_hierarchy
    ADD CONSTRAINT org_hierarchy_subordinate_id_fkey FOREIGN KEY (subordinate_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 9pKvqLFum2bObsviCR0UicKS5iVsqoRBndlIA3a7Sk5yUuhmJuTfXG0xxMdpCDZ

