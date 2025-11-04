## Headings

\# An escaped first-level heading

# A first-level heading

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

\## An escaped second-level heading

## A second-level heading

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

\### An escaped third-level heading
\#\#\# An escaped third-level heading

### A third-level heading

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

\#### An escaped fourth-level heading

#### A fourth-level heading

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

\##### An escaped Fifth level heading

##### A Fifth level heading

\###### An escaped Sixth level heading
\#\#\#\#\#\# An escaped Sixth level heading

###### A Sixth level heading

## Text formatting

\*Escaped Italic\* \*\*Escaped Bold\*\* \_Escaped Italic\_ \_\_Escaped Bold\_\_
*Italic* **Bold** _Italic_ __Bold__

```pre
|      Example      |         Syntax         |    Alternate Syntax    |
| :---------------: | :--------------------: | :--------------------: |
|        Bold       |        **Bold**        |        __Bold__        |
|      **Bold**     |      \*\*Bold\*\*      |      \_\_Bold\_\_      |
|    \*\*Bold\*\*   |    \\*\\*Bold\\*\\*    |    \\_\\_Bold\\_\\_    |
|                   |                        |                        |
|       Italic      |        *Italic*        |        _Italic_        |
|      *Italic*     |       \*Italic\*       |       \_Italic\_       |
|     \*Italic\*    |      \\*Italic\\*      |      \\_Italic\\_      |
|                   |                        |                        |
|     BoldItalic    |    ***BoldItalic***    |    ___BoldItalic___    |
|  ***BoldItalic*** | \*\*\*BoldItalic\*\*\* | \_\_\_BoldItalic\_\_\_ |
|                   |                        |                        |
|   Strikethrough   |   ~~Strikethrough~~    |                        |
| ~~Strikethrough~~ | \~\~Strikethrough\~\~  |                        |
```

|      Example      |         Syntax         |    Alternate Syntax    |
| :---------------: | :--------------------: | :--------------------: |
|        Bold       |        **Bold**        |        __Bold__        |
|      **Bold**     |      \*\*Bold\*\*      |      \_\_Bold\_\_      |
|    \*\*Bold\*\*   |    \\*\\*Bold\\*\\*    |    \\_\\_Bold\\_\\_    |
|                   |                        |                        |
|       Italic      |        *Italic*        |        _Italic_        |
|      *Italic*     |       \*Italic\*       |       \_Italic\_       |
|     \*Italic\*    |      \\*Italic\\*      |      \\_Italic\\_      |
|                   |                        |                        |
|     BoldItalic    |    ***BoldItalic***    |    ___BoldItalic___    |
|  ***BoldItalic*** | \*\*\*BoldItalic\*\*\* | \_\_\_BoldItalic\_\_\_ |
|                   |                        |                        |
|   Strikethrough   |   ~~Strikethrough~~    |                        |
| ~~Strikethrough~~ | \~\~Strikethrough\~\~  |                        |

\_\_Bold \*nested Italic\* Bold\_\_ **Bold _nested Italic_ Bold** ⎫  
\_\_Bold \_nested Italic\_ Bold\_\_ **Bold _nested Italic_ Bold** ⎬🆗

\*\*Bold \_nested Italic\_ Bold\*\* **Bold _nested Italic_ Bold** ⎭  
\*\*Bold \*nested Italic\* Bold\*\* **Bold _nested Italic_ Bold** ⎭✅

\*Italic \*\*Bold\*\* Italic\* _Italic **Bold** Italic_ ⎫
\*Italic \_\_Bold\_\_ Italic\* _Italic **Bold** Italic_ ⎬❌
\_Italic \*\*Bold\*\* Italic\_ _Italic **Bold** Italic_ ⎪  
\_Italic \_\_Bold\_\_ Italic\_ _Italic **Bold** Italic_ ⎭

\*Italic\* \*\*'nested' Bold\*\* \*Italic\* _Italic_ **'nested' Bold** _Italic_
\_Italic\_ \*\*'nested' Bold\*\* \_Italic\_ _Italic_ **'nested' Bold** _Italic_

\*\*Bo\*Italic\*ld\*\* **Bo*Italic*ld**
\*Ita\*\*\*Bold\*\*\*lic\* \*Ita**_Bold_**lic*
\*Ita\*\*\*\*Bold\*\*\*\*lic\* *Ita\***\*BoldItalic\*\***lic\*

₀₁₂₃₄⁵⁶⁷⁸⁹ <sub>01234</sub><sup>56789</sup>

## Paragraphs

```pre
Paragraph the first.⏎️
⏎️
Paragraph the second.⏎️
Second continued...⏎️
Two newlines start a paragraph⏎️¶
⏎️
And a third one.⏎️
```

## Quotes

```
> This is a quote
> with two lines
>
> > Nested quote of two
>> lines
>
> - A list
>- of things
>
> Last paragraph
```

> This is a quote  
> with two lines
>
> > Nested quote of two
> > lines
>
> - A list
> - of things
>
> Last paragraph

### Escaped quotes

```
\> This is an escaped quote
\> \> Nested
\> > Nested
\>
\> Last paragraph
```

\> This is an escaped quote
\> \> Nested
\> > Nested
\>
\> Last paragraph

## Comments

<!-- Inline comment -->

**Bold** <!-- comment between text --> _Italic_
**Bold <!-- comment inside bold --> Bold**
_Italic <!-- comment inside Italic --> Italic_
**Bold <!-- comment inside Bold --> Bold**
**_BoldItalic <!-- comment inside  --> BoldItalic_**

<!--
  Block comment
-->

## Horizontal rule

    ---   ⎫ one of
    ***   ⎬ on line
    ___   ⎭ by itself

escaped: \\--- or \\-\\-- or \\--\\- or \\-\\-\\-

\---
\-\--
\--\-
\-\-\-

---

escaped: \\**_ or \\_\\** or \\\*_\\_ or \\_\\_\\\*

\*\*\*
\*\*\*
\*\*\*
\*\*\*

---

escaped: \\**_ or \\_\\** or \\\__\\_ or \\_\\_\\\_

\_\_\_
\_\_\_
\_\_\_
\_\_\_

---

╺━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸

## Code Blocks

### Inline code:

|                            |                                  |                              |
| :------------------------: | :------------------------------: | :--------------------------: |
|  `let a = 'hello world';`  |    \`let a = 'hello world';\`    | \\`let a = 'hello world';\\` |
| `let a = \`hello world\`;` |  \`\`let a = \`hello world\`;\`  | \\`let a = 'hello world';\\` |
| ``let a = `hello world`;`` | \`\`let a = \`hello world\`;\`\` |

Some inline code `let a = 'hello world';`, followed by something.
inline code containing backticks ``let a = `${foo} ${bar}`;``.

Leading and trailing spaces `  a.?b.?c ?? 42    ` ditto `   foo && bar   `

- backticks: let a = `hello world`;

EoL: \``code ended by EoL\`
EoL: `code ended by EoL
EoL: \```code ended by EoL
EoL: ``code ended by EoL`
EoL: ``code ended by EoL
next line isn't code

### Multi-line blocks

```javascript
let javascript = () => 'hello world';
console.log(javascript());
```

`markdownHighlight_javascript`

\`\`\`bash
bash -command "quoted argument"
\`\`\`

```bash
bash -command "quoted argument"
```

▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▏bash▕▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅▔̅
bash -command "quoted argument"
▄▄▟ bash ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄

▄▄▟̅ bash ▙▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
bash -command "quoted argument"
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

`markdownHighlight_bash`
json / jsonc / [js|javascript|node] / [ts|typescript]

`code`

## Pre

See: ./pre.md

```pre
┌─∇─┬─────┬───────────────┐
│ ✔︎ │ \@> │ whole pattern │
├───┼─────┴─────┬─────────┤
│ ✔︎ │ \&  \@=   │         │
│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈│ here    │
│ ✘ │     \@!   │         │
├───┼───────────┼─────────┤
│ ✔︎ │ \zs \@N<= │ just    │
│┈┈┈│┈┈┈┈┈┈┈┈┈┈┈│ before  │
│ ✘ │     \@N<! │         │
└───┴──────╴∆╶──┴─────────┘

⎡✔︎⎤✔︎⎛✔︎⎞✔︎⎧✔︎⎫ ✓ ☑︎ [☘︎ ☺︎]
⎜¿⎟¿⎢¿⎥¿⎨¿⎬ ‽ ⸮ ⁈ ⁉︎ (⁇ † ‡)
⎣✘⎦✘⎝✘⎠✘⎪✘⎪ ✖︎ ✗ ☒ {⚑ ☓ ☹︎ ‼︎}
        ⎩b⎭
```

## Links

[Absolute Link](https://example.com/ 'with a title')
[Relative Link](docs/blah.html 'also with a title')
[Id Link](docs.html#section2)
**[Bold Link](https://example.com/docs/blah.html)**
_[Italic Link](https://example.com/docs/blah.html)_
[\`Code Link\`](https://example.com/docs/blah.html)

![Image](https://example.com/image.svg)
[![Image with a link](https://example.com/image.svg 'Caption for')](https://example.com/gallery/)

<https://www.markdownguide.org>
<fake@example.com>

## Lists

Unordered Elements In List

- Alpha
- Beta
- Gamma

- ABC
  > Quote
- XYZ

```pre
- Alpha    ∙ Alpha   - ABC             ∙ Foo
- Beta ╺━▶︎ ∙ Beta    ␣␣␣␣> A quote ╺━▶︎ ▋ A quote
- Gamma    ∙ Gamma   - XYZ             ∙ Baz
                    (↑4 spaces)
```

Ordered Elements

1. Foo
1. Bar
1. Baz

```pre
1. Foo     ⒈  Foo
1. Bar ╺━▶︎ ⒉  Bar
1. Baz     ⒊  Baz

1️ Foo
2️ Bar
3️ Baz

1⎤ Foo
2⎫ Bar
3 Baz
```

Nested

- α
  - β
    - γ
  - δ

```pre
⎧ Align ⎫ ⏐+⏐α⏐ 10. Tenth ⒑ Tenth
⎪ with  ⎪ ⏐ ⏐+⏐β⏐ - 10\.A ╺━▶︎ ▫︎ 10.A
⎪ first ├▶︎⏐ ⏐ ⏐+⏐γ - 10\.B ▪︎ 10.B
⎩ char  ⎭ ⏐ ⏐+⏐δ⏐ 11. Eleventh ⒒ Eleventh
```

## Task Lists

- [x] Task to be undone
- [ ] Task to be done
- [ ] \\\(Optional) Task starting with bracket

```pre

```

## Tables

| Col1 |  Col2  | Col3 |
| :--- | :----: | ---: |
| C1   |   C3   |   C5 |
| C2   | \|C4\| |   C6 |

```pre
  ┌────────┬────────┬────────┐
  │  Col1  │  Col2  │  Col3  │
  ├────────┼────────┼────────┤
  │ C1     │   C3   │     C5 │
  │ C2     │   C4   │     C6 │
  └────────┴────────┴────────┘
```

Col1 | Col2 | Col3 start/end pipes optional, column width can vary
--- | --- | --- three hyphens in each column of the header row

## Footnotes

Here is a simple footnote[^1].

A footnote can also have multiple lines[^2].

[^1]: My reference.

[^2]:
    To add line breaks within a footnote, prefix new lines with 2 spaces.
    This is a second line.

```pre
¹꛰︎²꛰︎³꛰︎⁴꛰︎⁵꛰︎⁶꛰︎⁷꛰︎⁸꛰︎⁹꛰︎⁰꛰︎ ܃¹ ¹܃ܝ²͎︎ ⢫⡝ ⢏⡹ ⢟⡻ ⢯⡽ ⢇⡸ ⢏⡹
¹²️³️⁴️⁵️⁶️⁷️⁸️⁹️ ¹️⁰️ ¹️¹️ ¹️²️️  ⣜⣣ ⣎⣱ ⣾⣷ ⣮⣵ ⢎⡱ ⢞⡵
⠘¹⠒²³⁴⠛⁵⁶⁷⠘⁸⁹⠃⁰
¹⠈⠉⠁⠐¹⠂⠒⠐¹⠂⠠₁⠄⠤⠠₁⠄⢀⣀⡀
¹⠘⠛⠃¹⠰⠶⠆¹₁⢠⣤⡄₁⢈⣉⡁
¹⠃⠛⠘¹⠃⠆⠶⠰₁⠆⡄⣤⢠₁️⡁⣉⢈
⠰₁⠤₂₃₄⠶₅₆₇₈₉܄܃܅¹܇¹¹܈܆܉⠢⢄
₁️₂️₃️₄️₅️₆️₇️₈️₉️
Here is a simple footnote¹꛰︎[^1].

A footnote can also⁴️ have multiple lines²꛰[^2].

[^1]: My reference.
[^2]:
    To add line breaks within a footnote, prefix new lines with 2 spaces.
    This is a second line.
```

## Collapsed sections

<details>
<summary>Tips for collapsed sections</summary>

...Markdown...
􀃲􀁢

</details>

## Alerts (GitHub)

> [!NOTE]
> Useful information that users should know, even when skimming content.
> 􀁜􀃬􀤏 􀉞 􀉟

> [!TIP]
> Helpful advice for doing things better or more easily.
> 􀅳􀅴 􁌴

> [!IMPORTANT]
> Key information users need to know to achieve their goal.
> 􀁞􀃮􀅎􀢒􀣴

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.
> 􀋉 􀋊 􀙬

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.
> 􀇾 􀇿

<!-- vim: set ts=2 sw=2 conceallevel=2 nowrap: -->
