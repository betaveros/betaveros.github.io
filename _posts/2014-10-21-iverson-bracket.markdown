---
layout: default
category: math
mathjax: true
title: Iverson Bracket
---

Very simple to explain: if $$ P $$ is a statement, $$ [P] $$ is 1 if $$ P $$ is true and 0 if not. So for example

$$
\begin{align*} [1 < 2] &= 1 \\ [1 > 2] &= 0 \end{align*}
$$

It's like using a boolean as an integer in C or Python.

It's useful to keep yourself organized when you're writing summations, especially if you're summing across terms with a weird condition or if you need to exchange two sums. It's also useful for writing pathological functions concisely.
