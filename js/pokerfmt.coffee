---
---
suitIndex = (c) -> switch c
	when "C" then 0
	when "D" then 1
	when "H" then 2
	when "S" then 3

replacer = (dec) -> (match, rank, suit, offset, string) ->
	si = suitIndex suit
	dec.suit[si][0] + rank + "♣♢♡♠"[si] + dec.suit[si][1]

multireplacer = (dec) -> (match) ->
	cont = match.replace(/\b([A2-9TJQK]|10)([CDHS])/g, replacer(dec))
	dec.start + cont + dec.end

bbCodeDec = (size, colors) ->
	start: if size? then "[size=#{size}]" else ""
	end: if size? then "[/size]" else ""
	suit:
		colors.map((elt) ->
			if elt?
				["[color=#{elt}]", "[/color]"]
			else ["", ""])

pokerReplace = (dec, s) ->
	s.replace(/\b([A2-9TJQK]|10)[CDHS]( ([A2-9TJQK]|10)[CDHS])*\b/g, multireplacer(dec))

getColors = ->
	switch $('input:radio[name=colorgrp]:checked').val()
		when "2" then [null, "red", "red", null]
		when "4" then ["green", "blue", "red", null]
emptyDec =
	start: ""
	end: ""
	suit: for _ in [0..3]
		["",""]
getDec = ->
	switch $('input:radio[name=fmtgrp]:checked').val()
		when "none" then emptyDec
		when "bb" then bbCodeDec(null, getColors())
		when "bb150" then bbCodeDec(150, getColors())

process = (e) ->
	# bbCodeDecs(["green", "blue", "red", null])
	e.preventDefault()
	text = document.getElementById("inp").value
	dec = getDec()
	result = pokerReplace(dec, text)
	document.getElementById("out").value = result
	false

$(document).ready(->
	$("#pform").submit(process)
	$("#inp").submit(process)
	$("#out").submit(process)
	$("#fmtbutton").click(process)
)
