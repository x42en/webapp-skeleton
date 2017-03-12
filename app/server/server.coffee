IOServer = require 'ioserver'

app = new IOServer
        port: 8000
        host: 'localhost'

app.addService
    name: 'chat'
    service: Chat

# <%End services%>

console.log '#[+] App started :)'
app.start()