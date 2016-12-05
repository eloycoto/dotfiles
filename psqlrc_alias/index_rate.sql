WITH index_used AS (
    SELECT
        relname,
        100 * idx_scan / (seq_scan + idx_scan) index_used,
        n_live_tup rows_in_table
    FROM pg_stat_user_tables
    WHERE
        seq_scan + idx_scan > 0)

SELECT
    relname,
    index_used,
    rows_in_table
from index_used
WHERE
    index_used < 90
    and rows_in_table > 10000;
