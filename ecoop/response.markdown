We thank the reviewers for their comments. We will work hard to
improve the presentation of the paper. We will act on all detailed comments.

# Reviewer 1.
Reviewer 1 asks about mechanisation and tools. We agree it is a big undertaking
and can only be done now that theory has been achieved. In fact,
we are working on implementing our semantics and use it to generate litmus tests and 
verifying client programs.

# Reviewer 2.
We will answer the resolution policy question in the response to reviewer 3.
Our framework can be easily extended to model aborted transactions and rollbacks: 
this is as simple as augmenting values in key-value stores to with a flag indicating 
whether a transaction, and tweaking the definition of update in execution tests to mark 
versions accordingly when performing a transaction update. 
While this approach would allow for expressing a greater range of consistency models, 
e.g. opacity, we felt that this would have made the paper harder to read.

# Reviewer 3.
The Reviewer asks for an in-depth comparison between our work, and [18,35].
[18] is a trace-based semantics, [35] is a graph-based semantics
and ours is state-based semantics.
All assume last-write-wins. [35] and us assume snapshot properties,
because both works focus on consistency models that are common in distributed kv-stores
such as causal consistency, parallel snapshot isolation and snapshot isolation.
[18] does not assume snapshot properties, because they want to cover weaker consistency models 
such as Read Committed. We agree that [18] captures more consistency models than we do.

In [18], the authors show that several notions of SI collapse into one.
They do not verify any actual implementation of protocols, although we believe that this would be feasible 
in their framework. 
In contrast, it is not straightforward for us to see how the framework of [18] can be used 
for client reasoning, due to their notion of trace embedding a total order of transaction 
that cannot be easily recovered at compile time. Our concern is shared also by [26] **exact page number 
should be here, I do not have access to the paper anymore**
We would be happy to see examples of client reasoning in [18],
which allows us to do a thorough comparison.

[35] proposed a fine-grained semantics on abstract exactions
and developed a model-checking tool for violation of robustness,
by converting abstract execution to dependency graphs, 
checking the properties on the dependency graphs. 
This approach suffer from two limitations. 
First, having a fine-grained semantics at the level of transactional
operations introduces unnecessary interleavings that complicate client reasoning 
and negatively affect the search-space of model-checking tools. 
In contrast, our semantics is coarse-grained, where the interleaving is at the 
level of individual transactions, and does not suffer from this limitation.
Second, all the works in the literature that perform client analysis of programs 
in a framework based on abstract executions do so by over-approximating 
consistency model specifications in terms of dependency graphs [9,14,15,16], 
and this is also the approach followed in [35]. While the over-approximation used in [35] 
is suitable for tackling robustness, it would not be useful for proving other interesting 
properties of transactional libraries: for example, transaction chopping [14,15,42] 
requires a precise characterisation in terms of consistency models in terms of dependency 
graphs. It is worth noting that the problem of finding such precise characterisations in 
a general setting is till open [16].
In contrast, in our work we directly prove robustness of transactional applications
by analysing the structure of kv-stores they generate. Because our definitions of 
consistency models are precise, in contrast with the dependency graph 
approximations of [35], we would be able to verify a larger class of properties for 
transactional libraries with respect to them.
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
Our framework abstracts from communication between replicas, hence it does not 
assume reliable causal order broadcast (RCOB). However, the encoding of 
COPS into our framework is made easier by the fact that the protocol relies on RCOB. 
We agree that verifying a protocol that does not rely on RCOB in our framework 
would be a much more difficult task, and we will look to implementations of such protocols next.

