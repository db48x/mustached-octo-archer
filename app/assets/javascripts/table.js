function makeTable(labels, props) {
    return $("<table>", props).append(makeRow(labels.map(makeHeaderCell)));
}

function makeRow(cells, props) {
    return $("<tr>", props).append(cells);
}

function makeHeaderCell(label, props) {
    return $("<th>", $.extend(props, { text: label }));
}

function makeTextCell(label, props) {
    return $("<td>", $.extend(props, { text: label }));
}

function makeCell(children, props) {
    return $("<td>", $.extend(props)).append(children);
}
