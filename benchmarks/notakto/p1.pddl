(define (problem notakto-p1)
    (:domain notakto)
    (:objects
		t1 t2 t3 t4 t5 t6 t7 t8 t9 - tile
    )
    (:init
		;; Board is empty (all x predicates are false) and player 1 starts
		(turn-p1)
    )
    (:goal
		;; Goal: do not get three in a row
      	(p1-win)
    )
)