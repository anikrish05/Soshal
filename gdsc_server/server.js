const express = require('express')
const app = express()
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

app.use('/api/users', require('./app/routes/users'))
app.use('/api/clubs', require('./app/routes/clubs'))
app.use('/api/events', require('./app/routes/events'))
app.use('/api/comments', require('./app/routes/comments'))

const port = 3000

app.listen(port, () => {
  console.log(`Soshal listening on port ${port}`)
})

