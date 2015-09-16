CREATE TABLE lang_lists (
  id_key serial primary key NOT NULL,
  name text,
  group text,
  popularity number
  );

  INSERT INTO job_lists (id_key, slug, label, code_rome) VALUES
  
  (1, 'javaScript', 'javaScript', ''),
  (2, 'Administrateur', 'Administrateur', 'M1801'),
  (3, 'Administrateur de base de données', 'Administrateur de base de données', 'M1801'),
  (4, 'Chef de projet web', 'Chef de projet web', 'M1803'),
  (5, 'Développeur', 'Développeur', 'M1805'),
  (6, 'Ingénieur informatique', 'Ingénieur informatique', 'M1810'),
  (7, 'Intégrateur', 'Intégrateur', 'M1805'),
  (8, 'Sécurité informatique', 'Sécurité informatique', 'M1801'),
  (9, 'Webmaster', 'Webmaster', 'M1805'),
  (10, 'Informaticien', 'Informaticien', 'M1805'),
  (11, 'Informatique', 'Informatique', 'M1805'),
  (12, 'Architecte', 'Architecte', 'M1802'),
  (13, 'Responsable informatique', 'Responsable informatique', 'M1803'),
  (14, 'Testeur informatique', 'Testeur informatique', 'M1805')
  ;