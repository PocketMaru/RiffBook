import SQLiteData

extension DatabaseMigrator {
    mutating func registerSessionMigrations() {
        registerMigration("Create sessionRecords") { db in
            try #sql(
                """
                CREATE TABLE "sessionRecords" (
                    "id" TEXT PRIMARY KEY NOT NULL DEFAULT (uuid()),
                    "name" TEXT NOT NULL,
                    "creationDate" TEXT NOT NULL
                ) STRICT
                """
            )
            .execute(db)
        }
    }
}
