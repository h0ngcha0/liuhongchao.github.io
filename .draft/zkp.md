Read:
- https://hackernoon.com/wtf-is-zero-knowledge-proof-be5b49735f27
not much to write
- https://medium.com/@VitalikButerin/zk-snarks-under-the-hood-b33151a013f6
  - https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell/
    a) encoding as a polynomial problem
    b) succinctness by random sampling
    c) homomorphic encoding / encryption
    d) zero knowledge
    
    The formal definition (still leaving out some details) of
    zero-knowledge is that there is a simulator that, having also
    produced the setup string, but does not know the secret witness,
    can interact with the verifier – but an outside observer is not
    able to distinguish this interaction from the interaction with the
    real prover.
      - is this simulation in anyway similiar to quickcheck?
      - turing test? AI? since we r talking about a simulation here.
      
  
    There are zkSNARKs for all problems in the class NP and actually,
    the practical zkSNARKs that exist today can be applied to all
    problems in NP in a generic fashion. It is unknown whether there
    are zkSNARKs for any problem outside of NP.
      - what? zkSNARKs can not be applied to class P problems?
      
    NP-complete in the sense of turing-complete? Seems that all NP-complete
    problems can be transformed into each other.
      - Quadratic Span Programs
        this seems to be the NP-complete problem that zkSNARKs uses to verify stuff.
        
        
        
  - https://medium.com/@VitalikButerin/quadratic-arithmetic-programs-from-zero-to-hero-f6d558cea649

    https://github.com/ethereum/research/tree/master/zksnark
    
    
    The steps here can be broken up into two halves. First, zk-SNARKs
    cannot be applied to any computational problem directly; rather, you
    have to convert the problem into the right “form” for the problem to
    operate on. The form is called a “quadratic arithmetic program” (QAP),
    and transforming the code of a function into one of these is itself
    highly nontrivial.
      - there is a compilation step
        - flatten
        - to R1CS
          it is almost like, polynomial function can be coded with a sequence of
          filters, the filter can do multiplication and addition?
        - R1CS to QAP
        
  - https://blog.plan99.net/vntinyram-7b9d5b299097
  - https://medium.com/@VitalikButerin/exploring-elliptic-curve-pairings-c73c1864e627


i found it super weird to say that "0" additional knowledge is revealed. where is the line drawn?
is hashing a kind of zero knowledge proof?

requires interaction?
- hash doesn't though. just one question asked.

there need to be some domain rules? otherwise how to verify?

what is the relatoinship with quickcheck?

is CT zkp?


(setq browse-url-browser-function 'browse-url-firefox)

- MIT Zero knowledge:
  - https://www.youtube.com/watch?v=IWF-U1B1KQI&list=WL&index=3&t=0s
    + verifier is important
      provers is not compuational bound
      
      what is NP problem, what is its place in the whole domain of computation?
      what is P problem?
      
      P -> polynormial problem is not exponential problem,  
      NP -> is all about polynomial time checking
      sudoku is not a P probelem. but it takes polynomial time to check
      chess strategy is not a P problem and it is not an NP problem since it doesn't
      take polynomial time to check.
      
      NP-complete
      
      prover wants to convince the verifier of a statement without revealing the NP proof (witness)
      
      any statement in NP, can be proved by zk
      
      2 ingredients of zk
        - interation
        - randomness
        
      definition of zero knowledge
      
      complexity theory (NA > NP) randomness
      
      how does prover convince to verifier that he knows the square problem
      (r**2 * k**b)   b is either 0 or 1
      prover always proves that he knowsb
      
      what is knowledge? things you can compute in polynomial time is not knowledge
      randomness is for free (arguably)
      
      (randomness + probablistic polynomial time) is not knowledge
      
      the verifier sees something, and the prover has a algorithm to generate the same
      view probabilitically (called simulator) that the verifier sees. therefore there is
      no knowledge transferred.
      
      computationally indistinguishable
      
      
      P vs NP
      https://www.youtube.com/watch?v=YX40hbAHx3s
      very good explaination, NP is hard to compute but easy to verify, like digital signature
      
      Does being able to quickly recognize correct answers mean there is also a quick way to find them?
      
  - THE book chapter 4
    is it possible to prove a statement without yielding anything beyond its validity.

  - 
