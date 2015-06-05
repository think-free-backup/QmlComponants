import QtQuick 2.0

Rectangle{

    id: button

    signal clicked();
    signal entered();
    signal exited();
    property double size: 150
    property alias hoverEnabled : mouseArea.hoverEnabled

    width: size
    height: size
    radius: size

    MouseArea{

        id: mouseArea
        anchors.fill: parent
        onClicked: {

            button.clicked();
        }
        onEntered:
            button.entered();
        onExited:
            button.exited();
    }

    MultiPointTouchArea{

        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 1

        touchPoints: [

            TouchPoint { id: touch1

                onPressedChanged:

                    if(pressed)
                        button.clicked();
            }
        ]
    }
}
