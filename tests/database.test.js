const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const migrationPath = path.join(
  __dirname,
  '..',
  'migrations',
  '001_create_gamification_tables.sql'
);
const migration = fs.readFileSync(migrationPath, 'utf8');
const seed = fs.readFileSync(path.join(__dirname, '..', 'seed.sql'), 'utf8');

test('schema separates the catalog from each user’s progress', () => {
  assert.match(migration, /CREATE TABLE IF NOT EXISTS achievements\s*\(/i);
  assert.match(migration, /CREATE TABLE IF NOT EXISTS user_achievements\s*\(/i);
  assert.match(migration, /PRIMARY KEY\s*\(user_id,\s*achievement_id\)/i);
  assert.match(
    migration,
    /achievement_id TEXT NOT NULL REFERENCES achievements\(id\) ON DELETE RESTRICT/i
  );
});

test('schema protects achievement targets, progress, and unlock timestamps', () => {
  assert.match(migration, /target INTEGER NOT NULL CHECK \(target > 0\)/i);
  assert.match(migration, /progress INTEGER NOT NULL DEFAULT 0 CHECK \(progress >= 0\)/i);
  assert.match(
    migration,
    /is_unlocked = TRUE AND unlocked_at IS NOT NULL[\s\S]*is_unlocked = FALSE AND unlocked_at IS NULL/i
  );
  assert.match(migration, /CREATE TRIGGER user_achievements_set_updated_at/i);
});

test('seed includes the five achievement IDs used by the Salud Activa app', () => {
  for (const id of [
    'first_pill',
    'med_streak_3',
    'med_streak_10',
    'record_health',
    'first_appointment'
  ]) {
    assert.match(seed, new RegExp(`\\('${id}',`));
  }
  assert.match(seed, /ON CONFLICT \(id\) DO NOTHING/i);
  assert.match(seed, /'med_streak_3',[^;]*, 3\)/);
  assert.match(seed, /'med_streak_10',[^;]*, 10\)/);
});
