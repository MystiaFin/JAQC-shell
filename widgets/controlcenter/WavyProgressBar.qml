import QtQuick
import "../../components/theme"
import "../../services"

Item {
    id: root

    property real progress: 0
    property bool animated: false
    property color activeColor: Theme.accentColor
    property color inactiveColor: Theme.surfaceBorderColor
    property real phase: 0

    readonly property real clampedProgress: Math.max(0, Math.min(1, progress))
    readonly property bool wavesEnabled: animated && !SettingsService.reduceMotion
        && clampedProgress > 0.1 && clampedProgress < 0.95

    implicitHeight: 10

    onClampedProgressChanged: track.requestPaint()
    onWavesEnabledChanged: track.requestPaint()
    onActiveColorChanged: track.requestPaint()
    onInactiveColorChanged: track.requestPaint()
    onWidthChanged: track.requestPaint()
    onHeightChanged: track.requestPaint()
    onPhaseChanged: track.requestPaint()

    Canvas {
        id: track
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const context = getContext("2d");
            const centerY = height / 2;
            const activeWidth = width * root.clampedProgress;
            const lineWidth = 4;
            const halfLine = lineWidth / 2;
            const wavelength = 40;
            const halfWavelength = wavelength / 2;
            const trackGap = 4 + lineWidth;
            context.reset();
            context.lineCap = "round";
            context.lineJoin = "round";

            if (activeWidth + trackGap < width - halfLine) {
                context.beginPath();
                context.strokeStyle = root.inactiveColor;
                context.lineWidth = lineWidth;
                context.moveTo(Math.max(halfLine, activeWidth + trackGap), centerY);
                context.lineTo(width - halfLine, centerY);
                context.stroke();
            }

            if (activeWidth <= 0) {
                context.beginPath();
                context.fillStyle = root.activeColor;
                context.arc(width - halfLine, centerY, halfLine, 0, Math.PI * 2);
                context.fill();
                return;
            }

            context.beginPath();
            context.strokeStyle = root.activeColor;
            context.lineWidth = lineWidth;
            const startX = halfLine;
            const endX = Math.max(startX, Math.min(activeWidth, width - halfLine));
            if (!root.wavesEnabled) {
                context.moveTo(startX, centerY);
                context.lineTo(endX, centerY);
            } else {
                context.save();
                context.beginPath();
                context.rect(0, 0, endX, height);
                context.clip();

                const shift = root.phase * wavelength;
                let anchorX = -shift;
                let controlY = centerY + height - lineWidth;
                context.beginPath();
                context.moveTo(anchorX, centerY);
                while (anchorX <= endX + wavelength) {
                    const nextAnchorX = anchorX + halfWavelength;
                    context.quadraticCurveTo(
                        anchorX + halfWavelength / 2,
                        controlY,
                        nextAnchorX,
                        centerY);
                    anchorX = nextAnchorX;
                    controlY = centerY - (controlY - centerY);
                }
                context.stroke();
                context.restore();
                context.beginPath();
            }
            if (!root.wavesEnabled)
                context.stroke();

            context.beginPath();
            context.fillStyle = root.activeColor;
            context.arc(width - halfLine, centerY, halfLine, 0, Math.PI * 2);
            context.fill();
        }
    }

    NumberAnimation on phase {
        running: root.wavesEnabled && root.visible
        loops: Animation.Infinite
        from: 0
        to: 1
        duration: Math.round(1000 / Math.max(0.1,
            SettingsService.globalAnimationSpeed))
    }
}
