import QtQuick 2.0

Rectangle{

    id: button

    signal clicked();
    property double size: 150

    width: size
    height: size
    radius: size

    MouseArea{

        anchors.fill: parent
        onClicked: {

            button.clicked();
        }
    }
}
