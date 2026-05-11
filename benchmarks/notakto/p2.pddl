(define (problem notakto-p2)
    (:domain notakto)
    (:objects
		t1 t2 t3 t4 t5 t6 t7 t8 t9 - tile
    )
    (:init
		;; Board is empty (all x predicates are false) and player 2 starts
		(turn-p2)
    )
    (:goal
		;; Goal: do not get three in a row
      	(p1-win)
    )
)