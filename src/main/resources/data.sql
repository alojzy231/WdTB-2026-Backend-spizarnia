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

-- ===== LAB 02 · pantry_item =====
insert into pantry_item (name, quantity, unit, location, expiry_date, min_quantity, opened) values
    ('Mleko 2%',            1.00, 'L',     'FRIDGE',   '2026-10-28', 1.00, true),
    ('Pierogi ruskie',      0.50, 'KG',    'FREEZER',  '2027-02-15', null, false),
    ('Makaron penne',       2.00, 'PACK',  'CUPBOARD', '2027-06-30', 1.00, false),
    ('Jajka',               6.00, 'PIECE', 'FRIDGE',   '2026-11-05', 4.00, false);

-- ===== LAB 02 · shopping_list_item =====
insert into shopping_list_item (product_name, quantity, unit, estimated_price, purchased, added_at) values
    ('Mleko 2%',            2.00, 'L',     7.98,  false, '2026-10-22 18:30:00'),
    ('Jajka',              10.00, 'PIECE', 12.49, false, '2026-10-23 09:15:00'),
    ('Ryż basmati',         1.00, 'PACK',  6.99,  true,  '2026-10-20 20:00:00'),
    ('Ser żółty',         300.00, 'G',     null,  false, current_timestamp);
