const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello from Rimoo Raspberry App! Main service is running. v1.0.0');
});

app.listen(port, () => {
  console.log(`Main app listening at http://localhost:${port}`);
});

console.log('Main application started.');
