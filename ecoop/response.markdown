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
execution test failing. This is straightforward, by adapting the update 
to augment the values with abort information and using transaction-local 
variable stores rather than thread-local variable stores.  We can capture 
rollbacks by changing the update rule in the operational semantics.
While these adaptations would enable us to express a greater range of 
consistency models, e.g. opacity, we felt that this would have made the paper
harder to read. We can comment on this. 

### Reviewer 3: related work.

The reviewer asks for an in-depth comparison between our work, 
and [18,35]: [18] is a trace-based semantics; [35] is a
graph-based semantics; and ours is a state-based semantics. All
approaches have their merits.

We all assume the last-write-wins policy. [35] and this paper assumes
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
information (such as as the total order on transactions) that just
would not be observable by the client program. It is not at all clear
that it is appropriate for client reasoning. Our concern is shared
also by [26]: 
> However, they do not consider verification (manual or
> automated) of client programs, and it is not immediately apparent if
> their specification formalism is amenable for use within a
> verification toolchain.

[35] proposed a fine-grained operational semantics on abstract
exactions and developed a model-checking tool for the violation of
robustness, by converting abstract execution to dependency graphs and
checking the properties on the dependency graphs. This approach has
two limitations.  First, having a fine-grained semantics at the level
of transactional operations introduces unnecessary interleavings that
complicate client reasoning and negatively affect the search-space of
model-checking tools. In contrast, our semantics is coarse-grained,
where the interleaving is at the level of individual transactions, and
does not suffer from this limitation. Second, all the works in the
literature that perform client analysis of programs in a framework
based on abstract executions do so by over-approximating consistency
model specifications in terms of dependency graphs [9,14,15,16], and
this is also the approach followed in [35]. While the
over-approximation used in [35] is suitable for tackling robustness,
it would not be useful for proving other interesting properties of
transactional libraries: for example, transaction chopping [14,15,42]
requires a precise characterisation in terms of consistency models in
terms of dependency graphs. It is worth noting that the problem of
finding such precise characterisations in a general setting is till
open [16].  In contrast, in our work we directly prove robustness of
transactional applications by analysing the structure of kv-stores
they generate. Because our definitions of consistency models are
precise, in contrast with the dependency graph approximations of [35],
we would be able to verify a larger class of properties for
transactional libraries with respect to them.

### Reviewer 3: the WSI consistency model. 

The WSI consistency model in this paper has been used to establish 
a proof technique for proving the robustness of libraries of a certain 
general form against WSI and hence SI. It has not been justified with 
respect to an implementation which is why we did not empahsise it in 
the introduction. We will clarify.

# Detailed Comments

Put below in the right place. 

### Reviewer 1.

- Line 315. In a replicated database such as COPS, one client can update
one replica and a client on the other replica might see none of the
updates.

### Reviewer 2.

- Definition 5. This is a formal definition of a normal snapshot.

- Availability. This is a property related to implementations. 

### Reviewer 3.

- Line 115. We regard our operational semantics as an interface, or
mid-point, between implementations and clients. We will clarify.

----not done from here--------

- Fig 1. In our semantics, the views of clients are non-deterministic if
they satisfy the execution test.

- Line 243-244. Implementation protocols such as COPS and ClockSI informally 
argued the correctness of the protocols in their paper.
By contrast, we give formal proofs via trace refinements.

- Line 245. A library is a transactional application with fixed APIs.

- Line 338. We will take out this claim about modelling resolution
policies other than last-write-wins, since it needs more
justification. We were thinking that, for example, clients
non-deterministically picks the values in the views.

- Line 481. We focus on distributed kv-store for now. Eventual
consistency allows anomalous behaviours such as lost update and long
fork. The lost update means an update cannot be observed by other
clients, however the state is still converged.

- Reliable causal order broadcast. Our framework abstracts from
communication between replicas, hence it does not assume reliable
causal order broadcast (RCOB). However, the encoding of COPS into our
framework is made easier by the fact that the protocol relies on RCOB.
We agree that verifying a protocol that does not rely on RCOB in our
framework would be a much more difficult task, and we will look to
implementations of such protocols next.

