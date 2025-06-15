const express = require('express');
const sql = require('mssql');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Set EJS as the template engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// SQL Server config
const config = {
    user: 'cyber',
    password: '12345678',
    server: '127.0.0.1',
    database: 'PJ',
    port: 1433,
    options: {
        encrypt: false,
        trustServerCertificate: true,
        enableArithAbort: true
    }
};

const pool = new sql.ConnectionPool(config);
const poolConnect = pool.connect();

pool.on('error', err => {
    console.error('SQL Pool Error', err);
});

// Serve login.html at root
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

// Handle login POST
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        let pool = await sql.connect(config);
        let result = await pool.request()
            .input('username', sql.VarChar, username)
            .input('password', sql.VarChar, password)
            .query('SELECT * FROM Userr WHERE UserName = @username AND Password = @password');

        if (result.recordset.length > 0) {
            res.redirect('/search.html');
        } else {
            res.redirect('/?error=' + encodeURIComponent('Invalid username or password'));
        }
    } catch (err) {
        console.error('Database error:', err);
        res.status(500).send('Server error: ' + err.message);
    } finally {
        await sql.close();
    }
});

app.get('/criminal', async (req, res) => {
    const criminalId = req.query.id;

    if (!criminalId) {
        return res.status(400).send('Missing criminal ID');
    }

    try {
        await poolConnect;
        const request = pool.request();
        request.input('criminalId', sql.Int, criminalId);

        const result = await request.query(`
            SELECT 
                c.criminal_id,
                c.name AS criminal_name,
                c.date_of_birth,
                c.nationality,
                c.known_address_street,
                c.known_address_city,
                c.known_address_postal_code,
                a.aliase_name,
                cs.case_id,
                cs.title AS case_title,
                cs.description AS case_description,
                cs.date_reported,
                cs.status AS case_status
            FROM 
                Criminals c
            LEFT JOIN 
                Criminal_Aliases a ON c.criminal_id = a.criminal_id
            LEFT JOIN 
                Case_Criminals cc ON c.criminal_id = cc.criminal_id
            LEFT JOIN 
                Cases cs ON cc.case_id = cs.case_id
            WHERE 
                c.criminal_id = @criminalId;
        `);

        const data = result.recordset;

        if (data.length === 0) {
            return res.render('criminal', { data: [], criminalId });
        }

        res.render('criminal', { data, criminalId });
    } catch (err) {
        console.error('Error fetching criminal details:', err);
        res.status(500).send('Internal Server Error');
    }
});




app.post('/add-criminal', async (req, res) => {
    const {
        criminal_id,
        name,
        date_of_birth,
        nationality,
        known_address_street,
        known_address_city,
        known_address_postal_code,
        alias_id,
        aliase_name
    } = req.body;

    try {
        await poolConnect;

        // Insert into Criminals table
        const criminalRequest = pool.request();
        criminalRequest.input('criminal_id', sql.Int, criminal_id);
        criminalRequest.input('name', sql.NVarChar, name);
        criminalRequest.input('date_of_birth', sql.Date, date_of_birth);
        criminalRequest.input('nationality', sql.NVarChar, nationality);
        criminalRequest.input('known_address_street', sql.NVarChar, known_address_street);
        criminalRequest.input('known_address_city', sql.NVarChar, known_address_city);
        criminalRequest.input('known_address_postal_code', sql.NVarChar, known_address_postal_code);

        await criminalRequest.query(`
            INSERT INTO Criminals (criminal_id, name, date_of_birth, nationality, known_address_street, known_address_city, known_address_postal_code)
            VALUES (@criminal_id, @name, @date_of_birth, @nationality, @known_address_street, @known_address_city, @known_address_postal_code)
        `);

        // Insert into Criminal_Aliases if alias info is provided
        if (alias_id && aliase_name && aliase_name.trim() !== "") {
            const aliasRequest = pool.request();
            aliasRequest.input('alias_id', sql.Int, alias_id);
            aliasRequest.input('criminal_id', sql.Int, criminal_id);
            aliasRequest.input('aliase_name', sql.NVarChar, aliase_name.trim());

            await aliasRequest.query(`
                INSERT INTO Criminal_Aliases (alias_id, criminal_id, aliase_name)
                VALUES (@alias_id, @criminal_id, @aliase_name)
            `);
        }

        res.send(`<h2 style="color:lime;">Criminal and alias added successfully!</h2>`);
    } catch (err) {
        console.error('Error adding criminal:', err);
        res.status(500).send(`<h2 style="color:red;">Error adding criminal: ${err.message}</h2>`);
    }
});

app.get('/victim', async (req, res) => {
    const victimId = req.query.id;

    if (!victimId) {
        return res.status(400).send('Missing victim ID');
    }

    try {
        await poolConnect;
        const request = pool.request();
        request.input('victimId', sql.Int, victimId);

        const result = await request.query(`
            SELECT 
                V.victim_id,
                V.name AS victim_name,
                V.contact_info,
                V.type AS victim_type,
                C.case_id,
                C.title AS case_title,
                C.description AS case_description,
                C.date_reported,
                C.status AS case_status
            FROM 
                Victim V
            LEFT JOIN 
                Case_Victims CV ON V.victim_id = CV.victim_id
            LEFT JOIN 
                Cases C ON CV.case_id = C.case_id
            WHERE 
                V.victim_id = @victimId
        `);

        const data = result.recordset;

        if (data.length === 0) {
            return res.render('victim', { data: [], victimId });
        }

        res.render('victim', { data, victimId });
    } catch (err) {
        console.error('Error fetching victim details:', err);
        res.status(500).send('Internal Server Error');
    }
});



app.get('/report-data', async (req, res) => {
  const caseId = req.query.id;
  if (!caseId) return res.status(400).send({ error: "No case ID provided" });

  try {
    // Fetch case info
    const caseQuery = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query('SELECT * FROM Cases WHERE case_id = @caseId');

    if (caseQuery.recordset.length === 0) {
      return res.status(404).send({ error: "Case not found" });
    }

    const caseInfo = caseQuery.recordset[0];

    // Fetch related criminals
    const criminals = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query(`
        SELECT c.*
        FROM Criminals c
        JOIN Case_Criminals cc ON c.criminal_id = cc.criminal_id
        WHERE cc.case_id = @caseId
      `);

    // Fetch aliases
    const aliases = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query(`
        SELECT a.*
        FROM Criminal_Aliases a
        JOIN Case_Criminals cc ON a.criminal_id = cc.criminal_id
        WHERE cc.case_id = @caseId
      `);

    // Fetch related victims
    const victim = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query(`
        SELECT v.*
        FROM Victim v
        JOIN Case_Victims cv ON v.victim_id = cv.victim_id
        WHERE cv.case_id = @caseId
      `);

    // Fetch reports
    const reports = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query('SELECT * FROM Reports WHERE case_id = @caseId');

    // Fetch charges
    const charges = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query('SELECT * FROM Charges WHERE case_id = @caseId');

    // Fetch offenses
    const offenses = await pool.request()
      .input('caseId', sql.Int, caseId)
      .query(`
        SELECT o.*
        FROM Offenses o
        JOIN Case_Offenses co ON o.offense_id = co.offense_id
        WHERE co.case_id = @caseId
      `);

    res.send({
      case: caseInfo,
      criminals: criminals.recordset,
      aliases: aliases.recordset,
      victim: victim.recordset,
      reports: reports.recordset,
      charges: charges.recordset,
      offenses: offenses.recordset
    });

  } catch (err) {
    console.error(err);
    res.status(500).send({ error: "Failed to fetch report data" });
  }
});


app.post('/delete-criminal', async (req, res) => {
    const { criminal_id } = req.body;

    if (!criminal_id) {
        return res.status(400).send('Criminal ID is required');
    }

    try {
        await poolConnect;
        const request = pool.request();
        request.input('criminal_id', sql.Int, criminal_id);

        // First delete from any related bridge tables
        await request.query(`
            DELETE FROM Case_Criminals WHERE criminal_id = @criminal_id;
            DELETE FROM Criminal_Aliases WHERE criminal_id = @criminal_id;
        `);

        // Then delete from the main Criminals table
        await request.query(`
            DELETE FROM Criminals WHERE criminal_id = @criminal_id;
        `);

        res.send(`<h2 style="color:lime;">Criminal with ID ${criminal_id} deleted successfully!</h2>`);
    } catch (err) {
        console.error('Error deleting criminal:', err);
        res.status(500).send(`<h2 style="color:red;">Error: ${err.message}</h2>`);
    }
});

app.get('/api/access-logs', async (req, res) => {
  try {
    await poolConnect;
    const result = await pool.request().query('SELECT * FROM Access_Log');
    res.json(result.recordset);
  } catch (err) {
    console.error('Error fetching access logs:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
