using Toybox.WatchUi;

class DiveToolsMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        WatchUi.pushView(
            new ToolView(item),
            null,
            WatchUi.SLIDE_IMMEDIATE
        );
    }
}