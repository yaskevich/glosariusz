'use strict';
// https://www.npmjs.com/package/sqlite
import sqlite3 from 'sqlite3'
import { open } from 'sqlite'
import path from 'path'
import fs from 'fs'
import express from 'express'
import compression from 'compression'
// import bodyParser from 'body-parser'
import { fileURLToPath } from 'url';
import { dirname } from 'path';
const __dirname = dirname(fileURLToPath(import.meta.url));

(async () => {
    const db = await open({ filename: path.join(__dirname, 'glos.db'), driver: sqlite3.cached.Database })
	const app = express();
	const port = process.env.PORT || 3020;
	const index = fs.readFileSync(path.join(__dirname, 'public', 'index.html'), {encoding:'utf8', flag:'r'}); 
	
	const words = await db.all('SELECT id, title FROM slownik');
	const def = await db.all('SELECT id, title FROM slownik WHERE id IN (SELECT id FROM slownik ORDER BY RANDOM() LIMIT 20)');
	const sources = await db.all('SELECT * FROM sources');
	const sourcesObj = Object.fromEntries(sources.map(item => [item.abbr, item]));
	// prepared statements
	const stmtDatum = await db.prepare("SELECT * FROM slownik WHERE id = ?");
	const stmtData = await db.prepare("SELECT id, title FROM slownik WHERE title LIKE ?");
	// app.use(bodyParser.json());
	// app.use(bodyParser.urlencoded({ extended: true }));
	app.use(express.static('public'));
	app.set('trust proxy', true);
	app.get('/:id', async (req,res) => {
		// const id = req.params.id;
		res.send(index);
	});
	app.get('/api/def.json', async (req,res) => { res.json(def) });
	app.get('/api/list.json', async (req,res) => { res.json(words) });
	app.get('/api/sources.json', async (req,res) => { res.json(sourcesObj) });
	app.get('/api/datum.json', async (req,res) => { 
		const id = parseInt(Object.keys(req.query)[0]);
		const ip = req.header('x-forwarded-for') || req.connection.remoteAddress;
		console.log(`[${ip}] ${id}`);
		res.json(id ? [await stmtDatum.get(id)] : {});
	});
	app.get('/api/data.json', async(req,res) => {
		const raw = Object.keys(req.query)[0];
		const query = raw.replace(/[^A-ZĄĆĘŁŃÓŚŹŻ\-]+/ig, '');
		// console.log("query", query);
		res.json(query ? await stmtData.all(query+'%') : {});
	});	
	app.get('/', async(req,res) => {
		res.send(index);
	});

	app.listen(port);  
	console.log("Server started on port " + port);
})()