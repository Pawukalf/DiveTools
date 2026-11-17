using Toybox.WatchUi;
using Toybox.Graphics;

class ModView extends WatchUi.View {
    var oxygen;
    var ppo2;

    function initialize() {
        View.initialize();
        oxygen = 32;
        ppo2 = 1.4;
    }

    function increaseOxygen() {
        oxygen = oxygen + 1;
        if (oxygen > 100) {
            oxygen = 100;
        }
        WatchUi.requestUpdate();
    }

    function decreaseOxygen() {
        oxygen = oxygen - 1;
        if (oxygen < 1) {
            oxygen = 1;
        }
        WatchUi.requestUpdate();
    }

    function togglePpo2() {
        if (ppo2 < 1.5) {
            ppo2 = 1.6;
        } else {
            ppo2 = 1.4;
        }
        WatchUi.requestUpdate();
    }

    function calculateMod() {
        var oxygenFraction = oxygen.toFloat() / 100.0;
        return ((ppo2 / oxygenFraction) - 1.0) * 33.0;
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var mod = calculateMod();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        drawMix(dc, width / 2, height * 20 / 100);
        drawModWithUnit(dc, width / 2, height * 44 / 100, mod);
        drawPpo2Bubble(dc, width / 2, height * 70 / 100);
        drawGuidance(dc, width / 2, height * 86 / 100);
    }

    function drawMix(dc, centerX, centerY) {
        var font = Graphics.FONT_LARGE;
        var fontHeight = dc.getFontHeight(font);
        var mixText = "O2% " + oxygen.format("%d");

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - fontHeight / 2, font, mixText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawModWithUnit(dc, centerX, centerY, mod) {
        var numberFont = Graphics.FONT_NUMBER_HOT;
        var unitFont = Graphics.FONT_MEDIUM;
        var numberText = mod.format("%.0f");
        var unitText = "ft";
        var numberWidth = dc.getTextWidthInPixels(numberText, numberFont);
        var unitWidth = dc.getTextWidthInPixels(unitText, unitFont);
        var numberHeight = dc.getFontHeight(numberFont);
        var unitHeight = dc.getFontHeight(unitFont);
        var gap = 5;
        var totalWidth = numberWidth + gap + unitWidth;
        var startX = centerX - totalWidth / 2;
        var numberY = centerY - numberHeight / 2;
        var unitY = numberY + numberHeight - unitHeight - 18 - unitHeight / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(startX, numberY, numberFont, numberText, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(startX + numberWidth + gap, unitY, unitFont, unitText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawPpo2Bubble(dc, centerX, centerY) {
        var font = Graphics.FONT_SMALL;
        var fontHeight = dc.getFontHeight(font);
        var bubbleWidth = dc.getWidth() * 52 / 100;
        var bubbleHeight = fontHeight + 18;
        var bubbleX = centerX - bubbleWidth / 2;
        var bubbleY = centerY - bubbleHeight / 2;
        var bubbleRadius = bubbleHeight / 2;
        var ppo2Text = "PPO2  " + ppo2.format("%.1f");

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawRoundedRectangle(bubbleX, bubbleY, bubbleWidth, bubbleHeight, bubbleRadius);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - fontHeight / 2, font, ppo2Text, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    }

    function drawGuidance(dc, centerX, centerY) {
        var font = Graphics.FONT_XTINY;
        var fontHeight = dc.getFontHeight(font);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - fontHeight / 2, font, "UP/DN-O2   START-PPO2", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    }
}
