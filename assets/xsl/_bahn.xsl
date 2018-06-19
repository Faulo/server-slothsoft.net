<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/data">
		<html>
			<head>
				<title>Bahn Suchmaschine</title>
				<style type="text/css"><![CDATA[
table.Journeys {
	border-spacing: 5px;
	background-color: lightyellow;
}
table.Journeys  tr {
}
table.Journeys  thead th[data-index] {
	cursor:n-resize;
}
table.Journeys  thead th[data-index]:hover {
	background-color: lightblue;
}
table.Journeys  th {
	padding: 4px 8px;
	font-size: 120%;
}
table.Journeys  td {
	text-align: center;
	padding: 2px 5px;
	font-family: serif;
	font-weight: bold;
}
[data-price] {
	font-family: monospace;
}
[data-rating] {
	text-shadow: 0px 0px 4px lightblue;
}
[data-rating="1"] {
	background-color: rgb(129, 249, 120);
}
[data-rating="2"] {
	background-color: rgb(199, 234, 99);
}
[data-rating="3"] {
	background-color: rgb(240, 241, 103);
}
[data-rating="4"] {
	background-color: rgb(245, 193, 111);
}
[data-rating="5"] {
	background-color: rgb(250, 149, 116);
}
[data-rating="6"] {
	background-color: rgb(255, 123, 123);
}
				]]></style>
				<script type="application/javascript"><![CDATA[
var Bahn = {

	load : function(eve) {

		var Journeys = document.getElementsByClassName("Journeys"),

			i, j, k, l, head, ele;

		for (i = 0, j = Journeys.length; i < j; i++) {

			head = Journeys[i].tHead.getElementsByTagName("th");

			for (k = 0, l = head.length; k < l; k++) {

				ele = head[k];

				ele.addEventListener("click", Bahn.sortTable, false);

			}

		}

		head = document.getElementsByTagName("form")[0];

		for (i in Bahn.formEvents) {

			if (head[i].addEventListener) {

				if (head[i].type == "submit") {

					head[i].addEventListener("click", Bahn.formEvents[i], false);

				} else {

					head[i].addEventListener("input", Bahn.formEvents[i], false);

				}

			} else {

				for (k = 0, l = head[i].length; k < l; k++) {

					head[i][k].addEventListener("input", Bahn.formEvents[i], false);

				}

			}

		}

	},

	formEvents : {

		"form/start/date" : function(eve) {

			var ele = this.form["form/end/date"];

			if (ele.value < this.value) {

				ele.value = this.value;

			}

		},

		"form/end/date" : function(eve) {

			var ele = this.form["form/start/date"];

			if (ele.value > this.value) {

				ele.value = this.value;

			}

		},
/*
		"form/station/start" : function(eve) {

			var i, j, list1 = this.form["form/station/start"], list2 = this.form["form/station/end"];

			for (i = 0, j = list1.length; i < j; i++) {

				if (!list1[i].checked) {

					list2[i].checked = "checked";

				}

			}

		},

		"form/station/end" : function(eve) {

			var i, j, list1 = this.form["form/station/end"], list2 = this.form["form/station/start"];

			for (i = 0, j = list1.length; i < j; i++) {

				if (!list1[i].checked) {

					list2[i].checked = "checked";

				}

			}

		},
*/
		"form/submit/bahn" : function(eve) {

			document.body.setAttribute("style", "cursor: wait");

		}

	},

	sortTable : function(eve) {

		var table = this.parentNode.parentNode.parentNode,

			index = this.cellIndex,

			i, j, k, l, sort_i, tbody, ele, row, rows = [], rows_i = [], rows_sort = {}, arr = [];

		if (this.hasAttribute("data-index"))

			index = parseInt(this.getAttribute("data-index"));

		tbody = table.tBodies.item(0);

		for (i = 0, j = tbody.rows.length; i < j; i++) {

			row = tbody.rows[i];

			ele = row.cells[index];

			sort_i = undefined;

			if (ele.hasAttribute("data-sort")) {

				sort_i = ele.getAttribute("data-sort");

			} else  if (ele.hasAttribute("data-rating")) {

				sort_i = ele.getAttribute("data-rating");

			}

			if (sort_i) {				

				sort_i = parseInt(sort_i);

				if (sort_i === -1) {

					sort_i = parseInt(row.cells[index+1].getAttribute("data-sort"));

				}

				rows.push(row);

				rows_i.push(sort_i);

				rows_sort[sort_i] = sort_i;

			}

			

		}		

		for (i in rows_sort) {

			arr.push(parseInt(i));

		}

		rows_sort = arr;

		rows_sort.sort(Bahn.sortNumbers);

		for (i = 0, j = rows_sort.length; i < j; i++) {

			sort_i = rows_sort[i];

			for (k = 0, l = rows_i.length; k < l; k++) {

				if (sort_i === rows_i[k]) {

					tbody.appendChild(rows[k]);

				}

			}			

		}

	},

	sortNumbers : function (a,b) {

		return a - b;

	}

};



window.addEventListener("load", Bahn.load, false);


				]]></script>
			</head>
			<body>
				<form action="." method="GET">			
					<fieldset>
						<legend>Ort</legend>
						<dl>
							<dt>Startort</dt>
							<dd>					
								<ul>
									<li tm_list="repeat">
										<label>
											##stations/name##
											<input tm_cond="if:##form/station/start##" type="radio" name="form/station/start" value="##stations/id##" checked="checked"/>
											<input tm_cond="else" type="radio" name="form/station/start" value="##stations/id##"/>
										</label>
									</li>
								</ul>
							</dd>
							<dt>Zielort</dt>
							<dd>					
								<ul>
									<li tm_list="repeat">
										<label>
											##stations/name##
											<input tm_cond="if:##form/station/end##" type="radio" name="form/station/end" value="##stations/id##" checked="checked"/>
											<input tm_cond="else" type="radio" name="form/station/end" value="##stations/id##"/>
										</label>
									</li>
								</ul>
							</dd>
						</dl>
					</fieldset>
					<fieldset>
						<legend>Datum</legend>
						<dl>
							<dt>
								Früheste Hinfahrt
							</dt>
							<dd>
								<label>
									Datum
									<input type="date" name="form/start/date" value="##there/date##"/>
								</label>
								<label>
									Abfahrt
									<input type="time" name="form/start/time" value="##there/time##" step="3600"/>
								</label>
							</dd>
							<dt>
								Späteste Rückfahrt
							</dt>
							<dd>
								<label>
									Datum
									<input type="date" name="form/end/date" value="##back/date##"/>
								</label>
								<label>
									Ankuft
									<input type="time" name="form/end/time" value="##back/time##" step="3600"/>
								</label>
							</dd>
						</dl>					
					</fieldset>		
					<fieldset>
						<legend>Senden</legend>
						<label>
							Aus Cache laden, wenn möglich
							<input type="checkbox" value="1" name="form/cache" checked="checked"/>
						</label>
						<input type="submit" value="Fahrten ermitteln" name="form/submit/bahn"/>
					</fieldset>			
				</form>
				
				<div tm_cond="if:##show/request##">
					<h1>Hinfahrt</h1>
					<h2>##there/date## ##there/time##</h2>
					<table class="Journeys">
						<thead>
							<tr>
								<th data-index="0">
									Spar-Preis
								</th>
								<th data-index="1">
									Normaler Preis
								</th>							
								<th data-index="2">
									Dauer
								</th>
								<th data-index="3">
									Umsteigen
								</th>
								
								<th colspan="2" data-index="4">Abfahrt</th>
								<th colspan="2" data-index="6">Ankunft</th>							
								<th data-index="8">
									Züge
								</th>
								<th>Link</th>
							</tr>
						</thead>
						<tbody>
							<tr tm_list="repeat">
								<td data-rating="##journeys/there/rating/cheapPrice##" data-sort="##journeys/there/data/cheapPrice##">
									##journeys/there/cheapPrice##
								</td>
								<td data-rating="##journeys/there/rating/normalPrice##" data-sort="##journeys/there/data/normalPrice##">
									##journeys/there/normalPrice##
								</td>
									
								<td data-rating="##journeys/there/rating/duration##" data-sort="##journeys/there/data/duration##">
									##journeys/there/duration##
								</td>
								<td data-rating="##journeys/there/rating/changes##" data-sort="##journeys/there/data/changes##">
									##journeys/there/changes##
								</td>								
								<td data-rating="##journeys/there/rating/departure##" data-sort="##journeys/there/departure/data/datetime##">
									##journeys/there/departure/date##
								</td>
								<td data-rating="##journeys/there/rating/departure##">
									##journeys/there/departure/time##
								</td>
								<td data-rating="##journeys/there/rating/departure##" data-sort="##journeys/there/arrival/data/datetime##">
									##journeys/there/arrival/date##
								</td>								
								<td data-rating="##journeys/there/rating/departure##">
									##journeys/there/arrival/time##
								</td>
								<td data-rating="##journeys/there/rating/products##">
									##journeys/there/products##
								</td>
								<td>
									##journeys/there/details##
								</td>
							</tr>
						</tbody>
					</table>
				
					<h1>Rückfahrt</h1>
					<h2>##back/date## ##back/time##</h2>
				
					<table class="Journeys">
						<thead>
							<tr>
								<th data-index="0">
									Spar-Preis
								</th>
								<th data-index="1">
									Normaler Preis
								</th>							
								<th data-index="2">
									Dauer
								</th>
								<th data-index="3">
									Umsteigen
								</th>
								
								<th colspan="2" data-index="4">Abfahrt</th>
								<th colspan="2" data-index="6">Ankunft</th>							
								<th data-index="8">
									Züge
								</th>
								<th>Link</th>
							</tr>
						</thead>
						<tbody>
							<tr tm_list="repeat">
								<td data-rating="##journeys/back/rating/cheapPrice##" data-sort="##journeys/back/data/cheapPrice##">
									##journeys/back/cheapPrice##
								</td>
								<td data-rating="##journeys/back/rating/normalPrice##" data-sort="##journeys/back/data/normalPrice##">
									##journeys/back/normalPrice##
								</td>
									
								<td data-rating="##journeys/back/rating/duration##" data-sort="##journeys/back/data/duration##">
									##journeys/back/duration##
								</td>
								<td data-rating="##journeys/back/rating/changes##" data-sort="##journeys/back/data/changes##">
									##journeys/back/changes##
								</td>								
								<td data-rating="##journeys/back/rating/arrival##" data-sort="##journeys/back/departure/data/datetime##">
									##journeys/back/departure/date##
								</td>
								<td data-rating="##journeys/back/rating/arrival##">
									##journeys/back/departure/time##
								</td>
								<td data-rating="##journeys/back/rating/arrival##" data-sort="##journeys/back/arrival/data/datetime##">
									##journeys/back/arrival/date##
								</td>								
								<td data-rating="##journeys/back/rating/arrival##">
									##journeys/back/arrival/time##
								</td>
								<td data-rating="##journeys/back/rating/products##">
									##journeys/back/products##
								</td>
								<td>
									##journeys/back/details##
								</td>
							</tr>
						</tbody>
					</table>
				</div>		
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>