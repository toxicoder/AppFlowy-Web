// deploy/server.ts
import express from 'express';
import { resolve } from 'path';

const app = express();
// Default to 8080 if PORT is not set
const port = process.env.PORT || 8080;

// Enable trust proxy to correctly handle X-Forwarded-* headers
app.set('trust proxy', true);

app.use(express.static(resolve(__dirname, '../dist')));

app.get('*', (req, res) => {
  res.sendFile(resolve(__dirname, '../dist/index.html'));
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
