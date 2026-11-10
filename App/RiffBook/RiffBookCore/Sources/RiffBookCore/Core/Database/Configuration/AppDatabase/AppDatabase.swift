import OSLog
import SQLiteData

/// Database relationships:
/// - Each recording belongs to exactly one riff or session.
/// - Each effect belongs to one riff; a riff can have many effects.
/// - SongRiff links songs and riffs in a many-to-many relationship.
///   Each song–riff pair is unique, with a position defining its order in that song.
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
    
    migrator.registerRiffMigrations()
    
    migrator.registerSongMigrations()
    
    migrator.registerSongRiffMigrations()
    
    migrator.registerSessionMigrations()
    
    migrator.registerRecordingMigrations()
    
    migrator.registerEffectsMigrations()
    
    try migrator.migrate(db)
    
    logger.info("Opened database at `\(db.path)`")
    
    return db
}

private let logger = Logger(
    subsystem: "RiffBook",
    category: "Database"
)
