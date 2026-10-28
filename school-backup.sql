--
-- PostgreSQL database dump
--

\restrict l1jAbfh1Xl3APTPbzqPNn0y7aqfSvVv4hRVOoJCoxvcYOeZz46oQpyXAZlgJdob

-- Dumped from database version 18.6 (Debian 18.6-1.pgdg13+2)
-- Dumped by pg_dump version 18.6 (Debian 18.6-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: prisma_contract; Type: SCHEMA; Schema: -; Owner: amazing
--

CREATE SCHEMA prisma_contract;


ALTER SCHEMA prisma_contract OWNER TO amazing;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: contract; Type: TABLE; Schema: prisma_contract; Owner: amazing
--

CREATE TABLE prisma_contract.contract (
    core_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    contract_json jsonb NOT NULL
);


ALTER TABLE prisma_contract.contract OWNER TO amazing;

--
-- Name: ledger; Type: TABLE; Schema: prisma_contract; Owner: amazing
--

CREATE TABLE prisma_contract.ledger (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    space text NOT NULL,
    migration_name text NOT NULL,
    migration_hash text NOT NULL,
    origin_core_hash text,
    origin_profile_hash text,
    destination_core_hash text NOT NULL,
    destination_profile_hash text,
    operations jsonb NOT NULL
);


ALTER TABLE prisma_contract.ledger OWNER TO amazing;

--
-- Name: ledger_id_seq; Type: SEQUENCE; Schema: prisma_contract; Owner: amazing
--

CREATE SEQUENCE prisma_contract.ledger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE prisma_contract.ledger_id_seq OWNER TO amazing;

--
-- Name: ledger_id_seq; Type: SEQUENCE OWNED BY; Schema: prisma_contract; Owner: amazing
--

ALTER SEQUENCE prisma_contract.ledger_id_seq OWNED BY prisma_contract.ledger.id;


--
-- Name: marker; Type: TABLE; Schema: prisma_contract; Owner: amazing
--

CREATE TABLE prisma_contract.marker (
    space text DEFAULT 'app'::text NOT NULL,
    core_hash text NOT NULL,
    profile_hash text NOT NULL,
    contract_json jsonb,
    canonical_version integer,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    app_tag text,
    meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    invariants text[] DEFAULT '{}'::text[] NOT NULL
);


ALTER TABLE prisma_contract.marker OWNER TO amazing;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.admin (
    id text NOT NULL,
    username text NOT NULL
);


ALTER TABLE public.admin OWNER TO amazing;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.announcements (
    "classId" integer,
    date timestamp with time zone NOT NULL,
    description text NOT NULL,
    id integer NOT NULL,
    title text NOT NULL
);


ALTER TABLE public.announcements OWNER TO amazing;

--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.announcements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcements_id_seq OWNER TO amazing;

--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- Name: assignment; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.assignment (
    "dueTime" timestamp with time zone NOT NULL,
    id integer NOT NULL,
    "lessonId" integer NOT NULL,
    "startTime" timestamp with time zone NOT NULL,
    title text NOT NULL
);


ALTER TABLE public.assignment OWNER TO amazing;

--
-- Name: assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assignment_id_seq OWNER TO amazing;

--
-- Name: assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.assignment_id_seq OWNED BY public.assignment.id;


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.attendance (
    date timestamp with time zone NOT NULL,
    id integer NOT NULL,
    "lessonId" integer NOT NULL,
    present boolean NOT NULL,
    "studentId" text NOT NULL
);


ALTER TABLE public.attendance OWNER TO amazing;

--
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_id_seq OWNER TO amazing;

--
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.attendance_id_seq OWNED BY public.attendance.id;


--
-- Name: class; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.class (
    capacity integer NOT NULL,
    "gradeId" integer NOT NULL,
    id integer NOT NULL,
    name text NOT NULL,
    "supervisorId" text NOT NULL
);


ALTER TABLE public.class OWNER TO amazing;

--
-- Name: class_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.class_id_seq OWNER TO amazing;

--
-- Name: class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.class_id_seq OWNED BY public.class.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.events (
    "classId" integer,
    description text NOT NULL,
    "endDate" timestamp with time zone NOT NULL,
    id integer NOT NULL,
    "startDate" timestamp with time zone NOT NULL,
    title text NOT NULL
);


ALTER TABLE public.events OWNER TO amazing;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO amazing;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: exams; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.exams (
    "endTime" timestamp with time zone NOT NULL,
    id integer NOT NULL,
    "lessonId" integer NOT NULL,
    "startTime" timestamp with time zone NOT NULL,
    title text NOT NULL
);


ALTER TABLE public.exams OWNER TO amazing;

--
-- Name: exams_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.exams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exams_id_seq OWNER TO amazing;

--
-- Name: exams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.exams_id_seq OWNED BY public.exams.id;


--
-- Name: grade; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.grade (
    id integer NOT NULL,
    level integer NOT NULL
);


ALTER TABLE public.grade OWNER TO amazing;

--
-- Name: grade_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grade_id_seq OWNER TO amazing;

--
-- Name: grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.grade_id_seq OWNED BY public.grade.id;


--
-- Name: lesson; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.lesson (
    "classId" integer NOT NULL,
    day text NOT NULL,
    "endTime" timestamp with time zone NOT NULL,
    id integer NOT NULL,
    name text NOT NULL,
    "startTime" timestamp with time zone NOT NULL,
    "subjectId" integer NOT NULL,
    "teacherId" text NOT NULL,
    CONSTRAINT lesson_day_check_87ff5c3a CHECK ((day = ANY (ARRAY['MONDAY'::text, 'TUESDAY'::text, 'WEDNESDAY'::text, 'THURSDAY'::text, 'FRIDAY'::text])))
);


ALTER TABLE public.lesson OWNER TO amazing;

--
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_id_seq OWNER TO amazing;

--
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- Name: parent; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.parent (
    address text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    email text,
    id text NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    surname text NOT NULL,
    username text NOT NULL
);


ALTER TABLE public.parent OWNER TO amazing;

--
-- Name: result; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.result (
    "assignmentId" integer,
    "examId" integer,
    id integer NOT NULL,
    score integer NOT NULL,
    "studentId" text NOT NULL
);


ALTER TABLE public.result OWNER TO amazing;

--
-- Name: result_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.result_id_seq OWNER TO amazing;

--
-- Name: result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.result_id_seq OWNED BY public.result.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.student (
    address text NOT NULL,
    "bloodType" text NOT NULL,
    "classId" integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    email text,
    "gradeId" integer NOT NULL,
    id text NOT NULL,
    img text,
    name text NOT NULL,
    "parentId" text NOT NULL,
    phone text,
    sex text NOT NULL,
    surname text NOT NULL,
    username text NOT NULL,
    CONSTRAINT student_sex_check_0c53a478 CHECK ((sex = ANY (ARRAY['MALE'::text, 'FEMALE'::text])))
);


ALTER TABLE public.student OWNER TO amazing;

--
-- Name: studentSubject; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public."studentSubject" (
    "studentId" text NOT NULL,
    "subjectId" integer NOT NULL
);


ALTER TABLE public."studentSubject" OWNER TO amazing;

--
-- Name: subject; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.subject (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.subject OWNER TO amazing;

--
-- Name: subject_id_seq; Type: SEQUENCE; Schema: public; Owner: amazing
--

CREATE SEQUENCE public.subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_id_seq OWNER TO amazing;

--
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amazing
--

ALTER SEQUENCE public.subject_id_seq OWNED BY public.subject.id;


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public.teacher (
    address text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    email text,
    id text NOT NULL,
    img text,
    name text NOT NULL,
    phone text,
    surname text NOT NULL,
    username text NOT NULL
);


ALTER TABLE public.teacher OWNER TO amazing;

--
-- Name: teacherSubject; Type: TABLE; Schema: public; Owner: amazing
--

CREATE TABLE public."teacherSubject" (
    "subjectId" integer NOT NULL,
    "teacherId" text NOT NULL
);


ALTER TABLE public."teacherSubject" OWNER TO amazing;

--
-- Name: ledger id; Type: DEFAULT; Schema: prisma_contract; Owner: amazing
--

ALTER TABLE ONLY prisma_contract.ledger ALTER COLUMN id SET DEFAULT nextval('prisma_contract.ledger_id_seq'::regclass);


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: assignment id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.assignment ALTER COLUMN id SET DEFAULT nextval('public.assignment_id_seq'::regclass);


--
-- Name: attendance id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.attendance ALTER COLUMN id SET DEFAULT nextval('public.attendance_id_seq'::regclass);


--
-- Name: class id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.class ALTER COLUMN id SET DEFAULT nextval('public.class_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: exams id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.exams ALTER COLUMN id SET DEFAULT nextval('public.exams_id_seq'::regclass);


--
-- Name: grade id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.grade ALTER COLUMN id SET DEFAULT nextval('public.grade_id_seq'::regclass);


--
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- Name: result id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.result ALTER COLUMN id SET DEFAULT nextval('public.result_id_seq'::regclass);


--
-- Name: subject id; Type: DEFAULT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.subject ALTER COLUMN id SET DEFAULT nextval('public.subject_id_seq'::regclass);


--
-- Data for Name: contract; Type: TABLE DATA; Schema: prisma_contract; Owner: amazing
--

COPY prisma_contract.contract (core_hash, created_at, contract_json) FROM stdin;
17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68	2026-10-21 12:57:20.531234+00	{"meta": {}, "roots": {"admin": {"model": "Admin", "namespace": "public"}, "class": {"model": "Class", "namespace": "public"}, "exams": {"model": "Exams", "namespace": "public"}, "grade": {"model": "Grade", "namespace": "public"}, "events": {"model": "Events", "namespace": "public"}, "lesson": {"model": "Lesson", "namespace": "public"}, "parent": {"model": "Parent", "namespace": "public"}, "result": {"model": "Result", "namespace": "public"}, "student": {"model": "Student", "namespace": "public"}, "subject": {"model": "Subject", "namespace": "public"}, "teacher": {"model": "Teacher", "namespace": "public"}, "assignment": {"model": "Assignment", "namespace": "public"}, "attendance": {"model": "Attendance", "namespace": "public"}, "announcements": {"model": "Announcements", "namespace": "public"}, "studentSubject": {"model": "StudentSubject", "namespace": "public"}, "teacherSubject": {"model": "TeacherSubject", "namespace": "public"}}, "domain": {"namespaces": {"public": {"enum": {"Day": {"codecId": "pg/text@1", "members": [{"name": "MONDAY", "value": "MONDAY"}, {"name": "TUESDAY", "value": "TUESDAY"}, {"name": "WEDNESDAY", "value": "WEDNESDAY"}, {"name": "THURSDAY", "value": "THURSDAY"}, {"name": "FRIDAY", "value": "FRIDAY"}]}, "userSex": {"codecId": "pg/text@1", "members": [{"name": "MALE", "value": "MALE"}, {"name": "FEMALE", "value": "FEMALE"}]}}, "models": {"Admin": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "username": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "admin", "fields": {"id": {"column": "id"}, "username": {"column": "username"}}, "namespaceId": "public"}, "relations": {}}, "Class": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "name": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "gradeId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "capacity": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "supervisorId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "class", "fields": {"id": {"column": "id"}, "name": {"column": "name"}, "gradeId": {"column": "gradeId"}, "capacity": {"column": "capacity"}, "supervisorId": {"column": "supervisorId"}}, "namespaceId": "public"}, "relations": {"grade": {"on": {"localFields": ["gradeId"], "targetFields": ["id"]}, "to": {"model": "Grade", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "events": {"on": {"localFields": ["id"], "targetFields": ["classId"]}, "to": {"model": "Events", "namespace": "public"}, "cardinality": "1:N"}, "lessons": {"on": {"localFields": ["id"], "targetFields": ["classId"]}, "to": {"model": "Lesson", "namespace": "public"}, "cardinality": "1:N"}, "students": {"on": {"localFields": ["id"], "targetFields": ["classId"]}, "to": {"model": "Student", "namespace": "public"}, "cardinality": "1:N"}, "supervisor": {"on": {"localFields": ["supervisorId"], "targetFields": ["id"]}, "to": {"model": "Teacher", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "announcements": {"on": {"localFields": ["id"], "targetFields": ["classId"]}, "to": {"model": "Announcements", "namespace": "public"}, "cardinality": "1:N"}}}, "Exams": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "title": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "endTime": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "lessonId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "startTime": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}}, "storage": {"table": "exams", "fields": {"id": {"column": "id"}, "title": {"column": "title"}, "endTime": {"column": "endTime"}, "lessonId": {"column": "lessonId"}, "startTime": {"column": "startTime"}}, "namespaceId": "public"}, "relations": {"lesson": {"on": {"localFields": ["lessonId"], "targetFields": ["id"]}, "to": {"model": "Lesson", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "result": {"on": {"localFields": ["id"], "targetFields": ["examId"]}, "to": {"model": "Result", "namespace": "public"}, "cardinality": "1:N"}}}, "Grade": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "level": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}}, "storage": {"table": "grade", "fields": {"id": {"column": "id"}, "level": {"column": "level"}}, "namespaceId": "public"}, "relations": {"classes": {"on": {"localFields": ["id"], "targetFields": ["gradeId"]}, "to": {"model": "Class", "namespace": "public"}, "cardinality": "1:N"}, "students": {"on": {"localFields": ["id"], "targetFields": ["gradeId"]}, "to": {"model": "Student", "namespace": "public"}, "cardinality": "1:N"}}}, "Events": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "title": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "classId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": true}, "endDate": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "startDate": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "description": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "events", "fields": {"id": {"column": "id"}, "title": {"column": "title"}, "classId": {"column": "classId"}, "endDate": {"column": "endDate"}, "startDate": {"column": "startDate"}, "description": {"column": "description"}}, "namespaceId": "public"}, "relations": {"class": {"on": {"localFields": ["classId"], "targetFields": ["id"]}, "to": {"model": "Class", "namespace": "public"}, "nullable": true, "cardinality": "N:1"}}}, "Lesson": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "day": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false, "valueSet": {"plane": "domain", "entityKind": "enum", "entityName": "Day", "namespaceId": "public"}}, "name": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "classId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "endTime": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "startTime": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "subjectId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "teacherId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "lesson", "fields": {"id": {"column": "id"}, "day": {"column": "day"}, "name": {"column": "name"}, "classId": {"column": "classId"}, "endTime": {"column": "endTime"}, "startTime": {"column": "startTime"}, "subjectId": {"column": "subjectId"}, "teacherId": {"column": "teacherId"}}, "namespaceId": "public"}, "relations": {"class": {"on": {"localFields": ["classId"], "targetFields": ["id"]}, "to": {"model": "Class", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "exams": {"on": {"localFields": ["id"], "targetFields": ["lessonId"]}, "to": {"model": "Exams", "namespace": "public"}, "cardinality": "1:N"}, "subject": {"on": {"localFields": ["subjectId"], "targetFields": ["id"]}, "to": {"model": "Subject", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "teacher": {"on": {"localFields": ["teacherId"], "targetFields": ["id"]}, "to": {"model": "Teacher", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "assignment": {"on": {"localFields": ["id"], "targetFields": ["lessonId"]}, "to": {"model": "Assignment", "namespace": "public"}, "cardinality": "1:N"}, "attendance": {"on": {"localFields": ["id"], "targetFields": ["lessonId"]}, "to": {"model": "Attendance", "namespace": "public"}, "cardinality": "1:N"}}}, "Parent": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "name": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "email": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "phone": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "address": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "surname": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "username": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "createdAt": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}}, "storage": {"table": "parent", "fields": {"id": {"column": "id"}, "name": {"column": "name"}, "email": {"column": "email"}, "phone": {"column": "phone"}, "address": {"column": "address"}, "surname": {"column": "surname"}, "username": {"column": "username"}, "createdAt": {"column": "createdAt"}}, "namespaceId": "public"}, "relations": {"students": {"on": {"localFields": ["id"], "targetFields": ["parentId"]}, "to": {"model": "Student", "namespace": "public"}, "cardinality": "1:N"}}}, "Result": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "score": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "examId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": true}, "studentId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "assignmentId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": true}}, "storage": {"table": "result", "fields": {"id": {"column": "id"}, "score": {"column": "score"}, "examId": {"column": "examId"}, "studentId": {"column": "studentId"}, "assignmentId": {"column": "assignmentId"}}, "namespaceId": "public"}, "relations": {"exam": {"on": {"localFields": ["examId"], "targetFields": ["id"]}, "to": {"model": "Exams", "namespace": "public"}, "nullable": true, "cardinality": "N:1"}, "student": {"on": {"localFields": ["studentId"], "targetFields": ["id"]}, "to": {"model": "Student", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "assignment": {"on": {"localFields": ["assignmentId"], "targetFields": ["id"]}, "to": {"model": "Assignment", "namespace": "public"}, "nullable": true, "cardinality": "N:1"}}}, "Student": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "img": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "sex": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false, "valueSet": {"plane": "domain", "entityKind": "enum", "entityName": "userSex", "namespaceId": "public"}}, "name": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "email": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "phone": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "address": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "classId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "gradeId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "surname": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "parentId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "username": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "bloodType": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "createdAt": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}}, "storage": {"table": "student", "fields": {"id": {"column": "id"}, "img": {"column": "img"}, "sex": {"column": "sex"}, "name": {"column": "name"}, "email": {"column": "email"}, "phone": {"column": "phone"}, "address": {"column": "address"}, "classId": {"column": "classId"}, "gradeId": {"column": "gradeId"}, "surname": {"column": "surname"}, "parentId": {"column": "parentId"}, "username": {"column": "username"}, "bloodType": {"column": "bloodType"}, "createdAt": {"column": "createdAt"}}, "namespaceId": "public"}, "relations": {"class": {"on": {"localFields": ["classId"], "targetFields": ["id"]}, "to": {"model": "Class", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "grade": {"on": {"localFields": ["gradeId"], "targetFields": ["id"]}, "to": {"model": "Grade", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "parent": {"on": {"localFields": ["parentId"], "targetFields": ["id"]}, "to": {"model": "Parent", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "result": {"on": {"localFields": ["id"], "targetFields": ["studentId"]}, "to": {"model": "Result", "namespace": "public"}, "cardinality": "1:N"}, "subjects": {"on": {"localFields": ["id"], "targetFields": ["studentId"]}, "to": {"model": "StudentSubject", "namespace": "public"}, "cardinality": "1:N"}, "attendance": {"on": {"localFields": ["id"], "targetFields": ["studentId"]}, "to": {"model": "Attendance", "namespace": "public"}, "cardinality": "1:N"}}}, "Subject": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "name": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "subject", "fields": {"id": {"column": "id"}, "name": {"column": "name"}}, "namespaceId": "public"}, "relations": {"lessons": {"on": {"localFields": ["id"], "targetFields": ["subjectId"]}, "to": {"model": "Lesson", "namespace": "public"}, "cardinality": "1:N"}, "students": {"on": {"localFields": ["id"], "targetFields": ["subjectId"]}, "to": {"model": "StudentSubject", "namespace": "public"}, "cardinality": "1:N"}, "teachers": {"on": {"localFields": ["id"], "targetFields": ["subjectId"]}, "to": {"model": "TeacherSubject", "namespace": "public"}, "cardinality": "1:N"}}}, "Teacher": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "img": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "name": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "email": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "phone": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": true}, "address": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "surname": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "username": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "createdAt": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}}, "storage": {"table": "teacher", "fields": {"id": {"column": "id"}, "img": {"column": "img"}, "name": {"column": "name"}, "email": {"column": "email"}, "phone": {"column": "phone"}, "address": {"column": "address"}, "surname": {"column": "surname"}, "username": {"column": "username"}, "createdAt": {"column": "createdAt"}}, "namespaceId": "public"}, "relations": {"classes": {"on": {"localFields": ["id"], "targetFields": ["supervisorId"]}, "to": {"model": "Class", "namespace": "public"}, "cardinality": "1:N"}, "lessons": {"on": {"localFields": ["id"], "targetFields": ["teacherId"]}, "to": {"model": "Lesson", "namespace": "public"}, "cardinality": "1:N"}, "subjects": {"on": {"localFields": ["id"], "targetFields": ["teacherId"]}, "to": {"model": "TeacherSubject", "namespace": "public"}, "cardinality": "1:N"}}}, "Assignment": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "title": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "dueTime": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "lessonId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "startTime": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}}, "storage": {"table": "assignment", "fields": {"id": {"column": "id"}, "title": {"column": "title"}, "dueTime": {"column": "dueTime"}, "lessonId": {"column": "lessonId"}, "startTime": {"column": "startTime"}}, "namespaceId": "public"}, "relations": {"lesson": {"on": {"localFields": ["lessonId"], "targetFields": ["id"]}, "to": {"model": "Lesson", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "result": {"on": {"localFields": ["id"], "targetFields": ["assignmentId"]}, "to": {"model": "Result", "namespace": "public"}, "cardinality": "1:N"}}}, "Attendance": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "date": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "present": {"type": {"kind": "scalar", "codecId": "pg/bool@1"}, "nullable": false}, "lessonId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "studentId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "attendance", "fields": {"id": {"column": "id"}, "date": {"column": "date"}, "present": {"column": "present"}, "lessonId": {"column": "lessonId"}, "studentId": {"column": "studentId"}}, "namespaceId": "public"}, "relations": {"lesson": {"on": {"localFields": ["lessonId"], "targetFields": ["id"]}, "to": {"model": "Lesson", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "student": {"on": {"localFields": ["studentId"], "targetFields": ["id"]}, "to": {"model": "Student", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}}}, "Announcements": {"fields": {"id": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "date": {"type": {"kind": "scalar", "codecId": "pg/timestamptz-temporal@1"}, "nullable": false}, "title": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "classId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": true}, "description": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "announcements", "fields": {"id": {"column": "id"}, "date": {"column": "date"}, "title": {"column": "title"}, "classId": {"column": "classId"}, "description": {"column": "description"}}, "namespaceId": "public"}, "relations": {"class": {"on": {"localFields": ["classId"], "targetFields": ["id"]}, "to": {"model": "Class", "namespace": "public"}, "nullable": true, "cardinality": "N:1"}}}, "StudentSubject": {"fields": {"studentId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}, "subjectId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}}, "storage": {"table": "studentSubject", "fields": {"studentId": {"column": "studentId"}, "subjectId": {"column": "subjectId"}}, "namespaceId": "public"}, "relations": {"student": {"on": {"localFields": ["studentId"], "targetFields": ["id"]}, "to": {"model": "Student", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "subject": {"on": {"localFields": ["subjectId"], "targetFields": ["id"]}, "to": {"model": "Subject", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}}}, "TeacherSubject": {"fields": {"subjectId": {"type": {"kind": "scalar", "codecId": "pg/int4@1"}, "nullable": false}, "teacherId": {"type": {"kind": "scalar", "codecId": "pg/text@1"}, "nullable": false}}, "storage": {"table": "teacherSubject", "fields": {"subjectId": {"column": "subjectId"}, "teacherId": {"column": "teacherId"}}, "namespaceId": "public"}, "relations": {"subject": {"on": {"localFields": ["subjectId"], "targetFields": ["id"]}, "to": {"model": "Subject", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}, "teacher": {"on": {"localFields": ["teacherId"], "targetFields": ["id"]}, "to": {"model": "Teacher", "namespace": "public"}, "nullable": false, "cardinality": "N:1"}}}}}}}, "target": "postgres", "storage": {"namespaces": {"public": {"id": "public", "entries": {"table": {"admin": {"columns": {"id": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "username": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [], "uniques": [{"columns": ["username"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": []}, "class": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "name": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "gradeId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "capacity": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "supervisorId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [{"name": "class_gradeId_idx_624f4a73", "prefix": "class_gradeId_idx", "unique": false, "columns": ["gradeId"]}, {"name": "class_supervisorId_idx_fe423ed5", "prefix": "class_supervisorId_idx", "unique": false, "columns": ["supervisorId"]}], "uniques": [{"columns": ["name"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["supervisorId"], "tableName": "class", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "teacher", "namespaceId": "public"}}, {"source": {"columns": ["gradeId"], "tableName": "class", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "grade", "namespaceId": "public"}}]}, "exams": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "title": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "endTime": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "lessonId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "startTime": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}}, "indexes": [{"name": "exams_lessonId_idx_e358970d", "prefix": "exams_lessonId_idx", "unique": false, "columns": ["lessonId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["lessonId"], "tableName": "exams", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "lesson", "namespaceId": "public"}}]}, "grade": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "level": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}}, "indexes": [], "uniques": [{"columns": ["level"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": []}, "events": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "title": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "classId": {"codecId": "pg/int4@1", "nullable": true, "nativeType": "int4"}, "endDate": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "startDate": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "description": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [{"name": "events_classId_idx_0089e5e7", "prefix": "events_classId_idx", "unique": false, "columns": ["classId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["classId"], "tableName": "events", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "class", "namespaceId": "public"}}]}, "lesson": {"checks": [{"name": "lesson_day_check_87ff5c3a", "prefix": "lesson_day_check", "expression": "\\"day\\" IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY')"}], "columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "day": {"codecId": "pg/text@1", "nullable": false, "valueSet": {"plane": "storage", "entityKind": "valueSet", "entityName": "Day", "namespaceId": "public"}, "nativeType": "text"}, "name": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "classId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "endTime": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "startTime": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "subjectId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "teacherId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [{"name": "lesson_classId_idx_0089e5e7", "prefix": "lesson_classId_idx", "unique": false, "columns": ["classId"]}, {"name": "lesson_subjectId_idx_84df2a1d", "prefix": "lesson_subjectId_idx", "unique": false, "columns": ["subjectId"]}, {"name": "lesson_teacherId_idx_bc266660", "prefix": "lesson_teacherId_idx", "unique": false, "columns": ["teacherId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["subjectId"], "tableName": "lesson", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "subject", "namespaceId": "public"}}, {"source": {"columns": ["classId"], "tableName": "lesson", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "class", "namespaceId": "public"}}, {"source": {"columns": ["teacherId"], "tableName": "lesson", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "teacher", "namespaceId": "public"}}]}, "parent": {"columns": {"id": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "name": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "email": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "phone": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "address": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "surname": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "username": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "createdAt": {"codecId": "pg/timestamptz-temporal@1", "default": {"kind": "function", "expression": "now()"}, "nullable": false, "nativeType": "timestamptz"}}, "indexes": [], "uniques": [{"columns": ["username"]}, {"columns": ["email"]}, {"columns": ["phone"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": []}, "result": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "score": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "examId": {"codecId": "pg/int4@1", "nullable": true, "nativeType": "int4"}, "studentId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "assignmentId": {"codecId": "pg/int4@1", "nullable": true, "nativeType": "int4"}}, "indexes": [{"name": "result_assignmentId_idx_8cfb4ac4", "prefix": "result_assignmentId_idx", "unique": false, "columns": ["assignmentId"]}, {"name": "result_examId_idx_a57bdadd", "prefix": "result_examId_idx", "unique": false, "columns": ["examId"]}, {"name": "result_studentId_idx_bf255322", "prefix": "result_studentId_idx", "unique": false, "columns": ["studentId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["examId"], "tableName": "result", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "exams", "namespaceId": "public"}}, {"source": {"columns": ["assignmentId"], "tableName": "result", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "assignment", "namespaceId": "public"}}, {"source": {"columns": ["studentId"], "tableName": "result", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "student", "namespaceId": "public"}}]}, "student": {"checks": [{"name": "student_sex_check_0c53a478", "prefix": "student_sex_check", "expression": "\\"sex\\" IN ('MALE', 'FEMALE')"}], "columns": {"id": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "img": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "sex": {"codecId": "pg/text@1", "nullable": false, "valueSet": {"plane": "storage", "entityKind": "valueSet", "entityName": "userSex", "namespaceId": "public"}, "nativeType": "text"}, "name": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "email": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "phone": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "address": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "classId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "gradeId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "surname": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "parentId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "username": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "bloodType": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "createdAt": {"codecId": "pg/timestamptz-temporal@1", "default": {"kind": "function", "expression": "now()"}, "nullable": false, "nativeType": "timestamptz"}}, "indexes": [{"name": "student_classId_idx_0089e5e7", "prefix": "student_classId_idx", "unique": false, "columns": ["classId"]}, {"name": "student_gradeId_idx_624f4a73", "prefix": "student_gradeId_idx", "unique": false, "columns": ["gradeId"]}, {"name": "student_parentId_idx_6a68f597", "prefix": "student_parentId_idx", "unique": false, "columns": ["parentId"]}], "uniques": [{"columns": ["username"]}, {"columns": ["email"]}, {"columns": ["phone"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["parentId"], "tableName": "student", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "parent", "namespaceId": "public"}}, {"source": {"columns": ["classId"], "tableName": "student", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "class", "namespaceId": "public"}}, {"source": {"columns": ["gradeId"], "tableName": "student", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "grade", "namespaceId": "public"}}]}, "subject": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "name": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [], "uniques": [{"columns": ["name"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": []}, "teacher": {"columns": {"id": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "img": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "name": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "email": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "phone": {"codecId": "pg/text@1", "nullable": true, "nativeType": "text"}, "address": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "surname": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "username": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "createdAt": {"codecId": "pg/timestamptz-temporal@1", "default": {"kind": "function", "expression": "now()"}, "nullable": false, "nativeType": "timestamptz"}}, "indexes": [], "uniques": [{"columns": ["username"]}, {"columns": ["email"]}, {"columns": ["phone"]}], "primaryKey": {"columns": ["id"]}, "foreignKeys": []}, "assignment": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "title": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "dueTime": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "lessonId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "startTime": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}}, "indexes": [{"name": "assignment_lessonId_idx_e358970d", "prefix": "assignment_lessonId_idx", "unique": false, "columns": ["lessonId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["lessonId"], "tableName": "assignment", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "lesson", "namespaceId": "public"}}]}, "attendance": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "date": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "present": {"codecId": "pg/bool@1", "nullable": false, "nativeType": "bool"}, "lessonId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "studentId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [{"name": "attendance_lessonId_idx_e358970d", "prefix": "attendance_lessonId_idx", "unique": false, "columns": ["lessonId"]}, {"name": "attendance_studentId_idx_bf255322", "prefix": "attendance_studentId_idx", "unique": false, "columns": ["studentId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["studentId"], "tableName": "attendance", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "student", "namespaceId": "public"}}, {"source": {"columns": ["lessonId"], "tableName": "attendance", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "lesson", "namespaceId": "public"}}]}, "announcements": {"columns": {"id": {"codecId": "pg/int4@1", "default": {"kind": "function", "expression": "autoincrement()"}, "nullable": false, "nativeType": "int4"}, "date": {"codecId": "pg/timestamptz-temporal@1", "nullable": false, "nativeType": "timestamptz"}, "title": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "classId": {"codecId": "pg/int4@1", "nullable": true, "nativeType": "int4"}, "description": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [{"name": "announcements_classId_idx_0089e5e7", "prefix": "announcements_classId_idx", "unique": false, "columns": ["classId"]}], "uniques": [], "primaryKey": {"columns": ["id"]}, "foreignKeys": [{"source": {"columns": ["classId"], "tableName": "announcements", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "class", "namespaceId": "public"}}]}, "studentSubject": {"columns": {"studentId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}, "subjectId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}}, "indexes": [{"name": "studentSubject_studentId_idx_bf255322", "prefix": "studentSubject_studentId_idx", "unique": false, "columns": ["studentId"]}, {"name": "studentSubject_subjectId_idx_84df2a1d", "prefix": "studentSubject_subjectId_idx", "unique": false, "columns": ["subjectId"]}], "uniques": [], "primaryKey": {"columns": ["studentId", "subjectId"]}, "foreignKeys": [{"source": {"columns": ["studentId"], "tableName": "studentSubject", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "student", "namespaceId": "public"}}, {"source": {"columns": ["subjectId"], "tableName": "studentSubject", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "subject", "namespaceId": "public"}}]}, "teacherSubject": {"columns": {"subjectId": {"codecId": "pg/int4@1", "nullable": false, "nativeType": "int4"}, "teacherId": {"codecId": "pg/text@1", "nullable": false, "nativeType": "text"}}, "indexes": [{"name": "teacherSubject_subjectId_idx_84df2a1d", "prefix": "teacherSubject_subjectId_idx", "unique": false, "columns": ["subjectId"]}, {"name": "teacherSubject_teacherId_idx_bc266660", "prefix": "teacherSubject_teacherId_idx", "unique": false, "columns": ["teacherId"]}], "uniques": [], "primaryKey": {"columns": ["teacherId", "subjectId"]}, "foreignKeys": [{"source": {"columns": ["teacherId"], "tableName": "teacherSubject", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "teacher", "namespaceId": "public"}}, {"source": {"columns": ["subjectId"], "tableName": "teacherSubject", "namespaceId": "public"}, "target": {"columns": ["id"], "tableName": "subject", "namespaceId": "public"}}]}}, "valueSet": {"Day": {"kind": "valueSet", "values": ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"]}, "userSex": {"kind": "valueSet", "values": ["MALE", "FEMALE"]}}}}}, "storageHash": "17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68"}, "extensions": {}, "profileHash": "3916f444a8a17ad749191acf9e08dad97d1a327b88c2f1d45d12f240296aa8b2", "capabilities": {"sql": {"enums": true, "lateral": true, "returning": true, "scalarList": true, "checkConstraint": true, "defaultInInsert": true}, "postgres": {"limit": true, "jsonAgg": true, "lateral": true, "orderBy": true, "returning": true, "distinctOn": true}}, "targetFamily": "sql"}
\.


--
-- Data for Name: ledger; Type: TABLE DATA; Schema: prisma_contract; Owner: amazing
--

COPY prisma_contract.ledger (id, created_at, space, migration_name, migration_hash, origin_core_hash, origin_profile_hash, destination_core_hash, destination_profile_hash, operations) FROM stdin;
1	2026-10-21 12:57:20.531234+00	app		17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68		\N	17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68	\N	[{"id": "table.admin", "label": "Create table \\"admin\\"", "target": {"id": "postgres", "details": {"name": "admin", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"admin\\" (\\n  \\"id\\" text NOT NULL,\\n  \\"username\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"admin\\""}], "summary": "Creates table \\"admin\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"admin\\""], "description": "ensure table \\"admin\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"admin\\""], "description": "verify table \\"admin\\" exists"}], "operationClass": "additive"}, {"id": "table.announcements", "label": "Create table \\"announcements\\"", "target": {"id": "postgres", "details": {"name": "announcements", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"announcements\\" (\\n  \\"classId\\" int4,\\n  \\"date\\" timestamptz NOT NULL,\\n  \\"description\\" text NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"title\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"announcements\\""}], "summary": "Creates table \\"announcements\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"announcements\\""], "description": "ensure table \\"announcements\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"announcements\\""], "description": "verify table \\"announcements\\" exists"}], "operationClass": "additive"}, {"id": "table.assignment", "label": "Create table \\"assignment\\"", "target": {"id": "postgres", "details": {"name": "assignment", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"assignment\\" (\\n  \\"dueTime\\" timestamptz NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"lessonId\\" int4 NOT NULL,\\n  \\"startTime\\" timestamptz NOT NULL,\\n  \\"title\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"assignment\\""}], "summary": "Creates table \\"assignment\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"assignment\\""], "description": "ensure table \\"assignment\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"assignment\\""], "description": "verify table \\"assignment\\" exists"}], "operationClass": "additive"}, {"id": "table.attendance", "label": "Create table \\"attendance\\"", "target": {"id": "postgres", "details": {"name": "attendance", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"attendance\\" (\\n  \\"date\\" timestamptz NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"lessonId\\" int4 NOT NULL,\\n  \\"present\\" bool NOT NULL,\\n  \\"studentId\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"attendance\\""}], "summary": "Creates table \\"attendance\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"attendance\\""], "description": "ensure table \\"attendance\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"attendance\\""], "description": "verify table \\"attendance\\" exists"}], "operationClass": "additive"}, {"id": "table.class", "label": "Create table \\"class\\"", "target": {"id": "postgres", "details": {"name": "class", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"class\\" (\\n  \\"capacity\\" int4 NOT NULL,\\n  \\"gradeId\\" int4 NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"name\\" text NOT NULL,\\n  \\"supervisorId\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"class\\""}], "summary": "Creates table \\"class\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"class\\""], "description": "ensure table \\"class\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"class\\""], "description": "verify table \\"class\\" exists"}], "operationClass": "additive"}, {"id": "table.events", "label": "Create table \\"events\\"", "target": {"id": "postgres", "details": {"name": "events", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"events\\" (\\n  \\"classId\\" int4,\\n  \\"description\\" text NOT NULL,\\n  \\"endDate\\" timestamptz NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"startDate\\" timestamptz NOT NULL,\\n  \\"title\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"events\\""}], "summary": "Creates table \\"events\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"events\\""], "description": "ensure table \\"events\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"events\\""], "description": "verify table \\"events\\" exists"}], "operationClass": "additive"}, {"id": "table.exams", "label": "Create table \\"exams\\"", "target": {"id": "postgres", "details": {"name": "exams", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"exams\\" (\\n  \\"endTime\\" timestamptz NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"lessonId\\" int4 NOT NULL,\\n  \\"startTime\\" timestamptz NOT NULL,\\n  \\"title\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"exams\\""}], "summary": "Creates table \\"exams\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"exams\\""], "description": "ensure table \\"exams\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"exams\\""], "description": "verify table \\"exams\\" exists"}], "operationClass": "additive"}, {"id": "table.grade", "label": "Create table \\"grade\\"", "target": {"id": "postgres", "details": {"name": "grade", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"grade\\" (\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"level\\" int4 NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"grade\\""}], "summary": "Creates table \\"grade\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"grade\\""], "description": "ensure table \\"grade\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"grade\\""], "description": "verify table \\"grade\\" exists"}], "operationClass": "additive"}, {"id": "table.lesson", "label": "Create table \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"lesson\\" (\\n  \\"classId\\" int4 NOT NULL,\\n  \\"day\\" text NOT NULL,\\n  \\"endTime\\" timestamptz NOT NULL,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"name\\" text NOT NULL,\\n  \\"startTime\\" timestamptz NOT NULL,\\n  \\"subjectId\\" int4 NOT NULL,\\n  \\"teacherId\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\"),\\n  CONSTRAINT \\"lesson_day_check_87ff5c3a\\" CHECK (\\"day\\" IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY'))\\n)", "params": [], "description": "create table \\"lesson\\""}], "summary": "Creates table \\"lesson\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson\\""], "description": "ensure table \\"lesson\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson\\""], "description": "verify table \\"lesson\\" exists"}], "operationClass": "additive"}, {"id": "table.parent", "label": "Create table \\"parent\\"", "target": {"id": "postgres", "details": {"name": "parent", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"parent\\" (\\n  \\"address\\" text NOT NULL,\\n  \\"createdAt\\" timestamptz DEFAULT (now()) NOT NULL,\\n  \\"email\\" text,\\n  \\"id\\" text NOT NULL,\\n  \\"name\\" text NOT NULL,\\n  \\"phone\\" text NOT NULL,\\n  \\"surname\\" text NOT NULL,\\n  \\"username\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"parent\\""}], "summary": "Creates table \\"parent\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"parent\\""], "description": "ensure table \\"parent\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"parent\\""], "description": "verify table \\"parent\\" exists"}], "operationClass": "additive"}, {"id": "table.result", "label": "Create table \\"result\\"", "target": {"id": "postgres", "details": {"name": "result", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"result\\" (\\n  \\"assignmentId\\" int4,\\n  \\"examId\\" int4,\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"score\\" int4 NOT NULL,\\n  \\"studentId\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"result\\""}], "summary": "Creates table \\"result\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"result\\""], "description": "ensure table \\"result\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"result\\""], "description": "verify table \\"result\\" exists"}], "operationClass": "additive"}, {"id": "table.student", "label": "Create table \\"student\\"", "target": {"id": "postgres", "details": {"name": "student", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"student\\" (\\n  \\"address\\" text NOT NULL,\\n  \\"bloodType\\" text NOT NULL,\\n  \\"classId\\" int4 NOT NULL,\\n  \\"createdAt\\" timestamptz DEFAULT (now()) NOT NULL,\\n  \\"email\\" text,\\n  \\"gradeId\\" int4 NOT NULL,\\n  \\"id\\" text NOT NULL,\\n  \\"img\\" text,\\n  \\"name\\" text NOT NULL,\\n  \\"parentId\\" text NOT NULL,\\n  \\"phone\\" text,\\n  \\"sex\\" text NOT NULL,\\n  \\"surname\\" text NOT NULL,\\n  \\"username\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\"),\\n  CONSTRAINT \\"student_sex_check_0c53a478\\" CHECK (\\"sex\\" IN ('MALE', 'FEMALE'))\\n)", "params": [], "description": "create table \\"student\\""}], "summary": "Creates table \\"student\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"student\\""], "description": "ensure table \\"student\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"student\\""], "description": "verify table \\"student\\" exists"}], "operationClass": "additive"}, {"id": "table.studentSubject", "label": "Create table \\"studentSubject\\"", "target": {"id": "postgres", "details": {"name": "studentSubject", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"studentSubject\\" (\\n  \\"studentId\\" text NOT NULL,\\n  \\"subjectId\\" int4 NOT NULL,\\n  PRIMARY KEY (\\"studentId\\", \\"subjectId\\")\\n)", "params": [], "description": "create table \\"studentSubject\\""}], "summary": "Creates table \\"studentSubject\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"studentSubject\\""], "description": "ensure table \\"studentSubject\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"studentSubject\\""], "description": "verify table \\"studentSubject\\" exists"}], "operationClass": "additive"}, {"id": "table.subject", "label": "Create table \\"subject\\"", "target": {"id": "postgres", "details": {"name": "subject", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"subject\\" (\\n  \\"id\\" SERIAL NOT NULL,\\n  \\"name\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"subject\\""}], "summary": "Creates table \\"subject\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"subject\\""], "description": "ensure table \\"subject\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"subject\\""], "description": "verify table \\"subject\\" exists"}], "operationClass": "additive"}, {"id": "table.teacher", "label": "Create table \\"teacher\\"", "target": {"id": "postgres", "details": {"name": "teacher", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"teacher\\" (\\n  \\"address\\" text NOT NULL,\\n  \\"createdAt\\" timestamptz DEFAULT (now()) NOT NULL,\\n  \\"email\\" text,\\n  \\"id\\" text NOT NULL,\\n  \\"img\\" text,\\n  \\"name\\" text NOT NULL,\\n  \\"phone\\" text,\\n  \\"surname\\" text NOT NULL,\\n  \\"username\\" text NOT NULL,\\n  PRIMARY KEY (\\"id\\")\\n)", "params": [], "description": "create table \\"teacher\\""}], "summary": "Creates table \\"teacher\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacher\\""], "description": "ensure table \\"teacher\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacher\\""], "description": "verify table \\"teacher\\" exists"}], "operationClass": "additive"}, {"id": "table.teacherSubject", "label": "Create table \\"teacherSubject\\"", "target": {"id": "postgres", "details": {"name": "teacherSubject", "schema": "public", "objectType": "table"}}, "execute": [{"sql": "CREATE TABLE \\"public\\".\\"teacherSubject\\" (\\n  \\"subjectId\\" int4 NOT NULL,\\n  \\"teacherId\\" text NOT NULL,\\n  PRIMARY KEY (\\"teacherId\\", \\"subjectId\\")\\n)", "params": [], "description": "create table \\"teacherSubject\\""}], "summary": "Creates table \\"teacherSubject\\"", "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacherSubject\\""], "description": "ensure table \\"teacherSubject\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacherSubject\\""], "description": "verify table \\"teacherSubject\\" exists"}], "operationClass": "additive"}, {"id": "unique.admin.admin_username_key", "label": "Add unique constraint on \\"admin\\" (username)", "target": {"id": "postgres", "details": {"name": "admin_username_key", "table": "admin", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"admin\\" ADD CONSTRAINT \\"admin_username_key\\" UNIQUE (\\"username\\")", "description": "add unique constraint \\"admin_username_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["admin_username_key", "public", "\\"public\\".\\"admin\\""], "description": "ensure constraint \\"admin_username_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["admin_username_key", "public", "\\"public\\".\\"admin\\""], "description": "verify constraint \\"admin_username_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.class.class_name_key", "label": "Add unique constraint on \\"class\\" (name)", "target": {"id": "postgres", "details": {"name": "class_name_key", "table": "class", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"class\\" ADD CONSTRAINT \\"class_name_key\\" UNIQUE (\\"name\\")", "description": "add unique constraint \\"class_name_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["class_name_key", "public", "\\"public\\".\\"class\\""], "description": "ensure constraint \\"class_name_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["class_name_key", "public", "\\"public\\".\\"class\\""], "description": "verify constraint \\"class_name_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.grade.grade_level_key", "label": "Add unique constraint on \\"grade\\" (level)", "target": {"id": "postgres", "details": {"name": "grade_level_key", "table": "grade", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"grade\\" ADD CONSTRAINT \\"grade_level_key\\" UNIQUE (\\"level\\")", "description": "add unique constraint \\"grade_level_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["grade_level_key", "public", "\\"public\\".\\"grade\\""], "description": "ensure constraint \\"grade_level_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["grade_level_key", "public", "\\"public\\".\\"grade\\""], "description": "verify constraint \\"grade_level_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.parent.parent_username_key", "label": "Add unique constraint on \\"parent\\" (username)", "target": {"id": "postgres", "details": {"name": "parent_username_key", "table": "parent", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"parent\\" ADD CONSTRAINT \\"parent_username_key\\" UNIQUE (\\"username\\")", "description": "add unique constraint \\"parent_username_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["parent_username_key", "public", "\\"public\\".\\"parent\\""], "description": "ensure constraint \\"parent_username_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["parent_username_key", "public", "\\"public\\".\\"parent\\""], "description": "verify constraint \\"parent_username_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.parent.parent_email_key", "label": "Add unique constraint on \\"parent\\" (email)", "target": {"id": "postgres", "details": {"name": "parent_email_key", "table": "parent", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"parent\\" ADD CONSTRAINT \\"parent_email_key\\" UNIQUE (\\"email\\")", "description": "add unique constraint \\"parent_email_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["parent_email_key", "public", "\\"public\\".\\"parent\\""], "description": "ensure constraint \\"parent_email_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["parent_email_key", "public", "\\"public\\".\\"parent\\""], "description": "verify constraint \\"parent_email_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.parent.parent_phone_key", "label": "Add unique constraint on \\"parent\\" (phone)", "target": {"id": "postgres", "details": {"name": "parent_phone_key", "table": "parent", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"parent\\" ADD CONSTRAINT \\"parent_phone_key\\" UNIQUE (\\"phone\\")", "description": "add unique constraint \\"parent_phone_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["parent_phone_key", "public", "\\"public\\".\\"parent\\""], "description": "ensure constraint \\"parent_phone_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["parent_phone_key", "public", "\\"public\\".\\"parent\\""], "description": "verify constraint \\"parent_phone_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.student.student_username_key", "label": "Add unique constraint on \\"student\\" (username)", "target": {"id": "postgres", "details": {"name": "student_username_key", "table": "student", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"student\\" ADD CONSTRAINT \\"student_username_key\\" UNIQUE (\\"username\\")", "description": "add unique constraint \\"student_username_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_username_key", "public", "\\"public\\".\\"student\\""], "description": "ensure constraint \\"student_username_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_username_key", "public", "\\"public\\".\\"student\\""], "description": "verify constraint \\"student_username_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.student.student_email_key", "label": "Add unique constraint on \\"student\\" (email)", "target": {"id": "postgres", "details": {"name": "student_email_key", "table": "student", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"student\\" ADD CONSTRAINT \\"student_email_key\\" UNIQUE (\\"email\\")", "description": "add unique constraint \\"student_email_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_email_key", "public", "\\"public\\".\\"student\\""], "description": "ensure constraint \\"student_email_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_email_key", "public", "\\"public\\".\\"student\\""], "description": "verify constraint \\"student_email_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.student.student_phone_key", "label": "Add unique constraint on \\"student\\" (phone)", "target": {"id": "postgres", "details": {"name": "student_phone_key", "table": "student", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"student\\" ADD CONSTRAINT \\"student_phone_key\\" UNIQUE (\\"phone\\")", "description": "add unique constraint \\"student_phone_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_phone_key", "public", "\\"public\\".\\"student\\""], "description": "ensure constraint \\"student_phone_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_phone_key", "public", "\\"public\\".\\"student\\""], "description": "verify constraint \\"student_phone_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.subject.subject_name_key", "label": "Add unique constraint on \\"subject\\" (name)", "target": {"id": "postgres", "details": {"name": "subject_name_key", "table": "subject", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"subject\\" ADD CONSTRAINT \\"subject_name_key\\" UNIQUE (\\"name\\")", "description": "add unique constraint \\"subject_name_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["subject_name_key", "public", "\\"public\\".\\"subject\\""], "description": "ensure constraint \\"subject_name_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["subject_name_key", "public", "\\"public\\".\\"subject\\""], "description": "verify constraint \\"subject_name_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.teacher.teacher_username_key", "label": "Add unique constraint on \\"teacher\\" (username)", "target": {"id": "postgres", "details": {"name": "teacher_username_key", "table": "teacher", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"teacher\\" ADD CONSTRAINT \\"teacher_username_key\\" UNIQUE (\\"username\\")", "description": "add unique constraint \\"teacher_username_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacher_username_key", "public", "\\"public\\".\\"teacher\\""], "description": "ensure constraint \\"teacher_username_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacher_username_key", "public", "\\"public\\".\\"teacher\\""], "description": "verify constraint \\"teacher_username_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.teacher.teacher_email_key", "label": "Add unique constraint on \\"teacher\\" (email)", "target": {"id": "postgres", "details": {"name": "teacher_email_key", "table": "teacher", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"teacher\\" ADD CONSTRAINT \\"teacher_email_key\\" UNIQUE (\\"email\\")", "description": "add unique constraint \\"teacher_email_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacher_email_key", "public", "\\"public\\".\\"teacher\\""], "description": "ensure constraint \\"teacher_email_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacher_email_key", "public", "\\"public\\".\\"teacher\\""], "description": "verify constraint \\"teacher_email_key\\" exists"}], "operationClass": "additive"}, {"id": "unique.teacher.teacher_phone_key", "label": "Add unique constraint on \\"teacher\\" (phone)", "target": {"id": "postgres", "details": {"name": "teacher_phone_key", "table": "teacher", "schema": "public", "objectType": "unique"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"teacher\\" ADD CONSTRAINT \\"teacher_phone_key\\" UNIQUE (\\"phone\\")", "description": "add unique constraint \\"teacher_phone_key\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacher_phone_key", "public", "\\"public\\".\\"teacher\\""], "description": "ensure constraint \\"teacher_phone_key\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacher_phone_key", "public", "\\"public\\".\\"teacher\\""], "description": "verify constraint \\"teacher_phone_key\\" exists"}], "operationClass": "additive"}, {"id": "index.announcements.announcements_classId_idx_0089e5e7", "label": "Create index \\"announcements_classId_idx_0089e5e7\\" on \\"announcements\\"", "target": {"id": "postgres", "details": {"name": "announcements_classId_idx_0089e5e7", "table": "announcements", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"announcements_classId_idx_0089e5e7\\" ON \\"public\\".\\"announcements\\" (\\"classId\\")", "params": [], "description": "create index \\"announcements_classId_idx_0089e5e7\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"announcements_classId_idx_0089e5e7\\""], "description": "ensure index \\"announcements_classId_idx_0089e5e7\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"announcements_classId_idx_0089e5e7\\""], "description": "verify index \\"announcements_classId_idx_0089e5e7\\" exists"}], "operationClass": "additive"}, {"id": "index.assignment.assignment_lessonId_idx_e358970d", "label": "Create index \\"assignment_lessonId_idx_e358970d\\" on \\"assignment\\"", "target": {"id": "postgres", "details": {"name": "assignment_lessonId_idx_e358970d", "table": "assignment", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"assignment_lessonId_idx_e358970d\\" ON \\"public\\".\\"assignment\\" (\\"lessonId\\")", "params": [], "description": "create index \\"assignment_lessonId_idx_e358970d\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"assignment_lessonId_idx_e358970d\\""], "description": "ensure index \\"assignment_lessonId_idx_e358970d\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"assignment_lessonId_idx_e358970d\\""], "description": "verify index \\"assignment_lessonId_idx_e358970d\\" exists"}], "operationClass": "additive"}, {"id": "index.attendance.attendance_lessonId_idx_e358970d", "label": "Create index \\"attendance_lessonId_idx_e358970d\\" on \\"attendance\\"", "target": {"id": "postgres", "details": {"name": "attendance_lessonId_idx_e358970d", "table": "attendance", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"attendance_lessonId_idx_e358970d\\" ON \\"public\\".\\"attendance\\" (\\"lessonId\\")", "params": [], "description": "create index \\"attendance_lessonId_idx_e358970d\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"attendance_lessonId_idx_e358970d\\""], "description": "ensure index \\"attendance_lessonId_idx_e358970d\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"attendance_lessonId_idx_e358970d\\""], "description": "verify index \\"attendance_lessonId_idx_e358970d\\" exists"}], "operationClass": "additive"}, {"id": "index.attendance.attendance_studentId_idx_bf255322", "label": "Create index \\"attendance_studentId_idx_bf255322\\" on \\"attendance\\"", "target": {"id": "postgres", "details": {"name": "attendance_studentId_idx_bf255322", "table": "attendance", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"attendance_studentId_idx_bf255322\\" ON \\"public\\".\\"attendance\\" (\\"studentId\\")", "params": [], "description": "create index \\"attendance_studentId_idx_bf255322\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"attendance_studentId_idx_bf255322\\""], "description": "ensure index \\"attendance_studentId_idx_bf255322\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"attendance_studentId_idx_bf255322\\""], "description": "verify index \\"attendance_studentId_idx_bf255322\\" exists"}], "operationClass": "additive"}, {"id": "index.class.class_gradeId_idx_624f4a73", "label": "Create index \\"class_gradeId_idx_624f4a73\\" on \\"class\\"", "target": {"id": "postgres", "details": {"name": "class_gradeId_idx_624f4a73", "table": "class", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"class_gradeId_idx_624f4a73\\" ON \\"public\\".\\"class\\" (\\"gradeId\\")", "params": [], "description": "create index \\"class_gradeId_idx_624f4a73\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"class_gradeId_idx_624f4a73\\""], "description": "ensure index \\"class_gradeId_idx_624f4a73\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"class_gradeId_idx_624f4a73\\""], "description": "verify index \\"class_gradeId_idx_624f4a73\\" exists"}], "operationClass": "additive"}, {"id": "index.class.class_supervisorId_idx_fe423ed5", "label": "Create index \\"class_supervisorId_idx_fe423ed5\\" on \\"class\\"", "target": {"id": "postgres", "details": {"name": "class_supervisorId_idx_fe423ed5", "table": "class", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"class_supervisorId_idx_fe423ed5\\" ON \\"public\\".\\"class\\" (\\"supervisorId\\")", "params": [], "description": "create index \\"class_supervisorId_idx_fe423ed5\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"class_supervisorId_idx_fe423ed5\\""], "description": "ensure index \\"class_supervisorId_idx_fe423ed5\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"class_supervisorId_idx_fe423ed5\\""], "description": "verify index \\"class_supervisorId_idx_fe423ed5\\" exists"}], "operationClass": "additive"}, {"id": "index.events.events_classId_idx_0089e5e7", "label": "Create index \\"events_classId_idx_0089e5e7\\" on \\"events\\"", "target": {"id": "postgres", "details": {"name": "events_classId_idx_0089e5e7", "table": "events", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"events_classId_idx_0089e5e7\\" ON \\"public\\".\\"events\\" (\\"classId\\")", "params": [], "description": "create index \\"events_classId_idx_0089e5e7\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"events_classId_idx_0089e5e7\\""], "description": "ensure index \\"events_classId_idx_0089e5e7\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"events_classId_idx_0089e5e7\\""], "description": "verify index \\"events_classId_idx_0089e5e7\\" exists"}], "operationClass": "additive"}, {"id": "index.exams.exams_lessonId_idx_e358970d", "label": "Create index \\"exams_lessonId_idx_e358970d\\" on \\"exams\\"", "target": {"id": "postgres", "details": {"name": "exams_lessonId_idx_e358970d", "table": "exams", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"exams_lessonId_idx_e358970d\\" ON \\"public\\".\\"exams\\" (\\"lessonId\\")", "params": [], "description": "create index \\"exams_lessonId_idx_e358970d\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"exams_lessonId_idx_e358970d\\""], "description": "ensure index \\"exams_lessonId_idx_e358970d\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"exams_lessonId_idx_e358970d\\""], "description": "verify index \\"exams_lessonId_idx_e358970d\\" exists"}], "operationClass": "additive"}, {"id": "index.lesson.lesson_classId_idx_0089e5e7", "label": "Create index \\"lesson_classId_idx_0089e5e7\\" on \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson_classId_idx_0089e5e7", "table": "lesson", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"lesson_classId_idx_0089e5e7\\" ON \\"public\\".\\"lesson\\" (\\"classId\\")", "params": [], "description": "create index \\"lesson_classId_idx_0089e5e7\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson_classId_idx_0089e5e7\\""], "description": "ensure index \\"lesson_classId_idx_0089e5e7\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson_classId_idx_0089e5e7\\""], "description": "verify index \\"lesson_classId_idx_0089e5e7\\" exists"}], "operationClass": "additive"}, {"id": "index.lesson.lesson_subjectId_idx_84df2a1d", "label": "Create index \\"lesson_subjectId_idx_84df2a1d\\" on \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson_subjectId_idx_84df2a1d", "table": "lesson", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"lesson_subjectId_idx_84df2a1d\\" ON \\"public\\".\\"lesson\\" (\\"subjectId\\")", "params": [], "description": "create index \\"lesson_subjectId_idx_84df2a1d\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson_subjectId_idx_84df2a1d\\""], "description": "ensure index \\"lesson_subjectId_idx_84df2a1d\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson_subjectId_idx_84df2a1d\\""], "description": "verify index \\"lesson_subjectId_idx_84df2a1d\\" exists"}], "operationClass": "additive"}, {"id": "index.lesson.lesson_teacherId_idx_bc266660", "label": "Create index \\"lesson_teacherId_idx_bc266660\\" on \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson_teacherId_idx_bc266660", "table": "lesson", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"lesson_teacherId_idx_bc266660\\" ON \\"public\\".\\"lesson\\" (\\"teacherId\\")", "params": [], "description": "create index \\"lesson_teacherId_idx_bc266660\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson_teacherId_idx_bc266660\\""], "description": "ensure index \\"lesson_teacherId_idx_bc266660\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"lesson_teacherId_idx_bc266660\\""], "description": "verify index \\"lesson_teacherId_idx_bc266660\\" exists"}], "operationClass": "additive"}, {"id": "index.result.result_assignmentId_idx_8cfb4ac4", "label": "Create index \\"result_assignmentId_idx_8cfb4ac4\\" on \\"result\\"", "target": {"id": "postgres", "details": {"name": "result_assignmentId_idx_8cfb4ac4", "table": "result", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"result_assignmentId_idx_8cfb4ac4\\" ON \\"public\\".\\"result\\" (\\"assignmentId\\")", "params": [], "description": "create index \\"result_assignmentId_idx_8cfb4ac4\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"result_assignmentId_idx_8cfb4ac4\\""], "description": "ensure index \\"result_assignmentId_idx_8cfb4ac4\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"result_assignmentId_idx_8cfb4ac4\\""], "description": "verify index \\"result_assignmentId_idx_8cfb4ac4\\" exists"}], "operationClass": "additive"}, {"id": "index.result.result_examId_idx_a57bdadd", "label": "Create index \\"result_examId_idx_a57bdadd\\" on \\"result\\"", "target": {"id": "postgres", "details": {"name": "result_examId_idx_a57bdadd", "table": "result", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"result_examId_idx_a57bdadd\\" ON \\"public\\".\\"result\\" (\\"examId\\")", "params": [], "description": "create index \\"result_examId_idx_a57bdadd\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"result_examId_idx_a57bdadd\\""], "description": "ensure index \\"result_examId_idx_a57bdadd\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"result_examId_idx_a57bdadd\\""], "description": "verify index \\"result_examId_idx_a57bdadd\\" exists"}], "operationClass": "additive"}, {"id": "index.result.result_studentId_idx_bf255322", "label": "Create index \\"result_studentId_idx_bf255322\\" on \\"result\\"", "target": {"id": "postgres", "details": {"name": "result_studentId_idx_bf255322", "table": "result", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"result_studentId_idx_bf255322\\" ON \\"public\\".\\"result\\" (\\"studentId\\")", "params": [], "description": "create index \\"result_studentId_idx_bf255322\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"result_studentId_idx_bf255322\\""], "description": "ensure index \\"result_studentId_idx_bf255322\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"result_studentId_idx_bf255322\\""], "description": "verify index \\"result_studentId_idx_bf255322\\" exists"}], "operationClass": "additive"}, {"id": "index.student.student_classId_idx_0089e5e7", "label": "Create index \\"student_classId_idx_0089e5e7\\" on \\"student\\"", "target": {"id": "postgres", "details": {"name": "student_classId_idx_0089e5e7", "table": "student", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"student_classId_idx_0089e5e7\\" ON \\"public\\".\\"student\\" (\\"classId\\")", "params": [], "description": "create index \\"student_classId_idx_0089e5e7\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"student_classId_idx_0089e5e7\\""], "description": "ensure index \\"student_classId_idx_0089e5e7\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"student_classId_idx_0089e5e7\\""], "description": "verify index \\"student_classId_idx_0089e5e7\\" exists"}], "operationClass": "additive"}, {"id": "index.student.student_gradeId_idx_624f4a73", "label": "Create index \\"student_gradeId_idx_624f4a73\\" on \\"student\\"", "target": {"id": "postgres", "details": {"name": "student_gradeId_idx_624f4a73", "table": "student", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"student_gradeId_idx_624f4a73\\" ON \\"public\\".\\"student\\" (\\"gradeId\\")", "params": [], "description": "create index \\"student_gradeId_idx_624f4a73\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"student_gradeId_idx_624f4a73\\""], "description": "ensure index \\"student_gradeId_idx_624f4a73\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"student_gradeId_idx_624f4a73\\""], "description": "verify index \\"student_gradeId_idx_624f4a73\\" exists"}], "operationClass": "additive"}, {"id": "index.student.student_parentId_idx_6a68f597", "label": "Create index \\"student_parentId_idx_6a68f597\\" on \\"student\\"", "target": {"id": "postgres", "details": {"name": "student_parentId_idx_6a68f597", "table": "student", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"student_parentId_idx_6a68f597\\" ON \\"public\\".\\"student\\" (\\"parentId\\")", "params": [], "description": "create index \\"student_parentId_idx_6a68f597\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"student_parentId_idx_6a68f597\\""], "description": "ensure index \\"student_parentId_idx_6a68f597\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"student_parentId_idx_6a68f597\\""], "description": "verify index \\"student_parentId_idx_6a68f597\\" exists"}], "operationClass": "additive"}, {"id": "index.studentSubject.studentSubject_studentId_idx_bf255322", "label": "Create index \\"studentSubject_studentId_idx_bf255322\\" on \\"studentSubject\\"", "target": {"id": "postgres", "details": {"name": "studentSubject_studentId_idx_bf255322", "table": "studentSubject", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"studentSubject_studentId_idx_bf255322\\" ON \\"public\\".\\"studentSubject\\" (\\"studentId\\")", "params": [], "description": "create index \\"studentSubject_studentId_idx_bf255322\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"studentSubject_studentId_idx_bf255322\\""], "description": "ensure index \\"studentSubject_studentId_idx_bf255322\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"studentSubject_studentId_idx_bf255322\\""], "description": "verify index \\"studentSubject_studentId_idx_bf255322\\" exists"}], "operationClass": "additive"}, {"id": "index.studentSubject.studentSubject_subjectId_idx_84df2a1d", "label": "Create index \\"studentSubject_subjectId_idx_84df2a1d\\" on \\"studentSubject\\"", "target": {"id": "postgres", "details": {"name": "studentSubject_subjectId_idx_84df2a1d", "table": "studentSubject", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"studentSubject_subjectId_idx_84df2a1d\\" ON \\"public\\".\\"studentSubject\\" (\\"subjectId\\")", "params": [], "description": "create index \\"studentSubject_subjectId_idx_84df2a1d\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"studentSubject_subjectId_idx_84df2a1d\\""], "description": "ensure index \\"studentSubject_subjectId_idx_84df2a1d\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"studentSubject_subjectId_idx_84df2a1d\\""], "description": "verify index \\"studentSubject_subjectId_idx_84df2a1d\\" exists"}], "operationClass": "additive"}, {"id": "index.teacherSubject.teacherSubject_subjectId_idx_84df2a1d", "label": "Create index \\"teacherSubject_subjectId_idx_84df2a1d\\" on \\"teacherSubject\\"", "target": {"id": "postgres", "details": {"name": "teacherSubject_subjectId_idx_84df2a1d", "table": "teacherSubject", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"teacherSubject_subjectId_idx_84df2a1d\\" ON \\"public\\".\\"teacherSubject\\" (\\"subjectId\\")", "params": [], "description": "create index \\"teacherSubject_subjectId_idx_84df2a1d\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacherSubject_subjectId_idx_84df2a1d\\""], "description": "ensure index \\"teacherSubject_subjectId_idx_84df2a1d\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacherSubject_subjectId_idx_84df2a1d\\""], "description": "verify index \\"teacherSubject_subjectId_idx_84df2a1d\\" exists"}], "operationClass": "additive"}, {"id": "index.teacherSubject.teacherSubject_teacherId_idx_bc266660", "label": "Create index \\"teacherSubject_teacherId_idx_bc266660\\" on \\"teacherSubject\\"", "target": {"id": "postgres", "details": {"name": "teacherSubject_teacherId_idx_bc266660", "table": "teacherSubject", "schema": "public", "objectType": "index"}}, "execute": [{"sql": "CREATE INDEX \\"teacherSubject_teacherId_idx_bc266660\\" ON \\"public\\".\\"teacherSubject\\" (\\"teacherId\\")", "params": [], "description": "create index \\"teacherSubject_teacherId_idx_bc266660\\""}], "precheck": [{"sql": "SELECT (to_regclass($1)) IS NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacherSubject_teacherId_idx_bc266660\\""], "description": "ensure index \\"teacherSubject_teacherId_idx_bc266660\\" does not exist"}], "postcheck": [{"sql": "SELECT (to_regclass($1)) IS NOT NULL AS \\"result\\"", "params": ["\\"public\\".\\"teacherSubject_teacherId_idx_bc266660\\""], "description": "verify index \\"teacherSubject_teacherId_idx_bc266660\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.announcements.announcements_classId_fkey", "label": "Add foreign key \\"announcements_classId_fkey\\" on \\"announcements\\"", "target": {"id": "postgres", "details": {"name": "announcements_classId_fkey", "table": "announcements", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"announcements\\"\\nADD CONSTRAINT \\"announcements_classId_fkey\\"\\nFOREIGN KEY (\\"classId\\")\\nREFERENCES \\"public\\".\\"class\\" (\\"id\\")", "description": "add FK \\"announcements_classId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["announcements_classId_fkey", "public", "\\"public\\".\\"announcements\\""], "description": "ensure FK \\"announcements_classId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["announcements_classId_fkey", "public", "\\"public\\".\\"announcements\\""], "description": "verify FK \\"announcements_classId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.assignment.assignment_lessonId_fkey", "label": "Add foreign key \\"assignment_lessonId_fkey\\" on \\"assignment\\"", "target": {"id": "postgres", "details": {"name": "assignment_lessonId_fkey", "table": "assignment", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"assignment\\"\\nADD CONSTRAINT \\"assignment_lessonId_fkey\\"\\nFOREIGN KEY (\\"lessonId\\")\\nREFERENCES \\"public\\".\\"lesson\\" (\\"id\\")", "description": "add FK \\"assignment_lessonId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["assignment_lessonId_fkey", "public", "\\"public\\".\\"assignment\\""], "description": "ensure FK \\"assignment_lessonId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["assignment_lessonId_fkey", "public", "\\"public\\".\\"assignment\\""], "description": "verify FK \\"assignment_lessonId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.attendance.attendance_studentId_fkey", "label": "Add foreign key \\"attendance_studentId_fkey\\" on \\"attendance\\"", "target": {"id": "postgres", "details": {"name": "attendance_studentId_fkey", "table": "attendance", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"attendance\\"\\nADD CONSTRAINT \\"attendance_studentId_fkey\\"\\nFOREIGN KEY (\\"studentId\\")\\nREFERENCES \\"public\\".\\"student\\" (\\"id\\")", "description": "add FK \\"attendance_studentId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["attendance_studentId_fkey", "public", "\\"public\\".\\"attendance\\""], "description": "ensure FK \\"attendance_studentId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["attendance_studentId_fkey", "public", "\\"public\\".\\"attendance\\""], "description": "verify FK \\"attendance_studentId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.attendance.attendance_lessonId_fkey", "label": "Add foreign key \\"attendance_lessonId_fkey\\" on \\"attendance\\"", "target": {"id": "postgres", "details": {"name": "attendance_lessonId_fkey", "table": "attendance", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"attendance\\"\\nADD CONSTRAINT \\"attendance_lessonId_fkey\\"\\nFOREIGN KEY (\\"lessonId\\")\\nREFERENCES \\"public\\".\\"lesson\\" (\\"id\\")", "description": "add FK \\"attendance_lessonId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["attendance_lessonId_fkey", "public", "\\"public\\".\\"attendance\\""], "description": "ensure FK \\"attendance_lessonId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["attendance_lessonId_fkey", "public", "\\"public\\".\\"attendance\\""], "description": "verify FK \\"attendance_lessonId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.class.class_supervisorId_fkey", "label": "Add foreign key \\"class_supervisorId_fkey\\" on \\"class\\"", "target": {"id": "postgres", "details": {"name": "class_supervisorId_fkey", "table": "class", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"class\\"\\nADD CONSTRAINT \\"class_supervisorId_fkey\\"\\nFOREIGN KEY (\\"supervisorId\\")\\nREFERENCES \\"public\\".\\"teacher\\" (\\"id\\")", "description": "add FK \\"class_supervisorId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["class_supervisorId_fkey", "public", "\\"public\\".\\"class\\""], "description": "ensure FK \\"class_supervisorId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["class_supervisorId_fkey", "public", "\\"public\\".\\"class\\""], "description": "verify FK \\"class_supervisorId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.class.class_gradeId_fkey", "label": "Add foreign key \\"class_gradeId_fkey\\" on \\"class\\"", "target": {"id": "postgres", "details": {"name": "class_gradeId_fkey", "table": "class", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"class\\"\\nADD CONSTRAINT \\"class_gradeId_fkey\\"\\nFOREIGN KEY (\\"gradeId\\")\\nREFERENCES \\"public\\".\\"grade\\" (\\"id\\")", "description": "add FK \\"class_gradeId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["class_gradeId_fkey", "public", "\\"public\\".\\"class\\""], "description": "ensure FK \\"class_gradeId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["class_gradeId_fkey", "public", "\\"public\\".\\"class\\""], "description": "verify FK \\"class_gradeId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.events.events_classId_fkey", "label": "Add foreign key \\"events_classId_fkey\\" on \\"events\\"", "target": {"id": "postgres", "details": {"name": "events_classId_fkey", "table": "events", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"events\\"\\nADD CONSTRAINT \\"events_classId_fkey\\"\\nFOREIGN KEY (\\"classId\\")\\nREFERENCES \\"public\\".\\"class\\" (\\"id\\")", "description": "add FK \\"events_classId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["events_classId_fkey", "public", "\\"public\\".\\"events\\""], "description": "ensure FK \\"events_classId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["events_classId_fkey", "public", "\\"public\\".\\"events\\""], "description": "verify FK \\"events_classId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.exams.exams_lessonId_fkey", "label": "Add foreign key \\"exams_lessonId_fkey\\" on \\"exams\\"", "target": {"id": "postgres", "details": {"name": "exams_lessonId_fkey", "table": "exams", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"exams\\"\\nADD CONSTRAINT \\"exams_lessonId_fkey\\"\\nFOREIGN KEY (\\"lessonId\\")\\nREFERENCES \\"public\\".\\"lesson\\" (\\"id\\")", "description": "add FK \\"exams_lessonId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["exams_lessonId_fkey", "public", "\\"public\\".\\"exams\\""], "description": "ensure FK \\"exams_lessonId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["exams_lessonId_fkey", "public", "\\"public\\".\\"exams\\""], "description": "verify FK \\"exams_lessonId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.lesson.lesson_subjectId_fkey", "label": "Add foreign key \\"lesson_subjectId_fkey\\" on \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson_subjectId_fkey", "table": "lesson", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"lesson\\"\\nADD CONSTRAINT \\"lesson_subjectId_fkey\\"\\nFOREIGN KEY (\\"subjectId\\")\\nREFERENCES \\"public\\".\\"subject\\" (\\"id\\")", "description": "add FK \\"lesson_subjectId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["lesson_subjectId_fkey", "public", "\\"public\\".\\"lesson\\""], "description": "ensure FK \\"lesson_subjectId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["lesson_subjectId_fkey", "public", "\\"public\\".\\"lesson\\""], "description": "verify FK \\"lesson_subjectId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.lesson.lesson_classId_fkey", "label": "Add foreign key \\"lesson_classId_fkey\\" on \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson_classId_fkey", "table": "lesson", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"lesson\\"\\nADD CONSTRAINT \\"lesson_classId_fkey\\"\\nFOREIGN KEY (\\"classId\\")\\nREFERENCES \\"public\\".\\"class\\" (\\"id\\")", "description": "add FK \\"lesson_classId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["lesson_classId_fkey", "public", "\\"public\\".\\"lesson\\""], "description": "ensure FK \\"lesson_classId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["lesson_classId_fkey", "public", "\\"public\\".\\"lesson\\""], "description": "verify FK \\"lesson_classId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.lesson.lesson_teacherId_fkey", "label": "Add foreign key \\"lesson_teacherId_fkey\\" on \\"lesson\\"", "target": {"id": "postgres", "details": {"name": "lesson_teacherId_fkey", "table": "lesson", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"lesson\\"\\nADD CONSTRAINT \\"lesson_teacherId_fkey\\"\\nFOREIGN KEY (\\"teacherId\\")\\nREFERENCES \\"public\\".\\"teacher\\" (\\"id\\")", "description": "add FK \\"lesson_teacherId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["lesson_teacherId_fkey", "public", "\\"public\\".\\"lesson\\""], "description": "ensure FK \\"lesson_teacherId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["lesson_teacherId_fkey", "public", "\\"public\\".\\"lesson\\""], "description": "verify FK \\"lesson_teacherId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.result.result_examId_fkey", "label": "Add foreign key \\"result_examId_fkey\\" on \\"result\\"", "target": {"id": "postgres", "details": {"name": "result_examId_fkey", "table": "result", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"result\\"\\nADD CONSTRAINT \\"result_examId_fkey\\"\\nFOREIGN KEY (\\"examId\\")\\nREFERENCES \\"public\\".\\"exams\\" (\\"id\\")", "description": "add FK \\"result_examId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["result_examId_fkey", "public", "\\"public\\".\\"result\\""], "description": "ensure FK \\"result_examId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["result_examId_fkey", "public", "\\"public\\".\\"result\\""], "description": "verify FK \\"result_examId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.result.result_assignmentId_fkey", "label": "Add foreign key \\"result_assignmentId_fkey\\" on \\"result\\"", "target": {"id": "postgres", "details": {"name": "result_assignmentId_fkey", "table": "result", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"result\\"\\nADD CONSTRAINT \\"result_assignmentId_fkey\\"\\nFOREIGN KEY (\\"assignmentId\\")\\nREFERENCES \\"public\\".\\"assignment\\" (\\"id\\")", "description": "add FK \\"result_assignmentId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["result_assignmentId_fkey", "public", "\\"public\\".\\"result\\""], "description": "ensure FK \\"result_assignmentId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["result_assignmentId_fkey", "public", "\\"public\\".\\"result\\""], "description": "verify FK \\"result_assignmentId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.result.result_studentId_fkey", "label": "Add foreign key \\"result_studentId_fkey\\" on \\"result\\"", "target": {"id": "postgres", "details": {"name": "result_studentId_fkey", "table": "result", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"result\\"\\nADD CONSTRAINT \\"result_studentId_fkey\\"\\nFOREIGN KEY (\\"studentId\\")\\nREFERENCES \\"public\\".\\"student\\" (\\"id\\")", "description": "add FK \\"result_studentId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["result_studentId_fkey", "public", "\\"public\\".\\"result\\""], "description": "ensure FK \\"result_studentId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["result_studentId_fkey", "public", "\\"public\\".\\"result\\""], "description": "verify FK \\"result_studentId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.student.student_parentId_fkey", "label": "Add foreign key \\"student_parentId_fkey\\" on \\"student\\"", "target": {"id": "postgres", "details": {"name": "student_parentId_fkey", "table": "student", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"student\\"\\nADD CONSTRAINT \\"student_parentId_fkey\\"\\nFOREIGN KEY (\\"parentId\\")\\nREFERENCES \\"public\\".\\"parent\\" (\\"id\\")", "description": "add FK \\"student_parentId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_parentId_fkey", "public", "\\"public\\".\\"student\\""], "description": "ensure FK \\"student_parentId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_parentId_fkey", "public", "\\"public\\".\\"student\\""], "description": "verify FK \\"student_parentId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.student.student_classId_fkey", "label": "Add foreign key \\"student_classId_fkey\\" on \\"student\\"", "target": {"id": "postgres", "details": {"name": "student_classId_fkey", "table": "student", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"student\\"\\nADD CONSTRAINT \\"student_classId_fkey\\"\\nFOREIGN KEY (\\"classId\\")\\nREFERENCES \\"public\\".\\"class\\" (\\"id\\")", "description": "add FK \\"student_classId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_classId_fkey", "public", "\\"public\\".\\"student\\""], "description": "ensure FK \\"student_classId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_classId_fkey", "public", "\\"public\\".\\"student\\""], "description": "verify FK \\"student_classId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.student.student_gradeId_fkey", "label": "Add foreign key \\"student_gradeId_fkey\\" on \\"student\\"", "target": {"id": "postgres", "details": {"name": "student_gradeId_fkey", "table": "student", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"student\\"\\nADD CONSTRAINT \\"student_gradeId_fkey\\"\\nFOREIGN KEY (\\"gradeId\\")\\nREFERENCES \\"public\\".\\"grade\\" (\\"id\\")", "description": "add FK \\"student_gradeId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_gradeId_fkey", "public", "\\"public\\".\\"student\\""], "description": "ensure FK \\"student_gradeId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["student_gradeId_fkey", "public", "\\"public\\".\\"student\\""], "description": "verify FK \\"student_gradeId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.studentSubject.studentSubject_studentId_fkey", "label": "Add foreign key \\"studentSubject_studentId_fkey\\" on \\"studentSubject\\"", "target": {"id": "postgres", "details": {"name": "studentSubject_studentId_fkey", "table": "studentSubject", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"studentSubject\\"\\nADD CONSTRAINT \\"studentSubject_studentId_fkey\\"\\nFOREIGN KEY (\\"studentId\\")\\nREFERENCES \\"public\\".\\"student\\" (\\"id\\")", "description": "add FK \\"studentSubject_studentId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["studentSubject_studentId_fkey", "public", "\\"public\\".\\"studentSubject\\""], "description": "ensure FK \\"studentSubject_studentId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["studentSubject_studentId_fkey", "public", "\\"public\\".\\"studentSubject\\""], "description": "verify FK \\"studentSubject_studentId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.studentSubject.studentSubject_subjectId_fkey", "label": "Add foreign key \\"studentSubject_subjectId_fkey\\" on \\"studentSubject\\"", "target": {"id": "postgres", "details": {"name": "studentSubject_subjectId_fkey", "table": "studentSubject", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"studentSubject\\"\\nADD CONSTRAINT \\"studentSubject_subjectId_fkey\\"\\nFOREIGN KEY (\\"subjectId\\")\\nREFERENCES \\"public\\".\\"subject\\" (\\"id\\")", "description": "add FK \\"studentSubject_subjectId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["studentSubject_subjectId_fkey", "public", "\\"public\\".\\"studentSubject\\""], "description": "ensure FK \\"studentSubject_subjectId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["studentSubject_subjectId_fkey", "public", "\\"public\\".\\"studentSubject\\""], "description": "verify FK \\"studentSubject_subjectId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.teacherSubject.teacherSubject_teacherId_fkey", "label": "Add foreign key \\"teacherSubject_teacherId_fkey\\" on \\"teacherSubject\\"", "target": {"id": "postgres", "details": {"name": "teacherSubject_teacherId_fkey", "table": "teacherSubject", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"teacherSubject\\"\\nADD CONSTRAINT \\"teacherSubject_teacherId_fkey\\"\\nFOREIGN KEY (\\"teacherId\\")\\nREFERENCES \\"public\\".\\"teacher\\" (\\"id\\")", "description": "add FK \\"teacherSubject_teacherId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacherSubject_teacherId_fkey", "public", "\\"public\\".\\"teacherSubject\\""], "description": "ensure FK \\"teacherSubject_teacherId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacherSubject_teacherId_fkey", "public", "\\"public\\".\\"teacherSubject\\""], "description": "verify FK \\"teacherSubject_teacherId_fkey\\" exists"}], "operationClass": "additive"}, {"id": "foreignKey.teacherSubject.teacherSubject_subjectId_fkey", "label": "Add foreign key \\"teacherSubject_subjectId_fkey\\" on \\"teacherSubject\\"", "target": {"id": "postgres", "details": {"name": "teacherSubject_subjectId_fkey", "table": "teacherSubject", "schema": "public", "objectType": "foreignKey"}}, "execute": [{"sql": "ALTER TABLE \\"public\\".\\"teacherSubject\\"\\nADD CONSTRAINT \\"teacherSubject_subjectId_fkey\\"\\nFOREIGN KEY (\\"subjectId\\")\\nREFERENCES \\"public\\".\\"subject\\" (\\"id\\")", "description": "add FK \\"teacherSubject_subjectId_fkey\\""}], "precheck": [{"sql": "SELECT NOT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacherSubject_subjectId_fkey", "public", "\\"public\\".\\"teacherSubject\\""], "description": "ensure FK \\"teacherSubject_subjectId_fkey\\" does not exist"}], "postcheck": [{"sql": "SELECT EXISTS (SELECT 1 AS \\"one\\" FROM \\"pg_constraint\\" AS \\"c\\" INNER JOIN \\"pg_namespace\\" AS \\"n\\" ON \\"n\\".\\"oid\\" = \\"c\\".\\"connamespace\\" WHERE (\\"c\\".\\"conname\\" = $1 AND \\"n\\".\\"nspname\\" = $2 AND \\"c\\".\\"conrelid\\" = to_regclass($3))) AS \\"result\\"", "params": ["teacherSubject_subjectId_fkey", "public", "\\"public\\".\\"teacherSubject\\""], "description": "verify FK \\"teacherSubject_subjectId_fkey\\" exists"}], "operationClass": "additive"}]
\.


--
-- Data for Name: marker; Type: TABLE DATA; Schema: prisma_contract; Owner: amazing
--

COPY prisma_contract.marker (space, core_hash, profile_hash, contract_json, canonical_version, updated_at, app_tag, meta, invariants) FROM stdin;
app	17ed9e861a76671189af7a01112352c7cd2d10a266d7c49fee2ada55d4228c68	3916f444a8a17ad749191acf9e08dad97d1a327b88c2f1d45d12f240296aa8b2	\N	\N	2026-10-21 12:57:20.531234+00	\N	{}	{}
\.


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.admin (id, username) FROM stdin;
admin1	admin1
admin2	admin2
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.announcements ("classId", date, description, id, title) FROM stdin;
1	2026-10-21 12:57:51.102+00	Description for Announcement 1	1	Announcement 1
2	2026-10-21 12:57:51.116+00	Description for Announcement 2	2	Announcement 2
3	2026-10-21 12:57:51.128+00	Description for Announcement 3	3	Announcement 3
4	2026-10-21 12:57:51.14+00	Description for Announcement 4	4	Announcement 4
5	2026-10-21 12:57:51.151+00	Description for Announcement 5	5	Announcement 5
\.


--
-- Data for Name: assignment; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.assignment ("dueTime", id, "lessonId", "startTime", title) FROM stdin;
2026-10-22 12:57:50.543+00	1	1	2026-10-21 11:00:00+00	Assignment 1
2026-10-22 12:57:50.557+00	2	2	2026-10-21 11:00:00+00	Assignment 2
2026-10-22 12:57:50.571+00	3	3	2026-10-21 11:00:00+00	Assignment 3
2026-10-22 12:57:50.585+00	4	4	2026-10-21 11:00:00+00	Assignment 4
2026-10-22 12:57:50.597+00	5	5	2026-10-21 11:00:00+00	Assignment 5
2026-10-22 12:57:50.611+00	6	6	2026-10-21 11:00:00+00	Assignment 6
2026-10-22 12:57:50.625+00	7	7	2026-10-21 11:00:00+00	Assignment 7
2026-10-22 12:57:50.638+00	8	8	2026-10-21 11:00:00+00	Assignment 8
2026-10-22 12:57:50.651+00	9	9	2026-10-21 11:00:00+00	Assignment 9
2026-10-22 12:57:50.664+00	10	10	2026-10-21 11:00:00+00	Assignment 10
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.attendance (date, id, "lessonId", present, "studentId") FROM stdin;
2026-10-21 12:57:50.813+00	2	2	t	student2
2026-10-21 12:57:50.823+00	3	3	t	student3
2026-10-21 12:57:50.835+00	4	4	t	student4
2026-10-21 12:57:50.847+00	5	5	f	student5
2026-10-21 12:57:50.857+00	6	6	t	student6
2026-10-21 12:57:50.869+00	7	7	t	student7
2026-10-21 12:57:50.881+00	8	8	t	student8
2026-10-21 12:57:50.893+00	9	9	t	student9
2026-10-21 12:57:50.906+00	10	10	f	student10
2026-10-21 12:57:50.932+00	12	12	t	student2
2026-10-21 12:57:50.945+00	13	13	t	student3
2026-10-21 12:57:50.959+00	14	14	t	student4
2026-10-21 12:57:50.97+00	15	15	f	student5
2026-10-21 12:57:50.983+00	16	16	t	student6
2026-10-21 12:57:50.996+00	17	17	t	student7
2026-10-21 12:57:51.003+00	18	18	t	student8
2026-10-21 12:57:51.014+00	19	19	t	student9
2026-10-21 12:57:51.026+00	20	20	f	student10
2026-10-21 12:57:50.799+00	1	1	t	user_3KzpLEeEzHMJLgeEbpYsm2xFk5X
2026-10-21 12:57:50.919+00	11	11	t	user_3KzpLEeEzHMJLgeEbpYsm2xFk5X
\.


--
-- Data for Name: class; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.class (capacity, "gradeId", id, name, "supervisorId") FROM stdin;
16	1	1	1A	teacher1
15	2	2	2A	teacher2
19	3	3	3A	teacher3
18	4	4	4A	teacher4
18	5	5	5A	teacher5
15	6	6	6A	teacher6
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.events ("classId", description, "endDate", id, "startDate", title) FROM stdin;
1	Description for Event 1	2026-10-21 15:00:00+00	1	2026-10-21 14:00:00+00	Event 1
2	Description for Event 2	2026-10-21 16:00:00+00	2	2026-10-21 15:00:00+00	Event 2
3	Description for Event 3	2026-10-21 17:00:00+00	3	2026-10-21 16:00:00+00	Event 3
4	Description for Event 4	2026-10-21 18:00:00+00	4	2026-10-21 17:00:00+00	Event 4
5	Description for Event 5	2026-10-21 19:00:00+00	5	2026-10-21 18:00:00+00	Event 5
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.exams ("endTime", id, "lessonId", "startTime", title) FROM stdin;
2026-10-21 11:00:00+00	1	1	2026-10-21 10:00:00+00	Exam 1
2026-10-21 12:00:00+00	2	2	2026-10-21 11:00:00+00	Exam 2
2026-10-21 10:00:00+00	3	3	2026-10-21 09:00:00+00	Exam 3
2026-10-21 11:00:00+00	4	4	2026-10-21 10:00:00+00	Exam 4
2026-10-21 12:00:00+00	5	5	2026-10-21 11:00:00+00	Exam 5
2026-10-21 10:00:00+00	6	6	2026-10-21 09:00:00+00	Exam 6
2026-10-21 11:00:00+00	7	7	2026-10-21 10:00:00+00	Exam 7
2026-10-21 12:00:00+00	8	8	2026-10-21 11:00:00+00	Exam 8
2026-10-21 10:00:00+00	9	9	2026-10-21 09:00:00+00	Exam 9
2026-10-21 11:00:00+00	10	10	2026-10-21 10:00:00+00	Exam 10
\.


--
-- Data for Name: grade; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.grade (id, level) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.lesson ("classId", day, "endTime", id, name, "startTime", "subjectId", "teacherId") FROM stdin;
1	MONDAY	2026-10-21 09:00:00+00	1	Lesson1	2026-10-21 08:00:00+00	1	teacher1
2	TUESDAY	2026-10-21 10:00:00+00	2	Lesson2	2026-10-21 09:00:00+00	2	teacher2
3	WEDNESDAY	2026-10-21 11:00:00+00	3	Lesson3	2026-10-21 10:00:00+00	3	teacher3
4	THURSDAY	2026-10-21 12:00:00+00	4	Lesson4	2026-10-21 11:00:00+00	4	teacher4
5	FRIDAY	2026-10-21 08:00:00+00	5	Lesson5	2026-10-21 07:00:00+00	5	teacher5
6	MONDAY	2026-10-21 09:00:00+00	6	Lesson6	2026-10-21 08:00:00+00	6	teacher6
1	TUESDAY	2026-10-21 10:00:00+00	7	Lesson7	2026-10-21 09:00:00+00	7	teacher7
2	WEDNESDAY	2026-10-21 11:00:00+00	8	Lesson8	2026-10-21 10:00:00+00	8	teacher8
3	THURSDAY	2026-10-21 12:00:00+00	9	Lesson9	2026-10-21 11:00:00+00	9	teacher9
4	FRIDAY	2026-10-21 08:00:00+00	10	Lesson10	2026-10-21 07:00:00+00	10	teacher10
5	MONDAY	2026-10-21 09:00:00+00	11	Lesson11	2026-10-21 08:00:00+00	1	teacher11
6	TUESDAY	2026-10-21 10:00:00+00	12	Lesson12	2026-10-21 09:00:00+00	2	teacher12
1	WEDNESDAY	2026-10-21 11:00:00+00	13	Lesson13	2026-10-21 10:00:00+00	3	teacher13
2	THURSDAY	2026-10-21 12:00:00+00	14	Lesson14	2026-10-21 11:00:00+00	4	teacher14
3	FRIDAY	2026-10-21 08:00:00+00	15	Lesson15	2026-10-21 07:00:00+00	5	teacher15
4	MONDAY	2026-10-21 09:00:00+00	16	Lesson16	2026-10-21 08:00:00+00	6	teacher1
5	TUESDAY	2026-10-21 10:00:00+00	17	Lesson17	2026-10-21 09:00:00+00	7	teacher2
6	WEDNESDAY	2026-10-21 11:00:00+00	18	Lesson18	2026-10-21 10:00:00+00	8	teacher3
1	THURSDAY	2026-10-21 12:00:00+00	19	Lesson19	2026-10-21 11:00:00+00	9	teacher4
2	FRIDAY	2026-10-21 08:00:00+00	20	Lesson20	2026-10-21 07:00:00+00	10	teacher5
3	MONDAY	2026-10-21 09:00:00+00	21	Lesson21	2026-10-21 08:00:00+00	1	teacher6
4	TUESDAY	2026-10-21 10:00:00+00	22	Lesson22	2026-10-21 09:00:00+00	2	teacher7
5	WEDNESDAY	2026-10-21 11:00:00+00	23	Lesson23	2026-10-21 10:00:00+00	3	teacher8
6	THURSDAY	2026-10-21 12:00:00+00	24	Lesson24	2026-10-21 11:00:00+00	4	teacher9
1	FRIDAY	2026-10-21 08:00:00+00	25	Lesson25	2026-10-21 07:00:00+00	5	teacher10
2	MONDAY	2026-10-21 09:00:00+00	26	Lesson26	2026-10-21 08:00:00+00	6	teacher11
3	TUESDAY	2026-10-21 10:00:00+00	27	Lesson27	2026-10-21 09:00:00+00	7	teacher12
4	WEDNESDAY	2026-10-21 11:00:00+00	28	Lesson28	2026-10-21 10:00:00+00	8	teacher13
5	THURSDAY	2026-10-21 12:00:00+00	29	Lesson29	2026-10-21 11:00:00+00	9	teacher14
6	FRIDAY	2026-10-21 08:00:00+00	30	Lesson30	2026-10-21 07:00:00+00	10	teacher15
\.


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.parent (address, "createdAt", email, id, name, phone, surname, username) FROM stdin;
Address1	2026-10-21 12:57:46.779779+00	parent1@example.com	parentId1	PName 1	0810000001	PSurname 1	parentId1
Address2	2026-10-21 12:57:46.787754+00	parent2@example.com	parentId2	PName 2	0810000002	PSurname 2	parentId2
Address3	2026-10-21 12:57:46.793032+00	parent3@example.com	parentId3	PName 3	0810000003	PSurname 3	parentId3
Address4	2026-10-21 12:57:46.799346+00	parent4@example.com	parentId4	PName 4	0810000004	PSurname 4	parentId4
Address5	2026-10-21 12:57:46.806439+00	parent5@example.com	parentId5	PName 5	0810000005	PSurname 5	parentId5
Address6	2026-10-21 12:57:46.811024+00	parent6@example.com	parentId6	PName 6	0810000006	PSurname 6	parentId6
Address7	2026-10-21 12:57:46.816683+00	parent7@example.com	parentId7	PName 7	0810000007	PSurname 7	parentId7
Address8	2026-10-21 12:57:46.821888+00	parent8@example.com	parentId8	PName 8	0810000008	PSurname 8	parentId8
Address9	2026-10-21 12:57:46.826483+00	parent9@example.com	parentId9	PName 9	0810000009	PSurname 9	parentId9
Address10	2026-10-21 12:57:46.831704+00	parent10@example.com	parentId10	PName 10	08100000010	PSurname 10	parentId10
Address11	2026-10-21 12:57:46.837836+00	parent11@example.com	parentId11	PName 11	08100000011	PSurname 11	parentId11
Address12	2026-10-21 12:57:46.847771+00	parent12@example.com	parentId12	PName 12	08100000012	PSurname 12	parentId12
Address13	2026-10-21 12:57:46.854314+00	parent13@example.com	parentId13	PName 13	08100000013	PSurname 13	parentId13
Address14	2026-10-21 12:57:46.866403+00	parent14@example.com	parentId14	PName 14	08100000014	PSurname 14	parentId14
Address15	2026-10-21 12:57:46.871648+00	parent15@example.com	parentId15	PName 15	08100000015	PSurname 15	parentId15
Address16	2026-10-21 12:57:46.877557+00	parent16@example.com	parentId16	PName 16	08100000016	PSurname 16	parentId16
Address17	2026-10-21 12:57:46.886781+00	parent17@example.com	parentId17	PName 17	08100000017	PSurname 17	parentId17
Address18	2026-10-21 12:57:46.893587+00	parent18@example.com	parentId18	PName 18	08100000018	PSurname 18	parentId18
Address19	2026-10-21 12:57:46.898895+00	parent19@example.com	parentId19	PName 19	08100000019	PSurname 19	parentId19
Address20	2026-10-21 12:57:46.905123+00	parent20@example.com	parentId20	PName 20	08100000020	PSurname 20	parentId20
Address21	2026-10-21 12:57:46.910784+00	parent21@example.com	parentId21	PName 21	08100000021	PSurname 21	parentId21
Address22	2026-10-21 12:57:46.916737+00	parent22@example.com	parentId22	PName 22	08100000022	PSurname 22	parentId22
Address23	2026-10-21 12:57:46.921894+00	parent23@example.com	parentId23	PName 23	08100000023	PSurname 23	parentId23
Address24	2026-10-21 12:57:46.926683+00	parent24@example.com	parentId24	PName 24	08100000024	PSurname 24	parentId24
Address25	2026-10-21 12:57:46.932185+00	parent25@example.com	parentId25	PName 25	08100000025	PSurname 25	parentId25
\.


--
-- Data for Name: result; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.result ("assignmentId", "examId", id, score, "studentId") FROM stdin;
\N	2	2	75	student2
\N	3	3	85	student3
\N	4	4	80	student4
\N	5	5	70	student5
1	\N	6	97	student6
2	\N	7	81	student7
3	\N	8	88	student8
4	\N	9	98	student9
5	\N	10	85	student10
\N	1	1	88	user_3KzpLEeEzHMJLgeEbpYsm2xFk5X
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.student (address, "bloodType", "classId", "createdAt", email, "gradeId", id, img, name, "parentId", phone, sex, surname, username) FROM stdin;
Address2	O-	2	2026-10-21 12:57:46.947269+00	student2@example.com	2	student2	\N	SName2	parentId1	0820000002	MALE	SSurname2	student2
Address3	O-	3	2026-10-21 12:57:46.957875+00	student3@example.com	3	student3	\N	SName3	parentId2	0820000003	FEMALE	SSurname3	student3
Address4	O-	4	2026-10-21 12:57:46.965161+00	student4@example.com	4	student4	\N	SName4	parentId2	0820000004	MALE	SSurname4	student4
Address5	O-	5	2026-10-21 12:57:46.970497+00	student5@example.com	5	student5	\N	SName5	parentId3	0820000005	FEMALE	SSurname5	student5
Address6	O-	6	2026-10-21 12:57:46.976086+00	student6@example.com	6	student6	\N	SName6	parentId3	0820000006	MALE	SSurname6	student6
Address7	O-	1	2026-10-21 12:57:46.987882+00	student7@example.com	1	student7	\N	SName7	parentId4	0820000007	FEMALE	SSurname7	student7
Address8	O-	2	2026-10-21 12:57:46.999649+00	student8@example.com	2	student8	\N	SName8	parentId4	0820000008	MALE	SSurname8	student8
Address9	O-	3	2026-10-21 12:57:47.010236+00	student9@example.com	3	student9	\N	SName9	parentId5	0820000009	FEMALE	SSurname9	student9
Address10	O-	4	2026-10-21 12:57:47.016977+00	student10@example.com	4	student10	\N	SName10	parentId5	08200000010	MALE	SSurname10	student10
Address11	O-	5	2026-10-21 12:57:47.022945+00	student11@example.com	5	student11	\N	SName11	parentId6	08200000011	FEMALE	SSurname11	student11
Address12	O-	6	2026-10-21 12:57:47.027964+00	student12@example.com	6	student12	\N	SName12	parentId6	08200000012	MALE	SSurname12	student12
Address13	O-	1	2026-10-21 12:57:47.034267+00	student13@example.com	1	student13	\N	SName13	parentId7	08200000013	FEMALE	SSurname13	student13
Address14	O-	2	2026-10-21 12:57:47.040391+00	student14@example.com	2	student14	\N	SName14	parentId7	08200000014	MALE	SSurname14	student14
Address15	O-	3	2026-10-21 12:57:47.046023+00	student15@example.com	3	student15	\N	SName15	parentId8	08200000015	FEMALE	SSurname15	student15
Address16	O-	4	2026-10-21 12:57:47.061152+00	student16@example.com	4	student16	\N	SName16	parentId8	08200000016	MALE	SSurname16	student16
Address17	O-	5	2026-10-21 12:57:47.072587+00	student17@example.com	5	student17	\N	SName17	parentId9	08200000017	FEMALE	SSurname17	student17
Address18	O-	6	2026-10-21 12:57:47.082574+00	student18@example.com	6	student18	\N	SName18	parentId9	08200000018	MALE	SSurname18	student18
Address19	O-	1	2026-10-21 12:57:47.092907+00	student19@example.com	1	student19	\N	SName19	parentId10	08200000019	FEMALE	SSurname19	student19
Address20	O-	2	2026-10-21 12:57:47.099992+00	student20@example.com	2	student20	\N	SName20	parentId10	08200000020	MALE	SSurname20	student20
Address21	O-	3	2026-10-21 12:57:47.111156+00	student21@example.com	3	student21	\N	SName21	parentId11	08200000021	FEMALE	SSurname21	student21
Address22	O-	4	2026-10-21 12:57:47.121719+00	student22@example.com	4	student22	\N	SName22	parentId11	08200000022	MALE	SSurname22	student22
Address23	O-	5	2026-10-21 12:57:47.127857+00	student23@example.com	5	student23	\N	SName23	parentId12	08200000023	FEMALE	SSurname23	student23
Address24	O-	6	2026-10-21 12:57:47.134526+00	student24@example.com	6	student24	\N	SName24	parentId12	08200000024	MALE	SSurname24	student24
Address25	O-	1	2026-10-21 12:57:47.144065+00	student25@example.com	1	student25	\N	SName25	parentId13	08200000025	FEMALE	SSurname25	student25
Address26	O-	2	2026-10-21 12:57:47.159679+00	student26@example.com	2	student26	\N	SName26	parentId13	08200000026	MALE	SSurname26	student26
Address27	O-	3	2026-10-21 12:57:47.175923+00	student27@example.com	3	student27	\N	SName27	parentId14	08200000027	FEMALE	SSurname27	student27
Address28	O-	4	2026-10-21 12:57:47.186402+00	student28@example.com	4	student28	\N	SName28	parentId14	08200000028	MALE	SSurname28	student28
Address29	O-	5	2026-10-21 12:57:47.195828+00	student29@example.com	5	student29	\N	SName29	parentId15	08200000029	FEMALE	SSurname29	student29
Address30	O-	6	2026-10-21 12:57:47.202963+00	student30@example.com	6	student30	\N	SName30	parentId15	08200000030	MALE	SSurname30	student30
Address31	O-	1	2026-10-21 12:57:47.212752+00	student31@example.com	1	student31	\N	SName31	parentId16	08200000031	FEMALE	SSurname31	student31
Address32	O-	2	2026-10-21 12:57:47.222142+00	student32@example.com	2	student32	\N	SName32	parentId16	08200000032	MALE	SSurname32	student32
Address33	O-	3	2026-10-21 12:57:47.227408+00	student33@example.com	3	student33	\N	SName33	parentId17	08200000033	FEMALE	SSurname33	student33
Address34	O-	4	2026-10-21 12:57:47.232729+00	student34@example.com	4	student34	\N	SName34	parentId17	08200000034	MALE	SSurname34	student34
Address35	O-	5	2026-10-21 12:57:47.2376+00	student35@example.com	5	student35	\N	SName35	parentId18	08200000035	FEMALE	SSurname35	student35
Address36	O-	6	2026-10-21 12:57:47.242013+00	student36@example.com	6	student36	\N	SName36	parentId18	08200000036	MALE	SSurname36	student36
Address37	O-	1	2026-10-21 12:57:47.251523+00	student37@example.com	1	student37	\N	SName37	parentId19	08200000037	FEMALE	SSurname37	student37
Address38	O-	2	2026-10-21 12:57:47.26848+00	student38@example.com	2	student38	\N	SName38	parentId19	08200000038	MALE	SSurname38	student38
Address39	O-	3	2026-10-21 12:57:47.281995+00	student39@example.com	3	student39	\N	SName39	parentId20	08200000039	FEMALE	SSurname39	student39
Address40	O-	4	2026-10-21 12:57:47.295689+00	student40@example.com	4	student40	\N	SName40	parentId20	08200000040	MALE	SSurname40	student40
Address41	O-	5	2026-10-21 12:57:47.308015+00	student41@example.com	5	student41	\N	SName41	parentId21	08200000041	FEMALE	SSurname41	student41
Address42	O-	6	2026-10-21 12:57:47.31978+00	student42@example.com	6	student42	\N	SName42	parentId21	08200000042	MALE	SSurname42	student42
Address43	O-	1	2026-10-21 12:57:47.327995+00	student43@example.com	1	student43	\N	SName43	parentId22	08200000043	FEMALE	SSurname43	student43
Address44	O-	2	2026-10-21 12:57:47.336051+00	student44@example.com	2	student44	\N	SName44	parentId22	08200000044	MALE	SSurname44	student44
Address45	O-	3	2026-10-21 12:57:47.346175+00	student45@example.com	3	student45	\N	SName45	parentId23	08200000045	FEMALE	SSurname45	student45
Address46	O-	4	2026-10-21 12:57:47.357532+00	student46@example.com	4	student46	\N	SName46	parentId23	08200000046	MALE	SSurname46	student46
Address47	O-	5	2026-10-21 12:57:47.37048+00	student47@example.com	5	student47	\N	SName47	parentId24	08200000047	FEMALE	SSurname47	student47
Address48	O-	6	2026-10-21 12:57:47.382614+00	student48@example.com	6	student48	\N	SName48	parentId24	08200000048	MALE	SSurname48	student48
Address49	O-	1	2026-10-21 12:57:47.390546+00	student49@example.com	1	student49	\N	SName49	parentId25	08200000049	FEMALE	SSurname49	student49
Address50	O-	2	2026-10-21 12:57:47.399481+00	student50@example.com	2	student50	\N	SName50	parentId25	08200000050	MALE	SSurname50	student50
Address1	O-	1	2026-10-21 12:57:46.939041+00	\N	1	user_3KzpLEeEzHMJLgeEbpYsm2xFk5X	\N	SName1	parentId1	\N	FEMALE	SSurname1	student1
\.


--
-- Data for Name: studentSubject; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public."studentSubject" ("studentId", "subjectId") FROM stdin;
student2	2
student2	3
student2	4
student2	5
student2	6
student3	3
student3	4
student3	5
student3	6
student3	7
student4	4
student4	5
student4	6
student4	7
student4	8
student5	5
student5	6
student5	7
student5	8
student5	9
student6	6
student6	7
student6	8
student6	9
student6	10
student7	7
student7	8
student7	9
student7	10
student7	1
student8	8
student8	9
student8	10
student8	1
student8	2
student9	9
student9	10
student9	1
student9	2
student9	3
student10	10
student10	1
student10	2
student10	3
student10	4
student11	1
student11	2
student11	3
student11	4
student11	5
student12	2
student12	3
student12	4
student12	5
student12	6
student13	3
student13	4
student13	5
student13	6
student13	7
student14	4
student14	5
student14	6
student14	7
student14	8
student15	5
student15	6
student15	7
student15	8
student15	9
student16	6
student16	7
student16	8
student16	9
student16	10
student17	7
student17	8
student17	9
student17	10
student17	1
student18	8
student18	9
student18	10
student18	1
student18	2
student19	9
student19	10
student19	1
student19	2
student19	3
student20	10
student20	1
student20	2
student20	3
student20	4
student21	1
student21	2
student21	3
student21	4
student21	5
student22	2
student22	3
student22	4
student22	5
student22	6
student23	3
student23	4
student23	5
student23	6
student23	7
student24	4
student24	5
student24	6
student24	7
student24	8
student25	5
student25	6
student25	7
student25	8
student25	9
student26	6
student26	7
student26	8
student26	9
student26	10
student27	7
student27	8
student27	9
student27	10
student27	1
student28	8
student28	9
student28	10
student28	1
student28	2
student29	9
student29	10
student29	1
student29	2
student29	3
student30	10
student30	1
student30	2
student30	3
student30	4
student31	1
student31	2
student31	3
student31	4
student31	5
student32	2
student32	3
student32	4
student32	5
student32	6
student33	3
student33	4
student33	5
student33	6
student33	7
student34	4
student34	5
student34	6
student34	7
student34	8
student35	5
student35	6
student35	7
student35	8
student35	9
student36	6
student36	7
student36	8
student36	9
student36	10
student37	7
student37	8
student37	9
student37	10
student37	1
student38	8
student38	9
student38	10
student38	1
student38	2
student39	9
student39	10
student39	1
student39	2
student39	3
student40	10
student40	1
student40	2
student40	3
student40	4
student41	1
student41	2
student41	3
student41	4
student41	5
student42	2
student42	3
student42	4
student42	5
student42	6
student43	3
student43	4
student43	5
student43	6
student43	7
student44	4
student44	5
student44	6
student44	7
student44	8
student45	5
student45	6
student45	7
student45	8
student45	9
student46	6
student46	7
student46	8
student46	9
student46	10
student47	7
student47	8
student47	9
student47	10
student47	1
student48	8
student48	9
student48	10
student48	1
student48	2
student49	9
student49	10
student49	1
student49	2
student49	3
student50	10
student50	1
student50	2
student50	3
student50	4
user_3KzpLEeEzHMJLgeEbpYsm2xFk5X	1
user_3KzpLEeEzHMJLgeEbpYsm2xFk5X	2
user_3KzpLEeEzHMJLgeEbpYsm2xFk5X	3
user_3KzpLEeEzHMJLgeEbpYsm2xFk5X	4
user_3KzpLEeEzHMJLgeEbpYsm2xFk5X	5
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.subject (id, name) FROM stdin;
1	Mathematics
2	Science
3	English
4	History
5	Geography
6	Physics
7	Chemistry
8	Biology
9	Computer Science
10	Art
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public.teacher (address, "createdAt", email, id, img, name, phone, surname, username) FROM stdin;
Address1	2026-10-21 12:57:46.379309+00	teacher1@example.com	teacher1	\N	TName1	0800000001	TSurname1	teacher1
Address2	2026-10-21 12:57:46.391976+00	teacher2@example.com	teacher2	\N	TName2	0800000002	TSurname2	teacher2
Address3	2026-10-21 12:57:46.40243+00	teacher3@example.com	teacher3	\N	TName3	0800000003	TSurname3	teacher3
Address4	2026-10-21 12:57:46.412174+00	teacher4@example.com	teacher4	\N	TName4	0800000004	TSurname4	teacher4
Address5	2026-10-21 12:57:46.421728+00	teacher5@example.com	teacher5	\N	TName5	0800000005	TSurname5	teacher5
Address6	2026-10-21 12:57:46.431149+00	teacher6@example.com	teacher6	\N	TName6	0800000006	TSurname6	teacher6
Address7	2026-10-21 12:57:46.440689+00	teacher7@example.com	teacher7	\N	TName7	0800000007	TSurname7	teacher7
Address8	2026-10-21 12:57:46.450299+00	teacher8@example.com	teacher8	\N	TName8	0800000008	TSurname8	teacher8
Address9	2026-10-21 12:57:46.45966+00	teacher9@example.com	teacher9	\N	TName9	0800000009	TSurname9	teacher9
Address10	2026-10-21 12:57:46.470007+00	teacher10@example.com	teacher10	\N	TName10	08000000010	TSurname10	teacher10
Address11	2026-10-21 12:57:46.479659+00	teacher11@example.com	teacher11	\N	TName11	08000000011	TSurname11	teacher11
Address12	2026-10-21 12:57:46.490137+00	teacher12@example.com	teacher12	\N	TName12	08000000012	TSurname12	teacher12
Address13	2026-10-21 12:57:46.499564+00	teacher13@example.com	teacher13	\N	TName13	08000000013	TSurname13	teacher13
Address14	2026-10-21 12:57:46.509121+00	teacher14@example.com	teacher14	\N	TName14	08000000014	TSurname14	teacher14
Address15	2026-10-21 12:57:46.516767+00	teacher15@example.com	teacher15	\N	TName15	08000000015	TSurname15	teacher15
\.


--
-- Data for Name: teacherSubject; Type: TABLE DATA; Schema: public; Owner: amazing
--

COPY public."teacherSubject" ("subjectId", "teacherId") FROM stdin;
1	teacher1
1	teacher2
2	teacher2
2	teacher3
3	teacher3
3	teacher4
4	teacher4
4	teacher5
5	teacher5
5	teacher6
6	teacher6
6	teacher7
7	teacher7
7	teacher8
8	teacher8
8	teacher9
9	teacher9
9	teacher10
10	teacher10
10	teacher11
\.


--
-- Name: ledger_id_seq; Type: SEQUENCE SET; Schema: prisma_contract; Owner: amazing
--

SELECT pg_catalog.setval('prisma_contract.ledger_id_seq', 1, true);


--
-- Name: announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.announcements_id_seq', 5, true);


--
-- Name: assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.assignment_id_seq', 10, true);


--
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.attendance_id_seq', 20, true);


--
-- Name: class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.class_id_seq', 6, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.events_id_seq', 5, true);


--
-- Name: exams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.exams_id_seq', 10, true);


--
-- Name: grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.grade_id_seq', 6, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.lesson_id_seq', 30, true);


--
-- Name: result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.result_id_seq', 10, true);


--
-- Name: subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amazing
--

SELECT pg_catalog.setval('public.subject_id_seq', 10, true);


--
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: prisma_contract; Owner: amazing
--

ALTER TABLE ONLY prisma_contract.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (core_hash);


--
-- Name: ledger ledger_pkey; Type: CONSTRAINT; Schema: prisma_contract; Owner: amazing
--

ALTER TABLE ONLY prisma_contract.ledger
    ADD CONSTRAINT ledger_pkey PRIMARY KEY (id);


--
-- Name: marker marker_pkey; Type: CONSTRAINT; Schema: prisma_contract; Owner: amazing
--

ALTER TABLE ONLY prisma_contract.marker
    ADD CONSTRAINT marker_pkey PRIMARY KEY (space);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: admin admin_username_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_username_key UNIQUE (username);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: assignment assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT assignment_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: class class_name_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_name_key UNIQUE (name);


--
-- Name: class class_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: grade grade_level_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT grade_level_key UNIQUE (level);


--
-- Name: grade grade_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT grade_pkey PRIMARY KEY (id);


--
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- Name: parent parent_email_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT parent_email_key UNIQUE (email);


--
-- Name: parent parent_phone_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT parent_phone_key UNIQUE (phone);


--
-- Name: parent parent_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT parent_pkey PRIMARY KEY (id);


--
-- Name: parent parent_username_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT parent_username_key UNIQUE (username);


--
-- Name: result result_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT result_pkey PRIMARY KEY (id);


--
-- Name: studentSubject studentSubject_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public."studentSubject"
    ADD CONSTRAINT "studentSubject_pkey" PRIMARY KEY ("studentId", "subjectId");


--
-- Name: student student_email_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_email_key UNIQUE (email);


--
-- Name: student student_phone_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_phone_key UNIQUE (phone);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: student student_username_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_username_key UNIQUE (username);


--
-- Name: subject subject_name_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_name_key UNIQUE (name);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- Name: teacherSubject teacherSubject_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public."teacherSubject"
    ADD CONSTRAINT "teacherSubject_pkey" PRIMARY KEY ("teacherId", "subjectId");


--
-- Name: teacher teacher_email_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_email_key UNIQUE (email);


--
-- Name: teacher teacher_phone_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_phone_key UNIQUE (phone);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- Name: teacher teacher_username_key; Type: CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_username_key UNIQUE (username);


--
-- Name: announcements_classId_idx_0089e5e7; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "announcements_classId_idx_0089e5e7" ON public.announcements USING btree ("classId");


--
-- Name: assignment_lessonId_idx_e358970d; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "assignment_lessonId_idx_e358970d" ON public.assignment USING btree ("lessonId");


--
-- Name: attendance_lessonId_idx_e358970d; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "attendance_lessonId_idx_e358970d" ON public.attendance USING btree ("lessonId");


--
-- Name: attendance_studentId_idx_bf255322; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "attendance_studentId_idx_bf255322" ON public.attendance USING btree ("studentId");


--
-- Name: class_gradeId_idx_624f4a73; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "class_gradeId_idx_624f4a73" ON public.class USING btree ("gradeId");


--
-- Name: class_supervisorId_idx_fe423ed5; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "class_supervisorId_idx_fe423ed5" ON public.class USING btree ("supervisorId");


--
-- Name: events_classId_idx_0089e5e7; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "events_classId_idx_0089e5e7" ON public.events USING btree ("classId");


--
-- Name: exams_lessonId_idx_e358970d; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "exams_lessonId_idx_e358970d" ON public.exams USING btree ("lessonId");


--
-- Name: lesson_classId_idx_0089e5e7; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "lesson_classId_idx_0089e5e7" ON public.lesson USING btree ("classId");


--
-- Name: lesson_subjectId_idx_84df2a1d; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "lesson_subjectId_idx_84df2a1d" ON public.lesson USING btree ("subjectId");


--
-- Name: lesson_teacherId_idx_bc266660; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "lesson_teacherId_idx_bc266660" ON public.lesson USING btree ("teacherId");


--
-- Name: result_assignmentId_idx_8cfb4ac4; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "result_assignmentId_idx_8cfb4ac4" ON public.result USING btree ("assignmentId");


--
-- Name: result_examId_idx_a57bdadd; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "result_examId_idx_a57bdadd" ON public.result USING btree ("examId");


--
-- Name: result_studentId_idx_bf255322; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "result_studentId_idx_bf255322" ON public.result USING btree ("studentId");


--
-- Name: studentSubject_studentId_idx_bf255322; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "studentSubject_studentId_idx_bf255322" ON public."studentSubject" USING btree ("studentId");


--
-- Name: studentSubject_subjectId_idx_84df2a1d; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "studentSubject_subjectId_idx_84df2a1d" ON public."studentSubject" USING btree ("subjectId");


--
-- Name: student_classId_idx_0089e5e7; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "student_classId_idx_0089e5e7" ON public.student USING btree ("classId");


--
-- Name: student_gradeId_idx_624f4a73; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "student_gradeId_idx_624f4a73" ON public.student USING btree ("gradeId");


--
-- Name: student_parentId_idx_6a68f597; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "student_parentId_idx_6a68f597" ON public.student USING btree ("parentId");


--
-- Name: teacherSubject_subjectId_idx_84df2a1d; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "teacherSubject_subjectId_idx_84df2a1d" ON public."teacherSubject" USING btree ("subjectId");


--
-- Name: teacherSubject_teacherId_idx_bc266660; Type: INDEX; Schema: public; Owner: amazing
--

CREATE INDEX "teacherSubject_teacherId_idx_bc266660" ON public."teacherSubject" USING btree ("teacherId");


--
-- Name: announcements announcements_classId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT "announcements_classId_fkey" FOREIGN KEY ("classId") REFERENCES public.class(id);


--
-- Name: assignment assignment_lessonId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT "assignment_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES public.lesson(id);


--
-- Name: attendance attendance_lessonId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT "attendance_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES public.lesson(id);


--
-- Name: attendance attendance_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT "attendance_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public.student(id);


--
-- Name: class class_gradeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT "class_gradeId_fkey" FOREIGN KEY ("gradeId") REFERENCES public.grade(id);


--
-- Name: class class_supervisorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT "class_supervisorId_fkey" FOREIGN KEY ("supervisorId") REFERENCES public.teacher(id);


--
-- Name: events events_classId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT "events_classId_fkey" FOREIGN KEY ("classId") REFERENCES public.class(id);


--
-- Name: exams exams_lessonId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT "exams_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES public.lesson(id);


--
-- Name: lesson lesson_classId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT "lesson_classId_fkey" FOREIGN KEY ("classId") REFERENCES public.class(id);


--
-- Name: lesson lesson_subjectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT "lesson_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES public.subject(id);


--
-- Name: lesson lesson_teacherId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT "lesson_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES public.teacher(id);


--
-- Name: result result_assignmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT "result_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES public.assignment(id);


--
-- Name: result result_examId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT "result_examId_fkey" FOREIGN KEY ("examId") REFERENCES public.exams(id);


--
-- Name: result result_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT "result_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public.student(id);


--
-- Name: studentSubject studentSubject_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public."studentSubject"
    ADD CONSTRAINT "studentSubject_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public.student(id);


--
-- Name: studentSubject studentSubject_subjectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public."studentSubject"
    ADD CONSTRAINT "studentSubject_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES public.subject(id);


--
-- Name: student student_classId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "student_classId_fkey" FOREIGN KEY ("classId") REFERENCES public.class(id);


--
-- Name: student student_gradeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "student_gradeId_fkey" FOREIGN KEY ("gradeId") REFERENCES public.grade(id);


--
-- Name: student student_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "student_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public.parent(id);


--
-- Name: teacherSubject teacherSubject_subjectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public."teacherSubject"
    ADD CONSTRAINT "teacherSubject_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES public.subject(id);


--
-- Name: teacherSubject teacherSubject_teacherId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: amazing
--

ALTER TABLE ONLY public."teacherSubject"
    ADD CONSTRAINT "teacherSubject_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES public.teacher(id);


--
-- PostgreSQL database dump complete
--

\unrestrict l1jAbfh1Xl3APTPbzqPNn0y7aqfSvVv4hRVOoJCoxvcYOeZz46oQpyXAZlgJdob

