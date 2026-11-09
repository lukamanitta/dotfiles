import QtQuick
import "../Singletons"

/**
 * Single-line text that ping-pong scrolls when wider than the available width,
 * so long track and artist names stay readable. Caller sets the width (e.g.
 * via anchors) and `active` to gate the motion. The label snaps to whole pixels
 * so NativeRendering stays crisp while it scrolls.
 */
Item {
    id: root

    property string text: ""
    property color color: Theme.cream
    property real pixelSize: 14
    property int weight: Font.Normal
    property bool active: true

    property real scrollX: 0

    implicitHeight: label.implicitHeight
    clip: true

    readonly property bool overflowing: label.implicitWidth > width
    readonly property real maxScroll: Math.max(0, label.implicitWidth - width)
    readonly property bool leftOverflow: overflowing && scrollX < -0.5
    readonly property bool rightOverflow: overflowing && -scrollX < maxScroll - 0.5

    /**
     * Vignette the clipped edges only where there is hidden content, so the
     * marquee never ends on a hard line. The layer shader fades the text's own
     * alpha, revealing whatever card background is underneath.
     */
    layer.enabled: true
    layer.effect: ShaderEffect {
        property real leftFade: root.leftOverflow ? 0.12 : 0
        property real rightFade: root.rightOverflow ? 0.12 : 0
        fragmentShader: "../../shaders/edgefade.frag.qsb"
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        x: Math.round(root.scrollX)
        text: root.text
        color: root.color
        renderType: Text.NativeRendering
        font.family: Theme.font
        font.pixelSize: root.pixelSize
        font.weight: root.weight
        elide: root.overflowing ? Text.ElideNone : Text.ElideRight
        width: root.overflowing ? implicitWidth : root.width

        onTextChanged: root.sync()
    }

    SequentialAnimation {
        id: anim
        loops: Animation.Infinite
        PauseAnimation { duration: 1800 }
        NumberAnimation {
            target: root
            property: "scrollX"
            from: 0
            to: -(label.implicitWidth - root.width)
            duration: Math.max(1, label.implicitWidth - root.width) * 22
            easing.type: Easing.InOutSine
        }
        PauseAnimation { duration: 1800 }
        NumberAnimation {
            target: root
            property: "scrollX"
            from: -(label.implicitWidth - root.width)
            to: 0
            duration: Math.max(1, label.implicitWidth - root.width) * 22
            easing.type: Easing.InOutSine
        }
    }

    onActiveChanged: sync()
    onOverflowingChanged: sync()
    Component.onCompleted: sync()

    /**
     * Fully imperative start/stop: a `running` binding here would be severed by
     * the first imperative stop() and leave the loop animating forever inside a
     * hidden surface. Re-syncing on overflow changes also refreshes the captured
     * from/to endpoints after a width change.
     */
    function sync() {
        anim.stop();
        root.scrollX = 0;
        if (overflowing && active)
            anim.start();
    }
}
