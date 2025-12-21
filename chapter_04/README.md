# Chapter 4: Procedures

## 4.2.1 Orders

- _Normal-order_ language:

  Delay evaluation of procedure arguments until the actual argument values are needed.

- _Applicitive-order_ language:

  All the arguments to Scheme procedures are evaluated when the procedure is applied.

- _lazy evaluation_:

  Delaying evaluation of procedure arguments until the last possible moment (e.g., until they are required by a primitive operation)

If the body of a procedure is entered before an argument has been evaluated we say that the procedure is _non-strict_ in that argument. If the argument is evaluated before the body of the procedure is entered we say that the procedure is _strict_ in that argument.

## 4.3 Variations on a Scheme — Nondeterministic Computing

the nondeterministic program evaluator supports the illusion that time branches, and that our programs have different possible execution histories. When we reach a dead end, we can revisit a previous choice point and proceed along a different branch.

### 4.3.3 Execution procedures and continuations

The evaluation of an expression will finish by calling one of these two continuations:

- If the evaluation results in a value, the success continuation is called with that value;
- if the evaluation results in the discovery of a dead end, the failure continuation is called.

**It is the job of the success continuation to receive a value and proceed with the computation. Along with that value, the success continuation is passed another failure continuation, which is to be called subsequently if the use of that value leads to a dead end.**

## 4.4 Logic Programming

In a nondeterministic language, expressions can have more than one value, and, as a result, the computation is dealing with relations rather than with single-valued functions. Logic programming extends this idea by combining a relational vision of programming with a powerful kind of symbolic pattern matching called unification.

> What is Logic Programming? "What is" instead of "How to". However, the neat part is: "What is" can't always reveal the way of "How to". If the language itself does not provide the primitive of "How to", like `defer`, It is impossible for user to run a function at the end of a procedure call by simply specifying "this snippet run at the end".

### 4.4.1 Deductive Information Retrieval

`(rule ⟨conclusion⟩ ⟨body⟩)`

> Understanding the append example case in the book will open a Door to a new world. Btw, you should see roast in exam 4.63.

### 4.4.2 How the query system works?

In general, the query evaluator uses the following method to apply a rule when trying to establish a query pattern in a frame that specifies bindings for some of the pattern variables:

- Unify the query with the conclusion of the rule to form, if successful, an extension of the original frame.
- Relative to the extended frame, evaluate the query formed by the body of the rule.

Notice how similar this is to the method for applying a procedure in the eval/apply evaluator for Lisp:

- Bind the procedure’s parameters to its arguments to form a frame that extends the original procedure environment.
- Relative to the extended environment, evaluate the expression formed by the body of the procedure.

The similarity between the two evaluators should come as no surprise.

> Under what circumstances will an `and` query could, in the worst case, have to perform a number of matches that is
> exponential in the number of queries? Say a `and` query has `n` subqueries, and all variables in each subquery never
> overlap. Then the stream will be exponentially expanded. (p621)

### 4.4.3 Is Logic Programming Mathematical Logic?

The aim of logic programming is to provide the programmer with techniques for decomposing a computational problem into two separate problems: "what" is to be computed, and "how" this should be computed.

There is also a much more serious way in which the not of the query language differs from the not of mathematical logic. In logic, we interpret the statement "not P" to mean that P is not true. In the query system, however, "not P " means that P is not deducible from the knowledge in the data base. The not of logic programming languages reflects the so-called closed world assumption that all relevant information has been included in the data base.

### 4.4.4 Implementing the Query System

#### 4.4.4.3

If a pattern contains a dot followed by a pattern variable, the pattern variable matches the rest of the data list (rather than the next element of the data list), just as one would expect with the dotted-tail notation described in Exercise 2.20. Although the pattern matcher we have just implemented doesn’t look for dots, it does behave as we want. This is because the Lisp read primitive, which is used by query-driver-loop to read the query and represent it as a list structure, treats dots in a special way.

When read sees a dot, instead of making the next item be the next element of a list (the car of a cons whose cdr will be the rest of the list) it makes the next item be the cdr of the list structure. For example, the list structure produced by read for the pattern (computer ?type) could be constructed by evaluating the expression (cons 'computer (cons '?type '())), and that for (computer . ?type) could be constructed by evaluating the expression (cons 'computer '?type).

Thus, as pattern-match recursively compares cars and cdrs of a data list and a paern that had a dot, it eventually matches the variable after the dot (which is a cdr of the pattern) against a sublist of the data list, binding the variable to that list. For example, matching the pattern (computer . ?type) against (computer programmer trainee) will match ?type against the list (programmer trainee).

#### 4.4.4.4

The unifier is like the pattern matcher except that it is symmetrical—variables are allowed on both sides of the match. unify-match is basically the same as pattern-match, except that there is extra code (marked “\*\*\*” below) to handle the case where the object on the right side of the match is a variable.
