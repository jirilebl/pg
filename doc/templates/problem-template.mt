<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title><%= $filename %></title>

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/base16/eva.min.css">

	<style>
		.explanation {
			--bs-code-color: #971556;
		}
		.preamble {
			background-color: lightblue;
		}
		.setup {
			background-color: #ddffdd;
		}
		.statement {
			background-color: #eeb08199;
		}
		.answer {
			background-color: #ffffdd;
		}
		.solution {
			background-color: #ffb6c199;
		}
	</style>
</head>

<body class="p-3">
	<div class="container-fluid">
		<h1><%= $filename %></h1>
		<p><%= $description %></p>
		<h2>POD for Macro Files</h2>
		<ul>
			% for (@$macros) {
				% if ($macro_loc->{$_}) {
					<li><a href="<%= $pod_dir %>/<%= $macro_loc->{$_} %>"><%= $_ =%></a></li>
				% } else {
					<li class="text-danger"><%= $_ %></li>
				% }
			% }
		</ul>
		<div class="row">
			<div class="col text-center"><h2 class="fw-bold fs-3">PG problem file</h2></div>
			<div class="col text-center"><h2 class="fw-bold fs-3">Explanation</h2></div>
		</div>
		% for (@$blocks) {
			<div class="row">
				<div class="col-sm-12 col-md-6 order-md-first order-last p-0 position-relative overflow-x-hidden">
					<button class="clipboard-btn btn btn-sm btn-dark position-absolute top-0 end-0 me-1 mt-1"
						type="button" data-code="<%== $_->{code} %>" aria-label="copy to clipboard">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
							class="bi bi-clipboard" viewBox="0 0 16 16" aria-hidden="true" focusable="false">
							<path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
							<path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
						</svg>
					</button>
					<pre class="m-0 h-100"><% =%>\
						<code class="language-perl bg-dark border border-secondary h-100"><%= $_->{code} %></code><% =%>\
					</pre><% =%>
				</div>
				<div class="explanation <%= $_->{section} %> col-sm-12 col-md-6 order-md-last order-first border border-dark">
					<p><b><%= ucfirst($_->{section}) %></b></p>
					<%= $_->{doc} %>
				</div>
			</div>
		% }
	</div>

	<script type="module">
		import hljs from 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/es/highlight.min.js';
		hljs.highlightAll();

		for (const btn of document.querySelectorAll('.clipboard-btn')) {
			btn.addEventListener('click', () => navigator.clipboard.writeText(btn.dataset.code));
		}
	</script>
</body>

</html>
