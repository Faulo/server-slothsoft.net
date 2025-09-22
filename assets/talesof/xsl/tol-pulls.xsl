<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/data">
		<script type="application/javascript"><![CDATA[
var PullEditor = {
	submit : function(formNode) {
		try {
			formNode.outThrees.value = "?";
			formNode.outFours.value = "?";
			formNode.outFives.value = "?";
			
			window.setTimeout(
				() => {
					PullEditor.generate(formNode);
				},
				0
			);
		} catch(e) {
			alert(e);
		}
		return false;
	},
	generate : function(formNode) {
		try {
			let config = {};
			config.tryouts = 100000;
			config.probabilities = [
				parseInt(formNode.probThrees.value),
				parseInt(formNode.probFours.value),
				parseInt(formNode.probFives.value),
			];
			config.max = 0;
			config.max += config.probabilities[0];
			config.max += config.probabilities[1];
			config.max += config.probabilities[2];
			config.guarantees = [
				formNode.guarantee.value === "three",
				formNode.guarantee.value === "four",
				formNode.guarantee.value === "five",
			];
			config.pulls = formNode.pulls.value;
			
			let result = this.generatePulls(config);
			
			formNode.outThrees.value = result[0].toFixed(2);
			formNode.outFours.value = result[1].toFixed(2);
			formNode.outFives.value = result[2].toFixed(2);
		} catch(e) {
			alert(e);
		}
		return false;
	},
	generatePulls : function(config) {
		let ret = this.generateResult();
		for (let i = 0; i < config.tryouts; i++) {
			let result;
			do {
				result = this.generatePull(config);
			} while (result === false);
			
			for (let j = 0; j < result.length; j++) {
				ret[j] += result[j] / config.tryouts;
			}
		}
		
		return ret;
	},
	generatePull : function(config) {
		let ret = this.generateResult();
		
		for (let pull = 0; pull < config.pulls; pull++) {
			let val = this.generateNumber(config.max);
			for (let i = 0; i < config.probabilities.length; i++) {
				if (val < config.probabilities[i]) {
					ret[i]++;
					break;
				} else {
					val -= config.probabilities[i];
				}
			}
		}
		
		let guaranteeCheck = true;
		for (let i = 0; i < config.guarantees.length; i++) {
			if (config.guarantees[i]) {
				guaranteeCheck = false;
				for (let j = i; j < ret.length; j++) {
					if (ret[j] > 0) {
						guaranteeCheck = true;
						break;
					}
				}
				if (!guaranteeCheck) {
					break;
				}
			}
		}
		
		return guaranteeCheck
			? ret
			: false;
	},
	generateNumber : function(max) {
		return Math.random() * max;
	},
	generateResult : function() {
		return [0, 0, 0];
	},
};
		]]></script>
		<article class="PullEditor">
			<h2>Tales of Link - Pulls</h2>
			<form method="POST" action="" onsubmit="return PullEditor.submit(this)">
				<fieldset>
					<legend>Settings</legend>
					<table>
						<tbody>
							<tr>
								<th>Probability ✰✰✰</th>
								<td data-value="64">
									<input name="probThrees" type="range" min="0" max="100" step="1" value="64"
										oninput="this.parentNode.setAttribute('data-value', this.value)" />
								</td>
							</tr>
							<tr>
								<th>Probability ✰✰✰✰</th>
								<td data-value="30">
									<input name="probFours" type="range" min="0" max="100" step="1" value="30"
										oninput="this.parentNode.setAttribute('data-value', this.value)" />
								</td>
							</tr>
							<tr>
								<th>Probability ✰✰✰✰✰</th>
								<td data-value="6">
									<input name="probFives" type="range" min="0" max="100" step="1" value="6"
										oninput="this.parentNode.setAttribute('data-value', this.value)" />
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<label>
										<input type="radio" name="guarantee" required="required" value="three" />
										No guarantee
									</label>
									<label>
										<input type="radio" name="guarantee" required="required" value="four" />
										1x✰✰✰✰ guaranteed
									</label>
									<label>
										<input type="radio" name="guarantee" required="required" value="five" />
										1x✰✰✰✰✰ guaranteed
									</label>
								</td>
							</tr>
							<tr>
								<th>Number of pulls</th>
								<td>
									<input name="pulls" type="number" min="1" max="100" step="1" value="1" />
								</td>
							</tr>
						</tbody>
						<button type="submit">Generate!</button>
					</table>
				</fieldset>
				<fieldset>
					<legend>Results</legend>
					<table>
						<tbody>
							<tr>
								<th />
								<th>✰✰✰</th>
								<th>✰✰✰✰</th>
								<th>✰✰✰✰✰</th>
							</tr>
							<tr>
								<th>Expected value:</th>
								<td>
									<output name="outThrees">?</output>
								</td>
								<td>
									<output name="outFours">?</output>
								</td>
								<td>
									<output name="outFives">?</output>
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
			</form>
		</article>
	</xsl:template>
</xsl:stylesheet>
