const oracledb = require('oracledb');
const loadEnvFile = require('./utils/envUtil');

const envVariables = loadEnvFile('./.env');

// Database configuration setup. Ensure your .env file has the required database credentials.
const dbConfig = {
    user: envVariables.ORACLE_USER,
    password: envVariables.ORACLE_PASS,
    connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
    poolMin: 1,
    poolMax: 3,
    poolIncrement: 1,
    poolTimeout: 60
};

// initialize connection pool
async function initializeConnectionPool() {
    try {
        await oracledb.createPool(dbConfig);
        console.log('Connection pool started');
    } catch (err) {
        console.error('Initialization error: ' + err.message);
    }
}

async function closePoolAndExit() {
    console.log('\nTerminating');
    try {
        await oracledb.getPool().close(10); // 10 seconds grace period for connections to finish
        console.log('Pool closed');
        process.exit(0);
    } catch (err) {
        console.error(err.message);
        process.exit(1);
    }
}

initializeConnectionPool();

process
    .once('SIGTERM', closePoolAndExit)
    .once('SIGINT', closePoolAndExit);


// ----------------------------------------------------------
// Wrapper to manage OracleDB actions, simplifying connection handling.
async function withOracleDB(action) {
    let connection;
    try {
        connection = await oracledb.getConnection(); // Gets a connection from the default pool 
        return await action(connection);
    } catch (err) {
        console.error(err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}


// ----------------------------------------------------------
// Core functions for database operations
// Modify these functions, especially the SQL queries, based on your project's requirements and design.
async function testOracleConnection() {
    return await withOracleDB(async (connection) => {
        return true;
    }).catch(() => {
        return false;
    });
}

async function fetchDemotableFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM DEMOTABLE');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function initiateDemotable() {
    return await withOracleDB(async (connection) => {
        try {
            await connection.execute(`DROP TABLE DEMOTABLE`);
        } catch(err) {
            console.log('Table might not exist, proceeding to create...');
        }

        const result = await connection.execute(`
            CREATE TABLE DEMOTABLE (
                id NUMBER PRIMARY KEY,
                name VARCHAR2(20)
            )
        `);
        return true;
    }).catch(() => {
        return false;
    });
}

async function insertDemotable(id, name) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO DEMOTABLE (id, name) VALUES (:id, :name)`,
            [id, name],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function updateNameDemotable(oldName, newName) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE DEMOTABLE SET name=:newName where name=:oldName`,
            [newName, oldName],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function countDemotable() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT Count(*) FROM DEMOTABLE');
        return result.rows[0][0];
    }).catch(() => {
        return -1;
    });
}

// HSR Build Functions
async function fetchCharactersFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM CHARACTERS');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchCharacterDetailFromDb(name) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            'SELECT path FROM CHARACTERS WHERE name=:name',
            [name]
        );
        return result.rows[0][0];
    }).catch(() => {
        return [];
    })
}

async function fetchCharacterStatsFromDb(name) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT s.stat_type, s.stat_value 
            FROM Stats s, CharacterRelations c
            WHERE s.cid = c.cid AND c.name=:name
        `, [name]);
        return result.rows;
    }).catch(() => {
        return [];
    }) 
}

async function fetchCharMaterialsFromDb(name) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT md.name
            FROM MaterialDetails md, Characters_Materials cm, Materials m
            WHERE m.mid = cm.mid AND m.name = md.name AND cm.cid = (SELECT cid
                                                                    FROM CharacterRelations
                                                                    WHERE name=:name)
        `, [name]);
        return result.rows[0];
    }).catch(() => {
        return [];
    }) 
}

async function fetchBuildsDetailsFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT b.bid, b.name, cr.name, lc.name
            FROM Builds b, CharacterRelations cr, Builds_LightCones blc, LightCones lc
            WHERE b.bid = cr.bid AND blc.bid = b.bid AND blc.cone_id = lc.cone_id
        `);
        return result.rows;
    }).catch(() => {
        return [];
    })
}

async function fetchBuildRelicsFromDb(bid) {
    // TODO
    return;
}


async function insertBuild(bid, b_name, cone_id, lc_name, cid, c_name, rid, relic_level, r_name, main_stat, rarity, rec_main, rec_ss) {
    return await withOracleDB(async (connection) => {
        // Insert into Builds
        const buildResult = await connection.execute(
            `INSERT INTO Builds (bid, name) VALUES (:bid, :name)`,
            [bid, b_name],
            { autoCommit: false } 
        );

        // Insert into LightCones
        const lightConeResult = await connection.execute(
            `INSERT INTO LightCones (cone_id, name, bid) VALUES (:cone_id, :name, :bid)`,
            [cone_id, lc_name, bid],
            { autoCommit: false }
        );

        // Insert into CharacterRelations
        const charRelationResult = await connection.execute(
            `INSERT INTO CharacterRelations (cid, name, cone_id, bid) VALUES (:cid, :name, :cone_id, :bid)`,
            [cid, c_name, cone_id, bid],
            { autoCommit: false }
        );

        // Insert into Relics
        const relicsResult = await connection.execute(
            `INSERT INTO Relics (rid, relic_level, name, main_stat, rarity, bid, rec_main, rec_substat) VALUES (:rid, :relic_level, :name, :main_stat, :rarity, :bid, :rec_main, :rec_substat)`,
            [rid, relic_level, r_name, main_stat, rarity, bid, rec_main, rec_ss],
            { autoCommit: false }
        );

        // Commit the transaction only if all queries succeed
        await connection.commit();

        return (
            buildResult.rowsAffected > 0 &&
            lightConeResult.rowsAffected > 0 &&
            charRelationResult.rowsAffected > 0 &&
            relicsResult.rowsAffected > 0
        );

    }).catch(() => {
        return false;
    });

}

async function updateNameBuild(bid, newName) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE Builds SET name=:newName where bid=:bid`,
            [newName, bid],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

async function deleteBuild(bid) {
    return await withOracleDB(async (connection) => {
        try {
            const result = await connection.execute(
                `DELETE FROM Builds WHERE bid = :bid`,
                { bid },
                { autoCommit: true }
            );

            return result.rowsAffected > 0;
        } catch (error) {
            console.error("Delete Error:", error);
            return false;
        }
    });
}


module.exports = {
    testOracleConnection,
    fetchDemotableFromDb,
    initiateDemotable, 
    insertDemotable, 
    updateNameDemotable, 
    countDemotable,
    fetchCharactersFromDb,
    fetchCharacterDetailFromDb,
    fetchCharacterStatsFromDb,
    fetchCharMaterialsFromDb,
    fetchBuildsDetailsFromDb,
    insertBuild,
    updateNameBuild,
    deleteBuild
};