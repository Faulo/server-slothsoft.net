<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/*">
		<div class="VCT">
			<article class="Instructions">
				<h2>Introduction</h2>
				<p>
					This is an open and free video chat.
					It is based on the W3C standards
					<a href="http://www.w3.org/TR/eventsource/">Server-Sent Events</a>
					,
					<a href="http://www.w3.org/TR/webrtc/">WebRTC</a>
					, and
					<a href="http://www.w3.org/TR/mediacapture-streams/">Media Capture and Streams</a>
					to provide a quick, easy-to-use stream transmission... thing.
				</p>
				<p>
					Our server stores the metadata needed for browsers to start communicating, but after that nothing else gets sent
					to it.
					The actual audio/video streams are transmitted peer-to-peer, with no server in between, so none of those are
					stored (or even processed) anywhere.
				</p>
				<p>
					To start, press "Create New Room" below, then share the URL you land in with any peeps you want to talk to.
				</p>
				<p>
					There's probably lots of bugs, so handle with care.
				</p>
			</article>
			<form action="Room/" method="GET">
				<p>
					<button type="submit">Create New Room</button>
				</p>
			</form>
			<article class="Instructions">
				<h2>Usage Notes</h2>
				<p>
					Because we here at Slothsoft are all awkward penguins, the Video Chat Thing won't start sending streams out on its
					own.
					To initiate a video chat with someone else, each of you will have to click on
					<button>📤</button>
					to start sending out your own respective webcam feeds.
				</p>
			</article>
		</div>
	</xsl:template>
</xsl:stylesheet>
