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
