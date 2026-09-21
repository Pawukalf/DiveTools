using Toybox.WatchUi;
using Toybox.Graphics;

class DiveToolsView extends WatchUi.View {

    var selected;

    function initialize() {
        View.initialize();
        selected = 0;
    }

    function moveSelection(direction) {
        selected = selected + direction;

        if (selected < 0) {
            selected = 3;
        }

        if (selected > 3) {
            selected = 0;
        }

        WatchUi.requestUpdate();
    }

    function getSelection() {
        return selected;
    }

    function onUpdate(dc) {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );

        dc.clear();

        var leftX = screenWidth * 34 / 100;
        var rightX = screenWidth * 66 / 100;

        var topY = screenHeight * 37 / 100;
        var bottomY = screenHeight * 63 / 100;

        drawOption(
            dc,
            leftX,
            topY,
            "MOD",
            selected == 0
        );

        drawOption(
            dc,
            rightX,
            topY,
            "MIX",
            selected == 1
        );

        drawOption(
            dc,
            leftX,
            bottomY,
            "EAD",
            selected == 2
        );

        drawOption(
            dc,
            rightX,
            bottomY,
            "END",
            selected == 3
        );
    }

    function drawOption(dc, centerX, centerY, label, isSelected) {
        var font = Graphics.FONT_LARGE;
        var fontHeight = dc.getFontHeight(font);

        var bubbleWidth = dc.getWidth() * 30 / 100;
        var bubbleHeight = fontHeight + 18;

        var bubbleX = centerX - bubbleWidth / 2;
        var bubbleY = centerY - bubbleHeight / 2;
        var bubbleRadius = bubbleHeight / 2;

        var textY = centerY - fontHeight / 2;

        if (isSelected) {
            dc.setColor(
                Graphics.COLOR_WHITE,
                Graphics.COLOR_BLACK
            );

            dc.fillRoundedRectangle(
                bubbleX,
                bubbleY,
                bubbleWidth,
                bubbleHeight,
                bubbleRadius
            );

            dc.setColor(
                Graphics.COLOR_BLACK,
                Graphics.COLOR_TRANSPARENT
            );
        } else {
            dc.setColor(
                Graphics.COLOR_WHITE,
                Graphics.COLOR_TRANSPARENT
            );
        }

        dc.drawText(
            centerX,
            textY,
            font,
            label,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );
    }
}