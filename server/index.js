var express = require('express')
var path = require('path')
var app = express()
var cors = require('cors')
var bodyParser = require('body-parser')
const cron = require('node-cron');
var ip = require('ip');
var mysql = require('mysql')
var db = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "bia"
});
db.connect((err) => {
    if (err) throw err
    console.log('koneksi database berhasil')
})
app.use(cors())
app.use(bodyParser.json())
app.use(express.static(path.join(__dirname, '../web/build/web')))
app.use(express.urlencoded({ extended: true }))
app.get('/', (req, res) => {
    res.render('index')
})

app.post('/getperson', (req, res) => {
    let no_pasien = req.body.no_pasien
    db.query(`select * from pasien where no_pasien=${no_pasien}`, (err, result, field) => {
        // res.send(result[0])
        try {
            let response = `${result[0].berat},${result[0].tinggi},${result[0].usia}`
            res.send(response)
        } catch (error) {
            console.log(error)
            res.status(404).send('na')
        }
    })
})
app.post('/ecw', (req,res) => {
    let no_pasien = req.body.no_pasien
    let ecw = req.body.ecw
    let modified = Date.now()
    db.query(`update pasien set ecw=${ecw}, modified=${modified} where no_pasien = ${no_pasien}`)
    res.send(`ECW : ${ecw}`)
})
app.post('/tbw', (req,res) => {
    let no_pasien = req.body.no_pasien
    let tbw = req.body.tbw
    let modified = Date.now()
    db.query(`update pasien set tbw=${tbw}, modified=${modified} where no_pasien = ${no_pasien}`)
    res.send(`TBW : ${tbw}`)
})
app.get('/last', (req,res) => {
    db.query(`select * from pasien order by modified desc limit 1`,(err, rows, field) => {
        res.send(rows[0])
    })
})
// cron.schedule('* * * * * *', () => {
//     var now = Date.now()
//     db.query(`select timestamp from jadwal where timestamp < ${now} AND state = 0`, (err, rows, field) => {
//         if (rows.length > 0) {
//             db.query(`update relay set relay1=0,relay2=0,relay3=0,relay4=0`)
//             db.query(`delete from jadwal where timestamp < ${now} AND state = 0`)
//         }
//     })
//     db.query(`select timestamp from jadwal where timestamp < ${now} AND state = 1`, (err, rows, field) => {
//         if (rows.length > 0) {
//             db.query(`update relay set relay1=1,relay2=1,relay3=1,relay4=1`)
//             db.query(`delete from jadwal where timestamp < ${now} AND state = 1`)
//         }
//     })
// })

app.listen(3000, console.log(`Web Server : ${ip.address()}:3000`))