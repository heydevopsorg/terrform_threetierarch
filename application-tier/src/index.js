import express from 'express';
import mysql from 'mysql';

const PORT = process.env.PORT || 3000
const connection = mysql.createConnection({
  host: process.env.RDS_HOSTNAME,
  user: process.env.RDS_USERNAME,
  password: process.env.RDS_PASSWORD,
  port: process.env.RDS_PORT,
  db_name: process.env.RDS_DB_NAME
});
connection.connect()
connection.query(`use ${process.env.RDS_DB_NAME};`)

let app = express()

app.get('/', async (req, res) => {
  res.send({ message: 'hello world'})
})

app.get('/init', async (req, res) => {
  connection.query('CREATE TABLE IF NOT EXISTS users (id INT(5) NOT NULL AUTO_INCREMENT PRIMARY KEY, lastname VARCHAR(40), firstname VARCHAR(40), email VARCHAR(30));');
  connection.query('INSERT INTO users (lastname, firstname, email) VALUES ( "Tony", "Sam", "tonysam@whatever.com"), ( "Doe", "John", "john.doe@whatever.com" );');
  res.send({ message: "init step done" })
})

app.get('/users', async (req, res) => {
  connection.query('SELECT * from users', function (error, results) {
    if (error) throw error;
    res.send(results)
  });
  
})

// Custom 404 route not found handler
app.use((req, res) => {
  res.status(404).send('404 not found')
})

app.listen(PORT, () => {
  console.log(`Listening on PORT ${PORT}`);
})