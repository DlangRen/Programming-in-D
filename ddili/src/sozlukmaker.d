/**
 * This program processes the sozluk.txt file to generate:
 *
 * 1) sozluk.ddoc
 *
 * 2) sozluk_body.ddoc
 *
 */

import std.stdio;
import std.format;
import std.string;
import std.exception;
import std.algorithm;
import std.array;
import std.regex;

import alphabet;

struct Entry
{
    string macroName;
    string word;
    string otherLanguage;
    string definition;
}

string parseRequiredPart(R)(ref R parts)
{
    enforce(!parts.empty);

    const part = parts.front.idup;
    parts.popFront();

    return part;
}

Entry parseEntry(const(char)[] line)
{
    auto parts = line
                 .splitter('|')
                 .map!strip;

    Entry entry;

    try {
        entry.macroName     = parseRequiredPart(parts);
        entry.word          = parseRequiredPart(parts);
        entry.otherLanguage = parseRequiredPart(parts);
        entry.definition    = parseRequiredPart(parts);

        enforce (parts.empty);

    } catch (Exception exc) {
        throw new Exception(
            format("Invalid sozluk line: %s", line));
    }

    return entry;
}

Entry languageSwapped(Entry entry)
{
    return Entry(
        entry.macroName, entry.otherLanguage, entry.word, entry.definition);
}

void main(string[] args)
{
    const alphabetName = args[1];    /* "english", "turkish", etc. */
    Alphabet alphabet = makeAlphabet(alphabetName);

    auto macroEntries = File("sozluk.txt", "r")
                        .byLine
                        .filter!(l => !l.empty)
                        .map!strip
                        .map!parseEntry
                        .array;

    auto sozlukEntries = macroEntries
                         .map!(e => (e.word == e.otherLanguage
                                     ? [ e ]
                                     : [ e, e.languageSwapped ]))
                         .joiner
                         .array
                         .sort!((l, r) =>
                                indexSectionOrder(l.word, r.word, alphabet));

    writeln("Generating sozluk.ddoc");
    auto sozluk = File("sozluk.ddoc", "w");

    foreach (entry; macroEntries) {
        if (entry.word.front == 'ı') {
            throw new Exception(
                format("Limitation: Current framework will sort this entry " ~
                       " among the 'i's: %s", entry));
        }

        sozluk.writefln(
            `%s = <div class="mini_sozluk_sozcuk"> $(B %s:) [%s], %s</div>`,
            entry.macroName, entry.word, entry.otherLanguage, entry.definition);
    }

    writeln("Generating sozluk_body.ddoc");
    auto sozluk_body = File("sozluk_body.ddoc", "w");
    sozluk_body.write("SOZLUK_BODY=");

    dchar lastInitial = ' ';

    foreach (entry; sozlukEntries) {
        dchar initial = alphabet.toUpper(initialLetter(entry.word));
        if (initial == 'I') {
            /* HACK: We do not distinguish between 'i' and 'I'. (We assume
             * that all words that start with 'I' are English and should be
             * listed with the 'i's.) */
            initial = 'İ';
        }

        if (lastInitial != initial) {
            if (lastInitial != ' ') {
                sozluk_body.writeln(`</ul>`);
            }

            sozluk_body.writefln(
                `<h5 class="index_section">%s</h5>`, initial);
            sozluk_body.writeln(`<ul class="index_section">`);
            lastInitial = initial;
        }

        sozluk_body.writefln(`<li>$(B %s:) [%s], %s</li>`,
                             entry.word, entry.otherLanguage, entry.definition);
    }

    sozluk_body.writeln(`</ul>`);
}
