CREATE TABLE job_list (
  id_key serial primary key NOT NULL,
  slug text,
  label text,
  code_rome text
  );

INSERT INTO job_list (id_key, slug, label, code_rome) VALUES
(1, 'Administrateur', 'Administrateur', 'M1801'),
(2, 'Administrateur de base de données', 'Administrateur de base de données', 'M1801'),
(3, 'Chef de projet web', 'Chef de projet web', 'M1803'),
(4, 'Développeur', 'Développeur', 'M1805'),
(5, 'Ingénieur informatique', 'Ingénieur informatique', 'M1810'),
(6, 'Intégrateur', 'Intégrateur', 'M1805'),
(7, 'Sécurité informatique', 'Sécurité informatique', 'M1801'),
(8, 'Webmaster', 'Webmaster', 'M1805'),
(9, 'Informaticien', 'Informaticien', 'M1805'),
(10, 'Informatique', 'Informatique', 'M1805'),
(11, 'Architecte', 'Architecte', 'M1802'),
(12, 'Responsable informatique', 'Responsable informatique', 'M1803'),
(13, 'Testeur informatique', 'Testeur informatique', 'M1805')
;

CREATE TABLE job_offers (
  region_adress text,
  id_key serial primary key NOT NULL,
  title text,
  contrat_type text,
  code_rome text,
  offer_description text,
  company_description text,
  url text,
  latitude numeric,
  longitude numeric,
  offer_id text,
  publication_date text
);

CREATE TABLE parse (
  url text,
  id text,
  id_key serial primary key NOT NULL
);
