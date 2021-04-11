create table if not exists book
(
    book_id           int auto_increment,
    book_title        varchar(250) not null,
    book_isbn         varchar(13)  not null,
    book_pages        int(4),
    book_publish_year int(4),

    primary key (book_id)
);

create table author
(
    id      int auto_increment primary key,
    name    varchar(15) not null,
    surname varchar(50) not null
);

create table `user`
(
    id          int auto_increment primary key,
    name        varchar(15)  not null,
    surname     varchar(50)  not null,
    email       varchar(100) null,
    phone       varchar(12),
    card_number varchar(9)
);

create table book_author
(
    ba_book_id   int not null,
    ba_author_id int not null,

    primary key (ba_author_id, ba_book_id),
    foreign key (ba_book_id) references book (book_id) on update cascade on delete restrict,
    foreign key (ba_author_id) references author (id) on update cascade on delete restrict
);


insert into `user` (name, surname, email)
values ('Rafał', 'Przetakowski', 'rafal.p@beeflow.co.uk');
insert into `user` (name, surname, email)
values ('Tomasz', 'Zasada', 'tomasz.zasada@wp.pl');
insert into `user` (name, surname, email)
values ('Olga', 'Czytelna', 'czytelna.o@onet.pl');


INSERT INTO book(book_title, book_isbn)
VALUES ('Wyznawcy płomienia', '1-11111'),
       ('Rose mother', '1234-1'),
       ('Władca pierścieni - dwie wieże', '4321-4');

INSERT INTO author(name, surname)
VALUES ('Stephen', 'King'),
       ('J.R.R.', 'Tolkien');

select book_id
from book
where book_title like 'Rose%';

insert into book_author (ba_book_id, ba_author_id)
values ((select book_id from book where book_title like 'Rose%'),
        (select id from author where author.surname like 'King'));

select *
from book
         right join book_author on book.book_id = book_author.ba_book_id
         right join author as a on book_author.ba_author_id = a.id;

select *
from author
         inner join book_author ba on author.id = ba.ba_author_id
         inner join book b on b.book_id = ba.ba_book_id;

create table book_status
(
    id   int auto_increment primary key,
    name varchar(20) not null unique
);

drop table if exists book_statu;

insert into book_status(name)
values ('Dostępna'),
       ('Wypożyczona');

create table book_copy
(
    id        int auto_increment,
    book_id   int not null,
    status_id int not null default (1),

    primary key (id),
    foreign key (book_id) references book (book_id) on update cascade on delete restrict,
    foreign key (status_id) references book_status (id) on update cascade on delete restrict
);

create table user_book_rent
(
    id          int auto_increment,
    bc_id       int  not null,
    user_id     int  not null,
    rented_on   date not null default (now()),
    returned_on date null,

    primary key (id),
    foreign key (bc_id) references book_copy (id) on update cascade on delete restrict,
    foreign key (user_id) references `user` (id) on update cascade on delete restrict
);

update book
set book_pages        = 366,
    book_publish_year = 2000
where book_title like 'Rose%other';

