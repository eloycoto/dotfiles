select
  client_addr as client,
  pg_size_pretty(pg_xlog_location_diff(pg_current_xlog_location(),sent_location)) as pending,
  pg_size_pretty(pg_xlog_location_diff(sent_location,write_location)) as write,
  pg_size_pretty(pg_xlog_location_diff(write_location,flush_location)) as flush,
  pg_size_pretty(pg_xlog_location_diff(flush_location,replay_location)) as replay,
  pg_size_pretty(pg_xlog_location_diff(pg_current_xlog_location(),replay_location)) as total
from pg_stat_replication;
