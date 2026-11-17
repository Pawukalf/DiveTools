using Toybox.WatchUi;

class EadDelegate extends WatchUi.InputDelegate {

    var view;

    function initialize(viewRef) {
        InputDelegate.initialize();

        view = viewRef;
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            view.increaseValue();
            return true;
        }

        if (key == WatchUi.KEY_DOWN) {
            view.decreaseValue();
            return true;
        }

        if (
            key == WatchUi.KEY_ENTER ||
            key == WatchUi.KEY_START
        ) {
            view.toggleEditMode();
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