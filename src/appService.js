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
    });
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
    });
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
    });
}

async function fetchBuildsDetailsFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT b.bid, b.name, cr.name, lc.name, b.playstyle
            FROM Builds b, CharacterRelations cr, Builds_LightCones blc, LightCones lc
            WHERE b.cid = cr.cid AND blc.bid = b.bid AND blc.cone_id = lc.cone_id
        `);
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchBuildCharactersFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT cid, name
            FROM CharacterRelations 
        `);
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchBuildLightConesFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT cone_id, name
            FROM LightCones 
        `);
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchLightConesFromDb(columns) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `SELECT ${columns} FROM LightConeDetails`
        );
        return result.rows;
    }).catch(() => {
        return [];
    });
}

async function fetchAllRelics() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(`
            SELECT r.name, rd.set_name, r.rarity
            FROM Relics r
            JOIN RelicDetails rd ON r.name = rd.name
            ORDER BY r.rid
        `);
        return result.rows;
    }).catch((err) => {
        console.error("Error fetching relics from DB:", err);
        return [];
    });
}

async function fetchRelicsForType(type) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `
            SELECT r.name, rd.set_name, r.rarity
            FROM Relics r
            JOIN RelicDetails rd ON r.name = rd.name
            WHERE rd.relic_type = :type
            ORDER BY r.rid
            `,
            [type]
        );
        return result.rows;
    }).catch((err) => {
        console.error("Error fetching relics by type from DB:", err);
        return [];
    });
}


async function insertBuild(b_name, playstyle, cid, cone_id, ridData) {
    return await withOracleDB(async (connection) => {
        // Use the build_seq to generate a new bid and return it
        const buildResult = await connection.execute(
            `INSERT INTO Builds (bid, name, playstyle, cid) 
             VALUES (build_seq.nextval, :name, :playstyle, :cid)
             RETURNING bid INTO :bid_out`,
            {
                name: b_name,
                playstyle: playstyle,
                cid: cid,
                bid_out: { type: oracledb.NUMBER, dir: oracledb.BIND_OUT }
            },
            { autoCommit: false }
        );
        // Retrieve the generated bid from the OUT binding
        const newBid = buildResult.outBinds.bid_out[0];

        // Insert into Builds_LightCones using the new bid
        const buildLightConeResult = await connection.execute(
            `INSERT INTO Builds_LightCones (bid, cone_id) VALUES (:bid, :cone_id)`,
            { bid: newBid, cone_id: cone_id },
            { autoCommit: false }
        );

        // Insert into Builds_Relics for each relic slot
        let buildRelicResults = [];
        for (const slot in ridData) {
            const rid = ridData[slot];
            const res = await connection.execute(
                `INSERT INTO Builds_Relics (bid, rid) VALUES (:bid, :rid)`,
                { bid: newBid, rid: rid },
                { autoCommit: false }
            );
            buildRelicResults.push(res);
        }
        await connection.commit();

        // Verify that all inserts affected at least one row
        const relicsSuccess = buildRelicResults.every(r => r.rowsAffected > 0);
        return (
            buildResult.rowsAffected > 0 &&
            buildLightConeResult.rowsAffected > 0 &&
            relicsSuccess
        );
    }).catch((err) => {
        console.error("Insert build error:", err);
        return false;
    });
}

async function updateNameBuild(bid, newName, newPlaystyle) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE Builds SET name=:newName, playstyle=:newPlaystyle WHERE bid=:bid`,
            [newName, newPlaystyle, bid],
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

async function searchCharacter(search) {
    return await withOracleDB(async (connection) => {
        try {
            const result = await connection.execute(
                `SELECT * FROM Characters WHERE name LIKE %:search%`,
                { search },
                { autoCommit: true }
            );

            return result.rows[0][0];
        } catch (error) {
            console.error("Search Error:", error);
            return -1;
        }
    });
}

async function searchLightCones(search) {
    return await withOracleDB(async (connection) => {
        try {
            const result = await connection.execute(
                `SELECT * FROM LightConeDetails WHERE name LIKE %:search%`,
                { search },
                { autoCommit: true }
            );

            return result.rows[0][0];
        } catch (error) {
            console.error("Search Error:", error);
            return -1;
        }
    });
}

async function searchRelics(search) {
    return await withOracleDB(async (connection) => {
        try {
            const result = await connection.execute(
                `SELECT * FROM RelicDetails WHERE name LIKE %:search%`,
                { search },
                { autoCommit: true }
            );

            return result.rows[0][0];
        } catch (error) {
            console.error("Search Error:", error);
            return -1;
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
    fetchBuildCharactersFromDb,
    fetchBuildLightConesFromDb,
    fetchBuildsDetailsFromDb,
    fetchLightConesFromDb,
    fetchAllRelics,
    fetchRelicsForType,
    insertBuild,
    updateNameBuild,
    deleteBuild,
    searchCharacter,
    searchLightCones,
    searchRelics
};