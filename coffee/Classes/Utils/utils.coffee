Date::yyyymmdd = () ->
	dateStamp = [@getFullYear(), (@getMonth() + 1), @getDate()].join("-")
	RE_findSingleDigits = /\b(\d)\b/g

	# Places a `0` in front of single digit numbers.
	dateStamp = dateStamp.replace( RE_findSingleDigits, "0$1" )
	dateStamp.replace /\s/g, ""
	dateStamp

Date::yyyymmddh = () ->

	dateStamp = [@yyyymmdd(), @getHours()].join("-")
	RE_findSingleDigits = /\b(\d)\b/g

	# Places a `0` in front of single digit numbers.
	dateStamp = dateStamp.replace( RE_findSingleDigits, "0$1" )
	dateStamp.replace /\s/g, ""
	dateStamp

Date::yyyymmddhm = () ->

	dateStamp = [@yyyymmdd(), @getHours(), @getMinutes()].join("-")
	RE_findSingleDigits = /\b(\d)\b/g

	# Places a `0` in front of single digit numbers.
	dateStamp = dateStamp.replace( RE_findSingleDigits, "0$1" )
	dateStamp.replace /\s/g, ""
	dateStamp

Number::toRadians = () ->
    this * Math.PI / 180

