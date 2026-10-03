import QtQuick
import "_Shared/Singletons"

Item {
    id: surface

    property real s: 1
    property bool open: false
    property real morphCloseness: 1

    property real mTop: 0
    property real mLeft: 0
    property real mRight: 0
    property real mBottom: 0

    signal requestClose()

    property string ameForm: "off"
    property point amePoint: Qt.point(width / 2, height / 2)
    /** Set by the pill: true once its Ame bead has arrived at `amePoint`. */
    property bool ameArrived: false
    /** Set by the pill: true while its Ame bead is closing on `amePoint`. */
    property bool ameArriving: false
    /** Set by the pill: true while its Ame bead sits at rest on `amePoint`. */
    property bool ameAtTarget: false
    /** Hide the pill's Ame without resetting its position (Ame-fill hand-off). */
    property bool ameConcealed: false
    /** Bumped by the pill each time its Ame settles onto a target. */
    property int ameTick: 0

    readonly property bool active: open

    anchors.fill: parent
    anchors.topMargin: mTop * s
    anchors.leftMargin: mLeft * s
    anchors.rightMargin: mRight * s
    anchors.bottomMargin: mBottom * s

    enabled: open
    opacity: open ? Math.pow(morphCloseness, 1.3) : 0
    visible: opacity > 0.01

    Behavior on opacity {
        NumberAnimation { duration: Motion.standard; easing.type: Motion.easeStandard }
    }
}
