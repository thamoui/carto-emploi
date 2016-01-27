CREATE TABLE job_lists (
  id_key serial primary key NOT NULL,
  slug text,
  label text,
  code_rome text
  );

  INSERT INTO job_lists (id_key, slug, label, code_rome) VALUES
  (1, '', 'Tous métiers informatique', ''),
  (2, 'Administrateur', 'Administrateur', 'M1801'),
  (3, 'Administrateur de base de données', 'Administrateur de base de données', 'M1801'),
  (4, 'Chef de projet web', 'Chef$0020de$0020projet$0020web', 'M1803'),
  (5, 'Développeur', 'D$00e9veloppeur', 'M1805'),
  (6, 'Ingénieur informatique', 'Ing$00e9nieur$0020informatique', 'M1810'),
  (7, 'Intégrateur', 'Int$00e9grateur', 'M1805'),
  (8, 'Sécurité informatique', 'S$00e9curit$00e9$0020informatique', 'M1801'),
  (9, 'Webmaster', 'Webmaster', 'M1805'),
  (10, 'Informaticien', 'Informaticien', 'M1805'),
  (11, 'Informatique', 'Informatique', 'M1805'),
  (12, 'Architecte', 'Architecte', 'M1802'),
  (13, 'Responsable informatique', 'Responsable$0020informatique', 'M1803'),
  (14, 'Testeur informatique', 'Testeur$0020informatique', 'M1805')
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
  publication_date text,
  lang text,
  lang_gr text,
  created_at timestamp with time zone
);

CREATE TABLE parse (
  url text,
  id text,
  id_key serial primary key NOT NULL
);
