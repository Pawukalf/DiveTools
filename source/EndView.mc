using Toybox.WatchUi;
using Toybox.Graphics;

class EndView extends WatchUi.View {

    var depth;
    var oxygen;
    var helium;
    var editMode;

    function initialize() {
        View.initialize();

        depth = 60;
        oxygen = 18;
        helium = 45;

        // 0 = depth
        // 1 = oxygen
        // 2 = helium
        editMode = 0;
    }

    function increaseValue() {
        if (editMode == 0) {
            depth = depth + 1;

            if (depth > 150) {
                depth = 150;
            }
        } else if (editMode == 1) {
            oxygen = oxygen + 1;

            if (oxygen > 100 - helium) {
                oxygen = 100 - helium;
            }
        } else {
            helium = helium + 1;

            if (helium > 100 - oxygen) {
                helium = 100 - oxygen;
            }
        }

        WatchUi.requestUpdate();
    }

    function decreaseValue() {
        if (editMode == 0) {
            depth = depth - 1;

            if (depth < 1) {
                depth = 1;
            }
        } else if (editMode == 1) {
            oxygen = oxygen - 1;

            if (oxygen < 1) {
                oxygen = 1;
            }
        } else {
            helium = helium - 1;

            if (helium < 0) {
                helium = 0;
            }
        }

        WatchUi.requestUpdate();
    }

    function nextEditMode() {
        editMode = editMode + 1;

        if (editMode > 2) {
            editMode = 0;
        }

        WatchUi.requestUpdate();
    }

    function calculateNitrogen() {
        return 100 - oxygen - helium;
    }

    function calculateEnd() {
        var nitrogenFraction =
            calculateNitrogen().toFloat() / 100.0;

        var end =
            ((nitrogenFraction / 0.79) *
            (depth.toFloat() + 10.0)) -
            10.0;

        if (end < 0.0) {
            end = 0.0;
        }

        return end;
    }

    function calculatePpo2() {
        var oxygenFraction =
            oxygen.toFloat() / 100.0;

        var ambientPressure =
            depth.toFloat() / 10.0 + 1.0;

        return oxygenFraction * ambientPressure;
    }

    function getOxygenColor() {
        var currentPpo2 = calculatePpo2();

        if (currentPpo2 >= 1.6) {
            return Graphics.COLOR_RED;
        }

        if (currentPpo2 >= 1.4) {
            return Graphics.COLOR_YELLOW;
        }

        return Graphics.COLOR_WHITE;
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );

        dc.clear();

        drawTitle(
            dc,
            width / 2,
            height * 12 / 100
        );

        drawEndResult(
            dc,
            width / 2,
            height * 29 / 100
        );

        // Lower controls shifted upward
        drawInputOption(
            dc,
            width / 2,
            height * 51 / 100,
            "DEPTH " + depth.format("%d") + "m",
            editMode == 0,
            Graphics.COLOR_WHITE
        );

        drawInputOption(
            dc,
            width / 2,
            height * 63 / 100,
            "O2 " + oxygen.format("%d") + "%",
            editMode == 1,
            getOxygenColor()
        );

        drawInputOption(
            dc,
            width / 2,
            height * 75 / 100,
            "HE " + helium.format("%d") + "%",
            editMode == 2,
            Graphics.COLOR_WHITE
        );

        drawGuidance(
            dc,
            width / 2,
            height * 85 / 100
        );
    }

    function drawTitle(dc, centerX, centerY) {
        var font = Graphics.FONT_LARGE;
        var fontHeight = dc.getFontHeight(font);

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            centerX,
            centerY - fontHeight / 2,
            font,
            "END",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawEndResult(dc, centerX, centerY) {
        var numberFont = Graphics.FONT_NUMBER_HOT;
        var unitFont = Graphics.FONT_MEDIUM;

        var numberText =
            calculateEnd().format("%.1f");

        var unitText = "m";

        var numberWidth =
            dc.getTextWidthInPixels(
                numberText,
                numberFont
            );

        var unitWidth =
            dc.getTextWidthInPixels(
                unitText,
                unitFont
            );

        var numberHeight =
            dc.getFontHeight(numberFont);

        var unitHeight =
            dc.getFontHeight(unitFont);

        var gap = 5;

        var totalWidth =
            numberWidth +
            gap +
            unitWidth;

        var startX =
            centerX -
            totalWidth / 2;

        var numberY =
            centerY -
            numberHeight / 2;

        var unitY =
            numberY +
            numberHeight -
            unitHeight -
            32;

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            startX,
            numberY,
            numberFont,
            numberText,
            Graphics.TEXT_JUSTIFY_LEFT
        );

        dc.drawText(
            startX + numberWidth + gap,
            unitY,
            unitFont,
            unitText,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

    function drawInputOption(
        dc,
        centerX,
        centerY,
        text,
        isSelected,
        textColor
    ) {
        var font = Graphics.FONT_SMALL;
        var fontHeight = dc.getFontHeight(font);

        var bubbleWidth =
            dc.getWidth() * 57 / 100;

        var bubbleHeight =
            fontHeight + 10;

        var bubbleX =
            centerX -
            bubbleWidth / 2;

        var bubbleY =
            centerY -
            bubbleHeight / 2;

        var bubbleRadius =
            bubbleHeight / 2;

        if (isSelected) {
            dc.setColor(
                textColor,
                Graphics.COLOR_BLACK
            );

            dc.drawRoundedRectangle(
                bubbleX,
                bubbleY,
                bubbleWidth,
                bubbleHeight,
                bubbleRadius
            );
        }

        dc.setColor(
            textColor,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            centerX,
            centerY - fontHeight / 2,
            font,
            text,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );
    }

    function drawGuidance(dc, centerX, centerY) {
        var font = Graphics.FONT_XTINY;
        var fontHeight = dc.getFontHeight(font);
        var text;

        if (editMode == 0) {
            text = "UP/DN-DEP.   START-O2";
        } else if (editMode == 1) {
            text = "UP/DN-O2   START-HE";
        } else {
            text = "UP/DN-HE   START-DEP.";
        }

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            centerX,
            centerY - fontHeight / 2,
            font,
            text,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );
    }
}