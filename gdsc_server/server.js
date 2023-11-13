const path = "localhost:3000/"
var http = require('http'); // Import Node.js core module
//const firebase_app = require("lib/firebase.js");
var server = http.createServer(function (req, res) {   //create web server
    if (req.url == '/') { //check the URL of the current request
        
        // set response header
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.write(JSON.stringify({ message: "Hello World"}));  
            res.end(); 
    
    }
    else
        res.end('Invalid Request!');

});

server.listen(3000); //6 - listen for any incoming requests

console.log('Node.js web server at port 3000 is running..')