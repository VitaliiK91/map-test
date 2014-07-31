app = angular.module 'services', []

app.service 'sharedProperties', ->
  props = {
    route: { start: -1, end: -1 },
    markers: [],
    panorama: {}
  }
  
  return {
    Properties: -> return props,
    setStart: (val) -> return props.route.start = val,
    setEnd: (val) -> return props.route.end = val,
    setMarkers: (val) -> return props.markers = val,
    setPanorama: (val) -> return props.panorama = val
  }
