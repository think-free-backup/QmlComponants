import QtQuick 2.2

Item{

    id: slidebutton

    width: 300
    height: 100

    signal slided();
    signal clicked();

    property alias visual : loader.sourceComponent
    property alias visualWidth : loader.width

    Loader{

        id: loader
    
        height: 100
        width: 200
        smooth: true

        sourceComponent: Rectangle{

            color: "black"
            radius: 6
        }

        Behavior on x {

            NumberAnimation { duration: 250 }
        }

        MouseArea{

            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis           
            drag.maximumX : slidebutton.width - loader.width

            onReleased:{ 

                loader.x = 0

                if (loader.x === slidebutton.width - loader.width)
                    slidebutton.slided();
            }

            onClicked:{
                
                slidebutton.clicked();
            }
        } 
    }
}

