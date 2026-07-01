import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick
import "_Shared/Components"
import "_Shared/Singletons"

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

                anchors.leftMargin: marginHorizontal
                anchors.rightMargin: marginHorizontal

                property int barHeight: 36
                property real implicitHeight: barHeight ? barHeight : centerPill.implicitHeight

                RowLayout {
                    id: leftRow
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    StaticPill {
                        id: centerPill
                        anchors.verticalCenter: parent.verticalCenter
                        pillCrossAxis: content.barHeight

                        WorkspacesWidget {
                            id: workspaces
                            currentMonitor: root.monitorName
                        }
                    }

                    StaticPill {
                        anchors.verticalCenter: parent.verticalCenter
                        pillCrossAxis: content.barHeight

                        MediaWidget {}
                    }
                }

                StaticPill {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    pillCrossAxis: content.barHeight

                    ClockWidget {}
                }

                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    StaticPill {
                        anchors.verticalCenter: parent.verticalCenter

                        pillCrossAxis: content.barHeight

                        AudioWidget {}
                    }

                    StaticPill {
                        anchors.verticalCenter: parent.verticalCenter

                        pillCrossAxis: content.barHeight

                        CPUWidget {}
                        MemoryWidget {}
                        NetworkWidget {}
                    }
                }
            }
            Ame {
                id: ame
                anchors.fill: parent
                s: workspaces.ameS
                form: workspaces.ameForm
                heat: 0
                wake: {
                    void leftRow.x;
                    void leftRow.y;
                    void centerPill.x;
                    void centerPill.y;
                    void workspaces.x;
                    void workspaces.y;

                    workspaces.mapToItem(null, workspaces.heroPoint.x, workspaces.heroPoint.y);
                }
                point: {
                    void leftRow.x;
                    void leftRow.y;
                    void centerPill.x;
                    void centerPill.y;
                    void workspaces.x;
                    void workspaces.y;

                    workspaces.mapToItem(null, workspaces.amePoint.x, workspaces.amePoint.y);
                }
            }
        }
    }
}
