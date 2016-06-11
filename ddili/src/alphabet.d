/**
 * This module handles sorting and capitalization of text according to a
 * specific alphabet (English and Turkish).
 */

import std.uni;
import std.algorithm;
import std.range;
import std.conv;
import std.format;
import std.exception;

interface Alphabet
{
    bool is_less(dchar lhs, dchar rhs);
    bool is_less(string lhs, string rhs);
    bool is_greater(dchar lhs, dchar rhs);
    string toLower(string s);
    dchar toUpper(dchar d);
}

class EnglishAlphabet : Alphabet
{
    bool is_less(dchar lhs, dchar rhs)
    {
        return lhs < rhs;
    }

    bool is_less(string lhs, string rhs)
    {
        return lhs < rhs;
    }

    bool is_greater(dchar lhs, dchar rhs)
    {
        return lhs > rhs;
    }

    string toLower(string s)
    {
        return std.uni.toLower(s);
    }

    dchar toUpper(dchar d)
    {
        return std.uni.toUpper(d);
    }
}

class TurkishAlphabet : Alphabet
{
    static const lowerLetters = "abcçdefgğhıijklmnoöpqrsştuüvwxyz"d;
    static const upperLetters = "ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ"d;
    static assert (lowerLetters.length == upperLetters.length);

    int[dchar] order;
    dchar[dchar] uppers;
    dchar[dchar] lowers;

    this()
    {
        foreach (int i, dchar c; lowerLetters) {
            order[c] = i;
        }

        foreach (l, u; zip(lowerLetters, upperLetters)) {
            uppers[l] = u;

            /* We are taking a chance here and assuming that all words that
             * start with 'I' are English words. We want them appear under İ
             * in the index even for Turkish books. Also see the HACK comment
             * inside generateIndex(). */
            lowers[u] = (u == 'I' ? 'i' : l);
        }
    }

    int orderCode(dchar d)
    {
        const o = d in order;
        return (o ? *o : d);
    }

    bool is_less(dchar lhs, dchar rhs)
    {
        return orderCode(lhs) < orderCode(rhs);
    }

    bool is_less(string lhs, string rhs)
    {
        /* Unfortunately, the following does not work due to the following bug:
         *
         *   https://issues.dlang.org/show_bug.cgi?id=13566
         *
         *  return cmp!((l, r) => orderCode(l) < orderCode(r))(lhs, rhs) < 0;
         */

        foreach (l, r; zip(lhs, rhs)) {
            const lo = orderCode(l);
            const ro = orderCode(r);

            if (lo < ro) {
                return true;
            }
        }

        /* Shorter one is before */
        return lhs.length < rhs.length;
    }

    bool is_greater(dchar lhs, dchar rhs)
    {
        return orderCode(lhs) > orderCode(rhs);
    }

    string toLower(string s)
    {
        dchar value(dchar src)
        {
            auto result = src in lowers;
            return (result ? *result : std.uni.toLower(src));
        }

        return s.map!value.to!string;
    }

    dchar toUpper(dchar d)
    {
        const u = d in uppers;
        return (u ? *u : std.uni.toUpper(d));
    }
}

class ChineseAlphabet : Alphabet
{
	bool is_less(dchar lhs, dchar rhs)
	{
		return lhs < rhs;
	}
	
	bool is_less(string lhs, string rhs)
	{
		return lhs < rhs;
	}
	
	bool is_greater(dchar lhs, dchar rhs)
	{
		return lhs > rhs;
	}
	
	string toLower(string s)
	{
		return s;
	}
	
	dchar toUpper(dchar d)
	{
		return d;
	}
}

Alphabet makeAlphabet(string alphabetName)
{
    Alphabet result;

    switch (alphabetName) {
    case "english":
        result = new EnglishAlphabet();
        break;

    case "turkish":
        result = new TurkishAlphabet();
        break;

    case "german":
        result = new EnglishAlphabet();
		break;

	case "chinese":
		result = new ChineseAlphabet();
		break;

    default:
        throw new Exception(format("Unsupported alphabet: %s", alphabetName));
    }

    return result;
}

/* Compares two characters according to the index section sorting rules. All
 * of the non-alpha characters are sorted before the alpha characters. */
int indexSectionOrderChar(dchar lhs, dchar rhs, Alphabet alphabet)
{
    const la = isAlpha(lhs);
    const ra = isAlpha(rhs);

    if (!la && ra) {
        return -1;
    }

    if (la && !ra) {
        return 1;
    }

    if (alphabet.is_less(lhs, rhs)) {
        return -1;

    } else if (alphabet.is_greater(lhs, rhs)) {
        return 1;

    } else {
        return 0;
    }
}

/* Removes leading non-alpha characters if they indeed lead at least one alpha
 * character. */
string removeLeadingNonAlphaMaybe(string s)
{
    string orig = s;

    if (!s.empty) {
        switch (s.front) {
        case '.', '-', '@', '~', '!':
            s.popFront();

            if (!s.empty && s.front.isAlpha) {
                return s;
            }

            break;

        case '_':
            auto result = s.find!(a => a != '_');
            if (!result.empty && result.front.isAlpha) {
                return result;
            }

            break;

        default:
            break;
        }
    }

    return orig;
}

/* Extracts an int from the string and pops the front of the string. */
int extractInt(ref string s)
{
    int result;

    const items = formattedRead(s, " %d", &result);
    assert(items == 1);

    return result;
}

/* Index section sorting predicate. */
bool indexSectionOrder(string lhs, string rhs, Alphabet alphabet)
{
    auto a = alphabet.toLower(lhs).removeLeadingNonAlphaMaybe;
    auto b = alphabet.toLower(rhs).removeLeadingNonAlphaMaybe;

    while (!a.empty && !b.empty) {

        /* Skip commas, they are just separators. */

        if (a.front == ',') {
            a.popFront();
            continue;
        }

        if (b.front == ',') {
            b.popFront();
            continue;
        }

        if (a.front.isNumber && b.front.isNumber) {
            /* We need to switch to numeric comparison for embedded numbers so
             * that e.g. UTF-8 is sorted before UTF-16. */
            int aValue = extractInt(a);
            int bValue = extractInt(b);

            if (aValue < bValue) {
                return true;

            } else if (aValue > bValue) {
                return false;
            }

            /* Numeric values are equal. Since a and b are already popped by
             * extractNumeric(), just continue with the rest of the
             * strings. */

        } else {
            /* Compare the corresponding characters. */

            const result = indexSectionOrderChar(a.front, b.front, alphabet);

            if (result < 0) {
                return true;

            } else if (result > 0) {
                return false;
            }

            a.popFront();
            b.popFront();
        }
    }

    if (a.empty && !b.empty) {
        /* Shorter string is sorted first. */
        return true;
    }

    if (!a.empty && b.empty) {
        return false;
    }

    /* A final comparison to take the potential leading dot into account. */
    if (lhs.length < rhs.length) {
        return true;

    }

    if (lhs.length == rhs.length) {
        /* They may differ only in lower vs. upper case. Use the original
         * strings to check for that. */
        return alphabet.is_less(lhs, rhs);
    }

    return false;
}

/* Ignores leading non-alpha characters if they indeed lead at least one alpha
 * character. */
dchar initialLetter(string s)
{
    enforce(!s.empty);

    auto maybeRemoved = removeLeadingNonAlphaMaybe(s);

    return maybeRemoved.empty ? s.front : maybeRemoved.front;
}
