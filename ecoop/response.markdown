We thank the reviewers for their comments. We will work hard to
improve the presentation of the paper and act on all the detailed
comments. We answer the main comments first and some of the more
detailed comments later.

# Main Comments

### Reviewer 1: mechanisation and tools. 

This is a large undertaking that can only be done now that theory has 
been achieved. In fact, we are working on implementing our semantics, 
using it to generate litmus tests and prove robustness results for 
client programs.

### Reviewer 2: concurrent update with merge. 

Our aim was to capture an interleaving operational semantics since a 
large number of implementations of distributed systems, including 
COPS and Clock-SI, are specifically designed to capture the atomic 
visibility of transactions. We agree that it is interesting to look
at concurrent updates with a merge strategy. This would require 
changing the core programming language and update rule, but 
probably not the state. We will clarify.
 
### Reviewer 2: aborts and rollbacks. 

We assume the reviewer is asking about aborts associated with an
execution test failing. This is straightforward, by adapting the
update to augment the values with abort information and using
transaction-local variable stores rather than thread-local variable
stores, to prevent information leaking outside aborted transactions.
We can capture rollbacks by changing the update rule in the
operational semantics.  While these adaptations would enable us to
express a greater range of consistency models, e.g. opacity, we felt
that this would have made the paper more difficult to read. We can
comment on this.

### Reviewer 3: related work.

The reviewer asks for an in-depth comparison between our work, and
[18,35]: [18] is a trace-based semantics; [35] is a graph-based
semantics; and ours is a state-based semantics. All approaches have
their merits.

All assume the last-write-wins policy. [35] and this paper assumes
snapshot properties, because the focus is on weak consistency models
widely used in distributed databases. [18] does not assume snapshot
properties, because the focus is on isolation levels such as Read
Committed. We agree that [18] captures more consistency models than
this paper. 

In [18], the authors show that several definitions of SI collapse into
one.  They do *not* verify protocol implementations and do *not* prove
invariant properties of client programs. We have verified protocol
implementations and proven invariant properties of client programs. We
believe [18] can be used to verify implementations. We believe it is
difficult to use [18] to prove invariant properties of client
programs.  Their notion of trace includes a large amount of
information (for example, the total order on transactions) that just
would not be observable by a client (for example, a client on one
replica does not necessarily see a transaction on another replica).
In our opinion, it is not clear that the approach of [18] is
appropriate for client reasoning. Our concern is shared also by [26]:
``However, they do not consider verification (manual or  automated)
of client programs, and it is not immediately apparent if their
specification formalism is amenable for use within a verification
toolchain.''

[35] proposed a fine-grained operational semantics on abstract
exactions and developed a model-checking tool for the violation of
robustness. This was achieved by converting abstract executions to
dependency graphs and checking the violation of robustness on the
dependency graphs. The approach has two issues. First, despite [35]
assuming atomic visibility of transactions, it presents a fine-grained
semantics at the level of the individual transactional operations
rather than whole transactions, introducing unnecessary interleavings
which complicates the client reasoning: for example, increasing the
search space of model-checking tools. In contrast, our semantics is
coarse-grained in that interleaving is at the level of whole
transactions. Second, all the literature that performs client analysis
on abstract executions achieves this indirectly by over-approximating
the consistency-model specifications using dependency graphs
[9,14,15,16,35]. It is not known how to do this precisely [16]. In
contrast, in our work we prove robustness results directly by
analysing the structure of kv-stores, without over-approximation.  We
also give precise reasoning about the mutual exclusion of locks,
which we believe will be difficult to prove using abstract executions.

### Reviewer 3: the WSI consistency model. 

The WSI consistency model in this paper has been used to establish 
a proof technique for proving the robustness of libraries of a certain 
general form against WSI and hence SI. It has not been justified with 
respect to an implementation which is why we did not empahsise it in 
the introduction. We will clarify.

# Detailed Comments

### Reviewer 1.

- Line 315. In a replicated database such as COPS, one client can update
one replica and a client on the other replica might see none of the
updates.

### Reviewer 2.

- Definition 5. This is a formal definition of a normal snapshot.

- Availability. We are not sure if we can capture avalability in our
operational semantics. This is worth investigation. 
 

### Reviewer 3.

- Line 115. We regard our operational semantics as an interface, or
mid-point, between implementations and clients. We will clarify.

- Fig 1. We mean that it is possible for the client to have either the
  view in (1c) or the view in (1d) under CC. It can only have the view
  (1d) under PSI and SI. We will clarify.

- Line 243-244. In [33] and [22], the correctness of the COPS and
Clock-SI protocol implementations is given by appealing to specific
definitions of consistency models that are dependent on these
particular implementations.  In contrast, we have proved that the
protocol implementations are correct by appealing to our general
definitions of consistency models that are independent of the
particular implementations.

- Line 245. Yes, we are thinking of a library as an application that
  an be used by client code.

- Line 338. We will take out this claim about modelling resolution
policies other than last-write-wins. It needs better justification.
(We were thinking of multi-value registers where clients is able to
choose a value from the whole view.)

- Line 481. We mean the anomolous behaviour allowed by the weak
  consistency models, such as the examples given in Figure 7. We will
  clarify.

- Line 503. The largest execution test means the largest execution
test possible in our semantics: that is, the can_commit and vshift
properties correspond to true.

- Reliable causal order broadcast. Our framework abstracts from
communication between replicas, hence it does not assume reliable
causal order broadcast (RCOB). However, the encoding of COPS into our
framework is made easier by the fact that the protocol relies on RCOB.
We agree that verifying a protocol that does not rely on RCOB in our
framework would be a much more difficult task, and we will look to
implementations of such protocols in futre. 

