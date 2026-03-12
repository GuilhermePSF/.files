import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // --- COLORS (Tokyo Night) ---
    property color colBg:      "#1a1b26"
    property color colSurface: "#24253a"
    property color colFg:      "#a9b1d6"
    property color colMuted:   "#444b6a"
    property color colCyan:    "#0db9d7"
    property color colPurple:  "#ad8ee6"
    property color colHover:   "#2f3155"

    property string fontFamily: "JetBrainsMono Nerd Font"

    // Top-level toggle — safe to reference from IpcHandler
    property bool pickerOpen: false

    IpcHandler {
        target: "displayPicker"
        function toggle() { root.pickerOpen = !root.pickerOpen }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            // Always present; content shown/hidden via inner Item.visible
            anchors { top: true; left: true; right: true; bottom: true }
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: root.pickerOpen
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

            Item {
                anchors.fill: parent
                visible: root.pickerOpen
                focus: root.pickerOpen

                Keys.onEscapePressed: root.pickerOpen = false

                // Scrim
                Rectangle {
                    anchors.fill: parent
                    color: "#cc000000"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.pickerOpen = false
                    }

                    // Card
                    Rectangle {
                        anchors.centerIn: parent
                        width: grid.width + 48
                        height: titleText.height + grid.height + 56
                        radius: 18
                        color: root.colBg
                        border.color: root.colMuted
                        border.width: 1

                        MouseArea { anchors.fill: parent }

                        Text {
                            id: titleText
                            text: "Display Mode"
                            color: root.colCyan
                            font.pixelSize: 15
                            font.family: root.fontFamily
                            font.bold: true
                            anchors.top: parent.top
                            anchors.topMargin: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Horizontal row of square buttons
                        Row {
                            id: grid
                            anchors.top: titleText.bottom
                            anchors.topMargin: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 12

                            component ModeButton: Rectangle {
                                property string label: ""
                                property string icon: ""
                                property string mode: ""

                                width: 100
                                height: 100
                                radius: 14
                                color: btnHover.containsMouse ? root.colHover : root.colSurface

                                Behavior on color {
                                    ColorAnimation { duration: 100 }
                                }

                                Process {
                                    id: modeProc
                                    command: ["bash", "-c", "~/.config/hypr/display-mode.sh " + parent.mode]
                                }

                                MouseArea {
                                    id: btnHover
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        modeProc.running = true
                                        root.pickerOpen = false
                                    }
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 8

                                    Text {
                                        text: parent.parent.icon
                                        color: root.colPurple
                                        font.pixelSize: 32
                                        font.family: root.fontFamily
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Text {
                                        text: parent.parent.label
                                        color: root.colFg
                                        font.pixelSize: 11
                                        font.family: root.fontFamily
                                        font.bold: true
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                            }

                            ModeButton { icon: "";  label: "Laptop\nOnly";    mode: "laptop-only"   }
                            ModeButton { icon: "󰍹"; label: "External\nOnly";  mode: "external-only" }
                            ModeButton { icon: ""; label: "Mirror";          mode: "mirror"        }
                            ModeButton { icon: ""; label: "Extend\nBelow";   mode: "extend-bottom" }
                            ModeButton { icon: ""; label: "Extend\nAbove";   mode: "extend-top"   }
                        }
                    }
                }
            }
        }
    }
}
