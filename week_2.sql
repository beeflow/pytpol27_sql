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

