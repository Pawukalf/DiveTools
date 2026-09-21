using Toybox.WatchUi;
using Toybox.Graphics;

class EadView extends WatchUi.View {

    var depth;
    var oxygen;
    var editMode;

    function initialize() {
        View.initialize();

        depth = 30;
        oxygen = 32;

        // 0 = adjust depth
        // 1 = adjust oxygen
        editMode = 0;
    }

    function increaseValue() {
        if (editMode == 0) {
            depth = depth + 1;

            if (depth > 100) {
                depth = 100;
            }
        } else {
            oxygen = oxygen + 1;

            if (oxygen > 100) {
                oxygen = 100;
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
        } else {
            oxygen = oxygen - 1;

            if (oxygen < 1) {
                oxygen = 1;
            }
        }

        WatchUi.requestUpdate();
    }

    function toggleEditMode() {
        if (editMode == 0) {
            editMode = 1;
        } else {
            editMode = 0;
        }

        WatchUi.requestUpdate();
    }

    function calculateEad() {
        var oxygenFraction =
            oxygen.toFloat() / 100.0;

        var nitrogenFraction =
            1.0 - oxygenFraction;

        var ead =
            ((nitrogenFraction / 0.79) *
            (depth.toFloat() + 10.0)) -
            10.0;

        if (ead < 0.0) {
            ead = 0.0;
        }

        return ead;
    }

    function calculatePpo2() {
        var oxygenFraction =
            oxygen.toFloat() / 100.0;

        var ambientPressure =
            depth.toFloat() / 10.0 + 1.0;

        return oxygenFraction * ambientPressure;
    }

    function getOxygenColor() {
        var currentPpo2 =
            calculatePpo2();

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

        drawEadTitle(
            dc,
            width / 2,
            height * 16 / 100
        );

        drawEadResult(
            dc,
            width / 2,
            height * 34 / 100
        );

        drawInputOption(
            dc,
            width / 2,
            height * 61 / 100,
            "O2% " + oxygen.format("%d") + "%",
            editMode == 1,
            getOxygenColor()
        );

        drawInputOption(
            dc,
            width / 2,
            height * 73 / 100,
            "DEPTH " + depth.format("%d") + "m",
            editMode == 0,
            Graphics.COLOR_WHITE
        );

        drawGuidance(
            dc,
            width / 2,
            height * 86 / 100
        );
    }

    function drawEadTitle(dc, centerX, centerY) {
        var font =
            Graphics.FONT_LARGE;

        var fontHeight =
            dc.getFontHeight(font);

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            centerX,
            centerY - fontHeight / 2,
            font,
            "EAD",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawEadResult(dc, centerX, centerY) {
        var numberFont =
            Graphics.FONT_NUMBER_HOT;

        var unitFont =
            Graphics.FONT_MEDIUM;

        var numberText =
            calculateEad().format("%.1f");

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
        var font =
            Graphics.FONT_SMALL;

        var fontHeight =
            dc.getFontHeight(font);

        var bubbleWidth =
            dc.getWidth() * 55 / 100;

        var bubbleHeight =
            fontHeight + 14;

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
        var font =
            Graphics.FONT_XTINY;

        var fontHeight =
            dc.getFontHeight(font);

        var text;

        if (editMode == 0) {
            text = "UP/DN-DEPTH   START-O2";
        } else {
            text = "UP/DN-O2   START-DEPTH";
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