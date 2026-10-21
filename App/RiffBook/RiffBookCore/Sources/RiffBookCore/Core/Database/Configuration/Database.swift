import OSLog
import SQLiteData

func appDatabase() throws -> any DatabaseWriter {
    @Dependency(\.context) var context
    
    var config = Configuration()
    
#if DEBUG
    config.prepareDatabase { db in
        db.trace(options: .profile) {
            if context == .preview {
                print("\($0.expandedDescription)")
            } else {
                logger.debug("\($0.expandedDescription)")
            }
        }
    }
#endif
    
    let db = try defaultDatabase(
        configuration: config
    )
    
    var migrator = DatabaseMigrator()
    
#if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
#endif
    
    migrator.registerMigration("Create riffs") { db in
        try #sql(
            """
            CREATE TABLE "riffRecords" (
                "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
                "name" TEXT NOT NULL,
                "instrument" TEXT NOT NULL,
                "effects" TEXT NOT NULL,
                "key" TEXT NOT NULL,
                "tuning" TEXT NOT NULL,
                "description" TEXT NOT NULL,
                "recordings" TEXT NOT NULL,
                "favorite" TEXT,
                "updatedAt" TEXT NOT NULL,
                "createdAt" TEXT NOT NULL
            ) STRICT
            """
        )
        .execute(db)
    }
    
    migrator.registerMigration("Create songs") { db in
        try #sql(
            """
            CREATE TABLE "songRecords" (
                "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
                "name" TEXT NOT NULL,
                "tuning" TEXT NOT NULL,
                "riffs" TEXT NOT NULL,
                "creationDate" TEXT NOT NULL
            ) STRICT
            """
        )
        .execute(db)
    }
    
    migrator.registerMigration("Create sessions") { db in
        try #sql(
            """
            CREATE TABLE "sessionRecords" (
                "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
                "name" TEXT NOT NULL,
                "recordings" TEXT NOT NULL,
                "creationDate" TEXT NOT NULL
            ) STRICT
            """
        )
        .execute(db)
    }
    
    migrator.registerMigration("Create recordings") { db in
        try #sql(
            """
            CREATE TABLE "recordingRecords" (
                "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
                "name" TEXT NOT NULL,
                "mediaType" TEXT NOT NULL,
                "fileName" TEXT NOT NULL,
                "createdAt" TEXT NOT NULL
            ) STRICT
            """
        )
        .execute(db)
    }
    
    try migrator.migrate(db)
    
    logger.info("Opened database at `\(db.path)`")
    
    return db
}

private let logger = Logger(
    subsystem: "RiffBook",
    category: "Database"
)
