app = angular.module 'services', []

app.service 'sharedProperties', ->
  props = {
    start: -1,
    end: -1,
    markers: []
  }
  
  return {
    Properties: -> return props,
    setStart: (val) -> return props.start = val,
    setEnd: (val) -> return props.end = val,
    setMarkers: (val) -> return props.markers = val
  }