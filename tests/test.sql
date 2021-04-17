-- Start a transaction.
BEGIN;

-- Plan how many tests you want to run.
SELECT tap.plan(1);

-- Run the tests.
SELECT tap.pass('My test passed, w00t!');

-- Finish the tests and clean up.
CALL tap.finish();
ROLLBACK;

BEGIN;
SELECT tap.plan(5);

SELECT tap.has_table(DATABASE(), 'book', 'Table book exists!');
SELECT tap.has_table(DATABASE(), 'author', 'Table author exists!');
SELECT tap.has_table(DATABASE(), 'user', 'Table user exists!');
SELECT tap.has_table(DATABASE(), 'book_author', 'Table book_author exists!');
SELECT tap.has_table(DATABASE(), 'book_status', 'Table book_status exists!');

CALL tap.finish();
ROLLBACK;