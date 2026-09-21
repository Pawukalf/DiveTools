using Toybox.Application;

class DiveToolsApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        var view = new DiveToolsView();

        return [
            view,
            new DiveToolsDelegate(view)
        ];
    }
}