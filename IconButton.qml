import QtQuick 2.2
import QtGraphicalEffects 1.0

Rectangle{

    id: button

    property color initialColor: "#666"
    property color animationColor: "#09c"
    property color overlayColor: "#333"
    property string image: ""

    color: initialColor

    signal clicked();

    Image{

        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: parent.image

        ColorOverlay {

            id: overlay

            anchors.fill: parent
            source: parent
            color: button.overlayColor
        }
    }

    // Press behaviour

    Behavior on color{

        PropertyAnimation{ property: "color"; duration: 150; }
    }

    Timer{
        id: backtocolor
        repeat: false
        interval: 150
        running: false
        onTriggered: button.color = button.initialColor
    }

    MouseArea{

        anchors.fill: parent
        onPressed: {

            button.color = button.animationColor
            backtocolor.running = true
            button.clicked();
        }
    }
}
