import SQLiteData

extension DatabaseMigrator {
    mutating func registerEffectsMigrations() {
        registerMigration("Create effectsRecords") { db in
            try #sql(
                """
                CREATE TABLE "effectsRecords" (
                    "id" TEXT PRIMARY KEY NOT NULL DEFAULT(uuid()),
                    "riffID" TEXT NOT NULL REFERENCES "riffRecords"("id") ON DELETE CASCADE,
                    "effect" TEXT NOT NULL
                ) STRICT
                """
            )
            .execute(db)
        }
        
        registerMigration("Index effects by riff") { db in
            try #sql(
                """
                CREATE INDEX "effectsRecords_riffID" ON "effectsRecords" ("riffID")
                """
            )
            .execute(db)
        }
    }
}
