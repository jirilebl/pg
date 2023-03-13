
=head1 niceTables.pl

Subroutines for creating tables that

=over

=item * conform to accessibility standards in HTML output

=item * have uniform styling across output formats, to the degree possible

=item * may use CSS for additional HTML styling

=item * may use LaTeX commands for additional hardcopy styling

=back

C<DataTable()> creates a table displaying data. Should not be used for layout,
such as displaying an array of graphs.

C<LayoutTable()> creates a "table" without using an HTML table in HTML output.
Please use C<LayoutTable> whenever you are simply laying out layout content
relation between content cells within a column or within a row.
If the for space-saving purposes. Ask yourself if there is any meaningful
answer is no in both cases, it is likely a case for C<LayoutTable()>.

=head2 Description

Command for a typical table.

    DataTable([
        [a,b,c,...],
        [d,e,f,...],
        ...
        ],
        options
    );

    LayoutTable([
        [a,b,c,...],
        [d,e,f,...],
        ...
        ],
        options
    );

As much as possible, options apply to all output formats.
Some options only apply to HTML styling, and some options only apply to PDF hardcopy.
Not all options are supported by every output format. For example PTX cannot use color information.

All features described below apply to a C<DataTable>.
Most also apply to a C<LayoutTable>, with the excpetions being:

=over

=item * C<caption>

=item * C<rowheaders>

=item * C<header>

=item * C<colspan>

=item * C<headerrow>

=back

=head2 Options for the WHOLE TABLE

=head3 The following applied to all output formats

=over

=item C<center =E<gt> 0 or 1>

Center the table (default 1)

=item C<caption =E<gt> string>

caption for the table

=item C<horizontalrules =E<gt> 0 or 1>

make rules above and below every row (default 0)

=item C<texalignment =E<gt> string>

an alignment string like the kinds used in LaTeX tabular environment: for example C<'r|ccp{1in}'>

=over

=item C<r >

right-aligned column

=item C<c >

center-aligned column

=item C<r >

left-aligned column

=item C<p{width} >

left-aligned paragraphs of fixed (absolute) width

=item C<X >

left-aligned paragraph that expands to fill (see Xratio below)

=item C<| >

a vertical rule (n adjacent pipes makes one rule that is n times thick)

=item C<!{\vrule width ...} >

vertical rule of the indicated width (must be an absolute width)

=item C< E<gt>{commands}>

Execute commands at each cell in the column For example, C<'cE<gt>{\color{blue}}c'> will make the
second column have blue text.

The following LaTeX commands may be used:

  \color{colorname}            text color
  \color[HTML]{xxxxxx}         text color (xxxxxx is a 6-character hex color code)
  \columncolor{colorname}      background color
  \columncolor[HTML]{xxxxxx}   background color (xxxxxx is a 6-character hex color code)
  \bfseries                    bold
  \itshape                     italics
  \ttfamily                    monospace

Other LaTeX commands apply only to PDF output.

=back

=item C<align =E<gt> string>

convenient short version of texalignment

=item C<Xratio =E<gt> number>

applies when X is part of overall alignment
Xratio must be some number with C<0 < Xratio <= 1> (default 0.97)
The table will only be Xratio wide, relative to the overall
horizontal space. And X columns expland to fill available space.

=item C<encase =E<gt> [ , ]>

Encases all table entries in the two entries. For example, to wrap
cells in math delimiters if you want all content in math mode.
In that case, use C<[$BM,$EM]>. See also noencase for individual cells.

=item C<rowheaders =E<gt> 0 or 1>

Make the first element of every row a row header.

=item C<headerrules =E<gt> 0 or 1>

Make a horizontal rule under a row of column headers and a vertical
rule to the right of a column of row headers. Default is 1.

=item C<valign =E<gt> 'top'>

Can be 'top', 'middle', or 'bottom'. Applies to all rows.
See below to override for an individual row.

=back

=head3 These apply to HTML output only

Note: each css property setting should inlude a colon and a semicolon.
Example:  C<'font-family: fantasy; text-decoration: underline;'>

=over

=item C<tablecss =E<gt> css string>

css styling commands for the table element

Example: C<tablecss =E<gt> 'border:1pt solid black;'>

=item C<captioncss =E<gt> css string>

css styling commands for the caption element

Example: C<captioncss =E<gt> 'color: blue;'>

=item C<columnscss => array ref

an array reference to css strings for columns

Note: only four css properties apply to a col element:

=over

=item C<border> (family)

=item C<background> (family)

=item C<width>

=item C<column-span>

=back

=item C<datacss =E<gt> css string>

css styling commands for td (non-header) cells

Example: C<datacss =E<gt> 'font-family:fantasy;'>

=item C<headercss =E<gt> css string>

css styling commands for th (header) cells

Example: C<headercss =E<gt> 'font-family:monospace;'>

=item C<allcellcss =E<gt> css string>

css styling commands for all cells

Example: C<allcellcss =E<gt> 'padding:20pt 20pt'>

=back

=head3 This applies to PDF hardcopy output only

=over

=item C<booktabs =E<gt> 0 or 1>

use booktabs for horizontal rules (default 1)

=back

=head2 Options for CELLS

Each cell entry can be an array reference where the first entry is the actual
cell content, and then key-value pairs follow. For example, in a table with four columns,
to make the first cell span two columns, enter the first cell as an array reference:

  [[a, colspan => 2], b, c]

Alternatively, using a hash reference with a data key:

  [{data => a, colspan => 2}, b, c]

All ouptut formats:

=over

=item C<halign =E<gt> string>

Similar to the components for texalignment above. However, only C<l, c, r, p{}>, and vertical
rule specifications should be used.

With vertical rule specifiers, any left vertical rule will only be observed for cells
is in the first column. Otherwise, use a right vertical rule on the cell to the left.

=item C<header =E<gt> type>,

Declares the scope of the HTML th element. Case-insensitive:

=over

=item C<th>   generic table header

=item C<ch>   column header ('col' and 'column' work too)

=item C<rh>   row header ('row' works too)

=item C<td>   overrides a headerrow or rowheaders option except PTX output cannont honor this

=back

=item C<color =E<gt> string>

color name or 6-character hex color code for text color

=item C<bgcolor =E<gt> string>

color name or 6-character hex color code for background color

=item C<b=E<gt>1>

Set the cell to bold font.

=item C<i=E<gt>1>

Set the cell to italics font.

=item C<m=E<gt>1>

Set the cell to monospace font.

=item C<tex =E<gt> commands>

Execute commands at start of a cell with scope the entire cell.  This option is legacy, and its
cross-format functionality is superceded by C<color, bgcolor, b, i,> and C<m>.

The following LaTeX commands may be used:

  \color{colorname}            text color
  \color[HTML]{xxxxxx}         text color (xxxxxx is a 6-character hex color code)
  \columncolor{colorname}      background color
  \columncolor[HTML]{xxxxxx}   background color (xxxxxx is a 6-character hex color code)
  \bfseries                    bold
  \itshape                     italics
  \ttfamily                    monospace

Other LaTeX commands apply only to hardcopy output.

Example: C<['a', tex =E<gt> '\bfseries'], ['b', tex =E<gt> '\itshape'], ['c', tex =E<gt> '\ttfamily']>

=item C<noencase =E<gt> 0 or 1>

If you are using encase (see above) use this to opt out

=item C<colspan =E<gt> n>

Positive integer; for cells that span more than one column when using this, you
often set halign as well.

=item C<top =E<gt> +int or string>

Make a top rule for one cell if the cell is in the top row. Thickness is either C<n>
pixels or a width like C<'0.04em'>. Has no effect on cells outside of top row.

=item C<bottom =E<gt> +int or string>

Make a bottom rule for one cell. Thickness is either C<n> pixels or a width like C<'0.04em'>.

=back

=head3 HTML output

This option is only for HTML output.

=over

=item C<cellcss =E<gt> string>

css styling commands for this cell

=back

=head3 PDF hardcopy output

The following apply only to PDF output

=over

=item C<texpre =E<gt> tex code>

For more fussy cell-by-cell alteration of the tex version of

=item C<texpost =E<gt> tex code>

the table, code to place before and after the cell content

=item C<texencase =E<gt> array ref>

Shortcut for entering [texpre,texpost] at once.

=back

=head2 Options for ROWS

Some parameters in a cell's options array affect the entire row.
When there is a clash, the last non-falsy declaration in the row will be used.

=over

=item C<rowcolor =E<gt> strin>

Sets the row's background color.  Must be a color name, 6-character hex color code,
or for legacy support only, in the form C<'[HTML]{xxxxxx}'>

=item C<rowcss =E<gt> string>

css styling commands for the row

=item C<headerrow =E<gt> 0 or 1>

Makes an entire row use header cells (with column scope)

=item C<rowtop =E<gt> +int or string>

When used on the first row, creates a top rule. Has no effect on other rows.  Thickness
is either C<n> pixels or a width like C<'0.04em'>.

=item C<rowbottom =E<gt> +int or string>

Make a bottom rule.  Thickness is either C<n> pixels or a width like C<'0.04em'>.

=item C<valign =E<gt> string>

Override table's overall vertical alignment for this row.  Can be C<'top'>, C<'middle'>,
or C<'bottom'>.

=back

=head2 Options for COLUMNS

Column styling is handled indirectly for now, mostly through the texalignment option above.

=cut

sub _niceTables_init {
	main::PG_restricted_eval('sub DataTable { NiceTables::DataTable(@_) }');
	main::PG_restricted_eval('sub LayoutTable { NiceTables::LayoutTable(@_) }');
}

package NiceTables;

sub DataTable {
	my $userArray = shift;

	# cleaned up and initialized version of the user's array of cell data and cell/row options
	# $tableArray references a 2D array for the table, with entries being a hash reference
	# The data key is the cell content, and other keys are (initialiized) options for the cell
	my $tableArray = TableArray($userArray);

	# establish the true number of columns, accounting for all uses of colspan
	my $colCount = ColumnCount($tableArray);

	# $tableOpts is a hash reference keeping the (initialized) global table options
	my $tableOpts = TableOptions($colCount, @_);

	# $alignment is a 1D array of hash references, with options for each column
	my $alignment = ParseAlignment($tableOpts->{texalignment});

	# if the user's data implies more columns than what they specified in texalignment
	# then we add columns to both $alignment and $tableOpts->{texalignment}
	for my $i ($#$alignment + 1 .. $colCount) {
		$alignment->[$i] = { halign => 'c', valign => '', right => '', width => '', tex => '' };
		$tableOpts->{texalignment} .= 'c';
	}

	return TableEnvironment($tableArray, $tableOpts, $alignment);
}

sub LayoutTable {
	return DataTable(@_, LaYoUt => 1);
}

# Make the outer table environment
sub TableEnvironment {
	my ($tableArray, $tableOpts, $alignment) = @_;

	# determine if somewhere in the alignment there are X columns
	my $hasX = 0;
	for my $align (@$alignment) {
		if ($align->{halign} eq 'X') {
			$hasX = 1;
			last;
		}
	}

	# determine if first row has a top border
	my $top = '';
	for my $x (@{ $tableArray->[0] }) {
		$top = $x->{rowtop} if ($x->{rowtop});
	}

	my $booktabs = $tableOpts->{booktabs};

	my $cols = Cols($tableArray, $tableOpts, $alignment);
	my $rows = Rows($tableArray, $tableOpts, $alignment);

	if ($main::displayMode eq 'TeX') {
		my $tabulartype  = $hasX ? 'tabularx'                        : 'tabular';
		my $tabularwidth = $hasX ? "$tableOpts->{Xratio}\\linewidth" : '';
		$rows = latexEnvironment($rows, $tabulartype, [ $tabularwidth, '[t]', $tableOpts->{texalignment} ], ' ');
		$rows = prefix($rows, '\centering%') if $tableOpts->{center};
		$rows = prefix($rows, '\renewcommand{\arraystretch}{2}', '')
			if $tableOpts->{LaYoUt};
		$rows = suffix(
			$rows,
			"\\captionsetup{textfont={sc},belowskip=12pt,aboveskip=4pt}\\captionof*{table}{$tableOpts->{caption}}",
			' '
		) if ($tableOpts->{caption});
		$rows = wrap($rows, '\par', '\par', '');
		$rows = wrap($rows, '{',    '}',    '');
	} elsif ($main::displayMode eq 'PTX') {
		my $ptxleft = getPTXthickness($alignment->[0]{left});
		my $ptxtop  = '';
		if ($tableOpts->{horizontalrules} && $booktabs) {
			$ptxtop = 'major';
		} elsif ($tableOpts->{horizontalrules}) {
			$ptxtop = 'minor';
		}
		$ptxtop = getPTXthickness($top) if $top;
		my $ptxwidth   = '';
		my $ptxmargins = '';

		if ($hasX) {
			$ptxwidth = $tableOpts->{Xratio} * 100;
			my $leftmargin  = ($tableOpts->{center}) ? (100 - $ptxwidth) / 2 : 0;
			my $rightmargin = 100 - $ptxwidth - $leftmargin;
			$ptxmargins = "${leftmargin}% ${rightmargin}%";
			$ptxwidth .= '%';
		} elsif (!$tableOpts->{center}) {
			$ptxwidth   = '100%';
			$ptxmargins = '0% 0%';
		}
		my $ptxbottom = ($tableOpts->{horizontalrules}) ? 'minor' : '';
		if ($tableOpts->{LaYoUt}) {
			$rows = tag(
				$rows,
				'sbsgroup',
				{
					width   => $ptxwidth,
					margins => $ptxmargins,
				}
			);
		} elsif (!$tableOpts->{LaYoUt}) {
			$rows = prefix($rows, $cols);
			$rows = tag(
				$rows,
				'tabular',
				{
					valign  => ($tableOpts->{valign} ne 'middle') ? $tableOpts->{valign} : '',
					width   => $ptxwidth,
					margins => $ptxmargins,
					left    => $ptxleft,
					top     => $ptxtop,
					bottom  => $ptxbottom
				}
			);
		}

		# We fake a caption as a tabular that follows the actual tabular
		# This is not great, but PTX has no option to put a caption on a tabular
		# (It can put a caption on a table, but we are not making a PTX table.)
		my $ptxcaption = '';
		if ($tableOpts->{caption}) {
			$ptxcaption = $tableOpts->{caption};
			$ptxcaption = tag($ptxcaption, 'cell');
			$ptxcaption = tag($ptxcaption, 'row');
			my $ptxcapwidth = '';
			if ($hasX) {
				$ptxcapwidth = $tableOpts->{Xratio} * 100 . '%';
			} else {
				$ptxcapwidth = '50%';
			}
			$ptxcapcol  = tag('', 'col', { width => $ptxcapwidth });
			$ptxcaption = prefix($ptxcaption, $ptxcapcol);
			$ptxcaption = tag($ptxcaption, 'tabular', { width => $ptxwidth, margins => $ptxmargins });
		}
		$rows = suffix($rows, $ptxcaption);
	} else {
		my $css = $tableOpts->{tablecss};
		if ($hasX) {
			$css .= css('width', $tableOpts->{Xratio} * 100 . '%');
		}
		$css .= css('border-left', getRuleCSS($alignment->[0]{left}));
		$css .= css('margin',      'auto') if $tableOpts->{center};

		my $htmlcols = '';
		$htmlcols = tag($cols, 'colgroup')
			unless ($cols =~ /^(<col>|\n)*$/ || $tableOpts->{LaYoUt});
		$rows = prefix($rows, $htmlcols);
		my $htmlcaption = tag($tableOpts->{caption}, 'caption', { style => $tableOpts->{captioncss} });
		$rows = prefix($rows, $htmlcaption) if ($tableOpts->{caption} && !$tableOpts->{LaYoUt});

		if ($tableOpts->{LaYoUt}) {
			$css .= css('display',         'table');
			$css .= css('border-collapse', 'collapse');
			$rows = tag($rows, 'div', { style => $css });
		} else {
			$rows = tag($rows, 'table', { style => $css });
		}
	}

	return $rows;

}

sub Cols {
	my ($tableArray, $tableOpts, $alignment) = @_;
	my $columnscss = $tableOpts->{columnscss};
	my @cols       = ();

	# Loop through columns ($alignment->[0] is the left border not a column)
	for my $i (1 .. $#$alignment) {
		my $align = $alignment->[$i];

		# determine if this column has any paragraph cells
		my $width = '';
		for my $y (@$tableArray) {
			for my $x (@$y) {

				# accounting for use of colspan...
				if ($x->{leftcol} == $i && $x->{halign} =~ /^p\{([^}]*?)\}/) {
					$width = $1;
				}
			}
		}

		# determine if this column has a top border
		my $top = '';
		for my $x (@{ $tableArray->[0] }) {

			# accounting for use of colspan...
			if ($x->{leftcol} <= $i && $i <= $x->{rightcol} && $x->{top}) {
				$top = $x->{top};
			}
		}

		if ($main::displayMode eq 'PTX') {
			my $ptxhalign = '';
			$ptxhalign = 'center' if ($align->{halign} eq 'c');
			$ptxhalign = 'right'  if ($align->{halign} eq 'r');
			my $ptxright = '';
			$ptxright = getPTXthickness($align->{right});
			my $ptxtop = '';
			$ptxtop = getPTXthickness($top);
			my $ptxwidth = '';
			$ptxwidth = getWidthPercent($align->{width}) if $align->{width};
			$ptxwidth = ($tableOpts->{Xratio} / $#$alignment * 100) . '%'
				if ($align->{halign} eq 'X');
			$ptxwidth = getWidthPercent($width) if $width;
			push(
				@cols,
				tag(
					'', 'col',
					{
						header => ($i == 1 && $tableOpts->{rowheaders}) ? 'yes' : '',
						halign => $ptxhalign,
						right  => $ptxright,
						top    => $ptxtop,
						width  => $ptxwidth
					}
				)
			);
		} else {
			my $htmlright = '';
			$htmlright .= css('border-right', 'solid 2px')
				if ($i == 1 && $tableOpts->{rowheaders} && $tableOpts->{headerrules});
			$htmlright .= css('border-right', getRuleCSS($align->{right}));
			my $htmltop = '';
			$htmltop .= css('border-top', getRuleCSS($top));

			# $i starts at 1, but columncss indexing starts at 0
			my $htmlcolcss = $columnscss->[ $i - 1 ];
			if ($align->{tex} =~ /\\columncolor(\[HTML\])?\{(.*?)[}!]/) {
				$htmlcolcss .= css('background-color', ($1 ? '#' : '') . $2);
			}

			push(@cols, tag('', 'col', { style => "${htmlright}${htmltop}${htmlcolcss}" }));
		}

	}

	return join("\n", @cols);

}

sub Rows {
	my ($tableArray, $tableOpts, $alignment) = @_;

	my @rows;
	my @htmlhead;
	my @htmlbody;
	my $htmlout;
	my $stillinhtmlhead = 1;

	for my $i (0 .. $#$tableArray) {
		my $rowArray = $tableArray->[$i];
		my $booktabs = $tableOpts->{booktabs};
		my $row      = Row($rowArray, $tableOpts, $alignment);
		my $html     = $row;

		# establish if this row has certain things
		# when declared mulltiple times, last non-falsy values are used
		my $bottom    = 0;
		my $top       = 0;
		my $rowcolor  = '';
		my $headerrow = '';
		my $valign    = '';
		for my $x (@$rowArray) {
			$bottom    = $x->{rowbottom} if ($x->{rowbottom});
			$top       = $x->{rowtop}    if ($x->{rowtop} && $i == 0);
			$rowcolor  = $x->{rowcolor}  if ($x->{rowcolor});
			$headerrow = 'yes'           if ($x->{headerrow});
			$valign    = $x->{valign}    if ($x->{valign});
		}

		if ($main::displayMode eq 'TeX') {
			# separator argument is space (not the default line break)
			# to avoid PGML catcode manipulation issues
			$row = prefix($row, "\\rowcolor" . formatColorLaTeX($rowcolor), ' ')
				if ($rowcolor);
			$row = prefix($row, hrule($booktabs, 'top', $top), ' ')
				if ($top || ($i == 0 && $tableOpts->{horizontalrules}));
			$row = suffix($row, "\\\\",                           ' ') unless ($i == $#$tableArray);
			$row = suffix($row, hrule($booktabs, 'mid', $bottom), ' ')
				if ($i < $#$tableArray && ($bottom || $tableOpts->{horizontalrules})
					|| $headerrow && $tableOpts->{headerrules});
			$row = suffix($row, "\\\\" . hrule($booktabs, 'bottom', $bottom), ' ')
				if ($i == $#$tableArray
					&& ($bottom || $tableOpts->{horizontalrules}));

			# do cells in this row have a top or bottom border?
			# although a propery of cells, LaTeX makes us do this at the row level
			for my $x (@$rowArray) {
				$row = prefix($row, hrule($booktabs, 'cmid', $x->{top}) . "{$x->{leftcol}-$x->{rightcol}}", ' ')
					if ($i == 0 && $x->{top});
				$row = suffix($row, hrule($booktabs, 'cmid', $x->{bottom}) . "{$x->{leftcol}-$x->{rightcol}}", ' ')
					if $x->{bottom};
			}

			push(@rows, $row);
		} elsif ($main::displayMode eq 'PTX') {
			my $ptxbottom = '';
			if ($i == $#$tableArray && $tableOpts->{horizontalrules} && $booktabs) {
				$ptxbottom = 'major';
			} elsif ($tableOpts->{horizontalrules}) {
				$ptxbottom = 'minor';
			}
			$ptxbottom = getPTXthickness($bottom) if $bottom;
			my $ptxleft = '';
			$ptxleft = 'minor'  if ($rowArray->[0]{halign} =~ /^\s*\|/);
			$ptxleft = 'medium' if ($rowArray->[0]{halign} =~ /^\s*\|\s*\|/);
			$ptxleft = 'major'  if ($rowArray->[0]{halign} =~ /^\s*\|\s*\|\s*\|/);

			if ($rowArray->[0]{halign} =~ /^(?:\s|\|)*!\{\s*\\vrule\s+width\s+([^}]*?)\s*}/) {
				$ptxleft = 'minor'  if ($1);
				$ptxleft = 'minor'  if ($1 == '0.04em');
				$ptxleft = 'medium' if ($1 == '0.07em');
				$ptxleft = 'major'  if ($1 == '0.11em');
			}

			$ptxleft = '' if ($ptxleft eq $alignment->[0]{left});
			$ptxleft = "none"
				if (!$ptxleft && $rowArray->[0]{halign} && $alignment->[0]{left});

			if ($tableOpts->{LaYoUt}) {
				my $ptxwidthsum = 0;
				my $ptxautocols = $#alignment;
				for my $j (1 .. $#alignment) {
					if ($rowArray->[ $j - 1 ]{width}) {
						$ptxwidthsum +=
							substr getWidthPercent($tableArray->[ $j - 1 ]{width}),
							0, -1;
						$ptxautocols -= 1;
					} elsif ($alignment->[$j]{width}) {
						$ptxwidthsum += substr getWidthPercent($alignment->[$j]{width}), 0, -1;
						$ptxautocols -= 1;
					}
				}

				# determine if somewhere in the overall alignment, there are X columns
				my $hasX = 0;
				for my $align (@$alignment) {
					if ($align->{halign} eq 'X') {
						$hasX = 1;
						last;
					}
				}
				my $leftoverspace =
					(($hasX) ? $tableOpts->{Xratio} * 100 : 100) - $ptxwidthsum;
				my $divvyuptherest = 0;
				$divvyuptherest = int($leftoverspace / $ptxautocols * 10000) / 10000
					unless ($ptxautocols == 0);
				my @ptxwidths;
				for my $j (1 .. $#alignment) {
					if ($rowOpts->[ $j - 1 ]{width}) {
						push(@ptxwidths, getWidthPercent($rowOpts->[ $j - 1 ]{width}));
					} elsif ($alignment->[$j]{width}) {
						push(@ptxwidths, getWidthPercent($alignment->[$j]{width}));
					} else {
						push(@ptxwidths, $divvyuptherest . '%');
					}
				}

				my $ptxwidths = join(" ", @ptxwidths);
				$row = tag(
					$row,
					'sidebyside',
					{
						valign  => ($valign) ? $valign : $tableOpts->{valign},
						margins => '0% 0%',
						widths  => $ptxwidths,
					}
				);
			} else {
				$row = tag(
					$row, 'row',
					{
						left   => $ptxleft,
						valign => $valign,
						header => $headerrow,
						bottom => $ptxbottom
					}
				);
			}
			push(@rows, $row);
		} else {
			my $css = '';
			for my $x (@$rowArray) {
				$css .= $x->{rowcss} if $x->{rowcss};
			}
			$css .= css('background-color', formatColorHTML($rowcolor));
			$css .= css('border-top',       'solid 3px')
				if ($i == 0 && $tableOpts->{horizontalrules});
			$css .= css('border-top',    getRuleCSS($top));
			$css .= css('border-bottom', 'solid 1px')
				if ($i < $#$tableArray && $tableOpts->{horizontalrules});
			$css .= css('border-bottom', 'solid 3px')
				if ($i == $#$tableArray && $tableOpts->{horizontalrules});
			$css .= css('border-bottom',  getRuleCSS($bottom));
			$css .= css('vertical-align', $valign);

			if ($tableOpts->{LaYoUt}) {
				$css .= css('display', 'table-row');
				$html = tag($html, 'div', { style => $css });
				push(@htmlbody, $html);
			} else {
				$html = tag($html, 'tr', { style => $css });
				if ($stillinhtmlhead && $headerrow) {
					push(@htmlhead, $html);
				} else {
					$stillinhtmlhead = 0;
					push(@htmlbody, $html);
				}
			}
		}
		if ($tableOpts->{LaYoUt}) {
			$htmlout = join("\n", @htmlbody);
		} else {
			my $htmlvalign = '';
			$htmlvalign = $tableOpts->{valign}
				unless ($tableOpts->{valign} eq 'middle');
			$htmlout = tag(join("\n", @htmlbody), 'tbody', { style => css('vertical-align', $htmlvalign) });
			if (@htmlhead) {
				my $htmlheadcss = css('vertical-align', $htmlvalign);
				$htmlheadcss .= css('border-bottom', 'solid 2px') if $tableOpts->{headerrules};
				$htmlout = prefix($htmlout, tag(join("\n", @htmlhead), 'thead', { style => $htmlheadcss }));
			}
		}
	}

	return main::MODES(
		TeX  => join(" ", @rows),
		HTML => $htmlout,
		PTX  => join("\n", @rows),
	);

}

sub Row {
	my ($rowArray, $tableOpts, $alignment) = @_;

	my $headerrow = '';
	my $valign    = '';
	for my $x (@$rowArray) {
		$headerrow = 'yes'        if ($x->{headerrow});
		$valign    = $x->{valign} if ($x->{valign});
	}

	my @cells;

	# Loops over the cells in the row
	for my $i (0 .. $#$rowArray) {
		my $cellOpts  = $rowArray->[$i];
		my $cellAlign = $alignment->[ $rowArray->[$i]{leftcol} ];
		my $cellData  = $cellOpts->{data};
		my $cell      = $cellData;

		if ($main::displayMode eq 'TeX') {
			$cell = prefix($cell, $cellOpts->{tex}, ' ');
			$cell = wrap($cell, @{ $tableOpts->{encase} })
				unless $cellOpts->{noencase};
			$cell = wrap($cell, $cellOpts->{texpre}, $cellOpts->{texpost});
			$cell = prefix($cell, '\bfseries', ' ')
				if ($tableOpts->{rowheaders} && $cellOpts->{header} ne 'td' && $i == 0
					|| ($headerrow && $cellOpts->{header} ne 'td')
					|| $cellOpts->{header} =~ /^(th|rh|ch|col|column|row)$/i);
			# Situations where we need \multicolumn
			if ($cellOpts->{colspan} > 1
				|| $cellOpts->{halign}
				|| $valign
				|| ($tableOpts->{valign}     && $tableOpts->{valign} ne 'top')
				|| ($tableOpts->{rowheaders} && $tableOpts->{headerrules}))
			{
				my $columntype = $cellOpts->{halign};
				$columntype = $cellAlign->{halign} // 'l' unless $columntype;
				$columntype = 'p{' . $tableOpts->{Xratio} / ($#$rowArray + 1) . "\\linewidth}"
					if ($columntype eq 'X');
				$columntype = "p{$cellAlign->{width}}"
					if ($cellAlign->{width});
				$columntype =~ s/^p/m/ if ($valign eq 'middle');
				$columntype =~ s/^p/b/ if ($valign eq 'bottom');
				$columntype =~ s/^p/m/ if ($tableOpts->{valign} eq 'middle');
				$columntype =~ s/^p/b/ if ($tableOpts->{valign} eq 'bottom');
				$columntype .= '|'
					if ($i == 0 && $cellOpts->{colspan} == 1 && $tableOpts->{rowheaders} && $tableOpts->{headerrules});
				$cell = latexCommand('multicolumn', [ $cellOpts->{colspan}, $columntype, $cell ]);
			}
			$cell = suffix($cell, '&', ' ') unless ($i == $#$rowArray);
			push(@cells, $cell);
		} elsif ($main::displayMode eq 'PTX') {
			$cell = wrap($cell, @{ $tableOpts->{encase} })
				unless $cellOpts->{noencase};

			$cell = tag($cell, 'p')
				if (($cellAlign->{width} || $cellAlign->{halign} eq 'X' || $cellOpts->{halign} =~ /^p/))
				&& !$tableOpts->{LaYoUt};
			my $ptxhalign = '';
			$ptxhalign = 'left'  if ($cellOpts->{halign} =~ /l/);
			$ptxhalign = 'right' if ($cellOpts->{halign} =~ /r/);
			my $ptxright = '';
			$ptxright = 'minor'  if ($cellOpts->{halign} =~ /\|\s*$/);
			$ptxright = 'medium' if ($cellOpts->{halign} =~ /\|\s*\|\s*$/);
			$ptxright = 'major'  if ($cellOpts->{halign} =~ /\|\s*\|\s*\|\s*$/);
			my $ptxbottom = '';
			$ptxbottom .= getPTXthickness($cellOpts->{bottom});

			if ($cellOpts->{halign} =~ /!\{\s*\\vrule\s+width\s+([^}]*?)\s*}\s*$/) {
				$ptxright = 'minor'  if ($1);
				$ptxright = 'minor'  if ($1 eq '0.04em');
				$ptxright = 'medium' if ($1 eq '0.07em');
				$ptxright = 'major'  if ($1 eq '0.11em');
			}
			if ($tableOpts->{LaYoUt}) {
				$cell = tag($cell, 'p');
				$cell = tag($cell, 'stack',);

			} else {
				$cell = tag(
					$cell, 'cell',
					{
						halign  => $ptxhalign,
						colspan => ($cellOpts->{colspan} > 1) ? $cellOpts->{colspan} : '',
						right   => $ptxright,
						bottom  => $ptxbottom
					},
					''
				);
			}
			push(@cells, $cell);
		} else {

			# HTML
			my $t     = 'td';
			my $scope = '';
			do { $t = 'th'; $scope = 'row'; }
				if ($i == 0 && $tableOpts->{rowheaders});
			do { $t = 'th'; $scope = 'col'; } if ($headerrow);
			$t     = 'th'  if ($cellOpts->{header} =~ /^(th|rh|ch|col|column|row)$/i);
			$scope = 'row' if ($cellOpts->{header} =~ /^(rh|row)$/i);
			$scope = 'col' if ($cellOpts->{header} =~ /^(ch|col|column)$/i);
			do { $t = 'td'; $scope = ''; } if ($cellOpts->{header} =~ /^td$/i);
			my $css = '';

			# col level
			$css .= css('text-align', 'center')
				if ($cellAlign->{halign} eq 'c');
			$css .= css('text-align', 'right')
				if ($cellAlign->{halign} eq 'r');
			$css .= css('width', $cellAlign->{width})
				if ($cellAlign->{width});
			$css .= css('font-weight', 'bold')
				if ($cellAlign->{tex} =~ /\\bfseries/);
			$css .= css('font-style', 'italic')
				if ($cellAlign->{tex} =~ /\\itshape/);
			$css .= css('font-family', 'monospace')
				if ($cellAlign->{tex} =~ /\\ttfamily/);
			if ($cellAlign->{tex} =~ /\\color(\[HTML\])?\{(.*?)[}!]/) {
				$css .= css('color', ($1 ? '#' : '') . $2);
			}

			# cell level
			$css .= $cellOpts->{cellcss};
			if ($cellOpts->{halign} =~ /^([|\s]*\|)/ && $i == 0) {
				my $count = $1 =~ tr/\|//;
				$css .= css('border-left', "solid ${count}px");
			}
			if ($cellOpts->{halign} =~ /^(\s\|)*!\{\\vrule\s+width\s+([^}]*?)}/
				&& $i == 0)
			{
				$css .= css('border-left', "solid $2");
			}
			if ($cellOpts->{halign} =~ /(\|[|\s]*)$/) {
				my $count = $1 =~ tr/\|//;
				$css .= css('border-right', "solid ${count}px");
			}
			if ($cellOpts->{halign} =~ /!\{\\vrule\s+width\s+([^}]*?)}\s*$/) {
				$css .= css('border-right', "solid $1");
			}
			$css .= css('border-bottom', getRuleCSS($cellOpts->{bottom}));
			$css .= css('text-align',    'left') if ($cellOpts->{halign} =~ /^l/);
			$css .= css('text-align',    'center')
				if ($cellOpts->{halign} =~ /^c/);
			$css .= css('text-align', 'right') if ($cellOpts->{halign} =~ /^r/);
			$css .= css('text-align', 'left')  if ($cellOpts->{halign} =~ /^p/);
			$css .= css('width',      $1)
				if ($cellOpts->{halign} =~ /^p\{([^}]*?)}/);
			$css .= css('font-weight', 'bold')
				if ($cellOpts->{tex} =~ /\\bfseries/);
			$css .= css('font-style', 'italic')
				if ($cellOpts->{tex} =~ /\\itshape/);
			$css .= css('font-family', 'monospace')
				if ($cellOpts->{tex} =~ /\\ttfamily/);

			if ($cellOpts->{tex} =~ /\\cellcolor(\[HTML\])?\{(.*?)[}!]/) {
				$css .= css('background-color', ($1 ? '#' : '') . $2);
			}
			if ($cellOpts->{tex} =~ /\\color(\[HTML\])?\{(.*?)[}!]/) {
				$css .= css('color', ($1 ? '#' : '') . $2);
			}
			$css .= $tableOpts->{allcellcss};
			$css .= $tableOpts->{headercss} if ($t eq 'th');
			$css .= $tableOpts->{datacss}   if ($t eq 'td');
			$cell = wrap($cell, @{ $tableOpts->{encase} })
				unless $cellOpts->{noencase};
			if ($tableOpts->{LaYoUt}) {
				$css .= css('display', 'table-cell');
				my $cellvalign = $tableOpts->{valign};
				$cellvalign = $valign if ($valign);
				$css        = css('vertical-align', $cellvalign) . $css;
				$css        = css('padding',        '12pt') . $css;
				if ($cellAlign->{tex} =~ /\\columncolor(\[HTML\])?\{(.*?)[\}!]/) {
					$css = css('background-color', ($1 ? '#' : '') . $2) . $css;
				}
				$css =
					css('border-right', getRuleCSS($cellAlign->{right})) . $css;
				$cell = tag($cell, 'div', { style => $css });
			} else {
				$css  = css('padding', '0pt 6pt') . $css;
				$cell = tag(
					$cell, $t,
					{
						style   => $css,
						scope   => $scope,
						colspan => ($cellOpts->{colspan} > 1) ? $cellOpts->{colspan} : ''
					}
				);
			}
			push(@cells, $cell);
		}
	}

	return main::MODES(
		TeX  => join(" ",  @cells),
		HTML => join("\n", @cells),
		PTX  => join("\n", @cells),
	);

}

# Takes the user's nested array and returns a cleaned up version with initializations
sub TableArray {
	my $userArray        = shift;
	my %supportedOptions = (
		data      => '',
		halign    => '',
		header    => '',
		tex       => '',
		noencase  => 0,
		colspan   => 1,
		cellcss   => '',
		texpre    => '',
		texpost   => '',
		rowcolor  => '',
		rowcss    => '',
		headerrow => '',
		rowtop    => 0,
		rowbottom => 0,
		top       => 0,
		bottom    => 0,
		valign    => '',
	);
	my @outArray;
	for my $i (0 .. $#$userArray) {
		my @outRow;
		my @userRow = @{ $userArray->[$i] };

		# $leftColIndex and $rightColIndex are part of a scheme to track use of colspan
		my $leftColIndex  = 0;
		my $rightColIndex = 0;
		for my $j (0 .. $#userRow) {
			my $userCell = $userRow[$j];
			my %outHash  = %supportedOptions;
			if (ref($userCell) eq 'HASH') {
				for my $key (keys(%supportedOptions)) {
					$outHash{$key} = $userCell->{$key}
						if defined($userCell->{$key});
				}

				# convenience
				$outHash{tex} .= '\color' . formatColorLaTeX($userCell->{color})
					if ($userCell->{color});
				$outHash{tex} .= '\cellcolor' . formatColorLaTeX($userCell->{bgcolor})
					if ($userCell->{bgcolor});
				$outHash{tex} .= '\bfseries' if ($userCell->{b});
				$outHash{tex} .= '\itshape'  if ($userCell->{i});
				$outHash{tex} .= '\ttfamily' if ($userCell->{m});
				$outHash{texpre} = $outHash{texpre} . $userCell->{texencase}[0]
					if $userCell->{texencase};
				$outHash{texpost} = $userCell->{texencase}[1] . $outHash{texpost}
					if $userCell->{texencase};

				# legacy misnomers
				$outHash{rowbottom} = $userCell->{midrule}
					if (defined($userCell->{midrule})
						&& !$outHash{rowbottom});
			} elsif (ref($userCell) eq 'ARRAY') {
				my @userCellCopy = (@$userCell);
				$outHash{data} = shift(@userCellCopy) if (@userCellCopy);
				my %userOptions = @userCellCopy;
				for my $key (keys(%supportedOptions)) {
					$outHash{$key} = $userOptions{$key}
						if defined($userOptions{$key});
				}

				# convenience
				$outHash{tex} .= '\color' . formatColorLaTeX($userOptions{color})
					if ($userOptions{color});
				$outHash{tex} .= '\cellcolor' . formatColorLaTeX($userOptions{bgcolor})
					if ($userOptions{bgcolor});
				$outHash{tex} .= '\bfseries' if ($userOptions{b});
				$outHash{tex} .= '\itshape'  if ($userOptions{i});
				$outHash{tex} .= '\ttfamily' if ($userOptions{m});
				$outHash{texpre} = $outHash{texpre} . $userOptions{texencase}->[0]
					if $userOptions{texencase};
				$outHash{texpost} = $userOptions{texencase}->[1] . $outHash{texpost}
					if $userOptions{texencase};

				# legacy misnomers
				$outHash{rowbottom} = $userOptions{midrule}
					if (defined($userOptions{midrule})
						&& !$outHash{rowbottom});
			} else {
				$outHash{data} = $userCell;
			}

			# clean up
			# remove any left vertical rule specifications from halign
			if ($j > 0
				&& $outHash{halign} =~ /((?<!\w)[lcrp](?!\w)\s*(\{[^}]*?\})?(\||!\{[^}]*?\}|\s)*)/)
			{
				$outHash{halign} = $1;
			}

			# scheme to track colspan
			$leftColIndex      = $rightColIndex + 1;
			$rightColIndex     = $rightColIndex + $outHash{colspan};
			$outHash{leftcol}  = $leftColIndex;
			$outHash{rightcol} = $rightColIndex;

			$outRow[$j] = \%outHash;
		}
		$outArray[$i] = \@outRow;
	}
	return \@outArray;
}

sub ColumnCount {
	my $tableArray = shift;
	my $colCount   = 0;
	for my $i (0 .. $#$tableArray) {
		my $thisRowColCount = 0;
		for my $j (0 .. $#{ $tableArray->[$i] }) {
			$thisRowColCount += $tableArray->[$i][$j]->{colspan};
		}
		$colCount = $thisRowColCount if ($thisRowColCount > $colCount);
	}
	return $colCount;
}

sub TableOptions {
	my $colCount         = shift;
	my %supportedOptions = (
		center          => 1,
		caption         => '',
		horizontalrules => 0,
		texalignment    => join('', ('c') x $colCount),
		Xratio          => 0.97,
		encase          => [ '', '' ],
		rowheaders      => 0,
		tablecss        => '',
		captioncss      => '',
		columnscss      => [ ('') x $colCount ],
		datacss         => '',
		headercss       => '',
		allcellcss      => '',
		valign          => 'top',
		booktabs        => 1,
		headerrules     => 1,
		LaYoUt          => 0,
	);
	%outHash = %supportedOptions;
	my %userOptions = @_;
	for my $key (keys(%supportedOptions)) {
		$outHash{$key} = $userOptions{$key} if defined($userOptions{$key});
	}

	# special user shortcut
	$outHash{texalignment} = $userOptions{align}
		if (defined($userOptions{align}) && !$userOptions{texalignment});

	# legacy misnomers
	$outHash{horizontalrules} = $userOptions{midrules}
		if (defined($userOptions{midrules}) && !$outHash{horizontalrules});

	return \%outHash;
}

sub ParseAlignment {
	my $alignment = shift;
	$alignment =~ s/\R//g;

	# first we parse things like *{20}{...} to expand them
	my $pattern = qr/\*\{(\d+)\}\{(.*?)\}/;
	while ($alignment =~ /$pattern/) {
		my @captured    = ($alignment =~ /$pattern/);
		my $replaceWith = $captured[1] x $captured[0];
		$alignment =~ s/$pattern/$replaceWith/;
	}

	my @align = ();

	# 0th entry is only for possible left border
	# other entries have only right borders,
	# the actual alignment is r, c, l, X, or p
	# explicit width vertical rules from !{...}
	# latex directives from >{...}
	# we make an array of the tokens of type:
	# r, c, l, X, |, !{...}, p{...}, >{...}
	# this is complicated because of potential nested brackets
	my @tokens             = ();
	my $bracesregex        = qr/(\{(?>[^{}]|(?R))*\})/x;
	my $bracecontentsregex = qr/((?>[^\{}]|(??{$bracesregex}))*)/x;

	# . at the end is to ensure we are whittling down $alignment at least a little
	my $tokenspattern = qr/^([rclX\|]\s*|[!p>]\s*\{((??{$bracecontentsregex}))\}\s*|.)/;

	$align[0] = { left => 0 };
	$leftpattern = qr/^\s*(\|\s*|!\s*\{\s*\\vrule\s+width\s+([^}]*?)\})/x;
	while ($alignment =~ $leftpattern) {
		my $token = $1;
		if ($token =~ /^\|/) {

			# this counts how many | we have
			$align[0]->{left} = 0
				unless ($align[0]{left} && $align[0]{left} =~ /\d+/);
			$align[0]->{left} += 1;
		} elsif ($token =~ /^!\s*\{\s*\\vrule\s+width\s+([^}]*?)\}/) {
			$align[0]->{left} = $1;
		}
		$alignment =~ s/$leftpattern//;
	}

	# now that leftmost vertical rule tokens taken care of, get all the other tokens
	while ($alignment) {
		my $token = ($alignment =~ /$tokenspattern/)[0];
		$alignment =~ s/$tokenspattern//;
		push(@tokens, $token);
	}

	# now run through tokens and grow @align
	# index for @align
	my $i = 1;

	# $j is index for @tokens
	for my $j (0 .. $#tokens) {
		my $token = $tokens[$j];
		my $next  = $tokens[ $j + 1 ] // '';
		if ($token =~ /^([lcrX])/) {
			$align[$i]->{halign} = $1;
			$align[$i]->{valign} = 'top' if ($1 eq 'X');
			$i++ unless ($next =~ /^[|!]/);
		} elsif ($token =~ /^\|/) {

			# this counts how many | we have
			$align[$i]->{right} = 0
				unless ($align[$i]->{right} && $align[$i]->{right} =~ /\d+/);
			$align[$i]->{right} += 1;
			$i++ unless ($next =~ /^[|!]/);
		} elsif ($token =~ /^!\s*\{\s*\\vrule\s+width\s+([^}]*?)\}/) {

			# for this style of vertical rule we store the width instead of a small positive integer
			$align[$i]->{right} = $1;
			$i++ unless ($next =~ /^[|!]/);
		} elsif ($token =~ /^p\{((??{$bracecontentsregex}))\}\s*/) {
			$align[$i]->{halign} = 'l';

			# record top alignment, but could be overwritten by row valign
			$align[$i]->{valign} = 'top';
			$align[$i]->{width}  = $1;
			$i++ unless ($next =~ /^[|!]/);
		} elsif ($token =~ /^>\s*\{((??{$bracecontentsregex}))\}/) {
			$align[$i]->{tex} = $1;

			# could parse these further for color identification, etc
		}
	}

	# now initialize any $align[$i] values that were not initialized
	for my $x (@align) {
		for my $key ('halign', 'valign', 'right', 'width', 'tex') {
			$x->{$key} = '' unless (defined $x->{$key});
		}
	}

	return \@align;

}

sub formatColorLaTeX {
	my $color = shift;
	if ($color =~ /^(\[HTML\])?\{.*\}$/) {
		return $color;
	} elsif ($color =~ /^[0-9a-fA-F]{6}$/) {
		return "[HTML]{$color}";
	} else {
		return "{$color}";
	}
}

sub formatColorHTML {
	my $color = shift;
	if ($color =~ /^\[HTML\]\{(.*)\}$/) {
		return '#' . $1;
	} elsif ($color =~ /^\{([^!]*)(?=[!\}])/) {
		return $1;
	} elsif ($color =~ /^(.*?)!/) {
		return $1;
	} elsif ($color =~ /^[0-9a-fA-F]{6}$/) {
		return "#$color";
	} else {
		return "$color";
	}
}

sub latexEnvironment {
	my ($inside, $environment, $options, $separator) = @_;
	$separator = "\n" unless (defined $separator);
	my $return = "\\begin{$environment}";
	for my $x (@$options) {
		if ($x =~ /^\[[^\]]+\]$/) {
			$return .= $x;
		} else {
			$return .= "{$x}" if ($x ne '');
		}
	}
	$return .= "$separator$inside$separator";
	$return .= "\\end{$environment}";
	return $return;
}

sub latexCommand {
	my ($command, $arguments) = @_;
	my $return = "\\$command";
	for my $x (@$arguments) {
		$return .= "{$x}" if ($x ne '');
	}
	$return .= " ";
	return $return;
}

sub wrap {
	my ($center, $left, $right, $separator) = @_;
	$separator = "\n" unless (defined $separator);
	return $center                   unless ($left || $right);
	return "$left$separator$center"  unless $right;
	return "$center$separator$right" unless $left;
	return "$left$separator$center$separator$right";
}

sub prefix {
	my ($center, $left, $separator) = @_;
	$separator = "\n" unless (defined $separator);
	return join("$separator", ($left, $center)) if ($left ne '');
	return $center;
}

sub suffix {
	my ($center, $right, $separator) = @_;
	$separator = "\n" unless (defined $separator);
	return join("$separator", ($center, $right)) if ($right ne '');
	return $center;
}

sub css {
	my ($property, $value) = @_;
	return ($value) ? "$property:$value;" : '';
}

sub tag {
	my ($inner, $name, $attributes, $separator) = @_;
	$separator = "\n" unless defined $separator;
	my $return = "<$name";
	for my $x (main::lex_sort(keys %$attributes)) {
		$return .= qq( $x="$attributes->{$x}") if ($attributes->{$x} ne '');
	}
	if ($inner) {
		$return .= ">$separator";
		$return .= $inner;
		$return .= "$separator</$name>";
	} else {
		$return .= '>' unless ($main::displayMode eq 'PTX');
		$return .= '/>' if ($main::displayMode eq 'PTX');
	}
	return $return;
}

sub getLaTeXthickness {
	my $input  = shift;
	my $output = '';
	if ($input =~ /^\s*(\.\d+|\d+\.?\d*)\s*$/) {
		$output = "$1px" if $1;
	} elsif ($input) {
		$output = "$input";
	}
	return $output;
}

sub getRuleCSS {
	my $input  = shift;
	my $output = '';
	if ($input =~ /^\s*(\.\d+|\d+\.?\d*)\s*$/) {
		$output = "solid $1px" if $1;
	} elsif ($input) {
		$output = "solid $input";
	}
	return $output;
}

sub getPTXthickness {
	# For a positive integer input, 1=>minor, 2=>medium, and greater=>major.
	# For a specific width input, we honor the PTX values
	# 0.04em=>minor, 0.07em=>medium, 0.11em=>major
	# but anything else goes to minor. Ideally an input would be compared
	# as a length unit to 0.04em, 0.07em, 0.11em and an appropriate choice
	# from minor|mediuum|major would be used. But we do not get into
	# comparing length units here.
	my $input = shift;
	return '' unless ($input);
	my $output = '';
	if ($input eq '1') {
		$output = "minor";
	} elsif ($input eq '2') {
		$output = "medium";
	} elsif ($input =~ /^[3-9]|[1-9]\d+$/) {
		$output = "major";
	} elsif ($input eq '0.04em') {
		$output = 'minor';
	} elsif ($input eq '0.07em') {
		$output = 'medium';
	} elsif ($input eq '0.11em') {
		$output = 'major';
	} elsif ($input) {
		$output = "minor";
	}
	return $output;
}

sub getWidthPercent {
	my $absWidth = shift;
	my $x        = 0;
	my $unit     = 'cm';
	if ($absWidth =~ /^(\.\d+|\d+\.?\d*)\s*(\w+)/) {
		$x    = $1;
		$unit = $2;
	}
	my %convert_to_cm = (
		'pt' => 1 / 864 * 249 / 250 * 12 * 2.54,
		'mm' => 1 / 10,
		'cm' => 1,
		'in' => 2.54,
		'ex' => 0.15132,
		'em' => 0.35146,
		'mu' => 0.35146 / 8,
		'sp' => 1 / 864 * 249 / 250 * 12 * 2.54 / 65536,
		'bp' => 2.54 / 72,
		'dd' => 1 / 864 * 249 / 250 * 12 * 2.54 * 1238 / 1157,
		'pc' => 1 / 864 * 249 / 250 * 12 * 2.54 * 12,
		'cc' => 1 / 864 * 249 / 250 * 12 * 2.54 * 1238 / 1157 * 12,
		'px' => 2.54 / 72,
	);
	return (int($x * $convert_to_cm{$unit} / (6.25 * 2.54) * 10000) / 100) . '%';
}

sub hrule {
	my ($booktabs, $type, $thickness) = @_;
	if ($booktabs) {
		my $thicknessArg = '';
		$thicknessArg = '[' . getLaTeXthickness($thickness) . ']'
			if ($thickness);
		return "\\" . $type . 'rule' . $thicknessArg;
	} elsif ($type eq 'cmid') {
		return "\\cline";
	} else {
		return "\\hline";
	}
}

1;
