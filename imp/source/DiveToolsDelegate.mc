using Toybox.WatchUi;

class DiveToolsDelegate
    extends WatchUi.InputDelegate {

    var view;

    function initialize(viewRef) {
        InputDelegate.initialize();

        view = viewRef;
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            view.moveSelection(-1);
            return true;
        }

        if (key == WatchUi.KEY_DOWN) {
            view.moveSelection(1);
            return true;
        }

        if (
            key == WatchUi.KEY_ENTER ||
            key == WatchUi.KEY_START
        ) {
            openSelectedTool();
            return true;
        }

        return false;
    }

    function openSelectedTool() {
        var selected =
            view.getSelection();

        if (selected == 0) {
            var modView =
                new ModView();

            WatchUi.pushView(
                modView,
                new ModDelegate(modView),
                WatchUi.SLIDE_IMMEDIATE
            );

            return;
        }

        if (selected == 1) {
            var bestMixView =
                new BestMixView();

            WatchUi.pushView(
                bestMixView,
                new BestMixDelegate(
                    bestMixView
                ),
                WatchUi.SLIDE_IMMEDIATE
            );

            return;
        }

        if (selected == 2) {
            var eadView =
                new EadView();

            WatchUi.pushView(
                eadView,
                new EadDelegate(eadView),
                WatchUi.SLIDE_IMMEDIATE
            );

            return;
        }

        if (selected == 3) {
            var endView =
                new EndView();

            WatchUi.pushView(
                endView,
                new EndDelegate(endView),
                WatchUi.SLIDE_IMMEDIATE
            );

            return;
        }
    }
}