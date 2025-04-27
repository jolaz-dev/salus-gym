class SQLiteMigration20250422Initial {
  static const String sql = '''
    CREATE TABLE IF NOT EXISTS appointment (
      id VARCHAR(36) NOT NULL,
      title VARCHAR(200) NOT NULL,
      start_time_utc INTEGER NOT NULL,
      duration_in_minutes INTEGER NOT NULL,
      color TEXT NOT NULL,
      CONSTRAINT appointment_pk PRIMARY KEY (id)
  );
  ''';
}
