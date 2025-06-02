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
