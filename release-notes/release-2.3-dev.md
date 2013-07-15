# Enyo 2.3-dev Release Notes

Welcome to Enyo 2.3-dev  The following items have changes since the Enyo 2.2
release. (Note that this list is not comprehensive; see the commit history in
GitHub for a complete list of changes.)

## Enyo

* This release adds support for the MVC model of app development.  This includes
    changes to properties to support bindings, computed properties, and property
    change observers; highlights are called out below.  (See our [MVC Overview]
    for details on all the new kinds and methods.)

    + Added `enyo.Application`, a new kind to include non-visible elements and
        rendered components.  It is defined in the new `Application.js` file in
        the `kernel` module.

    + Added `enyo.Router`, a new kind that acts as an application controller
        that responds to changes in the Web page URL.  This allows developers to
        modify application state on startup based on the initial URL, as well as
        track the current state by updating the URL as the application runs.
        `enyo.Router` is defined in the new `Router.js` file in the `kernel`
        module.

    + Significantly expanded `kernel` module, adding new files `Binding.js`,
        `Controller.js`, `ViewController.js`, and `dev.js` (in addition to the
        aforementioned `Application.js` and `Router.js`), along with new `data`
        submodule (with `Model`, `ModelController`, and `Collection` kinds) and
        `mixins` submodule.  Also made major additions to existing `lang.js`
        and `Object.js` files.

    + Added new `ext` module, which contains the new files `BooleanBinding.js`,
        `BooleanOnlyBinding.js`, and `InputBinding.js`, as well as `macroize.js`
        (previously found in the `kernel` module).

    + Added new file `ready.js` in the `boot` module.

    + Added `enyo.View` as an alias for `enyo.Control`.

    + Under `tools`, added unit tests for new MVC functionality.

* In `Oop.js`, changed `enyo.kind()` to delay most of its work until the kind
    is used for the first time.  This behavior is enabled by default for named
    kinds with no static members; it may be turned off by setting the kind's
    `noDefer` property to a truthy value, as is done in `enyo.Object`,
    `enyo.Component`, and `enyo.Control`.

    In a related development, kinds may now define "protected statics".  These
    are static members designed for use only within the given kind and its
    subkinds.  The presence of protected statics will not prevent the deferral
    of kind creation, whereas the presence of regular statics will.

    Finally, as a result of these modifications, in the configuration object
    passed into `enyo.kind()`, the value of the `kind` property will need to be
    quoted (e.g., `kind: "enyo.Control"`).  Previously, the quotation marks
    were optional.

* Added support for progress events during asynchronous activities.  Progress
    events are sent by `enyo.Async.sendProgress()` and handled by
    `enyo.Ajax.updateProgress()`.  Also added associated unit test.

* Added HTML5 fullscreen support to Enyo controls.  Changes include modification
    of `Control.js` and additions of `fullscreen.js` and "FullscreenSample".
    (This is temporarily disabled for webOS because it isn't working yet on the
    OS side.)

* Added support for loading framework source from embedded on-device location.

* Added new kinds `enyo.Media` and `enyo.Audio`.

* Moved code for drawers, previously in `onyx.Drawer`, into the core Enyo `ui`
    library as the new kind `enyo.Drawer`.

* Moved `focus()` and `blur()` methods from `enyo.Input` to `enyo.Control`,
    since they are generally useful for any DOM node.

* Added `enyo.design`, which is used to specify design information for the Ares
    designer tool.

* In `enyo.Object`, added new `bindSafely()` method, which acts like
    `enyo.bind()`, but handles the case in which the bound method is called
    after the object has been destroyed.  Also, in `set()` method, added
    documentation for optional `force` parameter; if true, the property whose
    value is being set will be updated (and notifications will be sent) even if
    the passed-in value is the same as the existing value.

* In `enyo.Component`, added a number of new methods:

    + `startJob()` and `stopJob()` are used to manage job methods that should be
        associated with a specific component; they are automatically stopped if
        the component is destroyed.

    + `throttleJob()` allows you to execute a method immediately and then
        prevent the method from being called again for a specified period of
        time.

    + `silence()` and `unsilence()` are used to stop and restore event
        propagation through the component.  This is useful when you're changing
        a lot of properties and want to keep observers from reacting to `changed`
        events until all of your work is complete.

* In `job.js`, added `enyo.job.throttle()`, which enables job throttling outside
    the context of a specific component.

* In `dispatcher.js`, added `enyo.dispatcher.stopListening()`, which removes
    listeners for a particular kind of event, and `enyo.unmakeBubble()`, which
    stops listening for events bubbled by `enyo.makeBubble()`.

* Renamed `phonegap.js` as `cordova.js` and added Enyo support for the
    `localechange` event supplied by cordova-webos (i.e., signals will be sent).

* In `loader.js` and `boot.js`, fixed issue causing `enyo.load()` to not wait
    until all files have loaded before calling the callback function.

* In `boot.js`, added `"charset"` to the generated script elements for Internet
    Explorer.

* Added new method `enyo.easedComplexLerp()` in `animation.js` and put it to use
    in `Animator.next()`.  The new method allows for more complex animations
    than are possible with the existing `enyo.easedLerp()`.

* In `enyo.Async`, fixed issue causing exceptions when setting properties on the
    subkind `enyo.Ajax`.  (The `constructor()` method was missing a call to
    `this.inherited(arguments)`.)

* In `enyo.Ajax`, changed `contentType` check from exact string match to regular
    expression, to allow values such as `'application/json; charset=utf-8'`.
    Also removed check for webOS platform when determining whether synchronous
    (blocking) AJAX requests are allowed.

* Added `overrideCallback` property to `enyo.JsonpRequest`, along with inline
    documentation and associated unit test.

* In `xhr.js`, fixed `request()` to only apply cache-control code to iOS 6,
    not to iOS versions greater than 6.

* In `modal.js`, updated `release()` to search for a passed-in target to
    release from the list of captured events, instead of simply releasing the
    last captured event.  This fixes an issue in which popups could close
    unexpectedly.

* In `FloatingLayer.js` and `Popup.js`, modified `enyo.FloatingLayer` so it
    recreates itself when `document.body` is wiped out by a fresh render.

* Added detection of Tizen platform in `platform.js` and made
    "TouchScrollStrategy" its default scroll strategy in `Scroller.js`.

* In `Oop.js`, fixed issue in `enyo.kind.features.push()` that could allow
    feature mixins to be run more than once, overwriting the custom subclass
    method.  Also added `enyo.kind.allowOverride` flag for use in Ares; it
    allows flagged kinds to be redefined.

* In `UiComponent.js`, modified `getBubbleTarget()` to allow events to bubble
    properly from a control to an owning component that is not a UiComponent.
    Also fixed issue in which setting the `addBefore` property could update the
    `children` array but not update the `controls` array with the same ordering.

* In `Repeater.js`, updated `decorateEvent()` to prevent index value from being
    overwritten when dealing with nested repeaters.

* In `RichText.js`, updated `valueChanged()` to prevent scroll reset on keypress.

* In `dom.js`, fixed positioning issues affecting IE8.

* In `drag.js`, reworked code for cloning events in `beginHold()`, as it was
    causing crashes in `ImageView`.
    
* In `lang.js`, fixed `enyo.getPath()` to return null if path is not defined.

* In `ready.js`, added legacy WebKit support for `enyo.ready()`.

* Fixed `enyo.Drawer` and "GestureSample" to stop propagation of animation
    events.

* In "RepeaterSample", modified `setupItem()` to stop event propagation.

* Updated samples with "no telephone number detection" and "no translation"
    meta tags.

* Removed obsolete "Playground" sample.

## Onyx

* Added new `onyx.Submenu` kind, which enables the creation of nested menus.
    Instances are meant to live alongside `onyx.MenuItem` objects within an
    `onyx.Menu`.

* Added `onyx.design`, which is used by libraries to specify their associated
    design information.  It replaces `design.js` and is discoverable via
    `package.js`. 

* Moved `onyx.Drawer` from Onyx library into Enyo core, as `enyo.Drawer`, with
    `onyx.Drawer` now aliased to `enyo.Drawer`.

* Cleaned up code for better compatibility with JSHint 2.1, which is used in
    Travis CI tests.

* Added `"es3": true` to `.jshintrc` to have JSHint detect trailing commas;
    removed trailing commas from "SubmenuSample".

* In `Popup.js`, modified `getScrimZIndex()` to ensure selection of proper
    z-index values for popups that should appear on top of other popups.

* In `ContextualPopup.js`, added ability to set `ontap` handlers for the action
    buttons.
 
* In `Menu.js`, added support for specifying a menu's scroll strategy.
 
* Tweaked the `Button`, `IconButton`, and `Slider` controls to work better on
    FirefoxOS.

* In `DatePicker.js`, fixed issue causing DatePicker controls to be unusable
    inside a Repeater.

* In `IntegerPicker.js`, fixed max/min validation in `valueChanged()`.

* In `MoreToolbar.js`, fixed issue that could cause a crash when resizing a
    window.

* Updated samples with "no telephone number detection" and "no translation" meta
    tags.

## Layout

* Added new `flex` layout module, based on CSS Flexible Box Model.

* Added several new layout-related kinds:

    + `enyo.ContextualLayout`, a layout strategy intended for use in a popup in
        a decorator/activator scenario, where the popup is positioned relative
        to the activating control

    + `enyo.FittableHeaderLayout`, a subkind of `enyo.FittableColumnsLayout` in
        which items are laid out in a set of naturally-sized vertical columns,
        with one column designated to expand horizontally to fill any leftover
        space

    + `enyo.GridList`, which extends `enyo.List` to display items in a grid
        pattern, with multiple items per row based on the available container
        width

    + `enyo.GridListImageItem`, a convenience component that may be used inside
        an `enyo.GridList` to display an image grid

    + `enyo.GridFlyweightRepeater`, which extends `enyo.FlyweightRepeater` to
        display items in a grid pattern

* In `enyo.List`, added support for horizontal layouts; also removed
    unnecessary call to `inEvent.preventDefault()`.

* Added `layout.design`, which contains information on the layouts available in
    the Layout library; it replaces `design.js` and is loaded by default.

* In `enyo.Panels`, added method `selectPanelByName()`, which selects a pane
    based on its name instead of its index.  Also fixed `removeControl()` to
    correctly update the active panel if you remove the one that's currently
    selected, as well as addressing issue causing problems with panel transition
    animations.

* Modified `enyo.Arranger` to allow panels to opt out of acceleration/transform
    on a per-instance basis.

* In `FittableLayout.css`, added special case for tables in a
    FittableColumnsLayout.  Also added special case for locales with
    right-to-left text alignment.

* Updated samples with "no telephone number detection" and "no translation"
    meta tags.

## Globalization/Localization

* Fixed `deploy.sh` to not create duplicate subdirectories.

## Bootplate

* Introduced new `bootplate-mvc` repo, an application template using the new
    MVC pattern.

* In `deploy.sh`, fixed issue causing problems when development path name
    contains whitespace.

* In `.gitmodules`, replaced absolute URL paths to github.com with relative
    paths to allowing forking of the project.

## Samples

* In `sampler` repo's `.gitmodules` file, replaced absolute URL paths to
    github.com with relative paths to allowing forking of the project.

* In Sampler app's `App.js` file, added platform checks for improved
    compatibility with Windows 8 and Windows Phone 8.  Also made fix to not
    clobber existing namespaces.

* In "ButtonSample", modified sample control to use `.png` file instead of
    `.ico` file for improved compatibility with Windows Phone 8 browser.

* In "PlatformSample", modified `updateWindowSize()` for improved compatibility
    with IE8.

* Fixed "ListPulldownSample" to work properly as a Windows 8 application.

* In "RepeaterSample", revised `setupItem()` to stop event propagation.

* In "ContextualPopupSample", fixed double-inclusion of Onyx source.

* Revised "PopupSample" to test fix for unexpected dismissal of popups.

## Tools

* Added `.jshintrc` files to the root folder of most repos; these are now used
    when writing new code and validating old code.

* Added support for Travis CI continuous integration system, which uses JSHint
    and PhantomJS to run tests on repos after each commit.

* Updated minifier support in Enyo to use `less 1.3.3` and `uglify-js 2.2.5`.
    Flag tweaks should result in ~5% reduction in gzipped-file size.  If you
    need to debug the minified logic, use the `--beautify` switch on the
    minifier to have it pretty-print the compacted code.

## Known Issues and Limitations

### Windows 8

Developers should be aware of the possibility for unexpected behavior related to
Windows 8's lack of support for JSONP and the fact that the Bootplate app must
be in its minified state to run properly on this platform.

### Windows Phone 8

While compatibility with Windows Phone 8 has been improved over previous
Enyo releases, we have encountered some notable (non-Enyo-related) obstacles
while developing for this platform.  Specifically:

* Debugging is difficult.  There is no `console.log()` for Visual Studio Express
    for Windows Phone 8.  To do logging, you must pass console messages from
    your JavaScript to a C# function that then produces output.  In addition, we
    sometimes received unexpected log data for things like objects.

* App caching can be a hindrance.  When you make a code change and redeploy your
    app, you won't always see new results from the app.  In order to see the
    results of our code changes, we have sometimes had to quit and restart
    Visual Studio, create a new project, or reboot a device.

* The viewport is somewhat odd, in that you can move your app around.  Setting
    specific pixel dimensions for the viewport and setting
    `-ms-touch-action: none;` (which is done in the `enyo-no-touch-action`
    class) seem to aid usability.

### Kindle Fire HD

We have noticed several issues with how swipeable/reorderable lists are handled
by the Web browser on Kindle Fire HD.  Currently, this browser lacks a mode in
which it can be full-screen without reacting to scrolls that cause the URL bar
to be shown or hidden.  As a result, operations that involve dragging often
fail.  This may be addressed by Amazon in a future browser update.