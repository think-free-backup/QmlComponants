import QtQuick 2.0

Item {

    id: sliderContainer

    anchors.fill: parent

    property int positions : 3;
    property int currentPosition : 0;

    property color color : "#22ffffff"
    property color borderColor : "#09c"
    property int borderWidth : 3
    property real radius : 6
    property int animationDuration : 500

    Rectangle {

        id: slider

        x: (sliderContainer.width / sliderContainer.positions) * sliderContainer.currentPosition;
        y: -5;
        width: parent.width / positions;
        height: parent.height + 10       
        smooth: true

        color: sliderContainer.color
        border.color: sliderContainer.borderColor
        radius: sliderContainer.radius
        border.width: sliderContainer.borderWidth

        Behavior on x{

            PropertyAnimation{properties: "x"; easing.type: Easing.InOutQuad; duration: sliderContainer.animationDuration}
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
