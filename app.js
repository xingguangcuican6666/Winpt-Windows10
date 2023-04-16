var http = require('http')
http.createServer(function require(response) {
    response.writeHead(200, {'Content-Type': 'text/plain'});
    response.end(data);
}).listen(80)
var fs = require('fs')

var data = fs.readFileSync('1.txt')
console.log('Server run as 127.0.0.1:80')