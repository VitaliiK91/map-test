class Marker
  constructor: (@id, @latitude, @longitude) ->
    @start = null
	@end = null
	@icon = "http://mapicons.nicolasmollet.com/wp-content/uploads/mapicons/shape-default/color-66c547/shapecolor-light/shadow-1/border-white/symbolstyle-dark/symbolshadowstyle-no/gradient-no/bridge_old.png"
	@showWindow = false