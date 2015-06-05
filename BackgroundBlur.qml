import QtQuick 2.0
import QtGraphicalEffects 1.0


Item{
    property alias sourceItem: effect_source.sourceItem
    property alias sourceRect: effect_source.sourceRect
    property alias radius : gaussianBlur.radius
    property alias samples : gaussianBlur.samples
    property alias deviation : gaussianBlur.deviation

    ShaderEffectSource {
      id: effect_source
      anchors.fill: parent.parent
      hideSource: false
      width: sourceRect.width
      height: sourceRect.height
      visible: false
      live: true
    }

    GaussianBlur {
      id: gaussianBlur
      anchors.fill: effect_source
      source: effect_source
      radius: 12
      samples: 16
      deviation: 10
    }
}

