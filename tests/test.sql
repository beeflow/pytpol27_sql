-- Start a transaction.
BEGIN;

-- drop database if exists test;
-- create database test;
-- use test;
--
-- create table `user`
-- (
--     id          int auto_increment primary key,
--     name        varchar(15)  not null,
--     surname     varchar(50)  not null,
--     email       varchar(100) null,
--     phone       varchar(12),
--     card_number varchar(9)
-- );

-- Plan how many tests you want to run.
SELECT tap.plan(9);

-- Run the tests.
SELECT tap.pass('My test passed, w00t!');

SELECT tap.has_table(DATABASE(), 'book', 'Table book exists!');
SELECT tap.has_table(DATABASE(), 'author', 'Table author exists!');
SELECT tap.has_table(DATABASE(), 'user', 'Table user exists!');
SELECT tap.has_table(DATABASE(), 'book_author', 'Table book_author exists!');
SELECT tap.has_table(DATABASE(), 'book_status', 'Table book_status exists!');

insert into `user` (first_name_id, last_name_id, email)
values (f_add_first_name('Heniek'), f_add_last_name('Olbromski'), 'heniek.o@beeflow.co.uk');

INSERT INTO book(book_title, book_isbn)
VALUES ('Przygody Heńka O', '1-1153111');
insert into book_copy (book_id)
select book_id
from book
where book_title = 'Przygody Heńka O';

select id
from book_status
where name = 'Dostępna';

select tap.ok((select id from book_status where name = 'Dostepna'), 'Istnieje status dostępna');

select tap.eq(
               (select status_id from book_copy where book_id = (select book_id from book where book_title = 'Przygody Heńka O')),
               (select id from book_status where lower(name) = 'dostepna'),
               'Domyślnie kopia książki jest dostępna'
           );

insert into user_book_rent (bc_id, user_id)
values (
        (select book_id from book where book_title = 'Przygody Heńka O'),
        (select id from `user` where email = 'heniek.o@beeflow.co.uk')
);

select tap.eq(
               (select status_id from book_copy where book_id = (select book_id from book where book_title = 'Przygody Heńka O')),
               (select id from book_status where lower(name) = 'wypozyczona'),
               'Wypożyczenie zmienia status książki na wypożyczona'
           );

CALL tap.finish();

drop database if exists test;

ROLLBACK;
