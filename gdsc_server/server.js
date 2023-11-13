const express = require('express')
const app = express()

const firebaseApp = initializeApp(firebaseConfig);
const port = 3000

app.get('/', (req, res) => {
  res.send(JSON.stringify({ message: "Helljo World"}))
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
