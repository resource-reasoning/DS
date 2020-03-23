We thank the reviewers for their comments. We will work hard to
improve the presentation of the paper. We will act on all detailed comments.

# Reviewer 1.
Reviewer 1 ask about mechanisation and tools. We agree it is a big undertaking
and can only be done now that theory has been achieved. In fact,
we are working on implementing our semantics and use it to generate litmus tests and 
verifying client programs.

# Reviewer 2.
We will answer the resolution policy question in the response to reviewer 3.
Our model focuses on the successful cases, and abstract from abort and rollbacks.
Transactional snapshots in Def. 4 is normal snapshots.
However, we want to distinguish them from view snapshots in Def. 4, hence using 
different terms.

# Reviewer 3.
Reviewers ask clarification of our work, and [18,35].
[18] is a trace-based semantics, [35] is a graph-based semantics
and ours is state-based semantics.
All assume last-write-wins. [35] and us assume snapshot properties,
because both works focus on consistency models that are common in distributed kv-stores
such as causal consistency, parallel snapshot isolation and snapshot isolation.
[18] does not assume snapshot properties, because they want to cover isolation levels.
We agree that [18] cover more consistency models than us.

[18] shown that several notions of SI collapses into one as their applications.
They did not verify implementation protocols in their model, but we believe they can. 
Both [26] and we believe that it is not straightforward to use [18] to do client reasoning. 
We would be happy to see examples of client reasoning in [18],
which allows us to do a thorough comparison.

[35] proposed a fine-grained semantics on abstract exactions
and developed a model-checking tool for violation of robustness,
by converting abstract execution to dependency graphs, 
checking the properties on the dependency graphs.
We believe that their fine-grained semantics on the level of transactional
operations introduces unnecessary interleaving which does not affect robustness,
while a better approach is a coarse-grained semantics 
on the level of individual transactions.
Separately, the conversion from abstract executions to dependency graphs is non-trivial.
By contrast, we directly prove robustness of transactional applications
using our coarse-grained semantics on kv-stores.
Our kv-stores can be directly seen as dependency graphs.
-------HOW TO SAY OVER-APPROXIMATION of [35].-------

# Detail questions:
## Reviewer 1
# Line 315.
Atomic visibility means if a client observes an update from a transaction, the client 
must see all updates from the transaction.
## Reviewer 3
### Fig 1.
In our semantics, the views of clients are non-deterministic if they satisfy the execution test.
### Line 243-244.
Implementation protocols such as COPS and ClockSI informally 
argued the correctness of the protocols in their paper.
By contrast, we give formal proofs via trace refienemnts.
### Line 245.
A library is a transactional application with fixed APIs.
### Line 338.
We will take out this claim about modelling resolution policies other than last-write-wins, 
since it needs more justification. We were thinking that, for example, 
clients non-deterministically picks the values in the views.
### Line 481.
We focus on distributed kv-store for now. Eventual consistency allows anomalous behaviours 
such as lost update and long fork. The lost update means an update cannot be observed by 
other clients, however the state is still converged.
### Reliable causal order broadcast.
This is implementation details in our semantics. 
Yet it will be more difficult to verify implementation protocols 
without reliable causal order broadcast.

