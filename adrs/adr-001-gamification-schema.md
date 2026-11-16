# ADR 001: Relational schema for achievements

- **Status:** Accepted
- **Context:** Salud Activa tracks achievements for medication use, health records, and appointments.
  The Android app currently models an achievement's catalog data separately from its unlock progress.
- **Decision:** Store catalog entries in `achievements` and user-specific state in
  `user_achievements`. Use the identity service's user ID as an external key rather than duplicating
  the user table. Keep Android drawable identifiers in the app and expose a stable `icon_key` in the
  shared catalog.
- **Consequences:** PostgreSQL constraints protect catalog and progress integrity, while ordered
  migrations keep schema changes deployable. User deletion and identity validation remain owned by
  the identity service.
