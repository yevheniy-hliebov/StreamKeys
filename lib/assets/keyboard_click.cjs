const http = require('http');

const buttonCode = process.argv[2];

const options = {
  hostname: '127.0.0.1',
  port: 13560,
  path: `/keyboard/${buttonCode}/click`,
  method: 'GET'
};

const req = http.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  res.on('end', () => {
    console.log(`Response: ${data}`);
  });
});

req.on('error', (e) => {
  console.error(`Problem with request: ${e.message}`);
});

req.end();
  