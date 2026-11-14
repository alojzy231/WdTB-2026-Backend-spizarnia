-- Dane startowe aplikacji. Tabele tworzy Hibernate z encji, a ten plik Spring Boot uruchamia zaraz potem.
-- LAB 01: dopiszcie tu konta wszystkich osób z zespołu (reguła R1.03).
-- LAB 02: dopiszcie dane do swoich tabel (kolejność: najpierw tabele, na które wskazują klucze obce).
insert into user_account (email, display_name, role, created_at) values
    ('ola@student.merito.pl',   'Ola',   'USER',    current_timestamp),
    ('kuba@student.merito.pl',  'Kuba',  'USER',    current_timestamp),
    ('firma@example.com',       'Firma', 'PARTNER', current_timestamp),
    ('admin@example.com',       'Admin', 'ADMIN',   current_timestamp);

-- LAB 01: Wasze konta (zmieńcie na swoje dane, rola USER)
-- insert into user_account (email, display_name, role, created_at) values
--     ('imie.nazwisko@student.merito.pl', 'Imię', 'USER', current_timestamp);
insert into user_account (email, display_name, role, created_at) values
    ('s586133@student.wroclaw.merito.pl', 'Damian Kłos',      'USER', current_timestamp),
    ('s737494@student.wroclaw.merito.pl', 'Cezary Goluch',    'USER', current_timestamp),
    ('s451014@student.wroclaw.merito.pl', 'Paulina Kowalska', 'USER', current_timestamp);

-- ===== LAB 02 · household =====                (wyżej niż tabele, które na nią wskazują)
insert into household (name, street, building_number, apartment_number, city, postal_code, members_count, created_at) values
    ('Mieszkanie Kasi',     'ul. Ruska',    '12', '4',   'Wrocław', '50-079', 3, '2026-10-01'),
    ('Dom Nowaków',         'ul. Kwiatowa', '7',  null,  'Oława',   '55-200', 4, '2026-09-15'),
    ('Pokój w akademiku',   'ul. Wittiga',  '4',  '204', 'Wrocław', '51-628', 2, '2026-10-10');

-- ===== LAB 03 · household_member =====         (konta: 1 = Ola, 2 = Kuba, 5 = Damian, 6 = Cezary, 7 = Paulina)
insert into household_member (nickname, joined_at, is_owner, household_id, user_account_id) values
    ('Ola',     '2026-10-01', true,  1, 1),
    ('Paulina', '2026-10-03', false, 1, 7),
    ('Kuba',    '2026-09-15', true,  2, 2),
    ('Damian',  '2026-10-10', true,  3, 5),
    ('Czarek',  '2026-10-12', false, 3, 6);

-- ===== LAB 03 · tag =====
insert into tag (name, color, description, created_at) values
    ('nabiał',          '#f2e3b3', 'Mleko, jogurty, sery i jajka',     '2026-10-01'),
    ('wegetariańskie',  '#8bc34a', 'Bez mięsa i ryb',                  '2026-10-01'),
    ('szybki obiad',    '#ff9800', 'Gotowe w 15 minut',                '2026-10-05'),
    ('na śniadanie',    '#03a9f4', null,                               '2026-10-05');

-- ===== LAB 02 · pantry_item =====               (household_id: 1 = Mieszkanie Kasi, 2 = Dom Nowaków, 3 = akademik)
insert into pantry_item (name, quantity, unit, location, expiry_date, min_quantity, opened, household_id) values
    ('Mleko 2%',            1.00, 'L',     'FRIDGE',   '2026-10-28', 1.00, true,  1),
    ('Pierogi ruskie',      0.50, 'KG',    'FREEZER',  '2027-02-15', null, false, 2),
    ('Makaron penne',       2.00, 'PACK',  'CUPBOARD', '2027-06-30', 1.00, false, 1),
    ('Jajka',               6.00, 'PIECE', 'FRIDGE',   '2026-11-05', 4.00, false, 3);

-- ===== LAB 03 · pantry_item_tag =====           (pary: produkt + etykieta)
insert into pantry_item_tag (pantry_item_id, tag_id) values
    (1, 1),                     -- mleko: nabiał
    (1, 4),                     -- mleko: na śniadanie
    (2, 2),                     -- pierogi: wegetariańskie
    (2, 3),                     -- pierogi: szybki obiad
    (3, 2),                     -- makaron: wegetariańskie
    (4, 1),                     -- jajka: nabiał
    (4, 4);                     -- jajka: na śniadanie

-- ===== LAB 02 · shopping_list_item =====        (pantry_item_id pusty, gdy produktu nie ma w spiżarni)
insert into shopping_list_item (product_name, quantity, unit, estimated_price, purchased, added_at, household_id, pantry_item_id) values
    ('Mleko 2%',            2.00, 'L',     7.98,  false, '2026-10-22 18:30:00', 1, 1),
    ('Jajka',              10.00, 'PIECE', 12.49, false, '2026-10-23 09:15:00', 3, 4),
    ('Ryż basmati',         1.00, 'PACK',  6.99,  true,  '2026-10-20 20:00:00', 2, null),
    ('Ser żółty',         300.00, 'G',     null,  false, current_timestamp,     1, null);
