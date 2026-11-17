using Toybox.WatchUi;
using Toybox.Graphics;

class ToolView extends WatchUi.View {

    var tool;

    function initialize(toolId) {
        View.initialize();
        tool = toolId;
    }

    function onUpdate(dc) {
        var title = "";

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );

        dc.clear();

        if (tool == :mod) {
            title = "MOD";
        } else if (tool == :bestMix) {
            title = "BEST MIX";
        } else if (tool == :ead) {
            title = "EAD";
        } else if (tool == :end) {
            title = "END";
        }

        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_LARGE,
            title,
            Graphics.TEXT_JUSTIFY_CENTER |
            Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}