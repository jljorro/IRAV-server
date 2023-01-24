var http = require('http');

var server = http.createServer(function(req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain; charset=utf8'});
    res.end('Hola, soy la aplicación web!');
});

server.listen(3000);
console.log("Servidor corriendo en http://localhost:3000/");