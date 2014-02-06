import QtQuick 2.0

Item {

    id: sliderContainer

    property int positions : 3;
    property int currentPosition : 0;

    anchors.fill: parent

    Rectangle {

        id: slider

        x: (sliderContainer.width / sliderContainer.positions) * sliderContainer.currentPosition;
        y: -5;
        width: parent.width / positions;
        height: parent.height + 10

        radius: 6
        smooth: true

        color:"#22ffffff"
        border.color: "#09c"
        border.width: 3

        Behavior on x{

            PropertyAnimation{properties: "x"; easing.type: Easing.InOutQuad; duration: 500}
        }

        MouseArea {

            anchors.fill: parent
            drag.target: parent; drag.axis: Drag.XAxis
            drag.minimumX: 2; drag.maximumX: sliderContainer.width - slider.width - 2

            onReleased: {

                sliderContainer.currentPosition = -1;
                sliderContainer.currentPosition = Math.floor( (slider.x  / ((sliderContainer.width / sliderContainer.positions) /2) ) / 2 + 0.5);
            }
        }
    }
}
