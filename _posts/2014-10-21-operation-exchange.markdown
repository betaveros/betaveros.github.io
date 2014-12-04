---
layout: default
category: math
mathjax: true
title: Operation Exchange
---
## Limit + Limit

Cheaply, using an [Iverson bracket]({% post_url 2014-10-21-iverson-bracket %}) expression:

$$
\begin{align*}
\lim_{a \to \infty} \lim_{b \to \infty} [a > b] &= 0 \\
\lim_{b \to \infty} \lim_{a \to \infty} [a > b] &= 1
\end{align*}
$$

For more continuity, use $$ \frac{a}{a + b} $$ instead (Rudin Example 7.2).

Uniform convergence on one limit suffices to allow this exchange, almost by definition.

## Limit + Continuity

Let

$$
f_\epsilon(x) = \begin{cases} 0 & \mbox{if } |x| \geq \epsilon \\ 1 - \left|\frac{x}{\epsilon}\right| &\mbox{if } |x| < \epsilon \end{cases}.
$$

In English: $$ f_\epsilon(x) $$ has a triangular bump at $$ x = 0 $$ with height $$ 1 $$ and width $$ 2\epsilon $$. It's continuous. But

$$
\lim_{\epsilon \to \infty} f_\epsilon(x) = [x = 0],
$$

which is not.

Rudin Example 7.3 is a more differentiable variant.

Uniform convergence on the limit suffices.

## Limit + Derivative

This is a sine wave.
$$
f_\epsilon(x) = \epsilon \sin \frac{x}{\epsilon^2}.
$$

If you decrease $$ \epsilon $$, its amplitude decreases, so it converges uniformly to $$ f(x) \equiv 0 $$. But its period decreases even faster, so as a result its derivative

$$
f'_\epsilon(x) = \frac{1}{\epsilon} \cos \frac{x}{\epsilon^2}
$$

diverges everywhere.

There's a lot of room for tweaking in this one.

## Limit + Integral

Consider this function defined on $$ [0,1] $$:

$$
f_\epsilon(x) = \begin{cases} 0 & \mbox{if } x \geq 2\epsilon \\ \frac{1}{\epsilon}\left(1 - \left|\frac{x - \epsilon}{\epsilon}\right|\right) &\mbox{if } x < 2\epsilon \end{cases}.
$$

So $$ f_\epsilon(x) $$ has a triangular bump of width $$ 2\epsilon $$ and height $$ \frac{1}{\epsilon} $$ right next to $$ 0 $$, which means

$$
\int_0^1 f_\epsilon(x) = 1
$$

for all $$ \epsilon < 1/2 $$.

But

$$
\lim_{\epsilon \to 0^+} f_\epsilon(x) = 0
$$

and the integral of this is obviously 0.

Once again, uniform convergence allows the exchange.

## Derivative + Continuity {#dc}

Single-variable: Rudin's Example 5.6(b).

$$
f(x) = \begin{cases} x^2 \sin(1/x) &\mbox{if } x \neq 0 \\ 0 &\mbox{if } x = 0 \end{cases}
$$

is differentiable everywhere, but its derivative is discontinuous at 0. (The other direction is moot: differentiable functions are continuous.)

Two-variable: Just use the above function and consider $$ f(x + y) $$?

## Derivative + Derivative

Rudin chapter 9, exercise 27: If

$$
f(x, y) = \begin{cases} 0 &\mbox{if } x = y = 0 \\ \frac{xy(x^2 - y^2)}{x^2 + y^2} &\mbox{else} \end{cases}
$$

then

$$
\begin{align*}
\left(\frac{\partial^2 f}{\partial x \partial y} \right)(0, 0) &= 1 \\
\left(\frac{\partial^2 f}{\partial y \partial x} \right)(0, 0) &= -1
\end{align*}
$$

If just one of these partial derivatives is continuous, one can deduce that the other exists and they're equal (Rudin Theorem 9.41).

## Integral + Integral

Finally, one without any counterexamples! (Note we disallow improper integrals, since those are really limits of integrals in disguise.) Basically, apply the definition. It helps to consider "rectangular partitions" made from intersecting two partitions, one in each dimension.
