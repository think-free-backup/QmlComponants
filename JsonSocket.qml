import QtQuick 2.0
import Qt.WebSockets 1.0

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

    signal jsonReceived(var json);


    /* Event handling */

    function socketOpened(){

        console.log("JsonSocket connected");

        // TODO : Start heartbeat timer

        ws.sendMessage('{"type": "hello", "body" : { "name" : "' + ws.hostname + '", "ssid" : "' + ws.ssid + '"}}')
    }

    function socketClosed(){

        ready = false;

        console.log("JsonSocket closed")

        // TODO : Reconnect
    }

    function socketError(){

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


        }
        else if (json.type === "ssid"){

            ws.ready = true;
            ws.ssid = json.body.ssid
            ws.fqdn = json.body.domain

            console.log("JsonSocket ready");
        }
        else{

            ws.jsonReceived(json);
        }
    }
}
