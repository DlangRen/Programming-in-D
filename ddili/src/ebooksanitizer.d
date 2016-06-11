/**
 * This program sanitizes the source HTML for ebook generation.
 *
 * 1) Replace Unicode box characters with their ASCII relatives.
 */

import std.stdio;
import std.algorithm;
import std.string;
import std.regex;

void main() {
    const dchar[dchar] transTable = [
        '│' : '|',
        '─' : '-',
        '┬' : '+',
        '┴' : '+',
        '┌' : '+',
        '└' : '+',
        '┐' : '+',
        '┘' : '+',
        '├' : '+',
        '┤' : '+',
    ];

    enum indexArrow = ctRegex!`⬁`;
    enum imageDir = ctRegex!`src=".*/image/`;

    stdin
        .byLine(KeepTerminator.yes)
        .map!(l => l.translate(transTable))
        .map!(l => replaceAll(l, indexArrow, `==>`))
        .map!(l => replaceAll(l, imageDir, `src="image/`))
        .copy(stdout.lockingTextWriter);
}
