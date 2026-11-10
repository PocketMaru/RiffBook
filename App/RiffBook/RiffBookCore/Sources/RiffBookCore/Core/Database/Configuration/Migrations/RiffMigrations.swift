import SQLiteData

extension DatabaseMigrator {
    mutating func registerRiffMigrations() {
        registerMigration("Create riffRecords") { db in
            try #sql(
                """
                CREATE TABLE "riffRecords" (
                    "id" TEXT PRIMARY KEY NOT NULL DEFAULT (uuid()),
                    "name" TEXT NOT NULL,
                    "instrument" TEXT NOT NULL,
                    "key" TEXT NOT NULL,
                    "tuning" TEXT NOT NULL,
                    "description" TEXT NOT NULL,
                    "favorite" TEXT,
                    "updatedAt" TEXT NOT NULL,
                    "createdAt" TEXT NOT NULL
                ) STRICT
                """
            )
            .execute(db)
        }
    }
}
