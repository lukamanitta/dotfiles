import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            required property var modelData
            screen: modelData

            property string monitorName: screen ? screen.name : ""

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"

            height: content.implicitHeight + (content.marginVertical * 2)

            Item {
                id: content
                anchors.fill: parent

                property int marginHorizontal: 12
                property int marginVertical: 6

                anchors.topMargin: marginVertical
                anchors.leftMargin: marginHorizontal
                anchors.rightMargin: marginHorizontal

                Pill {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    MediaWidget {}
                }

                Pill {
                    id: centerPill
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    WorkspacesWidget {
                        currentMonitor: root.monitorName
                    }
                }

                Pill {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    NetworkWidget {}
                    ClockWidget {}
                }

                property real implicitHeight: centerPill.implicitHeight
            }
        }
    }
}
