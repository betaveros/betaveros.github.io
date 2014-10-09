---
---
precise = (n) ->
	-9007199254740992 <= n <= 9007199254740992 # 2^53

factorize = (n, negPrefix, powerFmt, times) ->
	if n == 0 then return "0"
	if n == 1 then return "1"
	retarr = []
	prefix = ""
	rt = Math.sqrt(n)
	if n < 0 then prefix = negPrefix; n = -n
	if n % 2 == 0
		mul = 0
		while n % 2 == 0 then n /= 2; mul++
		rt = Math.sqrt(n)
		retarr.push powerFmt 2, mul
	if n % 3 == 0
		mul = 0
		while n % 3 == 0 then n /= 3; mul++
		retarr.push powerFmt 3, mul
	rt = Math.sqrt(n)
	jump = 2
	i = 5
	while i <= rt
		if n % i == 0
			mul = 0
			while n % i == 0 then n /= i; mul++
			rt = Math.sqrt(n)
			retarr.push powerFmt i, mul
		i += jump
		jump = 6 - jump
	if n != 1 then retarr.push powerFmt n, 1
	prefix + retarr.join times

fancyPower = (n, p) ->
	"<strong>" + n + "</strong>" + (if p == 1 then "" else "<sup>" + p + "</sup>")

simplePower = (n, p ) ->
	"" + n + (unless p == 1 then "^" + p else "")

empty = true
factorizeFormat = (num, fancy) ->
	if isNaN(num) then return "<em>not a number</em>"
	powerFmt = if fancy then fancyPower else simplePower
	neg = if fancy then "&minus;" else "-"
	times = if fancy then " <span class='times'>&times;</span> " else " * "
	result = num + " = " + factorize(num, neg, powerFmt, times)
	unless precise num
		result = "<em>imprecise!</em> " + result
	result

process = (e) ->
	e.preventDefault()
	text = document.getElementById("inp").value
	num = parseInt text
	fancy = document.getElementById("fancy").checked
	result = factorizeFormat num, fancy
	if document.getElementById("append").checked
		unless empty then result = "<br/>" + result
		document.getElementById("out").innerHTML += result
	else
		document.getElementById("out").innerHTML = result
	empty = false
	false

$(document).ready(->
	$("#fform").submit(process)
	$("#inp").submit(process)
	$("#factorbutton").click(process)
)
