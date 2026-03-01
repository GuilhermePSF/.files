import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // --- COLORS ---
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colPurple: "#ad8ee6"
    property color colRed: "#f7768e"
    property color colYellow: "#e0af68"
    property color colBlue: "#7aa2f7"

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    // --- VARIABLES ---
    property string kernelVersion: "Linux"
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property int volumeLevel: 0
    property string activeWindow: "Window"
    property string currentLayout: "Tile"
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    // --- PROCESSES (Data Gatherers) ---
    Process {
        id: kernelProc
        command: ["uname", "-r"]
        stdout: SplitParser { onRead: data => { if (data) kernelVersion = data.trim() } }
        Component.onCompleted: running = true
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var user = parseInt(parts[1]) || 0; var nice = parseInt(parts[2]) || 0
                var system = parseInt(parts[3]) || 0; var idle = parseInt(parts[4]) || 0
                var iowait = parseInt(parts[5]) || 0; var irq = parseInt(parts[6]) || 0
                var softirq = parseInt(parts[7]) || 0
                var total = user + nice + system + idle + iowait + irq + softirq
                var idleTime = idle + iowait
                if (lastCpuTotal > 0) {
                    var totalDiff = total - lastCpuTotal
                    var idleDiff = idleTime - lastCpuIdle
                    if (totalDiff > 0) cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                }
                lastCpuTotal = total; lastCpuIdle = idleTime
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1; var used = parseInt(parts[2]) || 0
                memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "df / | tail -1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                diskUsage = parseInt((parts[4] || "0%").replace('%', '')) || 0
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) volumeLevel = Math.round(parseFloat(match[1]) * 100)
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
        stdout: SplitParser { onRead: data => { if (data && data.trim()) activeWindow = data.trim() } }
        Component.onCompleted: running = true
    }

    Process {
        id: layoutProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
        stdout: SplitParser { onRead: data => { if (data && data.trim()) currentLayout = data.trim() } }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: { cpuProc.running = true; memProc.running = true; diskProc.running = true; volProc.running = true }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) { windowProc.running = true; layoutProc.running = true }
    }

    Timer {
        interval: 200; running: true; repeat: true
        onTriggered: { windowProc.running = true; layoutProc.running = true }
    }

    // --- THE BAR ---
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            anchors { top: true; left: true; right: true }
            implicitHeight: 30
            color: root.colBg

            Rectangle {
                anchors.fill: parent
                color: root.colBg

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    // Left padding
                    Item { width: 8 }

                    // WORKSPACES
                    Repeater {
                        model: 9
                        Rectangle {
                            Layout.preferredWidth: 20
                            Layout.preferredHeight: parent.height
                            color: "transparent"

                            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                            property bool hasWindows: workspace !== null

                            Text {
                                text: index + 1
                                color: parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted)
                                font.pixelSize: root.fontSize
                                font.family: root.fontFamily
                                font.bold: true
                                anchors.centerIn: parent
                            }
                            Rectangle {
                                width: 20; height: 3
                                color: parent.isActive ? root.colPurple : root.colBg
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch("workspace " + (index + 1))
                            }
                        }
                    }

                    // LAYOUT & TITLE
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 8; Layout.rightMargin: 8; color: root.colMuted }
                    Text { text: currentLayout; color: root.colFg; font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true }
                    
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 2; Layout.rightMargin: 8; color: root.colMuted }
                    Text {
                        text: activeWindow
                        color: root.colPurple
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    // SYSTEM STATS
                    Text { text: kernelVersion; color: root.colRed; font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true; Layout.rightMargin: 8 }
                    
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 0; Layout.rightMargin: 8; color: root.colMuted }
                    Text { text: "CPU: " + cpuUsage + "%"; color: root.colYellow; font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true; Layout.rightMargin: 8 }
                    
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 0; Layout.rightMargin: 8; color: root.colMuted }
                    Text { text: "Mem: " + memUsage + "%"; color: root.colCyan; font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true; Layout.rightMargin: 8 }
                    
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 0; Layout.rightMargin: 8; color: root.colMuted }
                    Text { text: "Disk: " + diskUsage + "%"; color: root.colBlue; font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true; Layout.rightMargin: 8 }
                    
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 0; Layout.rightMargin: 8; color: root.colMuted }
                    Text { text: "Vol: " + volumeLevel + "%"; color: root.colPurple; font.pixelSize: root.fontSize; font.family: root.fontFamily; font.bold: true; Layout.rightMargin: 8 }
                    
                    Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 16; Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 0; Layout.rightMargin: 8; color: root.colMuted }

                    // CLOCK
                    Text {
                        id: clockText
                        text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                        color: root.colCyan
                        font.pixelSize: root.fontSize
                        font.family: root.fontFamily
                        font.bold: true
                        Layout.rightMargin: 8
                        Timer {
                            interval: 1000; running: true; repeat: true
                            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                        }
                    }
                    Item { width: 8 }
                }
            }
        }
    }
}
