-- seq_tup_avg >100 bad
select
    relname,
    pg_size_pretty(pg_relation_size(relname::regclass)) as size,
    seq_scan, seq_tup_read,
    seq_scan / seq_tup_read as seq_tup_avg
from pg_stat_user_tables
    where seq_tup_read > 0 order by 3,4 desc;
