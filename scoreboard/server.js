const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 10007;
const DATA_FILES = {
  gpu: path.join(__dirname, 'data-gpu.json'),
  cpu: path.join(__dirname, 'data-cpu.json'),
};
const INDEX_FILE = path.join(__dirname, 'index.html');

function getMode(req) {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  return url.searchParams.get('mode') === 'cpu' ? 'cpu' : 'gpu';
}

function readData(mode) {
  const file = DATA_FILES[mode];
  if (!fs.existsSync(file)) {
    // Copy from template
    const tmpl = path.join(__dirname, 'data-template.json');
    fs.copyFileSync(tmpl, file);
  }
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function writeData(mode, data) {
  fs.writeFileSync(DATA_FILES[mode], JSON.stringify(data, null, 2));
}

function parseBody(req) {
  return new Promise((resolve) => {
    let body = '';
    req.on('data', c => body += c);
    req.on('end', () => {
      try { resolve(JSON.parse(body)); } catch { resolve({}); }
    });
  });
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);

  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

  // Routes
  if (url.pathname === '/' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(fs.readFileSync(INDEX_FILE, 'utf8'));
  }
  else if (url.pathname === '/api/data' && req.method === 'GET') {
    const mode = getMode(req);
    const data = readData(mode);
    data.mode = mode;
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(data));
  }
  else if (url.pathname === '/api/score' && req.method === 'POST') {
    const body = await parseBody(req);
    const { model, step, score, mode: m } = body;
    const mode = m === 'cpu' ? 'cpu' : 'gpu';
    if (model == null || step == null || score == null) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'need model, step, score' }));
      return;
    }
    const data = readData(mode);
    if (!data.scores[model]) data.scores[model] = {};
    data.scores[model][step] = Math.min(2, Math.max(0, parseInt(score)));
    writeData(mode, data);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: true }));
  }
  else if (url.pathname === '/api/notes' && req.method === 'POST') {
    const body = await parseBody(req);
    const { model, step, notes, mode: m } = body;
    const mode = m === 'cpu' ? 'cpu' : 'gpu';
    const data = readData(mode);
    if (!data.notes) data.notes = {};
    const key = `${model}__${step}`;
    data.notes[key] = notes || '';
    writeData(mode, data);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: true }));
  }
  else if (url.pathname === '/api/reset' && req.method === 'POST') {
    const body = await parseBody(req);
    const { model, mode: m } = body;
    const mode = m === 'cpu' ? 'cpu' : 'gpu';
    const data = readData(mode);
    if (model) {
      delete data.scores[model];
      if (data.notes) {
        for (const k of Object.keys(data.notes)) {
          if (k.startsWith(model + '__')) delete data.notes[k];
        }
      }
    } else {
      data.scores = {};
      data.notes = {};
    }
    writeData(mode, data);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ ok: true }));
  }
  else {
    res.writeHead(404);
    res.end('not found');
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`🦞⚪ Scoreboard on http://0.0.0.0:${PORT}`);
});
