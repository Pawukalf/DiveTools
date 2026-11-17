using Toybox.WatchUi;

class BestMixDelegate
    extends WatchUi.InputDelegate {

    var view;

    function initialize(viewRef) {
        InputDelegate.initialize();
        view = viewRef;
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            view.increaseDepth();
            return true;
        }

        if (key == WatchUi.KEY_DOWN) {
            view.decreaseDepth();
            return true;
        }

        if (
            key == WatchUi.KEY_ENTER ||
            key == WatchUi.KEY_START
        ) {
            view.togglePpo2();
            return true;
        }

        if (key == WatchUi.KEY_ESC) {
            WatchUi.popView(
                WatchUi.SLIDE_IMMEDIATE
            );

            return true;
        }

        return false;
    }
}