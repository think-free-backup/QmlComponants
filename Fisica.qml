import QtQuick 2.0

/*
**  Quick Phisics with Sequential Animation
**  quicking.wordpress.com
*/

MouseArea {
    id: fis

    onReleased: startFisica()

    function stop(){

        initFisica.stop();
    }

    /* Get last positions */
    property int oldX
    property int oldY
    SequentialAnimation{
        id: loadFisicaAnim
        loops: -1; running: pressed
        ScriptAction{
            script: {
                fis.oldX = drag.target.x
                fis.oldY = drag.target.y
                initFisica.stop()
            }
        }
        // get positions 200ms before release
        PauseAnimation { duration: 500 }
    }


    /* Calculate new positions */
    property int newX: drag.target.x + (drag.target.x - fis.oldX)
    property int newY: drag.target.y + (drag.target.y - fis.oldY)
    function startFisica(){
        // stop some animation
        loadFisicaAnim.stop()
        // check drag limits
        initFisica.xTo=(fis.newX > drag.maximumX)?drag.maximumX:(fis.newX < drag.minimumX)?drag.minimumX:fis.newX
        initFisica.yTo=(fis.newY > drag.maximumY)?drag.maximumY:(fis.newY < drag.minimumY)?drag.minimumY:fis.newY
        // start animation
        initFisica.start()
    }
    SequentialAnimation{
        id: initFisica
        property int xTo
        property int yTo
        ParallelAnimation{
            PropertyAnimation{ target:drag.target; property: "x"; to: initFisica.xTo; duration: 1000; easing.type: "OutSine"  }
            PropertyAnimation{ target:drag.target; property: "y"; to: initFisica.yTo; duration: 1000; easing.type: "OutSine"  }
        }
    }
}
