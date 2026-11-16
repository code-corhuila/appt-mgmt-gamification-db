CREATE TABLE IF NOT EXISTS achievements (
    id TEXT PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    description TEXT NOT NULL,
    icon_key VARCHAR(64) NOT NULL,
    target INTEGER NOT NULL CHECK (target > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_achievements (
    user_id TEXT NOT NULL,
    achievement_id TEXT NOT NULL REFERENCES achievements(id) ON DELETE RESTRICT,
    progress INTEGER NOT NULL DEFAULT 0 CHECK (progress >= 0),
    is_unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    unlocked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, achievement_id),
    CHECK (
        (is_unlocked = TRUE AND unlocked_at IS NOT NULL)
        OR (is_unlocked = FALSE AND unlocked_at IS NULL)
    )
);

CREATE INDEX IF NOT EXISTS user_achievements_unlocked_idx
    ON user_achievements (user_id, is_unlocked);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS user_achievements_set_updated_at ON user_achievements;
CREATE TRIGGER user_achievements_set_updated_at
    BEFORE UPDATE ON user_achievements
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();
