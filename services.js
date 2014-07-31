// Generated by CoffeeScript 1.5.0
(function() {
  var app;

  app = angular.module('services', []);

  app.service('sharedProperties', function() {
    var props;
    props = {
      route: {
        start: -1,
        end: -1
      },
      markers: [],
      panorama: {}
    };
    return {
      Properties: function() {
        return props;
      },
      setStart: function(val) {
        return props.route.start = val;
      },
      setEnd: function(val) {
        return props.route.end = val;
      },
      setMarkers: function(val) {
        return props.markers = val;
      },
      setPanorama: function(val) {
        return props.panorama = val.getGMap().getStreetView();
      }
    };
  });

  app.service('markerService', function() {
    return {
      setMarkerStatus: function(marker, status) {
        if (marker == null) {

        } else {
          marker.status = status;
          if (status === 'focused') {
            marker.showWindow = true;
          }
          if (status !== 'focused') {
            marker.prevIcon = "/states/" + status + ".png";
          }
          return marker.icon = "/states/" + status + ".png";
        }
      },
      setMarkerDefault: function(marker) {
        marker.showWindow = false;
        return marker.icon = marker.prevIcon;
      }
    };
  });

}).call(this);
