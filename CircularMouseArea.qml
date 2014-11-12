import QtQuick 2.2

Item {

    width: 200
    height: 200

    signal clicked;
    signal pressed;

    MouseArea {

        id: circleMouseArea

        anchors.fill: parent

        onClicked: {

            parent.clicked();
        }
        onPressed: {

            mouse.accepted = circleMouseArea.contains(mouse.x, mouse.y);

            if(mouse.accepted)
                parent.pressed();
        }

        function contains(x, y) {

            var d = (circleMouseArea.width / 2);
            var dx = (x - circleMouseArea.width / 2);
            var dy = (y - circleMouseArea.height / 2);

            return (d * d > dx * dx + dy * dy);
        }
    }
}
