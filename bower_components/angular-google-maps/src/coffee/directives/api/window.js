// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module("google-maps.directives.api").factory("Window", [
  "IWindow", "GmapUtil", "WindowChildModel", "$q", function(IWindow, GmapUtil, WindowChildModel, $q) {
    var Window;
    return Window = (function(_super) {
      __extends(Window, _super);

      Window.include(GmapUtil);

      function Window($timeout, $compile, $http, $templateCache) {
        this.init = __bind(this.init, this);
        this.link = __bind(this.link, this);
        var self;
        Window.__super__.constructor.call(this, $timeout, $compile, $http, $templateCache);
        self = this;
        this.require = ['^googleMap', '^?marker'];
        this.template = '<span class="angular-google-maps-window" ng-transclude></span>';
        this.$log.info(self);
      }

      Window.prototype.link = function(scope, element, attrs, ctrls) {
        var mapScope;
        mapScope = ctrls[0].getScope();
        return mapScope.deferred.promise.then((function(_this) {
          return function(mapCtrl) {
            var isIconVisibleOnClick, markerCtrl, markerScope;
            isIconVisibleOnClick = true;
            if (angular.isDefined(attrs.isiconvisibleonclick)) {
              isIconVisibleOnClick = scope.isIconVisibleOnClick;
            }
            markerCtrl = ctrls.length > 1 && (ctrls[1] != null) ? ctrls[1] : void 0;
            if (!markerCtrl) {
              _this.init(scope, element, isIconVisibleOnClick, mapCtrl);
              return;
            }
            markerScope = markerCtrl.getScope();
            return markerScope.deferred.promise.then(function() {
              return _this.init(scope, element, isIconVisibleOnClick, mapCtrl, markerScope);
            });
          };
        })(this));
      };

      Window.prototype.init = function(scope, element, isIconVisibleOnClick, mapCtrl, markerScope) {
        var defaults, gMarker, hasScopeCoords, opts, window;
        defaults = scope.options != null ? scope.options : {};
        hasScopeCoords = (scope != null) && this.validateCoords(scope.coords);
        if (markerScope != null) {
          gMarker = markerScope.gMarker;
          markerScope.$watch('coords', (function(_this) {
            return function(newValue, oldValue) {
              if ((markerScope.gMarker != null) && !window.markerCtrl) {
                window.markerCtrl = markerScope.gMarker;
                window.handleClick(true);
              }
              if (!_this.validateCoords(newValue)) {
                return window.hideWindow();
              }
              if (!angular.equals(newValue, oldValue)) {
                return window.getLatestPosition(_this.getCoords(newValue));
              }
            };
          })(this), true);
        }
        opts = hasScopeCoords ? this.createWindowOptions(gMarker, scope, element.html(), defaults) : defaults;
        if (mapCtrl != null) {
          window = new WindowChildModel({}, scope, opts, isIconVisibleOnClick, mapCtrl, gMarker, element);
        }
        scope.$on("$destroy", (function(_this) {
          return function() {
            return window != null ? window.destroy() : void 0;
          };
        })(this));
        if ((this.onChildCreation != null) && (window != null)) {
          return this.onChildCreation(window);
        }
      };

      return Window;

    })(IWindow);
  }
]);