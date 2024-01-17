const express = require('express');
const app = express();
const path = require('path'); // Add this line

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

// API routes
app.use('/api/users', require('./app/routes/users'));
app.use('/api/clubs', require('./app/routes/clubs'));
app.use('/api/events', require('./app/routes/events'));
app.use('/api/comments', require('./app/routes/comments'));
app.use('/api/crons', require('./app/routes/crons'));
app.use('/api/friendGroup', require('./app/routes/friendGroup'));

app.use(express.static(path.join(__dirname, 'public')));


const port = 3000;

app.listen(port, () => {
  console.log(`Soshal listening on port ${port}`);
});
