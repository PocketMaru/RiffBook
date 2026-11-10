import SQLiteData

extension DatabaseMigrator {
    mutating func registerSongMigrations() {
        registerMigration("Create songRecords") { db in
            try #sql(
                """
                CREATE TABLE "songRecords" (
                    "id" TEXT PRIMARY KEY NOT NULL DEFAULT (uuid()),
                    "name" TEXT NOT NULL,
                    "tuning" TEXT NOT NULL,
                    "creationDate" TEXT NOT NULL
                ) STRICT
                """
            )
            .execute(db)
        }
    }
}
