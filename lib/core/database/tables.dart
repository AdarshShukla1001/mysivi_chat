const String createUsersTable = '''
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  last_active TEXT NOT NULL
);
''';

const String createMessagesTable = '''
CREATE TABLE IF NOT EXISTS messages (
  id TEXT PRIMARY KEY,
  chat_id TEXT NOT NULL,
  message TEXT NOT NULL,
  owner TEXT NOT NULL,
  timestamp TEXT NOT NULL
);
''';
