create table book_copy_copy like book_copy;

drop table if exists book_copy_copy;

create view v_book_author as
select book.*, a.*
from book
         left join book_author ba on book.book_id = ba.ba_book_id
         left join author a on a.id = ba.ba_author_id;

select * from v_book_author;

-- 1. usunąć widok
drop view v_book_author;

-- 2. utworzyć nowy
create view v_book_author as
select book.*, first_name, last_name, a.id as author_id
from book
         left join book_author ba on book.book_id = ba.ba_book_id
         left join author a on a.id = ba.ba_author_id
         left join first_name fn on fn.id = a.first_name_id
         left join last_name ln on ln.id = a.last_name_id;

insert into user_book_rent(bc_id, user_id)
values (1, 1);

update book_copy
set status_id = (select id from book_status where lower(name) = 'wypożyczona')
where book_id = 1;


select status_id from book_copy where id = 2;

drop trigger if exists trg_rent_book_insert;
create trigger trg_rent_book_insert before insert on user_book_rent for each row
begin
    if (select status_id from book_copy where id = NEW.bc_id) <> 1 then
        SIGNAL SQLSTATE '45000' SET
        MYSQL_ERRNO = 60654,
        MESSAGE_TEXT = 'Error: książka jest już wypożyczona!';
    end if;
end;

insert into user_book_rent(bc_id, user_id)
values (2, 1);

create trigger trg_rent_book_change_status_insert after insert on user_book_rent for each row
begin
    update book_copy
    set status_id = (select id from book_status where lower(name) = 'wypożyczona')
    where book_id = NEW.bc_id;
end;

insert into user_book_rent(bc_id, user_id)
values (3, 1);

-- zwracam książkę nr 1
update user_book_rent set returned_on = cast(now() as date) where id = 1;

-- trigger, który po dodaniu daty zwrotu książki, zmieni jej status
drop trigger if exists trg_rent_book_change_status_update;
create trigger trg_rent_book_change_status_update after update on user_book_rent for each row
begin
    -- nie pozwól podmienić książki na już wypożyczoną
    if new.bc_id <> OLD.bc_id and (select status_id from book_copy where id = NEW.bc_id) <> 1 then
        SIGNAL SQLSTATE '45000' SET
        MYSQL_ERRNO = 60654,
        MESSAGE_TEXT = 'Error: książka jest już wypożyczona!';
    end if;

        -- nie pozwól wypożyczyć książki z datąwcześniejszą niż jej ostatnia data zwrotu
    if (new.rented_on < (select max(returned_on) from user_book_rent where id = NEW.bc_id)) then
        SIGNAL SQLSTATE '45000' SET
        MYSQL_ERRNO = 60654,
        MESSAGE_TEXT = 'Error: data wypożyczenia wcześniejsza niż oddania!';
    end if;

    -- zmień status nowej książki na wypożyczona a starej na dostępna, jeżeli podmieniasz książki
    if new.bc_id <> OLD.bc_id then
        update book_copy
        set status_id = (select id from book_status where lower(name) = 'wypożyczona')
        where book_id = NEW.bc_id;
    end if;

    -- zmień status tylko jeżeli jest faktycznie zwracana lub zamieniono książki
    if (OLD.returned_on is null and NEW.returned_on is not null) or new.bc_id <> OLD.bc_id then
        update book_copy
        set status_id = (select id from book_status where lower(name) = 'dostępna')
        where book_id = old.bc_id;
    end if;
end;

update user_book_rent set bc_id = 2 where id = 8;