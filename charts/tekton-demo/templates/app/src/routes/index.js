const express = require('express');

const router = express.Router();
const fetch = require('node-fetch');
require('dotenv').config();

const rest_api_ip = process.env.OPENLIBERTY_APP_SERVICE_HOST || process.env.LIBERTY_APP_SERVICE_HOST || process.env.LIBERTY_TEKTON_SERVICE_HOST || 'liberty-app';
const rest_api_port = process.env.OPENLIBERTY_APP_SERVICE_PORT || process.env.LIBERTY_APP_SERVICE_PORT || process.env.LIBERTY_TEKTON_SERVICE_PORT || '9080';

const AUTHORS_API_KEY = process.env.AUTHORS_API_KEY || 'none';

/* GET home page. */
router.get('/', (req, res) => {
  res.render('index', {
    getHash: () => process.env['revision-id'],
    getRevisionType: () => process.env['revision-type'],
    getRevisionId: () => process.env['revision-id'] || process.env.version,
    getEnvironment: () => process.env.environment,
    getVersion: () => process.env.version,
    getPod: () => process.env.hostname,
    links: null,
    error_authors: null,
  });
});

router.post('/get_links', async (req, res) => {
  const buff = new Buffer(AUTHORS_API_KEY);
  const base64data = encodeURIComponent(buff.toString('base64'));
  const { author } = req.body;
  const url = `http://${rest_api_ip}:${rest_api_port}/authors/v1/getauthor?name=${author}&apikey=${base64data}`;
  const health_url = `http://${rest_api_ip}:${rest_api_port}/health`;

  /* Perform HEALTH Check to OpenLiberty Authors API. */
  console.log('-------------------------------------------------------');
  try {
    const data = await fetch(health_url);
    const health = await data.json();
    console.log('Health check for OpenLiberty API.');
    console.log(health);
    if (health.outcome != 'UP') {
      console.log('Error: OpenLiberty API Server seems to be down. Please check.');
      res.render('index', { links: null, error_authors: 'Error: OpenLiberty API Server seems to be down. Please check.' });
      return;
    }
  } catch (err) {
    console.log('Error: Unable to invoke OpenLiberty API Health Check. Please check if OpenLiberty server is online.');
    res.render('index', { links: null, error_authors: 'Error: Unable to invoke OpenLiberty API Health Check. Please check if OpenLiberty server is online.' });
    return;
  }
  /* Perform the call to  OpenLiberty Authors API. */
  try {
    const data = await fetch(url);
    const links = await data.json();

    console.log(links);
    if (data.status > 200) res.render('index', { links: null, error_authors: links.description });
    else res.render('index', { links, error_authors: null });
  } catch (err) {
    console.log(err);
    res.render('index', { links: null, error_authors: 'Error: Unable to invoke OpenLiberty Authors API.' });
  }
});

module.exports = router;
