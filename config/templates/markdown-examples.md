# Markdown Examples

This page demonstrates various markdown features supported by Jupyter Book.

## Basic Formatting

You can write content using standard markdown.

**Bold text** and *italic text*

## Lists

Unordered list:
- Item 1
- Item 2
  - Subitem 2.1
  - Subitem 2.2
- Item 3

Ordered list:
1. First item
2. Second item
   1. Subitem 2.1
   2. Subitem 2.2
3. Third item

## Links and References

You can create [external links](https://jupyterbook.org) and {ref}`internal references <intro>`.

## Code Blocks

Inline code: `print("Hello World")`

Code block with syntax highlighting:
```python
def greet(name):
    """Greet someone"""
    print(f"Hello, {name}!")

greet("World")
```

## Math

Inline math: $E = mc^2$

Display math:
```{math}
\begin{aligned}
\frac{\partial f}{\partial x} &= 2x \\
\frac{\partial f}{\partial y} &= 2y
\end{aligned}
```

## Admonitions

```{note}
This is a note admonition.
```

```{warning}
This is a warning admonition.
```

```{tip}
This is a tip admonition.
```

## Figures

```{figure} https://jupyterbook.org/_static/logo.png
:name: jupyter-logo
:alt: Jupyter Book Logo
:width: 200px
:align: center

The Jupyter Book Logo
```

## Tables

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |

## Citations

Add citations using BibTeX {cite}`doe2020example`

## Panels and Tabs

````{panels}
Panel 1 Title
^^^
Panel 1 content
---
Panel 2 Title
^^^
Panel 2 content
````

````{tab-set}
```{tab-item} Tab 1
Content of tab 1
```

```{tab-item} Tab 2
Content of tab 2
```
````

## Dropdowns

```{dropdown} Click me to see the content!
Here's the hidden content
```

## Cross-References

You can reference sections using {ref}`markdown-examples`.

## Bibliography

```{bibliography}