SELECT COUNT(*) FROM review_id_table;

SELECT COUNT(*) FROM vine_table WHERE vine = 'Y';

SELECT COUNT(*) FROM vine_table WHERE vine = 'N';

SELECT AVG(star_rating) FROM vine_table WHERE vine = 'Y';

SELECT AVG(star_rating) FROM vine_table WHERE vine = 'N';

SELECT star_rating, COUNT(*) FROM vine_table WHERE vine = 'Y' GROUP BY star_rating;

SELECT star_rating, COUNT(*) FROM vine_table WHERE vine = 'N' GROUP BY star_rating;

SELECT AVG(helpful_votes) FROM vine_table WHERE vine = 'Y';

SELECT AVG(helpful_votes) FROM vine_table WHERE vine = 'N';

SELECT AVG(total_votes) FROM vine_table WHERE vine = 'Y';

