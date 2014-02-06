import QtQuick 2.0

Item {

    property int activationAreaX : parent.width/10;
    property int activationAreaY : parent.height/10;
    property bool mouseAreaActivated: false
    property int currentX: -1
    property int currentY: -1

    signal left (bool border)
    signal right (bool border)
    signal top (bool border)
    signal bottom (bool border)

    MouseArea{

        anchors.fill:parent
        focus:true

        property bool border : false;

        onPressed:{

            mouseAreaActivated = true;
        }

        onPositionChanged:{

            if(mouseAreaActivated){

                if (mouseX < 20 || mouseX > width - 20 || mouseY < 20 || mouseY > height - 20)
                    border = true;
                else
                    border = false;

                currentX = mouseX;
                currentY = mouseY;
                mouseAreaActivated = false;
            }
            else if (currentX > 0 && currentY > 0){

                // X

                if (mouseX > currentX + parent.activationAreaX){
                    parent.right(border);
                    currentX = -1;
                }
                else if (mouseX < currentX - parent.activationAreaX){
                    parent.left(border);
                    currentX = -1;
                }

                // Y

                if (mouseY > currentY + parent.activationAreaY){
                    parent.bottom(border);
                    currentY = -1;
                }
                else if (mouseY < currentY - parent.activationAreaY){
                    parent.top(border);
                    currentY = -1;
                }
            }
        }
    }
}

