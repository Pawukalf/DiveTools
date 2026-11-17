using Toybox.WatchUi;
using Toybox.Graphics;

class BestMixView extends WatchUi.View {
    var depth;
    var ppo2;

    function initialize() {
        View.initialize();
        depth = 100;
        ppo2 = 1.4;
    }

    function increaseDepth() {
        depth = depth + 1;
        if (depth > 500) {
            depth = 500;
        }
        WatchUi.requestUpdate();
    }

    function decreaseDepth() {
        depth = depth - 1;
        if (depth < 1) {
            depth = 1;
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

    function calculateBestMix() {
        var ambientPressure = depth.toFloat() / 33.0 + 1.0;
        var oxygenFraction = ppo2 / ambientPressure;
        var oxygenPercent = oxygenFraction * 100.0;
        var bestMix = oxygenPercent.toNumber();

        if (bestMix < 1) {
            bestMix = 1;
        }
        if (bestMix > 100) {
            bestMix = 100;
        }
        return bestMix;
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        drawDepth(dc, width / 2, height * 19 / 100);
        drawBestMix(dc, width / 2, height * 44 / 100);
        drawPpo2Bubble(dc, width / 2, height * 69 / 100);
        drawGuidance(dc, width / 2, height * 82 / 100);
    }

    function drawDepth(dc, centerX, centerY) {
        var numberFont = Graphics.FONT_NUMBER_MEDIUM;
        var unitFont = Graphics.FONT_MEDIUM;
        var numberText = depth.format("%d");
        var unitText = "ft";
        var numberWidth = dc.getTextWidthInPixels(numberText, numberFont);
        var unitWidth = dc.getTextWidthInPixels(unitText, unitFont);
        var numberHeight = dc.getFontHeight(numberFont);
        var unitHeight = dc.getFontHeight(unitFont);
        var gap = 4;
        var totalWidth = numberWidth + gap + unitWidth;
        var startX = centerX - totalWidth / 2;
        var numberY = centerY - numberHeight / 2;
        var unitY = numberY + numberHeight - unitHeight - 32;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(startX, numberY, numberFont, numberText, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(startX + numberWidth + gap, unitY, unitFont, unitText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawBestMix(dc, centerX, centerY) {
        var labelFont = Graphics.FONT_LARGE;
        var numberFont = Graphics.FONT_NUMBER_HOT;
        var labelText = "O2% ";
        var numberText = calculateBestMix().format("%d");
        var labelWidth = dc.getTextWidthInPixels(labelText, labelFont);
        var numberWidth = dc.getTextWidthInPixels(numberText, numberFont);
        var labelHeight = dc.getFontHeight(labelFont);
        var numberHeight = dc.getFontHeight(numberFont);
        var gap = 7;
        var totalWidth = labelWidth + gap + numberWidth;
        var startX = centerX - totalWidth / 2;
        var numberY = centerY - numberHeight / 2;
        var labelY = numberY + numberHeight - labelHeight - 37;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(startX, labelY, labelFont, labelText, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(startX + labelWidth + gap, numberY, numberFont, numberText, Graphics.TEXT_JUSTIFY_LEFT);
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
        dc.drawText(centerX, centerY - fontHeight / 2, font, "UP/DN-DEPTH   START-PPO2", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    }
}
