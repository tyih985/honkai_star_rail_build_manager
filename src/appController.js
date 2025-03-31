const express = require('express');
const appService = require('./appService');

const router = express.Router();

// ----------------------------------------------------------
// API endpoints
// Modify or extend these routes based on your project's needs.
router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    if (isConnect) {
        res.send('connected');
    } else {
        res.send('unable to connect');
    }
});

router.get('/demotable', async (req, res) => {
    const tableContent = await appService.fetchDemotableFromDb();
    res.json({data: tableContent});
});

router.post("/initiate-demotable", async (req, res) => {
    const initiateResult = await appService.initiateDemotable();
    if (initiateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/insert-demotable", async (req, res) => {
    const { id, name } = req.body;
    const insertResult = await appService.insertDemotable(id, name);
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post("/update-name-demotable", async (req, res) => {
    const { oldName, newName } = req.body;
    const updateResult = await appService.updateNameDemotable(oldName, newName);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.get('/count-demotable', async (req, res) => {
    const tableCount = await appService.countDemotable();
    if (tableCount >= 0) {
        res.json({
            success: true,
            count: tableCount
        });
    } else {
        res.status(500).json({
            success: false,
            count: tableCount
        });
    }
});

// HSR Build Manager Endpoints
router.get('/characters', async (req, res) => {
    const tableContent = await appService.fetchCharactersFromDb();
    res.json({data: tableContent});
});

router.get('/characters/:name', async (req, res) => {
    const name = decodeURIComponent(req.params.name);
    console.log(name);
    const details = await appService.fetchCharacterDetailFromDb(name);
    const stats = await appService.fetchCharacterStatsFromDb(name);
    const materials = await appService.fetchCharMaterialsFromDb(name);
    console.log(details, stats, materials);
    res.json({
        data: {
            details: details,
            stats: stats,
            materials: materials
        }
    })
});

router.get('/lightcones', async (req, res) => {
    const tableContent = await appService.fetchLightConesFromDb();
    res.json({ data: tableContent });
});

router.get('/relics', async (req, res) => {
    const type = req.query.type;
    let tableContent;
    if (type) {
        tableContent = await appService.fetchRelicsForType(type);
    } else {
        tableContent = await appService.fetchAllRelics();
    }
    res.json({ data: tableContent });
});

router.get('/builds', async (req, res) => {
    const tableContent = await appService.fetchBuildsDetailsFromDb();
    res.json({data: tableContent});
});


router.delete('/builds/:bid', async (req, res) => {
    const bid = decodeURIComponent(req.params.bid);
    const deleteResult = await appService.deleteBuild(bid);
    if (deleteResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false })
    }
});

router.put('/builds/:bid', async (req, res) => {
    const bid = decodeURIComponent(req.params.bid);
    const { name, playstyle } = req.body;
    const updateResult = await appService.updateNameBuild(bid, name, playstyle);
    if (updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.get('/builds/characters', async (req, res) => {
    const tableContent = await appService.fetchBuildCharactersFromDb();
    res.json({ data: tableContent });
});

router.get('/builds/lightcones', async (req, res) => {
    const tableContent = await appService.fetchBuildLightConesFromDb();
    res.json({ data: tableContent });
});


router.get('/characters/:name', async (req, res) => {
    const bid = decodeURIComponent(req.params.name);
    const tableContent = await appService.searchCharacter(search);
    res.json({data: tableContent});
});

router.get('/characters/:search', async (req, res) => {
    const bid = decodeURIComponent(req.params.search);
    const tableContent = await appService.searchCharacter(search);
    res.json({data: tableContent});
});

router.get('/lightcones/:search', async (req, res) => {
    const bid = decodeURIComponent(req.params.search);
    const tableContent = await appService.searchLightCones(search);
    res.json({data: tableContent});
});

router.get('/relics/:search', async (req, res) => {
    const bid = decodeURIComponent(req.params.search);
    const tableContent = await appService.searchRelics(search);
    res.json({data: tableContent});
});

router.post('/builds', async (req, res) => {
    const { name, playstyle, cid, cone_id, relics } = req.body;

    try {
        const result = await appService.insertBuild(name, playstyle, cid, cone_id, relics);
        if (result) {
            res.status(201).json({ message: "Build created successfully" });
        } else {
            res.status(400).json({ message: "Build creation failed" });
        }
    } catch (err) {
        console.error("Error creating build:", err);
        res.status(500).json({ message: "Internal server error" });
    }
});

module.exports = router;