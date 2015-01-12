import QtQuick 2.0
import Qt.WebSockets 1.0

Item{

    id: wscontainer

    property alias url: ws.url
    property alias hostname: ws.hostname
    property alias fqdn: ws.fqdn
    property alias ssid: ws.ssid
    property alias buffer: ws.buffer
    property alias active: ws.active
    property alias ready: ws.ready

    signal jsonReceived(var json);


    function sendMessage(message){

        ws.sendMessage(message);
    }

    function rpc(module, fct, params, dst){

        ws.rpc(module, fct, params, dst);
    }

    WebSocket {

        id: ws
        url: "ws://localhost:5002"
        active: false

        onStatusChanged:
                        if (ws.status == WebSocket.Open)
                            socketOpened();
                        else if (ws.status == WebSocket.Closed)
                            socketClosed();
                        else if (ws.status == WebSocket.Error)
                            socketError();

        onTextMessageReceived:
                        socketMessageReceived(message);

        /* Variables */

        property bool ready : false
        property string hostname : "notsetted"
        property string fqdn : "notsetted"
        property string ssid : ""
        property string buffer : ""

        /* Event handling */

        function socketOpened(){

            console.log("JsonSocket connected");

            hbmanager.start();

            ws.sendMessage('{"type": "hello", "body" : { "name" : "' + ws.hostname + '", "ssid" : "' + ws.ssid + '"}}')
        }

        function socketClosed(){

            hbmanager.stop();

            ready = false;
            active = true

            console.log("JsonSocket closed")
        }

        function socketError(){

            active = true

            console.log("JsonSocket error: " + ws.errorString)
        }


        /* Communication */

        function sendMessage(message){

            ws.sendTextMessage(':::0:::' + message + ':::1:::');
        }

        function rpc(module, fct, params, dst){

            ws.sendMessage('{ "type": "rpc", "body": {"module": "' + module + '", "fct": "' + fct + '", "params": ' + params + ' }, "src" : "' + ws.fqdn + '", "dst" : "' + dst + '" }');
        }

        function socketMessageReceived(receivedstring){

            ws.buffer = ws.buffer + receivedstring;

            var messageArray = ws.buffer.split(":::0:::");

            ws.buffer = "";

            for (var i in messageArray){

                var message = messageArray[i];

                if (message === "")
                    continue;

                if (message !== ""){

                    if (message.indexOf(":::1:::") !== -1)
                        processJson( JSON.parse(message.split(":::1:::")[0] ));
                    else
                        ws.buffer = message;
                }
            }
        }

        function processJson(json){

            if (json.type === "hbAck"){

                hbmanager.validate(json.body);
            }
            else if (json.type === "ssid"){

                ws.ready = true;
                ws.ssid = json.body.ssid
                ws.fqdn = json.body.domain

                console.log("JsonSocket ready");
            }
            else{

                wscontainer.jsonReceived(json);
            }
        }
    }

    Timer{

        id: connectionChecker

        interval: 2500
        running: true
        repeat: true
        onTriggered: {

            if (ws.status === WebSocket.Closed || ws.status === WebSocket.Error){

                console.log("Websocket is closed or error")
                ws.active = false
            }

            if (!ws.active){
                console.log("WS connection is not live, trying reconnect")
            }
            else{
                console.log("WS connection is live")
            }

            ws.active = true
        }
    }

    Item{

        id: hbmanager

        property var hbarray : []

        /* Heartbeat manager */

        Timer{

            id: hb

            interval: 3000
            running: false
            repeat: true
            onTriggered: {

                ws.sendMessage('{ "type": "hb", "body": "' + guid() + '"}');
            }

            function guid (){
              function s4() {
                return Math.floor((1 + Math.random()) * 0x10000)
                           .toString(16)
                           .substring(1);
              }
              return function() {
                return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                       s4() + '-' + s4() + s4() + s4();
              };
            }
        }

        function start(){

            hb.running = true
        }

        function stop(){

            hb.running = false
        }

        function validate(hb){

        }
    }
}

