---
layout: default
category: code
title: Factorize
extrajs: factorize
extracss: factorize
---
A basic JavaScript factorizer. Warning: it uses extremely dumb trial division, so numbers with large prime factors will quite likely hang your browser, and big numbers will overflow or lose precision. If you want to factor the big fish, use <a href="http://www.alpertron.com.ar/ECM.HTM">Alpertron's ECM applet</a>.

Reimplemented from betaveros.stash to check out:

- CoffeeScript, and its Jekyll bindings
- Bootstrap form styling
- the right way to bind JavaScript things to forms
- HTML labeled checkboxes

<div class="panel panel-default"><div class="panel-body">
<form role="form" name="fform" id="fform" class="form-inline">
<div class="form-group">
<input type="text" id="inp" name="inp" value="" class="form-control"/>
<button id="factorbutton" type="button" class="btn btn-primary">factor!</button>
</div>
<div class="form-group">
<label><input type="checkbox" id="append" name="append"/> append?</label>
</div>
<label><input type="checkbox" id="fancy" name="fancy" checked="1"/> fancy?</label>
</form>
<div id="out"></div>
</div>
</div>
