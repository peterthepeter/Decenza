import QtQuick
import QtQuick.Shapes
import Decenza

// Restrained, data-driven alternative to CupFillView.
// The ceramic and espresso keep fixed colours; only geometry communicates the shot:
// weight raises the liquid and flow changes the stream width.
Item {
    id: root

    property real currentWeight: 0
    property real targetWeight: 36
    property real currentFlow: 0
    property int phase: 0

    readonly property color ceramicColor: "#2b2a29"
    readonly property color ceramicEdgeColor: "#5a5753"
    readonly property color ceramicRecessColor: "#171616"
    readonly property color espressoColor: "#4f1f0d"
    readonly property color espressoSurfaceColor: "#9a5127"
    readonly property color primaryLabelColor: "#f2eee8"
    readonly property color secondaryLabelColor: "#aaa29a"

    function isExtractionPhase(p) {
        return p === MachineState.Phase.Preinfusion
            || p === MachineState.Phase.Pouring
            || p === MachineState.Phase.Ending
    }

    function isEspressoCycle(p) {
        return p === MachineState.Phase.EspressoPreheating
            || p === MachineState.Phase.Preinfusion
            || p === MachineState.Phase.Pouring
            || p === MachineState.Phase.Ending
    }

    readonly property bool extractionPhase: isExtractionPhase(phase)
    readonly property bool inEspressoCycle: isEspressoCycle(phase)
    property bool extractionSeen: false
    property real heldWeight: 0
    readonly property bool holding: extractionSeen && !inEspressoCycle
    readonly property real displayWeight: holding ? heldWeight : currentWeight
    readonly property real shownWeight: extractionSeen ? Math.max(displayWeight, 0) : 0
    readonly property real requestedFillRatio: targetWeight > 0 && extractionSeen
        ? Math.max(0, Math.min(shownWeight / targetWeight, 1)) : 0
    property real visualFillRatio: requestedFillRatio

    // The Loader can keep this instance alive through the post-shot stop overlay.
    // Match CupFillView's hold contract so switching visual styles never changes
    // what the user sees at the end of a shot.
    onCurrentWeightChanged: {
        if (extractionSeen && currentWeight > heldWeight)
            heldWeight = currentWeight
    }

    property int previousPhase: -1
    onPhaseChanged: {
        if (isEspressoCycle(phase) && !isEspressoCycle(previousPhase)) {
            extractionSeen = false
            heldWeight = 0
        }
        if (isExtractionPhase(phase))
            extractionSeen = true
        previousPhase = phase
    }

    onRequestedFillRatioChanged: visualFillRatio = requestedFillRatio

    Component.onCompleted: {
        previousPhase = phase
        if (isExtractionPhase(phase))
            extractionSeen = true
        visualFillRatio = requestedFillRatio
    }

    Behavior on visualFillRatio {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    // D4 proportions: the complete cup occupies about 90% of the earlier concept,
    // leaving a deliberate gap above the live-stat bar on landscape tablets.
    readonly property real cupBodyW: Math.min(width * 0.41, height * 1.32)
    readonly property real cupBodyH: cupBodyW * 0.72
    readonly property real cupX: (width - cupBodyW) / 2 - Theme.scaled(10)
    readonly property real cupY: height - cupBodyH - Theme.scaled(28)
    readonly property real rimH: cupBodyH * 0.085

    readonly property real innerTopY: cupBodyH * 0.12
    readonly property real innerBottomY: cupBodyH * 0.91
    readonly property real fillTopY: innerBottomY
        - (innerBottomY - innerTopY) * visualFillRatio
    readonly property real sideProgress: (fillTopY - innerTopY)
        / (innerBottomY - innerTopY)
    readonly property real fillLeftX: cupBodyW * (0.055 + 0.17 * sideProgress)
    readonly property real fillRightX: cupBodyW - fillLeftX
    readonly property bool streamVisible: extractionPhase && currentFlow > 0.08

    // Flow is deliberately encoded only by the stream: narrow at low flow,
    // widening smoothly without changing the espresso or ceramic colours.
    Rectangle {
        id: espressoStream
        z: 2
        x: root.cupX + root.cupBodyW / 2 - width / 2
        y: 0
        width: Theme.scaled(2.2)
            + Math.min(Math.max(root.currentFlow, 0) / 6, 1) * Theme.scaled(3.8)
        height: root.cupY + root.rimH * 0.58
        radius: width / 2
        color: "#6d2b11"
        opacity: root.streamVisible ? 0.92 : 0
        visible: opacity > 0

        Behavior on width {
            NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
        }
        Behavior on opacity {
            NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
        }

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.max(1, parent.width * 0.22)
            radius: width / 2
            color: "#b2693b"
            opacity: 0.26
        }
    }

    // The approved D4 handle: slim, slightly low, and visually subordinate.
    Rectangle {
        z: 0
        x: root.cupX + root.cupBodyW * 0.91
        y: root.cupY + root.cupBodyH * 0.19
        width: root.cupBodyW * 0.205
        height: root.cupBodyH * 0.34
        radius: height * 0.45
        color: "transparent"
        border.color: root.ceramicEdgeColor
        border.width: Theme.scaled(8)
    }

    // Matte ceramic body. The outline is intentionally precise; small edge strokes
    // provide depth without glass, glow, or a photorealistic texture layer.
    Shape {
        z: 1
        x: root.cupX
        y: root.cupY
        width: root.cupBodyW
        height: root.cupBodyH

        ShapePath {
            fillColor: root.ceramicColor
            strokeColor: root.ceramicEdgeColor
            strokeWidth: Theme.scaled(1.2)
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            startX: root.cupBodyW * 0.018
            startY: root.rimH * 0.48
            PathCubic {
                control1X: root.cupBodyW * 0.055
                control1Y: root.cupBodyH * 0.38
                control2X: root.cupBodyW * 0.13
                control2Y: root.cupBodyH * 0.79
                x: root.cupBodyW * 0.23
                y: root.cupBodyH * 0.94
            }
            PathCubic {
                control1X: root.cupBodyW * 0.34
                control1Y: root.cupBodyH * 0.99
                control2X: root.cupBodyW * 0.66
                control2Y: root.cupBodyH * 0.99
                x: root.cupBodyW * 0.77
                y: root.cupBodyH * 0.94
            }
            PathCubic {
                control1X: root.cupBodyW * 0.87
                control1Y: root.cupBodyH * 0.79
                control2X: root.cupBodyW * 0.945
                control2Y: root.cupBodyH * 0.38
                x: root.cupBodyW * 0.982
                y: root.rimH * 0.48
            }
            PathLine { x: root.cupBodyW * 0.018; y: root.rimH * 0.48 }
        }
    }

    // Recessed opening below the incoming stream.
    Rectangle {
        z: 2
        x: root.cupX + root.cupBodyW * 0.025
        y: root.cupY
        width: root.cupBodyW * 0.95
        height: root.rimH
        radius: height / 2
        color: root.ceramicRecessColor
    }

    Rectangle {
        z: 4
        x: root.cupX + root.cupBodyW * 0.018
        y: root.cupY
        width: root.cupBodyW * 0.964
        height: root.rimH
        radius: height / 2
        color: "transparent"
        border.color: root.ceramicEdgeColor
        border.width: Theme.scaled(2)
    }

    // Clean sectional liquid body. Its top edge is the only weight-driven cup
    // geometry, which keeps the fill immediately legible at a glance.
    Shape {
        z: 5
        x: root.cupX
        y: root.cupY
        width: root.cupBodyW
        height: root.cupBodyH
        visible: root.visualFillRatio > 0.001

        ShapePath {
            fillColor: root.espressoColor
            strokeColor: "transparent"
            startX: root.fillLeftX
            startY: root.fillTopY
            PathLine { x: root.fillRightX; y: root.fillTopY }
            PathCubic {
                control1X: root.cupBodyW * 0.83
                control1Y: root.cupBodyH * 0.80
                control2X: root.cupBodyW * 0.72
                control2Y: root.cupBodyH * 0.95
                x: root.cupBodyW * 0.59
                y: root.cupBodyH * 0.955
            }
            PathLine { x: root.cupBodyW * 0.41; y: root.cupBodyH * 0.955 }
            PathCubic {
                control1X: root.cupBodyW * 0.28
                control1Y: root.cupBodyH * 0.95
                control2X: root.cupBodyW * 0.17
                control2Y: root.cupBodyH * 0.80
                x: root.fillLeftX
                y: root.fillTopY
            }
        }
    }

    Rectangle {
        z: 6
        x: root.cupX + root.fillLeftX
        y: root.cupY + root.fillTopY - height / 2
        width: root.fillRightX - root.fillLeftX
        height: Theme.scaled(1.5)
        color: root.espressoSurfaceColor
        opacity: root.visualFillRatio > 0.001 ? 0.9 : 0

        Behavior on y {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }
    }

    // Fixed target-height notch: short enough to stay a reference rather than
    // becoming another graph line.
    Rectangle {
        z: 7
        x: root.cupX + root.cupBodyW * 0.80
        y: root.cupY + root.innerTopY
        width: root.cupBodyW * 0.065
        height: Theme.scaled(1.5)
        radius: height / 2
        color: root.secondaryLabelColor
        opacity: root.targetWeight > 0 ? 0.78 : 0
    }

    Column {
        z: 8
        x: root.cupX + root.cupBodyW / 2 - width / 2
        y: root.cupY + root.cupBodyH * 0.62 - height / 2
        spacing: Theme.scaled(3)

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.shownWeight.toFixed(1)
                + TranslationManager.translate("common.unit.grams", "g")
            color: root.primaryLabelColor
            font.family: Theme.bodyFont.family
            font.pixelSize: Theme.scaled(38)
            font.weight: Font.Medium
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.targetWeight > 0
                ? TranslationManager.translate("espresso.cupFill.target", "target")
                    + " " + root.targetWeight.toFixed(0)
                    + TranslationManager.translate("common.unit.grams", "g")
                : ""
            color: root.secondaryLabelColor
            font.family: Theme.captionFont.family
            font.pixelSize: Theme.scaled(15)
        }
    }
}
