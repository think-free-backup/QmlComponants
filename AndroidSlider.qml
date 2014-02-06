import QtQuick 2.0

Item {

    id: slider;

    width: 400;
    height: 2

    property real value: 0
    property real remoteValue : 0
    property real maximum: 1
    property real minimum: 0

    property int xMax: width - handle.width

    signal valueSet(int value);

    onValueChanged: updatePos();
    onXMaxChanged: updatePos();
    onMinimumChanged: updatePos();

    Rectangle {

        anchors.fill: parent

        gradient: Gradient {

            GradientStop { position: 0.0; color: "#66333333" }
            GradientStop { position: 1.0; color: "#66000000" }
        }
    }

    Rectangle {

        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.height
        width: handle.x

        gradient: Gradient {

            GradientStop { position: 0.0; color: "#09c" }
            GradientStop { position: 1.0; color: "#33b5e5" }
        }
    }

    Rectangle {

        id: handle;

        smooth: true
        y: - height/2 + 1
        width: parent.height * 15;
        height: width
        radius: width / 2
        opacity : 0.5
        border.color: "#09c";
        border.width: 1;

        color:"#33b5e5"

        MouseArea {

            id: mouse

            anchors.fill: parent;
            drag.target: parent
            drag.axis: Drag.XAxis;
            drag.minimumX: 0;
            drag.maximumX: slider.xMax

            onPositionChanged: {
                value = (maximum - minimum) * (handle.x) / slider.xMax + minimum;
            }

            onReleased: {
                slider.valueSet(value);
            }
        }
    }

    Rectangle {

        id: handleCenter;

        smooth: true
        anchors.centerIn: handle
        width: handle.width / 5;
        height: width
        radius: width / 2

        color:"#33b5e5"
    }

    onRemoteValueChanged: value = remoteValue;

    function updatePos() {

        if (maximum > minimum) {

            var pos = (value - minimum) * slider.xMax / (maximum - minimum);
            pos = Math.min(pos, width - handle.width);
            pos = Math.max(pos, 0);
            handle.x = pos;
        }
        else {

            handle.x = 0;
        }
    }
}
