import SQLiteData

extension DatabaseMigrator {
    mutating func registerSongRiffMigrations() {
        registerMigration("Create junction for song and riff tables") { db in
            try #sql(
                """
                CREATE TABLE "songRiffRecords" (
                    "songID" TEXT NOT NULL REFERENCES "songRecords"("id") ON DELETE CASCADE,
                    "riffID" TEXT NOT NULL REFERENCES "riffRecords"("id") ON DELETE CASCADE,
                    "position" INTEGER NOT NULL,
                    PRIMARY KEY ("songID", "riffID")
                ) STRICT
                """
            )
            .execute(db)
        }
        
        registerMigration("Index on songs containing the riff provided's ID.") { db in
            try #sql(
                """
                CREATE INDEX "songRiffRecords_riffID" ON "songRiffRecords" ("riffID")
                """
            )
            .execute(db)
        }
    }
}
