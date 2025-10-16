const http = require('http');
const port = 3000;
const message = process.env.MESSAGE || 'Hello from ECS!';
http.createServer((req, res) => {
  res.writeHead(200);
  res.end(`${message}\n`);
}).listen(port);
console.log(`Server running on port ${port}`);

