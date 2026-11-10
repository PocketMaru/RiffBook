import SQLiteData

extension DatabaseMigrator {
    mutating func registerRecordingMigrations() {
        registerMigration("Create recordingRecords") { db in
            try #sql(
                """
                CREATE TABLE "recordingRecords" (
                    "id" TEXT PRIMARY KEY NOT NULL DEFAULT (uuid()),
                    "riffID" TEXT REFERENCES "riffRecords"("id") ON DELETE CASCADE,
                    "sessionID" TEXT REFERENCES "sessionRecords"("id") ON DELETE CASCADE,
                    "name" TEXT NOT NULL,
                    "mediaType" TEXT NOT NULL,
                    "fileName" TEXT NOT NULL,
                    "createdAt" TEXT NOT NULL,
                    CHECK (
                        ("riffID" IS NOT NULL AND "sessionID" IS NULL)
                        OR
                        ("riffID" IS NULL AND "sessionID" IS NOT NULL)
                    )
                ) STRICT
                """
            )
            .execute(db)
        }
        
        registerMigration("Index recordings by riff") { db in
            try #sql(
                """
                CREATE INDEX "recordingRecords_riffID" ON "recordingRecords" ("riffID")
                """
            )
            .execute(db)
        }
        
        registerMigration("Index recordings by session") { db in
            try #sql(
                """
                CREATE INDEX "recordingRecords_sessionID" ON "recordingRecords" ("sessionID")
                """
            )
            .execute(db)
        }
    }
}
