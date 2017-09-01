import QtQuick 2.4
import QtGraphicalEffects 1.0
import React 0.1 as React

React.Item {
  id: root
  p_backgroundColor: 'transparent'

  property alias resizeMode: image.fillMode
  property alias tintColor: colorOverlay.color
  property string p_testID

  property var p_source;
  property bool p_onLoadStart: false
  property bool p_onLoadEnd: false
  property bool p_onLoad: false
  property bool p_onError: false
  property bool p_onProgress: false
  property bool p_onLayout: false
  property double p_blurRadius: 0
  property string p_resizeMode: 'cover'

  property var imageManager: null
  property string managedSource

  onP_sourceChanged: {
    //Manager will load image and set correct url to "managedSource" property
    imageManager.manageSource(p_source, root);
  }
  onP_resizeModeChanged: {
    image.fillMode = fillModeFromResizeMode(root.p_resizeMode)
  }

  objectName: p_testID

  onTintColorChanged: {
    image.visible = false
    colorOverlay.visible = true
  }

  Image {
    id: image
    visible: true
    anchors.fill: parent
    layer.enabled: root.borderRadius > 0
    fillMode: fillModeFromResizeMode(root.p_resizeMode)
    source: root.managedSource

    layer.effect: OpacityMask {
      maskSource: Rectangle {
        width: image.width
        height: image.height
        radius: root.borderRadius
      }
    }
  }

  ColorOverlay {
    visible: false
    anchors.fill: image
    id: colorOverlay
    source: image
  }

  function fillModeFromResizeMode(resizeMode) {
    switch (resizeMode) {
        case "cover": return Image.PreserveAspectCrop;
        case "contain": return Image.PreserveAspectFit;
        case "stretch": return Image.Stretch;
        case "repeat": return Image.Tile;
        case "center": return Image.Center;
        default: return Image.PreserveAspectCrop;
    }
  }
}
