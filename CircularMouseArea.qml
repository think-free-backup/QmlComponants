import QtQuick 2.2

MouseArea {

    id: circleMouseArea

    anchors.fill: parent
    onClicked: console.log("circle clicked");
    onPressed: mouse.accepted = circleMouseArea.contains(mouse.x, mouse.y);

    function contains(x, y) {
        var d = (area.width / 2);
        var dx = (x - area.width / 2);
        var dy = (y - area.height / 2);
        return (d * d > dx * dx + dy * dy);
    }
}
